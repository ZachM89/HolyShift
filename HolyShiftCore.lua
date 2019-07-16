local doclaw = 0
local mobcurhealth = 100--UnitHealth('target')		
local drtable = {}
local curtime = nil
local combstarttime = nil
local temptime = nil
local numtargets = 0
local reportthreshold = 80
function HolyShift_OnLoad()
    if UnitClass("player") == "Druid" then
        this:RegisterEvent("PLAYER_ENTERING_WORLD")
        this:RegisterEvent("PLAYER_REGEN_ENABLED")
		this:RegisterEvent("PLAYER_REGEN_DISABLED")
        this:RegisterEvent("VARIABLES_LOADED")
        this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
        this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
        this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
        this:RegisterEvent("CHAT_MSG_MONSTER_YELL")
		this:RegisterEvent("SPELL_FAILED_NOT_BEHIND")
		this:RegisterEvent("UI_ERROR_MESSAGE")
		this:RegisterEvent("PLAYER_TARGET_CHANGED")
    end
    
	SlashCmdList["HOLYSHIFT"] = HolyShift_SlashCommand;
	SLASH_HOLYSHIFT1 = "/hsdps";
end
function HolyShift_SlashCommand(msg)

	local _,_, HScommand,HSoption = string.find(msg, "([%w%p]+)%s*(.*)$")
	--local _,_, HScommand, HSoption = string.find(msg,"([%w%p]+)%s(.)$")
	--HSPrint(HScommand)
	if HScommand == "dps" then
		HolyShiftAddon(HSInnervateUse,HSMCPUse,HSMPUse,HSDRUse,HSFLUse,HSClawAdd,HSTigerUse,HSShiftUse,HSCowerUse,HSTrinketOne,HSTrinketTwo,HSDeathrate)
	elseif HScommand == "innervate" then 
		if HSoption == "on" then
			HSInnervateUse = 1
			HSPrint('|cff008000HolyShift innervate enabled. HSInnervateUse = |cffffffff'..HSInnervateUse)
		elseif HSoption == "off" then
			HSInnervateUse = 0
			HSPrint('|cff008000HolyShift innervate disabled. HSInnervateUse = |cffffffff'..HSInnervateUse)
		end
	elseif HScommand == "mcp" then 
		if HSoption == "on" then
			HSMCPUse = 1
			HSPrint('|cff008000HolyShift manual crowd pummeler enabled. HSMCPUse = |cffffffff'..HSMCPUse)
		elseif HSoption == "off" then
			HSMCPUse = 0
			HSPrint('|cff008000HolyShift manual crowd pummeler disabled. HSMCPUse = |cffffffff'..HSMCPUse)
		end
	elseif HScommand == "manapot" then 
		if HSoption == "on" then
			HSMPUse = 1
			HSPrint('|cff008000HolyShift mana pot use enabled. HSMPUse = |cffffffff'..HSMPUse)
		elseif HSoption == "off" then
			HSMPUse = 0
			HSPrint('|cff008000HolyShift mana pot use disabled. HSMPUse = |cffffffff'..HSMPUse)
		end
	elseif HScommand == "demonicrune" then 
		if HSoption == "on" then
			HSDRUse = 1
			HSPrint('|cff008000HolyShift demonic rune use enabled. HSDRUse = |cffffffff'..HSDRUse)
		elseif HSoption == "off" then
			HSDRUse = 0
			HSPrint('|cff008000HolyShift demonic rune use disabled. HSDRUse = |cffffffff'..HSDRUse)
		end
	elseif HScommand == "flurry" then 
		if HSoption == "on" then
			HSFLUse = 1
			HSPrint('|cff008000HolyShift juju flurry use enabled. HSFLUse = |cffffffff'..HSFLUse)
		elseif HSoption == "off" then
			HSFLUse = 0
			HSPrint('|cff008000HolyShift juju flurry use disabled. HSFLUse = |cffffffff'..HSFLUse)
		end
	elseif HScommand == "clawadds" then 
		if HSoption == "on" then
			HSClawAdd = 1
			HSPrint('|cff008000HolyShift claw non-bosses enabled. HSClawAdd = |cffffffff'..HSClawAdd)
		elseif HSoption == "off" then
			HSClawAdd = 0
			HSPrint('|cff008000HolyShift claw non-bosses disabled. HSClawAdd = |cffffffff'..HSClawAdd)
		end
	elseif HScommand == "tiger" then 
		if HSoption == "on" then
			HSTigerUse = 1
			HSPrint("|cff008000HolyShift tiger's fury enabled. HSTigerUse = |cffffffff"..HSTigerUse)
		elseif HSoption == "off" then
			HSTigerUse = 0
			HSPrint("|cff008000HolyShift tiger's fury disabled. HSTigerUse = |cffffffff"..HSTigerUse)
		end
	elseif HScommand == "shift" then 
		if HSoption == "on" then
			HSShiftUse = 1
			HSPrint('|cff008000HolyShift powershift enabled. HSShiftUse = |cffffffff'..HSShiftUse)
		elseif HSoption == "off" then
			HSShiftUse = 0
			HSPrint('|cff008000HolyShift powershift disabled. HSShiftUse = |cffffffff'..HSShiftUse)
		end
	elseif HScommand == "cower" then 
		if HSoption == "on" then
			HSCowerUse = 1
			HSPrint('|cff008000HolyShift auto cower enabled. HSCowerUse = |cffffffff'..HSCowerUse)
		elseif HSoption == "off" then
			HSCowerUse = 0
			HSPrint('|cff008000HolyShift auto cower disabled. HSCowerUse = |cffffffff'..HSCowerUse)
		end
	elseif HScommand == "deathrate" then 
		if HSoption == "on" then
			HSDeathrate = 1
			HSPrint('|cff008000HolyShift deathrate report enabled. HSDeathrate = |cffffffff'..HSDeathrate)
		elseif HSoption == "off" then
			HSDeathrate = 0
			HSPrint('|cff008000HolyShift deathrate report disabled. HSDeathrate = |cffffffff'..HSDeathrate)
		end
	elseif HScommand == "tone" then 
		HSTrinketOne = HSoption
		HSPrint('|cff008000HolyShift HSTrinketOne = |cffffffff'..HSTrinketOne)
	elseif HScommand == "ttwo" then 
		HSTrinketTwo = HSoption
		HSPrint('|cff008000HolyShift HSTrinketTwo = |cffffffff'..HSTrinketTwo)
	elseif HSCommand == nil or HSCommand == "" then
		--HSPrint(HSCommand)
		HSPrint("---------------------")
		HSPrint("|cff008000HSInnervateUse = |cffffffff"..HSInnervateUse.."|cff008000. /hsdps innervate on or /hsdps innervate off to change")
		HSPrint("|cff008000HSMCPUse = |cffffffff"..HSMCPUse.."|cff008000. /hsdps mcp on or /hsdps mcp off to change")
		HSPrint("|cff008000HSMPUse = |cffffffff"..HSMPUse.."|cff008000. /hsdps manapot on or /hsdps manapot off to change")
		HSPrint("|cff008000HSDRUse = |cffffffff"..HSDRUse.."|cff008000. /hsdps demonicrune on or /hsdps demonicrune off to change")
		HSPrint("|cff008000HSFLUse = |cffffffff"..HSFLUse.."|cff008000. /hsdps flurry on or /hsdps flurry off to change")
		HSPrint("|cff008000HSClawAdd = |cffffffff"..HSClawAdd.."|cff008000. /hsdps clawadds on or /hsdps clawadds off to change")
		HSPrint("|cff008000HSTigerUse = |cffffffff"..HSTigerUse.."|cff008000. /hsdps tiger on or /hsdps tiger off to change")
		HSPrint("|cff008000HSShiftUse = |cffffffff"..HSShiftUse.."|cff008000. /hsdps shift on or /hsdps shift off to change")
		HSPrint("|cff008000HSCowerUse = |cffffffff"..HSCowerUse.."|cff008000. /hsdps cower on or /hsdps cower off to change")
		HSPrint("|cff008000HSDeathrate = |cffffffff"..HSDeathrate.."|cff008000. /hsdps deathrate on or /hsdps deathrate off to change")
		HSPrint("|cff008000HSTrinketOne = |cffffffff"..HSTrinketOne.."|cff008000. /hsdps tone 'Trinket Name' to change")
		HSPrint("|cff008000HSTrinketTwo = |cffffffff"..HSTrinketTwo.."|cff008000. /hsdps ttwo 'Trinket Name' to change")
	end
	
	--MPPrint("Disabled functions: class is not Warrior or 31 point talent not learned")
