angular.module('sync', []).factory('sync', ['$rootScope', function($rootScope) {
    var socket = new WebSocketRails(location.host + '/websocket');
    var channels = {};
    
    return function(name, id) {
        var o = {
            $save: function(success_cb, failure_cb) {
                var trigger_name = name + (this.id != null? '.update' : '.create');
                socket.trigger(trigger_name, this, success_cb, failure_cb);
            }
        };

        // initial request
        socket.trigger(name + '.show', id, function(obj) {
            angular.extend(o, obj);
            $rootScope.$apply();
        });

        // when updates come in
        var channel_name = '/' + name + '/' + id;
        var channel = channels[channel_name] || socket.subscribe(channel_name);
        channels[channel_name] = channel;
        channel.bind('update', function(obj) {
            angular.extend(o, obj)
            $rootScope.$apply()
        });

        return o;
    };
}]);
