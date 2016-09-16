if (myHero.charName ~= "Warwick") then return 	end
local version = 0.1
local scriptname = "WARWIGGEL"
local author ="THCLER"
local fokus = nil
local SSmite = false
local Last_LevelSpell = 0
local SpellInfo = {
	AA = {Range = myHero.range + myHero.boundingRadius},
	Q = {Range = 400},
	W = {Range = 1250},
	E = {},
	R = {Range = 700}
}local ItemList = {
        BoTRK = {id = 3153, slot = nil},
        Youmuu = {id = 3142, slot = nil},
        BoTRK0 = {id = 3144, slot = nil},
        GunBlade = {id = 3146, slot = nil},
        Tiamat = {id = 3077, slot = nil},
        HTitanin = {id = 3748, slot = nil},
        HRavenous = {id = 3074, slot = nil}, 
    }
end

function OnLoad() 
	ts = TargetSelector(TARGET_PRIORITY, 1000, DAMAGE_PHYSICAL)
	enemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC)
	jungleMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerSmite") then 
		Smite = SUMMONER_1 
		SSmite = true 
	elseif 
		myHero:GetSpellData(SUMMONER_2).name:find("SummonerSmite") then 
		Smite = SUMMONER_2 
		SSmite = true
	end
	AutoUpdate()
	Menu()
	LoadLib()

	Print("Ein hungernder Schlag" ..scriptname.."Gl&Hf")
	if VIP_USER then
 	Print("<font color=\"#FFFFFF\"> ( VIP ) Ver: <font color=\"#FFFF00\">"..version.." </font>Loaded. Have fun!")
 else
 	Print("<font color=\"#FFFFFF\"> ( FREE ) Ver: <font color=\"#FFFF00\">"..version.." </font>Loaded. Have fun!")
end

function Print(v)
    print("<font color=\"#00BFFF\"><b>[<font color=\"#FE9A2E\">Thcler</font>: WARWIGGEL!]</b></font> <font color=\"#FFFFFF\">" .. v .. "</font>")
end