end
function HolyShift_OnEvent(event)
	if event == "PLAYER_ENTERING_WORLD" then
	end
	if event == "PLAYER_TARGET_CHANGED" then
		doclaw = 0
		--[[curtime = GetTime()
		combstarttime = GetTime()
		temptime = GetTime()
		mobcurhealth = UnitHealth('target')
		HSPrint(UnitName('target'))
		if mobcurhealth ~= 100 then
			mobcurhealth = 100
		end 
		if curtime ~= nil then
			curtime = nil
		end
		if temptime ~= nil then
			temptime = nil
		end]]
	end
	
	if event == "PLAYER_REGEN_DISABLED" then
		curtime = GetTime()
		combstarttime = GetTime()
		temptime = GetTime()
		mobcurhealth = UnitHealth('target')
		--HSPrint('Enterting combat. Current time is: '..curtime)
		--if secondspassed ~= 0 then
			--secondspassed = 0
		--end
		--for i = 1, table.getn(drtable) do
			--table.remove(drtable)
		--end
		--HSPrint("Leaving combat. doclaw = "..doclaw)
	end
	
	if event == "PLAYER_REGEN_ENABLED" then
		if deathrateyn == 1 then
			deathrate()
		end
		--HSPrint("Leaving combat. doclaw = "..doclaw)
		--combstarttime = 0
		if reportthreshold ~= 80 then
			reportthreshold = 80
		end
		if mobcurhealth ~= 100 then
			mobcurhealth = 100
		end 
		if curtime ~= nil then
			curtime = nil
		end
		if temptime ~= nil then
			temptime = nil
		end
		if doclaw ~= 0 then
			doclaw = 0
		end
	end
	
	if event == "UI_ERROR_MESSAGE" then
		if (strfind(arg1, "You must be")) then
			doclaw = 1
			--HSPrint("|cff008000Not behind the target, dummy---------------------")
		end
		if (strfind(arg1, "No charges remain")) then
			swapoutmcp()
			--doclaw = 1
			--HSPrint("|cff008000Not behind the target, dummy---------------------")
		end
	end
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if (strfind(arg1, "Your Claw")) then
			if doclaw == 1 then
				doclaw = 2
			elseif doclaw == 2 then
				doclaw = 0
			end
			--HSPrint("|cff008000You just clawed---------------------")
		end
		if (strfind(arg1, "Your Shred")) then
			if doclaw ~= 0 then
				doclaw = 0
			end
			--HSPrint("|cff008000You just Shredded---------------------")
		end
	end
	
	if event == "VARIABLES_LOADED" then
		HSPrint('HolyShift Loaded')
		
		if HSInnervateUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffInnervate Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffInnervate Disabled')
		end
		if HSMCPUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffManual Crowd Pummeler Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffManual Crowd Pummeler Disabled')
		end
		if HSMPUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffMana pot use Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffMana pot use Disabled')
		end
		if HSDRUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffDemonic rune use Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffDemonic rune use Disabled')
		end
		if HSFLUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffJuju flurry use Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffJuju flurry use Disabled')
		end
		if HSClawAdd == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffClaw non-bosses Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffClaw non-bosses Disabled')
		end
		if HSTigerUse == 1 then
			HSPrint("|cff008000HolyShift: |cffffffffTiger's Fury Enabled")
		else
			HSPrint("|cff008000HolyShift: |cffffffffTiger's Fury Disabled")
		end
		if HSShiftUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffPowershift Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffPowershift Disabled')
		end
		if HSCowerUse == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffAuto Cower Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffAuto Cower Disabled')
		end
		if HSTrinketOne == nil then
			HSPrint('|cff008000HolyShift: |cffffffffTRINKET SWAP: No trinket assigned for HSTrinketOne')
		else
			HSPrint('|cff008000HolyShift: |cffffffffTRINKET SWAP: TrinketOne = '..HSTrinketOne)
		end
		if HSTrinketTwo == nil then
			HSPrint('|cff008000HolyShift: |cffffffffTRINKET SWAP: No trinket assigned for HSTrinketTwo')
		else
			HSPrint('|cff008000HolyShift: |cffffffffTRINKET SWAP: HSTrinketTwo = '..HSTrinketTwo)
		end
		if HSDeathrate == 1 then
			HSPrint('|cff008000HolyShift: |cffffffffDeathrate report Enabled')
		else
			HSPrint('|cff008000HolyShift: |cffffffffDeathrate report Disabled')
		end
		
		if UnitClass("player") == "Druid" then
            if HSInnervateUse == nil then
                HSInnervateUse = 0
            else
                tonumber(HSInnervateUse)
            end
            if HSMCPUse == nil then
                HSMCPUse = 0
            else
                tonumber(HSMCPUse)
            end
            if HSMPUse == nil then
                HSMPUse = 0
            else
                tonumber(HSMPUse)
            end
            if HSDRUse == nil then
                HSDRUse = 0
            else
                tonumber(HSDRUse)
            end
            if HSFLUse == nil then
                HSFLUse = 0
            else
                tonumber(HSFLUse)
            end
			if HSClawAdd == nil then
                HSClawAdd = 0
            else
                tonumber(HSClawAdd)
            end
			if HSTigerUse == nil then
                HSTigerUse = 0
            else
                tonumber(HSTigerUse)
            end
			if HSShiftUse == nil then
                HSShiftUse = 0
            else
                tonumber(HSShiftUse)
            end
			if HSCowerUse == nil then
                HSCowerUse = 0
            else
                tonumber(HSCowerUse)
            end
			if HSTrinketOne == nil then
                HSTrinketOne = 'None'
            end
			if HSTrinketTwo == nil then
                HSTrinketTwo = 'None'
            end
		end
	end
