# =============================================== #
# BUILD CONTAINER
#
# There are multiple targets that can be built
# within the container, including:
# build, test, and release
# =============================================== #

# you can pass in NODE_VERSION as a --build-arg to override the version - a default is provided
ARG NODE_VERSION=latest
FROM node:${NODE_VERSION} as base

WORKDIR /build

########################################################################
# cache a layer for test dependencies
FROM base AS test_base

# CHROME (FOR TESTS)

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# lcov for test coverage summary
RUN apt-get update && apt-get install -yq lcov

########################################################################

########################################################################
# cache a layer for the deps
FROM base AS build_deps

COPY package.json /build/package.json
COPY package-lock.json /build/package-lock.json
RUN npm install
# NOTE - this is required for canary ember deps
RUN npm install ember-source


########################################################################
FROM test_base AS test

COPY . .
COPY --from=build_deps /build/node_modules /build/node_modules
RUN npm run lint
RUN COVERAGE=true CI=true node --max-old-space-size=1024 `which npm` run test
# emit the coverage summary for logging purposes
RUN lcov --summary ./coverage/lcov.info

########################################################################
# cache a layer for the deps
FROM build_deps AS build

COPY . .

ARG BUILD_TYPE=development
RUN npm run build -- --environment ${BUILD_TYPE}

########################################################################
# final release stage (will result in a very small image)
FROM nginx:1.15-alpine as release
WORKDIR /var/www

RUN mkdir -p /etc/nginx/ssl/
COPY --from=build /build/dist /var/www
COPY --from=build /build/config/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
########################################################################
