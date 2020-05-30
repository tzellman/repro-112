module.exports = {
    root: true,
    parser: 'babel-eslint',
    parserOptions: {
        ecmaVersion: 2017,
        sourceType: 'module'
    },
    plugins: ['ember', 'decorator-position'],
    extends: ['eslint:recommended', 'plugin:ember/recommended', 'plugin:decorator-position/ember'],
    env: {
        browser: true
    },
    rules: {
        'ember/no-mixins': 'off',
        'ember/no-jquery': 'error'
    },
    overrides: [
        // node files
        {
            files: [
                '.ember-cli.js',
                '.eslintrc.js',
                '.template-lintrc.js',
                'ember-cli-build.js',
                'testem.js',
                'blueprints/*/index.js',
                'config/**/*.js',
                'lib/*/index.js'
            ],
            excludedFiles: ['app/**'],
            parserOptions: {
                sourceType: 'script',
                ecmaVersion: 2015
            },
            env: {
                browser: false,
                node: true
            },
            plugins: ['node'],
            rules: Object.assign({}, require('eslint-plugin-node').configs.recommended.rules, {
                // add your custom rules and overrides for node files here
                'node/no-unpublished-require': 0
            })
        }
    ]
};
