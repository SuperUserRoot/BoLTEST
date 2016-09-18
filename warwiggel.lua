if (myHero.charName ~= "Warwick") then return 	end


local scriptname = "Warwiggel"
local fokus = nil
local SSmite = false
local Last_LevelSpell = 0
local SpellInfo = {
	AA = {Range = myHero.range + myHero.boundingRadius},
	Q = {Range = 400},
	W = {Range = 1250},
	E = {},
	R = {Range = 700}
}
local WWSkins = {
	["Warwick"] = {"Classic", "Grey", "Urf the Manatee", "Big Bad", "Tundra Hunter", "Feral", "Firefang", "Hyena", "Marauder"}
}
local ItemList = {
        BoTRK = {id = 3153, slot = nil},
        Youmuu = {id = 3142, slot = nil},
        BoTRK0 = {id = 3144, slot = nil},
        GunBlade = {id = 3146, slot = nil},
        Tiamat = {id = 3077, slot = nil},
        HTitanin = {id = 3748, slot = nil},
        HRavenous = {id = 3074, slot = nil}, 
    }

function OnLoad() 
	ts = TargetSelector(TARGET_PRIORITY, 10000, DAMAGE_PHYSICAL)
	enemyMinions = minionManager(MINION_ENEMY, 10000, myHero, MINION_SORT_HEALTH_ASC)
	jungleMinions = minionManager(MINION_JUNGLE, 70000, myHero, MINION_SORT_MAXHEALTH_DEC)
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerSmite") then 
		Smite = SUMMONER_1 
		SSmite = true 
	elseif 
		myHero:GetSpellData(SUMMONER_2).name:find("SummonerSmite") then 
		Smite = SUMMONER_2 
		SSmite = true
	end
    Menu()
	if VIP_USER then
		if ww.Utility.SkinC.Enablee then
			SetSkin(myHero, ww.Utility.SkinC.skins -1)
		end
	end
end



