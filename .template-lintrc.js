'use strict';

module.exports = {
    extends: 'recommended',
    rules: {
        'block-indentation': 4,
        'attribute-indentation': {
            indentation: 4,
            'open-invocation-max-len': 100,
            'process-elements': true,
            'element-open-end': 'new-line',
            'mustache-open-end': 'new-line'
        },
        'no-implicit-this': { allow: ['now'] }
    }
};