end
function HSPrint(msg)
    if (not DEFAULT_CHAT_FRAME) then
        return
    end
    DEFAULT_CHAT_FRAME:AddMessage((msg))
end
function EShift()
    local a,c=GetActiveForm()
    if(a==0) then
        CastShapeshiftForm(c) --Innervate put cat form on gcd so shift doesnt happen
    elseif(not IsSpellOnCD('Cat Form')) then
        CastShapeshiftForm(a)
        ToggleAutoAttack("off")
    end
end
function QuickShift()
    local a,c=GetActiveForm()
    if(a==0) then
        CastShapeshiftForm(c) --Innervate put cat form on gcd so shift doesnt happen
    else
        CastShapeshiftForm(a)
        ToggleAutoAttack("off")
    end
end
function ToggleAutoAttack(switch)
    if(switch == "off") then
        if(findAttackActionSlot() ~= 0) then
            AttackTarget()
        end
    elseif(switch == "on") then
        if(findAttackActionSlot() == 0) then
            AttackTarget()
        end
    end
end
function HolyShiftAddon(nervyn,mcpuse,mpuse,druse,fluse,clawad,tfuse,shiftuse,coweruse,tswapone,tswaptwo,deathrateon)
uac=UnitAffectingCombat
uibn=UseItemByName
giil=GetInventoryItemLink
giicd=GetInventoryItemCooldown
u=UnitMana('Player')
c=CastSpellByName
f=UnitPowerType("Player")
p=GetComboPoints("unit","target")
tot,rot=UnitName("targettarget")
romyn = HSBuffChk("INV_Misc_Rune")
stealthyn = HSBuffChk("Ability_Ambush")
shredtext = "Spell_Shadow_VampiricAura"
clawtext = "Ability_Druid_Rake"
partynum = GetNumPartyMembers()
romcd,romeq,rombag,romslot = ItemInfo('Rune of Metamorphosis')
kotscd,kotseq,kotsbag,kotsslot = ItemInfo('Kiss of the Spider')
gcloakcd,gcloakeq,gcdevbag,gcdevslot = ItemInfo('Gnomish Cloaking Device')
escd,eseq,esbag,esslot = ItemInfo('Earthstrike')
playername,_ = UnitName('player')
clawab = "Claw"
shredab = "Shred"
currentMana, maxMana = LunaUF.DruidManaLib:GetMana()
local flcd,_,flbag,flslot = ItemInfo('Juju Flurry')
local lipcd,_,lipbag,lipslot = ItemInfo('Limited Invulnerability Potion')
nervst, nervdur,_ = GetSpellCooldown(GetSpellID('Innervate'), "spell")
nervcd = nervdur - (GetTime() - nervst)
ferocity = SpecCheck(2,1)
impshred = SpecCheck(2,9)
natshapeshiftr = SpecCheck(1,7)
shth = 15
copobu = 100 - (40 + impshred*6 + 20)
idolofferocity = 0
nervuse = nervyn
pummelyn = mcpuse
dryn = druse
flyn = fluse
mpyn = mpuse
shiftyn = shiftuse
tfyn = tfuse
clawyn = clawad
coweryn = coweruse
trinketone = tswapone
trinkettwo = tswaptwo
deathrateyn = deathrateon
--trinketswap(trinketone,trinkettwo)
if(string.find(giil('player',18), 'Idol of Ferocity')) then
	idolofferocity = 3
end
if uac('player') and deathrateyn == 1 then --and UnitLevel('target') == -1 then
	deathrate()
