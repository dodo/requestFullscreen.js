# https://hacks.mozilla.org/2012/01/using-the-fullscreen-api-in-web-browsers/

vendors = ["webkit", "moz", "o", "ms"]


@requestFullscreen = do ->
    el = document?.documentElement
    request = el?.requestFullscreen
    for vendor in vendors
        break if (request ?= el?["#{vendor}RequestFullScreen"])
    return request ? () ->
        # place shim here


@exitFullscreen = do ->
    request = document?.exitFullscreen
    for vendor in vendors
        break if (request ?= document?["#{vendor}CancelFullScreen"])
    return request ? () ->
        # place shim here


@isFullscreen = do ->
    state = null
    found = document?.exitFullscreen
    # workaround for ie
    addEventListener = document?.addEventListener ? document?.attachEvent
    for vendor in [""].concat(vendors)
        if (found ?= document?["#{vendor}CancelFullScreen"])
            request = if request? then "#{vendor}FullScreen" else "fullscreen"
            addEventListener("#{request.toLowerCase()}change", ->
                state = document[request]
            , no)
            break
    return (callback) ->
        return state unless callback?
        addEventListener("#{request.toLowerCase()}change", callback, no)
