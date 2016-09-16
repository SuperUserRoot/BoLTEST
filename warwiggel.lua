if (myHero.charName ~= "Warwick") then return 	end
local version = 0.3
local gameV = GetGameVersion():split(' ')[1]
local scriptname = "Glaxy Warwick"
local author ="Glaxy"
local contact = "dimitri.psarev"	
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
    
    -- http://bol-tools.com/ tracker
assert(load(Base64Decode("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"), nil, "bt", _ENV))()
TrackerLoad("Clm2GTpteoO4Al2Y")
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
end

function OnUnload()
	if VIP_USER then
		if GlaxyWW.Utility.SkinC.Enablee then
			SetSkin(myHero, -1)
		end
	end
	Print("<font color=\"#FFA07A\"><i> -- Galaxy WW Unload, BYE BYE! </i>" ..GetUser()) 
end

function Print(v)
    print("<font color=\"#00BFFF\"><b>[<font color=\"#FE9A2E\">GLAXY</font>: GlaxyWarwick!]</b></font> <font color=\"#FFFFFF\">" .. v .. "</font>")
end

function Menu()
	GlaxyWW = scriptConfig("Glaxy Warwick", "GWconfig")
		GlaxyWW:addSubMenu("WW - Combo Mode", "ConfigCombo")
	GlaxyWW.ConfigCombo:addParam("ComboKey", "Default Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	GlaxyWW.ConfigCombo:addParam("SpellQ", "Use Q in combo mode:", SCRIPT_PARAM_ONOFF, true)
	GlaxyWW.ConfigCombo:addParam("spellW", "Use W in combo mode:", SCRIPT_PARAM_ONOFF, true)
	GlaxyWW.ConfigCombo:addParam("EnemyForW", "Min Enemy For W", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
	GlaxyWW.ConfigCombo:addParam("SpellR", "Use R in combo mode:", SCRIPT_PARAM_ONOFF, true)
	GlaxyWW.ConfigCombo:addParam("info1", "-> ITEMS IN COMBO MODE <-", SCRIPT_PARAM_INFO, "")
	GlaxyWW.ConfigCombo:addParam("BoTRK", "Use BoTRK / Gun Blade in combo mode:", SCRIPT_PARAM_ONOFF, true)
	GlaxyWW.ConfigCombo:addParam("Youmu", "Use Youmu in combo mode:", SCRIPT_PARAM_ONOFF, true)
	GlaxyWW.ConfigCombo:addParam("Hydra", "Use Hydra in combo mode:", SCRIPT_PARAM_ONOFF, true)



		GlaxyWW:addSubMenu("WW - LaneClear Mode", "ConfigLane")
   	GlaxyWW.ConfigLane:addParam("LaneKey", "Default LaneClear Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    GlaxyWW.ConfigLane:addParam("LaneQ", "Use Q in LaneClear mode:", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.ConfigLane:addParam("LaneW", "Use W in LaneClear mode:", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.ConfigLane:addParam("LaneClearMana", "Min mana % to use Q:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)


		GlaxyWW:addSubMenu("WW - JungleClear Mode", "ConfigJungle")
   	GlaxyWW.ConfigJungle:addParam("JungleKey", "Default JungleClear Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
    GlaxyWW.ConfigJungle:addParam("JungleQ", "Use Q in JungleClear mode:", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.ConfigJungle:addParam("JungleW", "Use W in JungleClear mode:", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.ConfigJungle:addParam("JungleClearMana", "Min mana % to use Q:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    	GlaxyWW:addSubMenu("WW - Draw Settings", "Draw")
    GlaxyWW.Draw:addParam("QD", "Enable Q Draw", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.Draw:addParam("WD", "Enable W Draw", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.Draw:addParam("ED", "Enable E Draw", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.Draw:addParam("RD", "Enable R Draw", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.Draw:addParam("AAD", "Enable AA Draw", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.Draw:addParam("Color", "Color Changer:", SCRIPT_PARAM_COLOR, {255,255,0,0})
    GlaxyWW.Draw:addParam("PermaShow", "WW - Perma Show:", SCRIPT_PARAM_ONOFF, true)
    	GlaxyWW:addSubMenu("WW - Utility", "Utility")
if VIP_USER then  
  	GlaxyWW.Utility:addSubMenu("WW - AutoLvlSpell", "autolvl")
  	GlaxyWW.Utility.autolvl:addParam("levelSequence", "Status", SCRIPT_PARAM_ONOFF, false)
 	GlaxyWW.Utility.autolvl:addParam("Humanizer", "Use Humanizer for "..myHero.charName..":", SCRIPT_PARAM_SLICE, 1000, 0, 3000, 0)
 	GlaxyWW.Utility.autolvl:addParam("Mod", "Spell Order :", SCRIPT_PARAM_LIST, 1, {"R-Q-W-E", "R-Q-E-W", "R-W-Q-E", "R-W-E-Q", "R-E-Q-W", "R-E-W-Q"});
 	GlaxyWW.Utility.autolvl.levelSequence = false

    	GlaxyWW.Utility:addSubMenu("WW - AutoBuy", "buy")  
    GlaxyWW.Utility.buy:addParam("Enable", "Enable AutoBuy :", SCRIPT_PARAM_ONOFF, true);  
    GlaxyWW.Utility.buy:addParam("Doran", "Buy Sword Doran :", SCRIPT_PARAM_ONOFF, true);
    GlaxyWW.Utility.buy:addParam("ISmite", "Buy Smite Item :", SCRIPT_PARAM_ONOFF, true);
    GlaxyWW.Utility.buy:addParam("Pots", "Buy Pots :", SCRIPT_PARAM_ONOFF, true);
    GlaxyWW.Utility.buy:addParam("Trinket", "Buy Trinket :", SCRIPT_PARAM_ONOFF, true)

    	GlaxyWW.Utility:addSubMenu("WW - Skin Changer", "SkinC")
    GlaxyWW.Utility.SkinC:addParam("Enablee", "Enable S.C: ", SCRIPT_PARAM_ONOFF, true)
    GlaxyWW.Utility.SkinC:setCallback("Enablee", function (nV)
        if nV then
          	Print("<font color=\"#FFA07A\"><i> -- SkinChanger Loaded</i>") 
          	SetSkin(myHero, GlaxyWW.Utility.SkinC.skins -1)
        else
          	SetSkin(myHero, -1)
        end
    end)
    GlaxyWW.Utility.SkinC:addParam("skins", "Select [" .. myHero.charName.. "] Skin:", SCRIPT_PARAM_LIST, 1, WWSkins[myHero.charName])
    GlaxyWW.Utility.SkinC:setCallback("skins", function (nV)
        if nV then 
          	if GlaxyWW.Utility.SkinC.Enablee then
            	SetSkin(myHero, GlaxyWW.Utility.SkinC.skins -1)
         	end
        end
    end)
end

    GlaxyWW:addParam("info1", "", SCRIPT_PARAM_INFO, "")
    GlaxyWW:addParam("info2", ""..scriptname.." [ver. "..version.."]", SCRIPT_PARAM_INFO, "")
    GlaxyWW:addParam("info3", "Created by "..author.."", SCRIPT_PARAM_INFO, "")
    GlaxyWW:addParam("info4", "Contact me (SKYPE): "..contact.."", SCRIPT_PARAM_INFO, "")

    GlaxyWW:addTS(ts)
    ts.name = "Target"
end
function LoadLib()
    CPSPath = LIB_PATH.."CustomPermaShow.lua"
    if not FileExist(CPSPath) then
        Print("Custom Perma Show not found, wait Download...")
        CPSHost = "raw.githubusercontent.com"
        CPSWebPath = "/Superx321/BoL/common/CustomPermaShow.lua".."?rand="..math.random(1,10000)
        DownloadFile("https://"..CPSHost..CPSWebPath, CPSPath, function ()  end)
        DelayAction(function() require("CustomPermaShow") end, 5)
        Print("Custom Perma Show Downloaded and Loaded!")
    else
        require("CustomPermaShow")
        Print("Custom Perma Show Found!")
    end
end
function PermaShow()
    if GlaxyWW.Draw.PermaShow then
        	CustomPermaShow("                 Glaxy Warwick", "", true, nil, nil, nil, 2)
        if GlaxyWW.ConfigCombo.ComboKey then
            CustomPermaShow("Current Mode:", "        Combo", true, RGB(153, 0, 153), nil, nil, 1)
        elseif GlaxyWW.ConfigLane.LaneKey then
            CustomPermaShow("Current Mode:", "   LaneClear", true, RGB(113, 79, 6), nil, nil, 1)
        elseif GlaxyWW.ConfigJungle.JungleKey then
	        CustomPermaShow("Current Mode:", "   JungleClear", true, RGB(135, 23, 210), nil, nil, 1)
	    else
            CustomPermaShow("Current Mode:", "         None", true, RGB(12, 77, 198	), nil, nil, 1)
        end
    end
end

function Human()
	return math.random(4, 5)
end

function OnDraw()
	if myHero.dead then return end
	if GlaxyWW.Draw.QD and myHero:CanUseSpell(_Q) == READY then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.Q.Range, ARGB(GlaxyWW.Draw.Color[1], GlaxyWW.Draw.Color[2], GlaxyWW.Draw.Color[3], GlaxyWW.Draw.Color[4]))
	end
	if GlaxyWW.Draw.WD and myHero:CanUseSpell(_W) == READY then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.W.Range, ARGB(GlaxyWW.Draw.Color[1], GlaxyWW.Draw.Color[2], GlaxyWW.Draw.Color[3], GlaxyWW.Draw.Color[4]))
	end
	if GlaxyWW.Draw.ED and myHero:CanUseSpell(_E) == READY then
		local Elvl = myHero:GetSpellData(_E).level
  		local ERange = {1500, 2300, 3100, 3900, 4700}
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, ERange[Elvl], ARGB(GlaxyWW.Draw.Color[1], GlaxyWW.Draw.Color[2], GlaxyWW.Draw.Color[3], GlaxyWW.Draw.Color[4]))
	end
	if GlaxyWW.Draw.RD and myHero:CanUseSpell(_R) == READY then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.R.Range, ARGB(GlaxyWW.Draw.Color[1], GlaxyWW.Draw.Color[2], GlaxyWW.Draw.Color[3], GlaxyWW.Draw.Color[4]))
	end
	if GlaxyWW.Draw.AAD then
		DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellInfo.AA.Range, ARGB(GlaxyWW.Draw.Color[1], GlaxyWW.Draw.Color[2], GlaxyWW.Draw.Color[3], GlaxyWW.Draw.Color[4]))
	end
	local target = fokus
  	if target == nil then return end
  	if (target ~= nil and target.type == myHero.type and target.team ~= myHero.team) then
    	DrawCircle(target.x, target.y, target.z, 100, ARGB(255,255,0,0))
    	local Pos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
    	DrawText("Target!", 20, Pos.x, Pos.y, ARGB(255,255,0,0))
  	end
end

function Sequence()
	if GlaxyWW.Utility.autolvl.Mod == 1 then
		levelSequence =  {1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3}
	elseif GlaxyWW.Utility.autolvl.Mod == 2 then
		levelSequence =  {1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2}
	elseif GlaxyWW.Utility.autolvl.Mod == 3 then
		levelSequence =  {2, 1, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3}
	elseif GlaxyWW.Utility.autolvl.Mod == 4 then
		levelSequence =  {2, 3, 1, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1}
	elseif GlaxyWW.Utility.autolvl.Mod == 5 then
		levelSequence =  {3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2}
	elseif GlaxyWW.Utility.autolvl.Mod == 6 then
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

	if GlaxyWW.Draw.PermaShow then
        PermaShow()
    end
	if GlaxyWW.ConfigCombo.ComboKey then
		Combo()
	end
	if GlaxyWW.ConfigLane.LaneKey then
		LaneClear()
	end
	if GlaxyWW.ConfigJungle.JungleKey then
		JungleClear()
	end
		UseItems()
	if VIP_USER then
		Sequence()
		if GlaxyWW.Utility.autolvl.levelSequence and os.clock() - Last_LevelSpell > 0 then
			DelayAction(function() autoLevelSetSequence(levelSequence)  end, GlaxyWW.Utility.autolvl.Humanizer/1000)
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
			if myHero:CanUseSpell(_Q) == READY and GlaxyWW.ConfigJungle.JungleQ and (myHero.mana >= (myHero.maxMana*(GlaxyWW.ConfigJungle.JungleClearMana*0.01))) then
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
			if myHero:CanUseSpell(_Q) == READY and GlaxyWW.ConfigLane.LaneQ and (myHero.mana >= (myHero.maxMana*(GlaxyWW.ConfigLane.LaneClearMana*0.01))) then
				CastQ(minions)
			end
			if myHero:CanUseSpell(_W) == READY then
				CastW()
			end 
		end
	end
end

function CastW()
	if CountEnemy(1250, myHero) >= GlaxyWW.ConfigCombo.EnemyForW then
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

function AutoBuy()
	if VIP_USER then
		if SSmite then
	 		if GlaxyWW.Utility.buy.ISmite then 
				DelayAction(function() BuyItem(1041) end, 0.5)
			end
		else
			 DelayAction(function() BuyItem(1055) end, 0.5)
		end

		if GlaxyWW.Utility.buy.Pots then
			DelayAction(function() BuyItem(2003) end, 1)
		end

		if GlaxyWW.Utility.buy.Pots then
			DelayAction(function() BuyItem(2003) end, 2)
		end	

		if GlaxyWW.Utility.buy.Trinket then
			DelayAction(function() BuyItem(3340) end, 3)
		end
	end
end
-------- items -----------
function UseItems()
	if GlaxyWW.ConfigCombo.ComboKey then
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
    if GlaxyWW.ConfigCombo.BoTRK and GetInventorySlotItem(3153) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY then
                CastSpell(GetInventorySlotItem(3153), Target)
            end
        end
    end
end
function BoTRK0()
     if GlaxyWW.ConfigCombo.BoTRK and GetInventorySlotItem(3144) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY then
                CastSpell(GetInventorySlotItem(3144), Target)
            end
        end

    end
end
function GunBlade()
    if GlaxyWW.ConfigCombo.BoTRK and GetInventorySlotItem(3146) ~= nil then
        local Target = ts.target
        if Target and ValidTarget(Target, 610) then
            if myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY then
                CastSpell(GetInventorySlotItem(3146), Target)
            end
        end
    end
end
function Youmuu()
	if GlaxyWW.ConfigCombo.Youmu then
	    local Target = ts.target
	    if GlaxyWW.ConfigCombo.Youmu and ValidTarget(Target, 1000) and GetInventorySlotItem(3142) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY then
	            CastSpell(GetInventorySlotItem(3142))
	        end
        end
    end
end
function Tiamat()
	if GlaxyWW.ConfigCombo.Hydra then
	    local Target = ts.target
	    if GlaxyWW.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3077) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY then
	            CastSpell(GetInventorySlotItem(3077))
	        end
        end
    end
end
function HRavenous()
	if GlaxyWW.ConfigCombo.Hydra then
	    local Target = ts.target
	    if GlaxyWW.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3074) ~= nil then
	        if myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY then
	            CastSpell(GetInventorySlotItem(3074))
	        end
        end
    end
end
function HTitanin()
	if GlaxyWW.ConfigCombo.Hydra then
	    local Target = ts.target
	    if GlaxyWW.ConfigCombo.Hydra and ValidTarget(Target, 1000) and GetInventorySlotItem(3748) ~= nil then
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
	local SCRIPT_NAME = "GlaxyWarwick";
	local UPDATE_HOST = "raw.githubusercontent.com";
	local UPDATE_PATH = "/Prot0o/Scripts/master/GlaxyWarwick.lua".."?rand="..math.random(1,10000);
	local UPDATE_FILE_PATH = SCRIPT_PATH.._ENV.FILE_NAME;
	local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH;
	local ServerData = GetWebResult(UPDATE_HOST, "/Prot0o/Scripts/master/GlaxyWarwick.version");
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
end