function Menu()
	ww = scriptConfig("Warwiggel", "GWconfig")
		ww:addSubMenu("WW - Combo Mode", "ConfigCombo")
	ww.ConfigCombo:addParam("ComboKey", "Default Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	ww.ConfigCombo:addParam("SpellQ", "Use Q in combo mode:", SCRIPT_PARAM_ONOFF, true)
	ww.ConfigCombo:addParam("spellW", "Use W in combo mode:", SCRIPT_PARAM_ONOFF, true)
	ww.ConfigCombo:addParam("EnemyForW", "Min Enemy For W", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
	ww.ConfigCombo:addParam("SpellR", "Use R in combo mode:", SCRIPT_PARAM_ONOFF, true)
	ww.ConfigCombo:addParam("info1", "-> ITEMS IN COMBO MODE <-", SCRIPT_PARAM_INFO, "")
	ww.ConfigCombo:addParam("BoTRK", "Use BoTRK / Gun Blade in combo mode:", SCRIPT_PARAM_ONOFF, true)
	ww.ConfigCombo:addParam("Youmu", "Use Youmu in combo mode:", SCRIPT_PARAM_ONOFF, true)
	ww.ConfigCombo:addParam("Hydra", "Use Hydra in combo mode:", SCRIPT_PARAM_ONOFF, true)



		ww:addSubMenu("WW - LaneClear Mode", "ConfigLane")
   	ww.ConfigLane:addParam("LaneKey", "Default LaneClear Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    ww.ConfigLane:addParam("LaneQ", "Use Q in LaneClear mode:", SCRIPT_PARAM_ONOFF, true)
    ww.ConfigLane:addParam("LaneW", "Use W in LaneClear mode:", SCRIPT_PARAM_ONOFF, true)
    ww.ConfigLane:addParam("LaneClearMana", "Min mana % to use Q:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)


		ww:addSubMenu("WW - JungleClear Mode", "ConfigJungle")
   	ww.ConfigJungle:addParam("JungleKey", "Default JungleClear Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
    ww.ConfigJungle:addParam("JungleQ", "Use Q in JungleClear mode:", SCRIPT_PARAM_ONOFF, true)
    ww.ConfigJungle:addParam("JungleW", "Use W in JungleClear mode:", SCRIPT_PARAM_ONOFF, true)
    ww.ConfigJungle:addParam("JungleClearMana", "Min mana % to use Q:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    	ww:addSubMenu("WW - Draw Settings", "Draw")
    ww.Draw:addParam("QD", "Enable Q Draw", SCRIPT_PARAM_ONOFF, true)
    ww.Draw:addParam("WD", "Enable W Draw", SCRIPT_PARAM_ONOFF, true)
    ww.Draw:addParam("ED", "Enable E Draw", SCRIPT_PARAM_ONOFF, true)
    ww.Draw:addParam("RD", "Enable R Draw", SCRIPT_PARAM_ONOFF, true)
    ww.Draw:addParam("AAD", "Enable AA Draw", SCRIPT_PARAM_ONOFF, true)
    ww.Draw:addParam("Color", "Color Changer:", SCRIPT_PARAM_COLOR, {255,255,0,0})
    ww.Draw:addParam("PermaShow", "WW - Perma Show:", SCRIPT_PARAM_ONOFF, true)
    	ww:addSubMenu("WW - Utility", "Utility")
if VIP_USER then  
  	ww.Utility:addSubMenu("WW - AutoLvlSpell", "autolvl")
  	ww.Utility.autolvl:addParam("levelSequence", "Status", SCRIPT_PARAM_ONOFF, false)
 	ww.Utility.autolvl:addParam("Humanizer", "Use Humanizer for "..myHero.charName..":", SCRIPT_PARAM_SLICE, 1000, 0, 3000, 0)
 	ww.Utility.autolvl:addParam("Mod", "Spell Order :", SCRIPT_PARAM_LIST, 1, {"R-Q-W-E", "R-Q-E-W", "R-W-Q-E", "R-W-E-Q", "R-E-Q-W", "R-E-W-Q"});
 	ww.Utility.autolvl.levelSequence = false

    	ww.Utility:addSubMenu("WW - AutoBuy", "buy")  
    ww.Utility.buy:addParam("Enable", "Enable AutoBuy :", SCRIPT_PARAM_ONOFF, true);  
    ww.Utility.buy:addParam("Doran", "Buy Sword Doran :", SCRIPT_PARAM_ONOFF, true);
    ww.Utility.buy:addParam("ISmite", "Buy Smite Item :", SCRIPT_PARAM_ONOFF, true);
    ww.Utility.buy:addParam("Pots", "Buy Pots :", SCRIPT_PARAM_ONOFF, true);
    ww.Utility.buy:addParam("Trinket", "Buy Trinket :", SCRIPT_PARAM_ONOFF, true)

    	ww.Utility:addSubMenu("WW - Skin Changer", "SkinC")
    ww.Utility.SkinC:addParam("Enablee", "Enable S.C: ", SCRIPT_PARAM_ONOFF, true)
    ww.Utility.SkinC:setCallback("Enablee", function (nV)
        if nV then
          	Print("<font color=\"#FFA07A\"><i> -- SkinChanger Loaded</i>") 
          	SetSkin(myHero, ww.Utility.SkinC.skins -1)
        else
          	SetSkin(myHero, -1)
        end
    end)
    ww.Utility.SkinC:addParam("skins", "Select [" .. myHero.charName.. "] Skin:", SCRIPT_PARAM_LIST, 1, WWSkins[myHero.charName])
    ww.Utility.SkinC:setCallback("skins", function (nV)
        if nV then 
          	if ww.Utility.SkinC.Enablee then
            	SetSkin(myHero, ww.Utility.SkinC.skins -1)
         	end
        end
    end)
end
end

function Human()
	return math.random(4, 5)
end

function Sequence()
	if ww.Utility.autolvl.Mod == 1 then
		levelSequence =  {1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3}
	elseif ww.Utility.autolvl.Mod == 2 then
		levelSequence =  {1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2}
	elseif ww.Utility.autolvl.Mod == 3 then
		levelSequence =  {2, 1, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3}
	elseif ww.Utility.autolvl.Mod == 4 then
		levelSequence =  {2, 3, 1, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1}
	elseif ww.Utility.autolvl.Mod == 5 then
		levelSequence =  {3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2}
	elseif ww.Utility.autolvl.Mod == 6 then
		levelSequence = {3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1}
	end
end

function OnWndMsg(msg, key)
	if msg == WM_LBUTTONDOWN then
		for i, t in ipairs(GetEnemyHeroes()) do
			if t.visible then
				if GetDistance(t, mousePos) <= 100 and ValidTarget(t) then
					if fokus ~= t then
						fokus = t
						Print("New Target: <font color=\"#ff66a3\"><u>"..t.charName.."</u></font>")
					else
						fokus = nil
						Print("Remove Targer: <font color=\"#ff66a3\"><u>"..t.charName.."</u></font>")
					end
				end
			end
		end
	end
end

function OnTick()
	enemyMinions:update()
	jungleMinions:update()
	ts:update()
    if ww.ConfigCombo.ComboKey then
		Combo()
	end
	if ww.ConfigLane.LaneKey then
		LaneClear()
	end
	if ww.ConfigJungle.JungleKey then
		JungleClear()
	end
		UseItems()
	if VIP_USER then
		Sequence()
		if ww.Utility.autolvl.levelSequence and os.clock() - Last_LevelSpell > 0 then
			DelayAction(function() autoLevelSetSequence(levelSequence)  end, ww.Utility.autolvl.Humanizer/1000)
	      	Last_LevelSpell = os.clock() + Human()
	    end
	end
end

function CountEnemy(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function JungleClear()
	for v, jminions in ipairs(jungleMinions.objects) do
		if jminions.visible then
			if myHero:CanUseSpell(_Q) == READY and ww.ConfigJungle.JungleQ and (myHero.mana >= (myHero.maxMana*(ww.ConfigJungle.JungleClearMana*0.01))) then
				CastQ(jminions)
			end
			if myHero:CanUseSpell(_W) == READY and ww.ConfigJungle.JungleQ then
				CastW()
			end 
		end
	end
end

function LaneClear()
	for v, minions in ipairs(enemyMinions.objects) do
		if minions.visible then
			if myHero:CanUseSpell(_Q) == READY and ww.ConfigLane.LaneQ and (myHero.mana >= (myHero.maxMana*(ww.ConfigLane.LaneClearMana*0.01))) then
				CastQ(minions)
			end
			if myHero:CanUseSpell(_W) == READY then
				CastW()
			end 
		end
	end
end

function CastW()
	if CountEnemy(1250, myHero) >= ww.ConfigCombo.EnemyForW then
		CastSpell(_W)
	end
end

function CastQ(unit)
	if unit == nil then return end
	if unit.visible then
		if GetDistance(unit) <= SpellInfo.Q.Range then
			if not unit.dead then
				CastSpell(_Q, unit)
			end
		end
	end
end

function CastR()
	local target = ts.target
	if target.visible then
		if GetDistance(target) <= SpellInfo.R.Range then
			if ValidTarget(target, SpellInfo.R.Range) then
				if not target.dead then
					CastSpell(_R, target)
				end
			end
		end
	end
end

function Combo()
	local target = fokus
  	if (target ~= nil and target.type == myHero.type and target.team ~= myHero.team) then
	  	if ValidTarget(target) then
			if target.visible then
				if myHero:CanUseSpell(_Q) == READY and GetDistance(target) <= SpellInfo.Q.Range then
					CastQ(target)
				end 
				if myHero:CanUseSpell(_W) == READY and GetDistance(target) <= SpellInfo.W.Range then
					CastW()
				end 
				if myHero:CanUseSpell(_R) == READY and GetDistance(target) <= SpellInfo.R.Range then
					CastR()
				end 
			end
		end
	else
		if ValidTarget(ts.target) then
			if ts.target.visible then
				if myHero:CanUseSpell(_Q) == READY and GetDistance(ts.target) <= SpellInfo.Q.Range then
					CastQ(ts.target)
				end 
				if myHero:CanUseSpell(_W) == READY and GetDistance(ts.target) <= SpellInfo.W.Range then
					CastW()
				end 
				if myHero:CanUseSpell(_R) == READY and GetDistance(ts.target) <= SpellInfo.R.Range then
					CastR()
				end 
			end
		end
	end
end


-------- items -----------
function UseItems()
	if ww.ConfigCombo.ComboKey then
	BoTRK()
	BoTRK0()
	Youmuu()
	GunBlade()
	Tiamat()
	HRavenous()
	HTitanin()	
	end
end
function BoTRK()
    if ww.ConfigCombo.BoTRK and GetInventorySlotItem(3153) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY then
                CastSpell(GetInventorySlotItem(3153), Target)
            end
        end
    end
end
function BoTRK0()
     if ww.ConfigCombo.BoTRK and GetInventorySlotItem(3144) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY then
                CastSpell(GetInventorySlotItem(3144), Target)
            end
        end

    end
end
function GunBlade()
    if ww.ConfigCombo.BoTRK and GetInventorySlotItem(3146) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY then
                CastSpell(GetInventorySlotItem(3146), Target)
            end
        end
    end
end
function Youmuu()
	if ww.ConfigCombo.Youmu then
	    local Target = ts.target
	    if ww.ConfigCombo.Youmu and ValidTarget(Target, 1000) and GetInventorySlotItem(3142) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY then
	            CastSpell(GetInventorySlotItem(3142))
	        end
        end
    end
end
function Tiamat()
	if ww.ConfigCombo.Hydra then
	    local Target = ts.target
	    if ww.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3077) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY then
	            CastSpell(GetInventorySlotItem(3077))
	        end
        end
    end
end
function HRavenous()
	if ww.ConfigCombo.Hydra then
	    local Target = ts.target
	    if ww.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3074) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY then
	            CastSpell(GetInventorySlotItem(3074))
	        end
        end
    end
end
function HTitanin()
	if ww.ConfigCombo.Hydra then
	    local Target = ts.target
	    if ww.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3748) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3748)) == READY then
	            CastSpell(GetInventorySlotItem(3748))
	        end
        end
    end
end
-------- lags free----------
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
  local radius = radius or 300
  local quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  local quality = 2 * math.pi / quality
  local radius = radius*.92
  local points = {}
  for theta = 0, 2 * math.pi + quality, quality do
  local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
   points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  DrawLines2(points, width or 1, color or 4294967295)
end
function round(num) 
  if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function DrawCircleLFC(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
    DrawCircleNextLvl(x, y, z, radius, 1, color, 75) 
  end
end