function Menu()
	WarwW = scriptConfig("Glaxy Warwick", "GWconfig")
		WarwW:addSubMenu("WW - Combo Mode", "ConfigCombo")
	WarwW.ConfigCombo:addParam("ComboKey", "Default Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	WarwW.ConfigCombo:addParam("SpellQ", "Use Q in Combo mode:", SCRIPT_PARAM_ONOFF, true)
	WarwW.ConfigCombo:addParam("spellW", "Use W in Combo mode:", SCRIPT_PARAM_ONOFF, true)
	WarwW.ConfigCombo:addParam("spellW2", "Min HP For casting W", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
	WarwW.ConfigCombo:addParam("SpellR", "Use R in Combo mode:", SCRIPT_PARAM_ONOFF, true)
	WarwW.ConfigCombo:addParam("info1", "-> ITEMS IN COMBO MODE <-", SCRIPT_PARAM_INFO, "")
	WarwW.ConfigCombo:addParam("BoTRK", "Use BoTRK / Gun Blade in combo mode:", SCRIPT_PARAM_ONOFF, true)
	WarwW.ConfigCombo:addParam("Youmu", "Use Youmu in Combo mode:", SCRIPT_PARAM_ONOFF, true)
	WarwW.ConfigCombo:addParam("Hydra", "Use Hydra in Combo mode:", SCRIPT_PARAM_ONOFF, true)
	end
end
		WarwW:addSubMenu("WW - LaneClear Mode", "ConfigLane")
   	WarwW.ConfigLane:addParam("LaneKey", "Default LaneClear Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    WarwW.ConfigLane:addParam("LaneQ", "Use Q in LaneClear mode:", SCRIPT_PARAM_ONOFF, true)
    WarwW.ConfigLane:addParam("LaneW", "Use W in LaneClear mode:", SCRIPT_PARAM_ONOFF, true)
    WarwW.ConfigLane:addParam("LaneClearMana", "Min mana % to use Q:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)


		WarwW:addSubMenu("WW - JungleClear Mode", "ConfigJungle")
   	WarwW.ConfigJungle:addParam("JungleKey", "Default JungleClear Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
    WarwW.ConfigJungle:addParam("JungleQ", "Use Q in JungleClear mode:", SCRIPT_PARAM_ONOFF, true)
    WarwW.ConfigJungle:addParam("JungleW", "Use W in JungleClear mode:", SCRIPT_PARAM_ONOFF, true)
    WarwW.ConfigJungle:addParam("JungleClearMana", "Min mana % to use Q:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    	WarwW:addSubMenu("WW - Draw Settings", "Draw")
    WarwW.Draw:addParam("QDraw", "Enable Q Draw", SCRIPT_PARAM_ONOFF, true)
    WarwW.Draw:addParam("WDraw", "Enable W Draw", SCRIPT_PARAM_ONOFF, true)
    WarwW.Draw:addParam("EDraw", "Enable E Draw", SCRIPT_PARAM_ONOFF, true)
    WarwW.Draw:addParam("RDraw", "Enable R Draw", SCRIPT_PARAM_ONOFF, true)
    WarwW.Draw:addParam("AARange", "Enable AA Draw", SCRIPT_PARAM_ONOFF, true)
    WarwW.Draw:addParam("Färb", "Pick:", SCRIPT_PARAM_COLOR, {255,255,0,0})
	WarwW:addSubMenu("WW - Utility", "Utility")
end
	
	
function Human()
	return math.random(4, 5)
end

function OnDraw()
	if myHero.dead then return end
	if WarwW.Draw.QD and myHero:CanUseSpell(_Q) == READY then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.Q.Range, ARGB(WarwW.Draw.Color[1], WarwW.Draw.Color[2], WarwW.Draw.Color[3], WarwW.Draw.Color[4]))
	end
	if WarwW.Draw.WD and myHero:CanUseSpell(_W) == READY then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.W.Range, ARGB(WarwW.Draw.Color[1], WarwW.Draw.Color[2], WarwW.Draw.Color[3], WarwW.Draw.Color[4]))
	end
	if WarwW.Draw.ED and myHero:CanUseSpell(_E) == READY then
		local Elvl = myHero:GetSpellData(_E).level
  		local ERange = {1500, 2300, 3100, 3900, 4700}
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, ERange[Elvl], ARGB(WarwW.Draw.Color[1], WarwW.Draw.Color[2], WarwW.Draw.Color[3], WarwW.Draw.Color[4]))
	end
	if WarwW.Draw.RD and myHero:CanUseSpell(_R) == READY then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.R.Range, ARGB(WarwW.Draw.Color[1], WarwW.Draw.Color[2], WarwW.Draw.Color[3], WarwW.Draw.Color[4]))
	end
	if WarwW.Draw.AAD then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.AA.Range, ARGB(WarwW.Draw.Color[1], WarwW.Draw.Color[2], WarwW.Draw.Color[3], WarwW.Draw.Color[4]))
	end
	local target = fokus
  	if target == nil then return end
  	if (target ~= nil and target.type == myHero.type and target.team ~= myHero.team) then
    	DrawCircle(target.x, target.y, target.z, 100, ARGB(255,255,0,0))
    	local Pos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
    	DrawText("Target!", 20, Pos.x, Pos.y, ARGB(255,255,0,0))
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

    end
	if WarwW.ConfigCombo.ComboKey then
		Combo()
	end
	if WarwW.ConfigLane.LaneKey then
		LaneClear()
	end
	if WarwW.ConfigJungle.JungleKey then
		JungleClear()
	end
		UseItems()

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
			if myHero:CanUseSpell(_Q) == READY and WarwW.ConfigJungle.JungleQ and (myHero.mana >= (myHero.maxMana*(WarwW.ConfigJungle.JungleClearMana*0.01))) then
				CastQ(jminions)
			end
			if myHero:CanUseSpell(_W) == READY then
				CastW()
			end 
		end
	end
end

function LaneClear()
	for v, minions in ipairs(enemyMinions.objects) do
		if minions.visible then
			if myHero:CanUseSpell(_Q) == READY and WarwW.ConfigLane.LaneQ and (myHero.mana >= (myHero.maxMana*(WarwW.ConfigLane.LaneClearMana*0.01))) then
				CastQ(minions)
			end
			if myHero:CanUseSpell(_W) == READY then
				CastW()
			end 
		end
	end
end

function CastW()
	if CountEnemy(1250, myHero) >= WarwW.ConfigCombo.EnemyForW then
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

function UseItems()
	if WarwW.ConfigCombo.ComboKey then
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
    if WarwW.ConfigCombo.BoTRK and GetInventorySlotItem(3153) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY then
                CastSpell(GetInventorySlotItem(3153), Target)
            end
        end
    end
end
function BoTRK0()
     if WarwW.ConfigCombo.BoTRK and GetInventorySlotItem(3144) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY then
                CastSpell(GetInventorySlotItem(3144), Target)
            end
        end

    end
end
function GunBlade()
    if WarwW.ConfigCombo.BoTRK and GetInventorySlotItem(3146) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY then
                CastSpell(GetInventorySlotItem(3146), Target)
            end
        end
    end
end
function Youmuu()
	if WarwW.ConfigCombo.Youmu then
	    local Target = ts.target
	    if WarwW.ConfigCombo.Youmu and ValidTarget(Target, 1000) and GetInventorySlotItem(3142) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY then
	            CastSpell(GetInventorySlotItem(3142))
	        end
        end
    end
end
function Tiamat()
	if WarwW.ConfigCombo.Hydra then
	    local Target = ts.target
	    if WarwW.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3077) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY then
	            CastSpell(GetInventorySlotItem(3077))
	        end
        end
    end
end
function HRavenous()
	if WarwW.ConfigCombo.Hydra then
	    local Target = ts.target
	    if WarwW.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3074) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY then
	            CastSpell(GetInventorySlotItem(3074))
	        end
        end
    end
end
function HTitanin()
	if WarwW.ConfigCombo.Hydra then
	    local Target = ts.target
	    if WarwW.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3748) ~= nil then
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
---------------------- update ----------------

function AutoUpdate()
	local SCRIPT_NAME = "WARWIGGEL";
	local UPDATE_HOST = "raw.githubusercontent.com";
	local UPDATE_PATH = /SuperUserRoot/WARWIGGEL.lua".."?rand="..math.random(1,10000);
	local UPDATE_FILE_PATH = SCRIPT_PATH.._ENV.FILE_NAME;
	local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH;
	local ServerData = GetWebResult(UPDATE_HOST, "/SuperUserRoot/WARWIGGEL.version");
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil;
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				Print("New version available "..ServerVersion);
				Print(">>Updating, please don't press F9<<");
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () Print("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3);
			end
		else
			Print("Error while downloading version info");
		end
	end
