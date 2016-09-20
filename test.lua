if myHero.charName ~= "Graves" then return end
Config = scriptConfig("FreeElo", "output", false)

function OnLoad()
	Config:addParam("Inject", "Inject?", SCRIPT_PARAM_ONOFF, false)
end

function OnProcessSpell(unit, spell)
  if (unit.isMe and spell.name:lower():find("attack")) and Config.Inject then
	CastSpell (_E, mousePos.x, mousePos.z)
  end
end
