(function() {
  var Affojaxo;
  Affojaxo = (function() {
    function Affojaxo() {}
    Affojaxo.prototype.getRequest = function() {
      try {
        return new ActiveXObject('Msxml2.XMLHTTP');
      } catch (error) {
        try {
          return new ActiveXObject('Microsoft.XMLHTTP');
        } catch (e) {
          return new window.XMLHttpRequest();
        }
      }
    };
    Affojaxo.prototype.send = function(url, callback, method, args) {
      var request;
      args || (args = '');
      request = this.getRequest();
      request.open(method, url, true);
      request.onreadystatechange = function() {
        if (request.readyState === 4) {
          return callback(request.responseText);
        }
      };
      request.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
      if (method === 'POST') {
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      }
      return request.send(this.parseArguments(args));
    };
    Affojaxo.prototype.get = function(url, callback) {
      return this.send(url, callback, 'GET');
    };
    Affojaxo.prototype.gets = function(url) {
      var request;
      request = this.getRequest();
      request.open('GET', url, false);
      request.send(null);
      return request.responseText;
    };
    Affojaxo.prototype.post = function(url, callback, args) {
      return this.send(url, callback, 'POST', args);
    };
    Affojaxo.prototype.parseArguments = function(mixed) {
      if (typeof mixed === 'string') {
        return mixed;
      } else if (typeof mixed === 'object') {
        return mixed.join('&');
      }
      return '';
    };
    return Affojaxo;
  })();
}).call(this);
