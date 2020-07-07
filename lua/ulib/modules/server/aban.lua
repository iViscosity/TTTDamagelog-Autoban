ABAN = {}
ABAN.Version	= 20200707

local bantime	= CreateConVar("aban_bantime", "1440", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "The time (in minutes) to ban someone for leaving with slays. Default: 1440 (1 day)", 0)
local multiply	= CreateConVar("aban_multiply", "1", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "Whether or not to multiply bantime by how many slays a person has.")
local notify	= CreateConVar("aban_notify", "1", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "Whether or not to let everyone know a person has been automatically banned.")
local exempt	= CreateConVar("aban_exempt_admins", "1", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "Whether or not to exempt (ignore) admins.")
local lowest	= CreateConVar("aban_lowest_admin_group", "operator", {FCVAR_ARCHIVE, FCVAR_PRINTABLEONLY}, "In your inheritance chain, this is the lowest rank that you'd like to be exempted if aban_exempt_admins is \"1\".")
local minslays	= CreateConVar("aban_min_slays", "1", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "The minimum amount of slays a player must have to be automatically banned.")

local prefix	= "[Autoban] "

function ABAN.BanPlayer(ply, slays)
	local reason = "Banned for leaving with %i %s"
	local notif = "%s was banned %s for leaving with %i %s."
	local time = bantime:GetInt()

	local timeStr, numStr

	if multiply:GetBool() then
		time = time * slays
	end

	local secs = time * 60
	timeStr = ULib.secondsToStringTime(secs) -- easier than doing it myself

	if slays == 1 then
		numStr = "slay"
	else
		numStr = "slays"
	end

	ULib.addBan(ply:SteamID(), time, prefix .. string.format(reason, slays, numStr), ply:Nick())

	if notify:GetBool() then
		ULib.tsayError(_, prefix .. string.format(notif, ply:Nick(), timeStr, slays, numStr), true)
	end
end

local function CheckForSlays(ply)
	if not sql.TableExists("damagelog_autoslay") then return end -- damagelogs doesn't exist on this server
	if ULib.bans[ply:SteamID()] then return end -- don't need to do anything if they were already banned
	if exempt:GetBool() and ply:CheckGroup(lowest:GetString()) then return end

	local data = sql.QueryRow("SELECT slays FROM damagelog_autoslay WHERE ply = '" .. ply:SteamID() .. "' LIMIT 1;")
	local slays

	if data then 
		slays = tonumber(data.slays)
	end

	if not slays
		or slays == 0
		or slays < minslays:GetInt() then return end

	ABAN.BanPlayer(ply, slays)
end
hook.Add("PlayerDisconnected", "CheckForSlays", CheckForSlays)