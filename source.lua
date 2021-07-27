local spoofedIP = "never gonna give you up never gonna let you down never gonna run around and desert you never gonna make you cry never gonna say goodbye never gonna tell a lie and hurt you - H3x0R" -- The IP you want the logger to THINK it is.
-- Removed vulnerabillity to disable the hooks.

local IP_Trackers = {
    ["v4.ident.me"] = true,
    ["v4.ident.me/"] = true, -- Trailing slash check
    
    ["api.ipify.org"] = true,
    ["api.ipify.org/"] = true,
    
    ["httpbin.org/get"] = true,
    ["httpbin.org/get/"] = true,
    
    ["icanhazip.com"] = true,
    ["icanhazip.com/"] = true
}

local function IsTracker(Url)
    if IP_Trackers[string.gsub(Url, "https://", "")] or IP_Trackers[string.gsub(Url, "http://", "")] then -- Remove http/s to check domain.
        return true -- Tracker found!
    end
    return false
end

local old;
old = hookfunction(game.HttpGet, function(self, url, ...)
    if type(url) == "string" then
        if IsTracker(url) then
            warn(url.." was used to attempt to log your IP. This request was intercepted.")
            return spoofedIP -- Spoofed IP
        end
    end
    return old(self, url, ...)
end)

local oldSyn;
oldSyn = hookfunction(syn.request, function(a, b, ...)
    if type(a) == "table" then
        if IsTracker(a.Url) then
            warn(a.Url.." was used to attempt to log your IP. This request was intercepted.")
            return {
                StatusCode = 200,
                Body = spoofedIP
            }
        end
    end
    return oldSyn(a, b, ...)
end)
