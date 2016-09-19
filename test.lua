if myHero.charName ~= "Graves" then return end
Config = scriptConfig("FreeElo", "output", false)

function OnLoad()
Config:addParam("Inject", "Inject?", SCRIPT_PARAM_ONOFF, false)
end

function OnProcessAttack(unit, attack)
	if unit.isMe and animation:lower():find("attack") and Config.Item("inject") then
		CastSpell(_E, mousePos)
		end	
	end

