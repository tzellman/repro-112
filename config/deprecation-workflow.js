/* eslint-disable no-undef */

self.deprecationWorkflow = self.deprecationWorkflow || {};
self.deprecationWorkflow.config = {
    workflow: [
        { handler: 'silence', matchId: 'computed-property.override' },
        { handler: 'silence', matchId: 'ember-component.send-action' }
    ]
};
