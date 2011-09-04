# **Affojaxo** is a lightweight library for building web applications with ajax support.
#
#### Basic Usage
#
#     affojaxo = new Affojaxo()
#     affojaxo.get(url, (data) ->
#         console.log data 
#     )
#
# **Author:** [Carl Mathisen](http://www.kamikazemedia.no/)

# 
class Affojaxo
    
    # The request object used for communication with a server. Usually this will either be
    # an ActiveXObject for browsers from Redmond or XMLHttpRequest object for the rest.
    getRequest: () ->
        
        try
            return new ActiveXObject('Msxml2.XMLHTTP')
        catch error
            try
                return new ActiveXObject('Microsoft.XMLHTTP')
            catch e
                return new window.XMLHttpRequest()
        
    # Sends a basic Ajax request. You will need to specify:
    #
    # * **url** - The URL (without parameters) to which the request is sent. Make sure that the URL is on the same
    # address and port as the script itself.
    # * **callback** - The response body will be sent as the first parameter to this callback function on completion
    # * **method** - POST or GET
    # * **args** - Arguments can be sent as a URL encoded string or as an associative object
    send: (url, callback, method, args) ->
        
        # Sets the arguments to an empty object if undefined.
        args or= ''
        
        # Fetch a new request object and setup the connection URL and method (GET or POST).
        request = @getRequest()
        request.open(method, url, true)
        
        # The connection response is asynchronys, so we need to setup
        # a callback on readyState 4. Once the response is sent back to
        # Affojaxo, the callback function is dispatched.
        request.onreadystatechange = () ->
            if request.readyState is 4
                callback(request.responseText)
                
        # Make sure that request parameters are decoded correctly at client (allow anything).
        request.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
                
        # Sets the headers of a POST request to act like a form submittion.
        if method is 'POST'
            request.setRequestHeader('Content-Type','application/x-www-form-urlencoded')
        
        request.send(@parseArguments(args))
    
    # Uses a GET request to query the specified url and return a response to the specified function.
    get: (url, callback) ->
        @send(url, callback, 'GET')
    
    # Uses a GET request to query the specified url and return a response synchronously.
    # Use this sparingly, as synchronous calls can lock up the browser.
    gets: (url) ->
        request = @getRequest()
        request.open('GET', url, false)
        request.send(null)
        return request.responseText
    
    # Uses a POST request to query the specified url and insert the result into the specified element.
    post: (url, callback, args) ->
        @send(url, callback, 'POST', args)
    
    # Makes sure that the arguments are formatted as a url encoded parameter string. This function
    # expects a string or an associative object to parse.
    parseArguments: (mixed) ->
        
        if typeof mixed is 'string'
            return mixed
        else if typeof mixed is 'object'
            return mixed.join('&')
        return ''
    