end
	if(romyn == true) then
		shth = 30
	end
	if(f==3) then --and (gcloakeq == 0 and gcloakcd ~= 0 and HSBuffChk("Spell_Nature_Invisibilty") == false) then
		if stealthyn == true then
			if HSBuffChk('Ability_Mount_JungleTiger') == false then
				CastSpellByName("Tiger's Fury(Rank 4)")
			end
			if CheckInteractDistance('target',3) == 1 then
				cast("Ravage")
			end
		else
			if tot == playername then --or (UnitLevel('target') ~= -1 and clawyn == 1) then
				if UnitLevel('target') == -1 then --If target is a boss then shift out so you can LIP
					if lipcd == 0 and lipslot ~= 0 then
						EShift()
					elseif(not IsSpellOnCD("Cower")) then
						c"Cower"
					elseif(not IsSpellOnCD("Barkskin")) then
						EShift()
					else
						Atk(clawab,pummelyn)
					end
				else --Else if target is not a boss
					if partynum > 2 then
						if(not IsSpellOnCD("Cower")) and coweryn == 1 then
							c"Cower"
						else
							Atk(clawab,pummelyn)
						end
					else
						Atk(clawab,pummelyn)
					end
				end
			else
				if clawyn == 1 then
					Atk(clawab,pummelyn)
				else
					if doclaw == 0 then 
						Atk(shredab,pummelyn)
					elseif doclaw == 1 then
						Atk(clawab,pummelyn)
					elseif doclaw == 2 then
						Atk(clawab,pummelyn)
					end
				end
			end
		end
	else
		if UnitLevel('target') == -1
		and uac('Player')
		and UnitInRaid('Player') then
			if tot == playername then
				if UnitName('target') ~= "Eye of C'Thun" 
				and UnitName('target') ~= "Anub'Rekhan" then
					if lipcd == 0 and lipslot ~= 0 then
						uibn("Limited Invulnerability Potion")
					elseif(not IsSpellOnCD("Barkskin")) then
						c"Barkskin"
					end
				end
			else
				if UnitHealth('target') > 10 then
					Restore(romeq,romcd,nervuse)
				end
			end
			if flcd == 0 and flyn == 1 and CheckInteractDistance('target',3) == 1 then
				UseContainerItem(flbag, flslot)
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			end
			if UnitName('target') == 'Chromaggus' then BrzRmv() end
		end
		if(not IsSpellOnCD("Cat Form")) then
			EShift()
		end
	end
end
function Atk(CorS,pummelz)
	--StAttack()
	local abiltext = nil
	local fbthresh = 5
	local manathresh = 90
	if UnitName('target') == 'Loatheb' then
		manathresh = 900
	end
	if UnitLevel('target') ~= -1 then
		if UnitLevel('target') > 60 then
			if UnitHealth('target') < 30 then
				if UnitHealth('target') > 10 then
					fbthresh = 4
				elseif UnitHealth('target') > 5 then
					fbthresh = 2
				else
					fbthresh = 1
				end
			end
		else
			if UnitHealth('target') > 30 then
				fbthresh = 4
			else
				if UnitHealth('target') > 10 then
					fbthresh = 2
				else
					fbthresh = 1
				end
			end
		end
	else
		PopSkeleton()
		if pummelz == 1 then 
			pummel() 
		end
		if uac('Player') and kotseq ~= -1 and kotscd == 0 and UnitName('target') ~= "Razorgore the Untamed" and CheckInteractDistance('target',3) == 1 then
			uibn("Kiss of the Spider")
		end 
		if uac('Player') and eseq ~= -1 and escd == 0 and UnitName('target') ~= "Razorgore the Untamed" and CheckInteractDistance('target',3) == 1 then
			uibn("Earthstrike")
		end
		--[[if trinketone ~= nil and trinkettwo ~= nil and trinketone ~= "none" and trinkettwo ~= "none" and gcloakeq ~= 0 then
			if --[[uac('Player') and eseq ~= 0 and]] escd < 100 and escd ~= 0 then
				--HSPrint(escd)
				--HSPrint(eseq)
				trinketswap(trinketone,trinkettwo)
			elseif HSBuffChk('Spell_Nature_Invisibilty') == true and gcloakcd > 30 then
				trinketswap(trinketone,trinkettwo)
			end
			if --[[uac('Player') and]] romeq ~= 0 and romcd < 100 and romcd ~= 0 then
				--trinketswap(trinketone,trinkettwo)
			end
		end]]
	end
	if UnitIsDead('target') then --and doclaw ~= 0 then
		doclaw = 0
		--HSPrint("Target dead. Doclaw = "..doclaw.."------------------")
	end
	if CorS == "Claw" then
		abiltext = clawtext
		copobu = 100 - (55 + ferocity + 20 + idolofferocity)
	elseif CorS == "Shred" then
		abiltext = shredtext
	end
	-------------------------------------------------
	--[[if HSBuffChk("Spell_Nature_Invisibilty") == true and gcloakeq ~= 0 and gcloakcd > 3598 then
		StAttack(0)
		HSPrint(gcloakcd)
		HSPrint('Attempting trinket swap')
	else]]
		--HSPrint(copobu)
		StAttack(1)

		if CheckInteractDistance('target',3) ~= 1 then
			if isTDebuff('target', 'Spell_Nature_FaerieFire') == false and stealthyn == false then
				CastSpellByName("Faerie Fire (Feral)(Rank 4)")
			end
			if HSBuffChk('Ability_Mount_JungleTiger') == false and u >= copobu + 30 and tfyn == 1 then
				CastSpellByName("Tiger's Fury(Rank 4)")
			end
		end
		if (HSBuffChk("Spell_Shadow_ManaBurn") == false) then
			if(p<fbthresh) then
				if u>=copobu then
					if isuse(FindActionSlot(abiltext)) == 1 then
						if not IsSpellOnCD(CorS) then
							cast(CorS)
							--HSPrint(doclaw)
						end
					end
				else
					if uac('Player') and UnitExists("target") then
						if isTDebuff('target', 'Spell_Nature_FaerieFire') == false and stealthyn == false and not IsSpellOnCD("Faerie Fire (Feral)") then
							CastSpellByName("Faerie Fire (Feral)(Rank 4)")
						end
						if (currentMana >= manathresh or romyn == true and romcd > 282) and shiftyn == 1 then
							if not(HSBuffChk("Spell_Nature_Invisibilty") == true and gcloakeq ~= -1 and gcloakcd > 3598) then--<<<----------------
								EShift()
							end
						end
					end
				end
			else
				if u>=shth then
					if isuse(FindActionSlot("Ability_Druid_FerociousBite")) == 1 then
						if not IsSpellOnCD("Ferocious Bite") then
							c"Ferocious Bite"
						end
					end
				else
					if uac('Player') and UnitExists("target") then
						if isTDebuff('target', 'Spell_Nature_FaerieFire') == false and stealthyn == false and not IsSpellOnCD("Faerie Fire (Feral)") then
							CastSpellByName("Faerie Fire (Feral)(Rank 4)")
						end
						if (currentMana >= manathresh or romyn == true and romcd > 282) and shiftyn == 1 then
							if not(HSBuffChk("Spell_Nature_Invisibilty") == true and gcloakeq ~= -1 and gcloakcd > 3598) then--<<<----------------
								EShift()
							end
						end
					end
				end
			end
		elseif (not IsSpellOnCD(CorS)) then
			cast(CorS)
		end
	--end
	-------------------------
