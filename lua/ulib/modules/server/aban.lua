ABAN = {}
ABAN.Version = 20200414

ABAN.Config = {}
ABAN.Config.Bantime = 1440 -- The time (in minutes) to ban someone for leaving with slays. Default: 1440 (1 day)
ABAN.Config.Multiply = true -- Whether or not to multiply this time by how many slays a person has
ABAN.Config.NotifyAll = true -- Whether or not to let everyone know a person has been automatically banned.
ABAN.Config.ExemptAdmins = true -- Whether or not to exempt (ignore) admins.
ABAN.Config.LowestAdminGroup = "operator" -- In your inheritance chain, this is the lowest rank that you'd like to be exempted if ExemptAdmins is true.
ABAN.Config.MinSlays = 1 -- The minimum amount of slays a player must have to be automatically banned.
ABAN.Config.Prefix = "[Autoban] " -- Prefix to automated message (i.e. PREFIX .. *player* has been banned")

function ABAN.BanPlayer(ply, slays)
	local reason = "Banned for leaving with %i %s"
	local notif = "%s was banned %s for leaving with %i %s."
	local timeStr = ""
	local numStr = ""
	local time = ABAN.Config.Bantime
	local mult = ABAN.Config.Multiply

	if mult then
		time = time * slays
	end

	if time == 0 then
		timeStr = "permanently"
	elseif time == 1440 then
		timeStr = "for 1 day"
	else
		timeStr = "for " .. tostring(math.Round((time / 60) / 24)) .. " days"
	end

	if slays == 1 then
		numStr = "slay"
	else
		numStr = "slays"
	end

	ULib.addBan(ply:SteamID(), time, ABAN.Config.Prefix .. string.format(reason, slays, numStr), ply:Nick())

	if ABAN.Config.NotifyAll then
		ULib.tsayError(_, ABAN.Config.Prefix .. string.format(notif, ply:Nick(), timeStr, slays, numStr), true)
	end
end

local function CheckForSlays(ply)
	if not sql.TableExists("damagelog_autoslay") then return end
	local data = sql.QueryRow("SELECT slays FROM damagelog_autoslay WHERE ply = '" .. ply:SteamID() .. "' LIMIT 1;")
	local slays

	if data then 
		slays = tonumber(data.slays)
	end

	if slays == 0 then return end
	if ABAN.Config.ExemptAdmins and ply:CheckGroup(ABAN.Config.LowestAdminGroup) then return end
	if tonumber(slays) < tonumber(ABAN.Config.MinSlays) then return end

	ABAN.BanPlayer(ply, slays)
end
hook.Add("PlayerDisconnected", "CheckForSlays", CheckForSlays)