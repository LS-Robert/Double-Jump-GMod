local doubleJumpHeight = 300
local doubleJumpCooldownDefault = 5  -- Default cooldown time in seconds
local doubleJumpCooldown = doubleJumpCooldownDefault  -- Current cooldown time

hook.Add("KeyPress", "DoubleJumpKeyPress", function(ply, key)
    if key == IN_JUMP then
        local currentTime = CurTime()

        if ply:IsOnGround() then
            ply:SetNWBool("DoubleJumped", false)
        elseif not ply:GetNWBool("DoubleJumped", false) and (not ply.doubleJumpTime or currentTime - ply.doubleJumpTime >= doubleJumpCooldown) then
            local velocity = ply:GetVelocity()
            velocity.z = doubleJumpHeight
            ply:SetVelocity(velocity)

            ply:SetNWBool("DoubleJumped", true)

            ply.doubleJumpTime = currentTime

            -- Create a particle effect under the player (commented out to disable)
            -- local effectData = EffectData()
            -- effectData:SetOrigin(ply:GetPos() - Vector(0, 0, 20))  -- Adjust the effect position
            -- util.Effect("cball_explode", effectData)  -- Use the particle effect "cball_explode"
        end
    end
end)

hook.Add("OnPlayerHitGround", "DoubleJumpReset", function(ply)
    ply:SetNWBool("DoubleJumped", false)
end)

-- Command
concommand.Add("set_double_jump_cooldown", function(ply, cmd, args)
    if IsValid(ply) and ply:IsSuperAdmin() then
        local newCooldown = tonumber(args[1])

        if newCooldown and newCooldown >= 0 then
            doubleJumpCooldown = newCooldown
            print("Double jump cooldown set to " .. newCooldown .. " seconds.")
        else
            print("Please enter a valid value for the cooldown. Example: /set_double_jump_cooldown 5")
        end
    end
end)

-- Discord and IG: Anto_Orza