end
function Restore(rom,romcd,nervyn)
	local resto = 1500
	local hthresh = 5
	local mpcd,_,mpbag,mpslot = ItemInfo('Major Mana Potion')
	local smcd,_,smbag,smslot = ItemInfo('Superior Mana Potion')
	local drcd,_,drbag,drslot = ItemInfo('Demonic Rune')
	local hscd,_,hsbag,hsslot = ItemInfo('Major Healthstone')
	local mpot = mpslot + smslot
	local curhp = Num_Round((UnitHealth('player')/UnitHealthMax('player')),2)
	if curhp < 0.4 and hsslot ~= 0 and hscd == 0 then
		uibn("Major Healthstone")
	end
	if HSBuffChk("INV_Potion_97") == true  then
		resto = 2800
		hthresh = 1
	end
	if UnitHealth('target') > hthresh then
		if u<resto then
			if(not IsSpellOnCD("Innervate")) and nervyn == 1 then
				c("Innervate",1)
			elseif HSBuffChk("Spell_Nature_Lightning") == false and nervcd < 340 and romyn == false then
				if rom ~= -1 and romcd == 0 then
					if CheckInteractDistance('target',3) == 1 then
						uibn("Rune of Metamorphosis")
					end
				else
					if (mpcd == 0 or smcd == 0) and (drcd == 0 or drcd == -1) and mpot ~= 0 and mpyn == 1 then
						if mpslot ~= 0 then
							uibn("Major Mana Potion")
						else
							uibn("Superior Mana Potion")
						end
					else
						if (mpcd > 0 or smcd > 0 or mpcd == -1 or smcd == -1) and drcd == 0 and drslot ~= 0 and dryn == 1 and UnitHealth('player') > 1000 then
							uibn("Demonic Rune")
						elseif (drcd > 0 or drcd == -1) and (mpcd == 0 or smcd == 0) and mpot ~= 0 and mpyn == 1 then
							if mpslot ~= 0 then
								uibn("Major Mana Potion")
							else
								uibn("Superior Mana Potion")
							end
						end
					end
				end
			end
		end
	end
end
function ItemInfo(iname)
	local ItemEquip = -1
	local ItemCdr = 0
	local ContainerBag = nil
	local ContainerSlot = nil
	for slot = 0, 19 do --Check player paper doll slots.
		if GetInventoryItemLink('player',slot) ~= nil then
			if string.find(GetInventoryItemLink('player',slot),iname) then
				ItemEquip = slot
				break
			end
		end
	end
	if ItemEquip == -1 then --Item is not equipped. Check player inventory.
		for bag = 0, 4, 1 do
			for slot = 1, GetContainerNumSlots(bag), 1 do
				local name = GetContainerItemLink(bag,slot)
				if name then
					if string.find(name,iname) then
						ContainerBag = bag
						ContainerSlot = slot
						break
					end
				end
			end
		end
	end
	if ContainerBag == nil then ContainerBag = 0 end
	if ContainerSlot == nil then ContainerSlot = 0 end
	if ItemEquip ~= -1 then --item is equipped
		icdstart,icddur,_ = GetInventoryItemCooldown('player',ItemEquip)
		ItemCdr = Num_Round(icddur - (GetTime() - icdstart),2)
	elseif ContainerSlot ~= 0 then -- Item is in container slot
		icdstart, icddur,_ = GetContainerItemCooldown(ContainerBag, ContainerSlot)
		ItemCdr = Num_Round(icddur - (GetTime() - icdstart),2)
	end
	
	if ItemCdr < 0 then ItemCdr = 0 end
	return ItemCdr,ItemEquip,ContainerBag,ContainerSlot
end
function HSBuffChk(texture)
	local i=0
	local g=GetPlayerBuff
	local isBuffActive = false
	while not(g(i) == -1)
	do
		if(strfind(GetPlayerBuffTexture(g(i)), texture)) then isBuffActive = true end
		i=i+1
	end
	return isBuffActive
end
function GetSpellID(sn)
	local i,a
		i=0
	while a~=sn do
		i=i+1
		a=GetSpellName(i,"spell")
	end
	return i
end
function IsSpellOnCD(sn)
    local gameTime = GetTime()
    local start,duration,_ = GetSpellCooldown(GetSpellID(sn), "spell")
    local cdT = start + duration - gameTime
    return (cdT >= 0.1)
end
function GetActiveForm()
    local _, formName, active = nil
    local formId = 0
    local catId = nil
    for i=1,GetNumShapeshiftForms(), 1 do
        _, formName, active = GetShapeshiftFormInfo(i)
        if(string.find(formName, "Cat Form")) then
            catId = i
        end
        if(active ~= nil)then
            formId = i
        end
    end
    return formId, catId
end
function findAttackActionSlot()
    for i = 1, 120, 1
        do
        if(IsAttackAction(i) == 1 and IsCurrentAction(i) == 1) then
        return i end
    end
    return 0
end
function CheckInv(itemName)
	local id1 = nil
	local id2 = nil
	for bag = 0, 4, 1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			local name = GetContainerItemLink(bag,slot)
			if name then
				if string.find(name, itemName) then
					id1 = bag
					id2 = slot
					break
				end
			end
		end
	end
	if id1 == nil then id1 = 0 end
	if id2 == nil then id2 = 0 end
	return id1, id2
