// Utility functions and polyfills

if (!Array.prototype.find) {
    Object.defineProperty(Array.prototype, 'find', {
        enumerable: false,
        configurable: true,
        writable: true,
        value: function(predicate) {
            if (this == null) {
                throw new TypeError('Array.prototype.find called on null or undefined');
            }
            if (typeof predicate !== 'function') {
                throw new TypeError('predicate must be a function');
            }
            var list = Object(this);
            var length = list.length >>> 0;
            var thisArg = arguments[1];
            var value;

            for (var i = 0; i < length; i++) {
                if (i in list) {
                    value = list[i];
                    if (predicate.call(thisArg, value, i, list)) {
                        return value;
                    }
                }
            }
            return undefined;
        }
    });
}

Array.prototype.contains = function(elem) {
    return this.indexOf(elem) !== -1;
};

window.Repomgmt = {
    safeArray: function(maybeArray) {
        return Array.isArray(maybeArray) ? maybeArray : [];
    },
    isAdmin: function() {
        return gon.is_admin;
    },
    isLoggedIn: function() {
        return gon.is_logged_in;
    }
}

String.prototype.containsCaseInsensitive = function(otherString) {
    return this.toLowerCase().indexOf(otherString.toLowerCase()) > -1;
}