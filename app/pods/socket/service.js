import Service from '@ember/service';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import Evented from '@ember/object/evented';

export default class SocketService extends Service.extend(Evented) {
    @service('websockets') socketService;
    @tracked socket;
}