end
function FindActionSlot(spellTexture)	
	for i = 1, 120, 1
		do
		if(GetActionTexture(i) ~= nil) then 
		if(string.find(GetActionTexture(i), spellTexture)) then return i end end
	end
	return 0
end
function isuse(abil)
	isUsable, notEnoughMana = IsUsableAction(abil)
	if isUsable == nil then
		isUsable = 0
	end
	return isUsable
end
function trinketswap(trinket1,trinket2) --Only sort of works
	if trinket1 == nil or trinket2 == nil then return end
	local secondtrinkloc = 0
	local gnomecloakcd,gnomecloakeq,gnomecloakbag,gnomecloakslot = ItemInfo('Gnomish Cloaking Device')
	if gnomecloakeq == 13 then
		secondtrinkloc = 14
	else
		secondtrinkloc = 13
	end
	local t1cd,t1eq,t1bag,t1slot = ItemInfo(trinket1)
	local t2cd,t2eq,t2bag,t2slot = ItemInfo(trinket2)
	if uac('Player') and gnomecloakeq ~= -1 and gnomecloakcd == 0 then
		UseItemByName('Gnomish Cloaking Device')
		ToggleAutoAttack("off")
	end
	if HSBuffChk("Spell_Nature_Invisibilty") and gnomecloakeq ~= -1 and gnomecloakcd > 30  then
		--[[if eseq ~= 0 and escd > 30 then
			PickupInventoryItem(secondtrinkloc)
			PickupContainerItem(t1bag,t1slot)
		elseif romeq ~= 0 and romcd > 30 then
			PickupInventoryItem(secondtrinkloc)
			PickupContainerItem(t1bag,t1slot)
		else]]
		if(string.find(giil('player',gnomecloakeq), 'Gnomish Cloaking Device')) then --and (string.find(giil('player',secondtrinkloc), trinket1) == false)then
		--if HSBuffChk('Ambush') == false then
			--CastSpellByName('Prowl')
		--end
			PickupInventoryItem(secondtrinkloc)
			PickupContainerItem(t1bag,t1slot)
		end
		if(string.find(giil('player',secondtrinkloc), trinket1)) then
			
			PickupInventoryItem(gnomecloakeq)
			PickupContainerItem(t2bag,t2slot)
		end
	end
end
function PopSkeleton()
	local tloc = giil("player", 17)
	local tokcd,tokeq,tokbag,tokslot = ItemInfo('Tome of Knowledge')
	local offhand = 'Ancient Cornerstone Grimoire'
	if tloc ~= nil then
		if(string.find(tloc, offhand)) then
			local acgcdr,acgeq,acgbag,acgslot = ItemInfo(offhand)
			if acgcdr == 0 and CheckInteractDistance('target',3) == 1 then
				UseItemByName('Ancient Cornerstone Grimoire')
			elseif acgcdr > 30 then
				PickupInventoryItem('17')
				PickupContainerItem(tokbag,tokslot)
			end
		end
	end
end
function pummel()
	local tloc = giil("player", 16)
	local wep = 'Manual Crowd Pummeler'
	local cd,t = 30, GetTime()
	if tloc ~= nil then
		if(string.find(tloc, wep)) then
			local mcpstart, mcpdur, _ = giicd("player", 16)
			local mcpcdr = mcpdur - (GetTime() - mcpstart)
			if mcpcdr < 0 then mcpcdr = 0 end
			if mcpcdr == 0 then
				if t-cd >= (TSSW or 0) and CheckInteractDistance('target',3) == 1 then 
					TSSW = t
					UseItemByName('Manual Crowd Pummeler')
				end
			end
		end
	end
end
function swapoutmcp()
	local tloc = GetInventoryItemLink("player", 16)
	local wep = 'Manual Crowd Pummeler'
	local bqwhcd,bqwheq,bqwhbag,bqwhslot = ItemInfo('Blessed Qiraji War Hammer')
	local tokcd,tokeq,tokbag,tokslot = ItemInfo('Tome of Knowledge')
	if tloc ~= nil then
		if(string.find(tloc, wep)) then
			PickupInventoryItem('16')
			PickupContainerItem(bqwhbag,bqwhslot)
		end
	end
	UseItemByName('Tome of Knowledge')
end
function BrzRmv()
	local debuff = "Bronze"
	for i=1,16 do
		local name = UnitDebuff("player",i)
		if name ~= nil and string.find(name, debuff) then
			UseItemByName("Hourglass Sand",1)
		end
	end
end
function Num_Round(number,decimals)
	return math.floor((number*math.pow(10,decimals)+0.5))/math.pow(10,decimals);
end
function StAttack(switch)
    for i = 1, 120, 1 do
        if IsAttackAction(i) == 1 then
			if IsCurrentAction(i) ~= switch then
				AttackTarget()
			end
		end
	end
end
function isTDebuff(target, debuff)
    local isDebuff = false
    for i = 1, 40 do
        if(strfind(tostring(UnitDebuff(target,i)), debuff)) then 
			isDebuff = true 
		end
    end
    return isDebuff
