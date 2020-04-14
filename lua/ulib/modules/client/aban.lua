local warn = false

local function _warnPlayer()
    if warn then
        -- a bit hacky but lets the size scale to the player's name length and size and stuff. 
        -- there is probably a better way to do this but I suck at clientside scripting so here you go.
        local w, h = surface.GetTextSize("WARNING: " .. string.upper(LocalPlayer():Nick()))
        local w2, h2 = surface.GetTextSize("You currently have slays. If you leave now you may be banned.")

        draw.RoundedBox(8, (ScrW() / 2) - (ScrW() / 6), 50, ScrW() / 3, 75, Color(200, 25, 25, 255))

        draw.SimpleText("WARNING: " .. string.upper(LocalPlayer():Nick()), "DermaDefault", (ScrW() / 2) - w / 2, 90 - h)
        draw.SimpleText("You currently have slays. If you leave now you may be banned.", "DermaDefault", (ScrW() / 2) - w2 / 2, 105 - h2)
    end
end
hook.Add("HUDPaint", "WarnPlayer", _warnPlayer)

local function _recvWarn(len)
    local ent = net.ReadEntity()
    if ent ~= LocalPlayer() then return end
    local slays = net.ReadUInt(32)

    if slays > 0 then
        warn = true
    else
        warn = false
    end
end
net.Receive("DL_AutoslaysLeft", _recvWarn)