end
function deathrate()
	local totalaverage = 0
	local mobhealth = nil
	local fightlength = 0
	local mobmaxhealth = 100
	if UnitExists('target') then
		mobhealth = 100
	else
		mobhealth = 0
	end
	if GetTime() > Num_Round(combstarttime,2) --[[+ 1]] and combstarttime ~= nil then
		curtime = Num_Round(GetTime(),2)-combstarttime --Calculates the number of seconds in combat
		if UnitExists('target') then
			mobmaxhealth = UnitHealthMax('target')
		else
			mobmaxhealth = 100
		end
		if UnitExists('target') then
			mobhealth = UnitHealth('target')
		else
			mobhealth = 0
		end
		if curtime ~= nil then
			totalaverage = Num_Round((mobmaxhealth - mobhealth)/curtime,2)
		end
		if totalaverage ~= 0 then
			fightlength = Num_Round(mobhealth/totalaverage,2)
		else
			fightlength = 'infinite'
		end
	end
	if GetTime() > Num_Round(temptime,2) + 1 and temptime ~= nil then
		if UnitHealth('target') <= reportthreshold then
			if UnitInRaid('player') then
				if UnitLevel('target') == -1 then
					SendChatMessage('Mob death rate is: '..totalaverage..'% per second',"RAID")
				end
			else
				HSPrint('---------------')
				HSPrint('Seconds in combat: '..Num_Round(curtime,2))
				HSPrint('Mob death rate is: '..totalaverage..'% per second')
			end
			if uac('player') then
				if UnitInRaid('player') then
					if UnitLevel('target') == -1 then
						SendChatMessage('Mob health is: '..mobhealth, "RAID")
						SendChatMessage('Predicted fight time remaining: '..fightlength..' seconds.',"RAID")
					end
				else
					HSPrint('Mob health is: '..mobhealth)
					HSPrint('Predicted fight time remaining: '..fightlength..' seconds.')
				end
			end
			reportthreshold = reportthreshold - 20
		end
		temptime = GetTime()
	end	
end
function SpecCheck(page,spellnum)
    if UnitClass("player") == "Druid" then
        local _, _, _, _, spec = GetTalentInfo(page,spellnum)
        return spec
    else
        return nil;
    end
end
--------------------------------------------AUTO BUFF---------------------------------------------------
function AutoBuff()
	local cd,t = 1.5, GetTime()
	local mongcd,_,mongbag,mongslot = ItemInfo('Elixir of the Mongoose')
	local fortcd,_,fortbag,fortslot = ItemInfo('Elixir of Fortitude')
	local supdcd,_,supdbag,supdslot = ItemInfo('Elixir of Superior Defense')
	local eogcd,_,eogbag,eogslot = ItemInfo('Elixir of Giants')
	local jjpcd,_,jjpbag,jjpslot = ItemInfo('Juju Power')
	local jjmcd,_,jjmbag,jjmslot = ItemInfo('Juju Might')
	local gggcd,_,gggbag,gggslot = ItemInfo('Gordok Green Grog')
	local sddcd,_,sddbag,sddslot = ItemInfo('Smoked Desert Dumplings')
	local bsfcd,_,bsfbag,bsfslot = ItemInfo('Blessed Sunfruit')
	local mbpcd,_,mbpbag,mbpslot = ItemInfo('Mageblood Potion')
	local cfcd,_,cfbag,cfslot = ItemInfo('Crystal Force')
	local jjgcd,_,jjgbag,jjgslot = ItemInfo('Juju Guile')
	local sagecd,_,sagebag,sageslot = ItemInfo('Elixir of the Sages')
	local ksbcd,_,ksbbag,ksbslot = ItemInfo("Kreeg's Stout Beatdown")
	local wfwcd,_,wfwbag,wfwslot = ItemInfo("Winterfall Firewater")
	local rblcd,_,rblbag,rblslot = ItemInfo("Rumsey Rum Black Label")
	local classy = UnitClass("player")
	local strbuff = jjpslot + eogslot
	local pwrbuff = jjmslot + wfwslot
	local lqrbuff = ksbslot + gggslot + rblslot
	local fudbuff = sddslot + bsfslot
	local omenofclarity = SpecCheck(1,9)
	if classy == "Druid" then
		if HSBuffChk('Regeneration') == false then
			CastSpellByName('Mark of the Wild',1)
		elseif HSBuffChk('Spell_Nature_CrystalBall') == false and omenofclarity == 1 then
			CastSpellByName('Omen of Clarity')
		elseif HSBuffChk('Thorns') == false then
			CastSpellByName('Thorns',1)
		end
	end
	if UnitInRaid('player') then
		if HSBuffChk('Potion_32') == false and mongslot ~= 0 then
			UseContainerItem(mongbag, mongslot)
		--elseif HSBuffChk('Potion_44') == false and fortslot ~= 0 then
			--UseContainerItem(fortbag, fortslot)
		elseif HSBuffChk('Potion_86') == false and supdslot ~= 0 then
			UseContainerItem(supdbag, supdslot)
		elseif HSBuffChk('MonsterScales_11') == false and HSBuffChk('Potion_61') == false and strbuff ~= 0 then
			if jjpslot ~= 0 then
				UseContainerItem(jjpbag, jjpslot)
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			elseif eogslot ~= 0 then
				UseContainerItem(eogbag, eogslot)
			end
		elseif HSBuffChk('MonsterScales_07') == false and HSBuffChk('Potion_92') == false and pwrbuff ~= 0 then
			if jjmslot ~= 0 then
				UseContainerItem(jjmbag, jjmslot)
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			elseif wfwslot ~= 0 then
				UseContainerItem(wfwbag, wfwslot)
			end
		elseif HSBuffChk('Drink_03') == false and HSBuffChk('Drink_05') == false and HSBuffChk('Drink_04') == false and lqrbuff ~= 0 then
			if t-cd >= (TSSW or 0) then
				TSSW = t
				if playername == "Maulbadude" then
					if ksbslot ~= 0 then
						UseContainerItem(ksbbag, ksbslot)
					elseif gggslot ~= 0 then
						UseContainerItem(gggbag, gggslot)
					elseif rblslot ~= 0 then
						UseContainerItem(rblbag, rblslot)
					end
				else
					if rblslot ~= 0 then
						UseContainerItem(rblbag, rblslot)
					elseif gggslot ~= 0 then
						UseContainerItem(gggbag, gggslot)
					elseif ksbslot ~= 0 then
						UseContainerItem(ksbbag, ksbslot)
					end
				end
			end
		elseif HSBuffChk('Misc_Food') == false and HSBuffChk('Misc_Fork&Knife') == false and HSBuffChk('Spell_Holy_Devotion') == false and fudbuff ~= 0 then
			if sddslot ~= 0 then
				UseContainerItem(sddbag, sddslot)
			elseif bsfslot ~= 0 then
				UseContainerItem(bsfbag, bsfslot)
			end
			echo(playername.." eating")
		end
		if playername == "Maulbadude" then
			if HSBuffChk('Potion_45') == false and mbpslot ~= 0 then
				UseContainerItem(mbpbag, mbpslot)
			elseif HSBuffChk('Gem_Crystal_02') == false and cfslot ~= 0 and cfcd == 0 then
				UseContainerItem(cfbag, cfslot)
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			elseif HSBuffChk('MonsterScales_13') == false and jjgslot ~= 0 then
				UseContainerItem(jjgbag, jjgslot)
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			elseif HSBuffChk('Potion_29') == false and sageslot ~= 0 then
				UseContainerItem(sagebag, sageslot)
			end
		end
	end
end
--------------------------------------------AUTO BUFF END---------------------------------------------------
--------------------------------------------MISC Feral Macros. Call with /run 'function name'---------------
function pummeler()
    local tloc = GetInventoryItemLink("player", 16)
    local wep = 'Manual Crowd Pummeler'
    local cd,t = 30, GetTime()
    if tloc ~= nil then
        if(string.find(tloc, wep)) then
            local mcpstart, mcpdur, _ = GetInventoryItemCooldown("player", 16)
            local mcpcdr = mcpdur - (GetTime() - mcpstart)
            if mcpcdr < 0 then mcpcdr = 0 end
            if mcpcdr == 0 then
                if t-cd >= (TSSW or 0) and CheckInteractDistance('target',3) == 1 then 
                    TSSW = t
                    UseItemByName('Manual Crowd Pummeler')
                end
            end
        end
    end
end
--------------------------------------------------------
function StealthOne()
	local cd,t = 3, GetTime()
	if t-cd >= (prowlwait or 0) then
		prowlwait = t
		CastSpellByName('Prowl')
	end
end
--------------------------------------------------------
function PatchHeal()
	if UnitHealth('target') < UnitHealthMax('target') then
		CastSpellByName('Healing Touch(Rank 2)')
	else
		SpellStopCasting()
	end
end
--------------------------------------------------------
function StealthTwo()
	if HSBuffChk('Ambush') == false then
		CastSpellByName('Prowl')
	end
end
--------------------------------------------------------
function QuickCast(spell,target)
	local pwrtype=UnitPowerType('Player')
	local curMana, mxMana = LunaUF.DruidManaLib:GetMana()
	if HSBuffChk('TravelForm') == true or HSBuffChk('AquaticForm') == true then
		QuickShift()
	elseif pwrtype == 3 then
		if string.find(spell,'QuickHT') then
			if UnitHealth('player') < UnitHealthMax('player') and curMana > 752 then
				QuickShift()
			end
		elseif string.find(spell,'Healing Touch') or string.find(spell,'Regrowth') or string.find(spell,'Bandage') then
			if UnitHealth('player') < UnitHealthMax('player') then
				QuickShift()
			end
		else
			QuickShift()
		end
	elseif pwrtype == 1 and not(UnitLevel('target') == -1 and UnitName('targettarget') == playername and UnitInRaid('player'))then
		if string.find(spell,'QuickHT') then
			if UnitHealth('player') < UnitHealthMax('player') and curMana > 752 then
				QuickShift()
			end
		elseif string.find(spell,'Healing Touch') or string.find(spell,'Regrowth') then
			if UnitHealth('player') < UnitHealthMax('player') then
				QuickShift()
			end
		else
			QuickShift()
		end
	elseif pwrtype == 0 then
		if string.find(spell,'QuickHT') then
			QuickHT()
		elseif string.find(spell,'Bandage') then
			if UnitHealth('player') < UnitHealthMax('player') then
				UseItemByName('Heavy Runecloth Bandage')
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			end
		else
			if target == nil then
				CastSpellByName(spell)
			else
				CastSpellByName(spell,target)
			end
		end
	end
end
-------------------------------------------------------------------------------
function QkStone()
	local pwrtype=UnitPowerType('Player')
	if pwrtype == 1 and HSBuffChk('Potion_69') == false then
		CastShapeshiftForm(1)
	elseif pwrtype == 0 then
		if HSBuffChk('Potion_69') == false then
			UseItemByName('Greater Stoneshield Potion')
		else
			CastShapeshiftForm(1)
		end
	end
end
---------------------------------------------------------------------------------
function QuickHT()
	local plname,_ = UnitName('player')
	local pwrtype=UnitPowerType('Player')
	local ranks = {'Healing Touch(Rank 11)','Healing Touch(Rank 10)','Healing Touch(Rank 9)','Healing Touch(Rank 8)',
	'Healing Touch(Rank 7)','Healing Touch(Rank 6)','Healing Touch(Rank 5)','Healing Touch(Rank 4)','Healing Touch(Rank 3)'}
	local curMana, mxMana = LunaUF.DruidManaLib:GetMana()
	local manacost = {1277,1197,1077,972,882,812,747,662,587}
	local healththreshold = {0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,0.98}
	if UnitHealth('player') < UnitHealthMax('player') then
		for i = 1, table.getn(ranks) do
			if UnitHealth('player') < UnitHealthMax('player')*healththreshold[i] then
				for g = i, table.getn(manacost) do
					if UnitMana('player') > manacost[g] then
						CastSpellByName(ranks[g],1)
						break
					end
				end
				break
			end
		end
	end
end
-------------------------------------------------------------------------------------
function BLTaunt()
    local pname,_ = UnitName('player')
    local bltot,_ = UnitName('targettarget')
    local blclass = UnitClass('targettarget')
    local blnames = {'Jce','Bigblackgoat','Coolage','Vefantur','Mobsonme','Freebee','Verik','Mobsonmep'}
    local tauntyn = 1
    for ind = 1, table.getn(blnames) do
        if bltot == blnames[ind] then
            tauntyn = 0
            break
        end
    end
    if blclass == 'Druid' and HSBuffChk("Ability_Racial_BearForm","targettarget") == true
    and HSBuffChk("Spell_Nature_UnyeildingStamina","targettarget") == true then
        tauntyn = 0
    end
    if bltot ~= pname and tauntyn == 1 then
        CastSpellByName('Growl')
    end
end
--------------------------------------------------END MISC Feral Macros-----------------------------------