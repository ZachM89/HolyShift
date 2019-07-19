local doclaw = 0
local mobcurhealth = 100--UnitHealth('target')		
local drtable = {}
local curtime = nil
local combstarttime = nil
local temptime = nil
local numtargets = 0
local reportthreshold = 80
local playername,_ = UnitName('player')
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
	--HSPrint(HScommand)
	if HScommand == "dps" then
		HolyShiftAddon()
	elseif HScommand == "innervate" then 
		if HSoption == "on" then
			HSInnervateUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto Innervate |cffecd226Enabled. |cffd08524HSInnervateUse = |cffffffff'..HSInnervateUse)
		elseif HSoption == "off" then
			HSInnervateUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto Innervate |cffecd226Disabled. |cffd08524HSInnervateUse = |cffffffff'..HSInnervateUse)
		end
	elseif HScommand == "mcp" then 
		if HSoption == "on" then
			HSMCPUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto Manual Crowd Pummeler |cffecd226Enabled. |cffd08524HSMCPUse = |cffffffff'..HSMCPUse)
		elseif HSoption == "off" then
			HSMCPUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto Manual Crowd Pummeler |cffecd226Disabled. |cffd08524HSMCPUse = |cffffffff'..HSMCPUse)
		end
	elseif HScommand == "manapot" then 
		if HSoption == "on" then
			HSMPUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto use Mana Potion |cffecd226Enabled. |cffd08524HSMPUse = |cffffffff'..HSMPUse)
		elseif HSoption == "off" then
			HSMPUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto use Mana Potion |cffecd226Disabled. |cffd08524HSMPUse = |cffffffff'..HSMPUse)
		end
	elseif HScommand == "demonicrune" then 
		if HSoption == "on" then
			HSDRUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto use Demonic Rune |cffecd226Enabled. |cffd08524HSDRUse = |cffffffff'..HSDRUse)
		elseif HSoption == "off" then
			HSDRUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto use Demonic Rune |cffecd226Disabled. |cffd08524HSDRUse = |cffffffff'..HSDRUse)
		end
	elseif HScommand == "flurry" then 
		if HSoption == "on" then
			HSFLUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto Juju Flurry |cffecd226Enabled. |cffd08524HSFLUse = |cffffffff'..HSFLUse)
		elseif HSoption == "off" then
			HSFLUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto Juju Flurry |cffecd226Disabled. |cffd08524HSFLUse = |cffffffff'..HSFLUse)
		end
	elseif HScommand == "clawadds" then 
		if HSoption == "on" then
			HSClawAdd = 1
			HSPrint('|cffd08524HolyShift |cffffffffClaw Non-Bosses |cffecd226Enabled. |cffd08524HSClawAdd = |cffffffff'..HSClawAdd)
		elseif HSoption == "off" then
			HSClawAdd = 0
			HSPrint('|cffd08524HolyShift |cffffffffClaw Non-Bosses |cffecd226Disabled. |cffd08524HSClawAdd = |cffffffff'..HSClawAdd)
		end
	elseif HScommand == "tiger" then 
		if HSoption == "on" then
			HSTigerUse = 1
			HSPrint("|cffd08524HolyShift |cffffffffAuto Tiger's Fury |cffecd226Enabled. |cffd08524HSTigerUse = |cffffffff"..HSTigerUse)
		elseif HSoption == "off" then
			HSTigerUse = 0
			HSPrint("|cffd08524HolyShift |cffffffffAuto Tiger's Fury |cffecd226Disabled. |cffd08524HSTigerUse = |cffffffff"..HSTigerUse)
		end
	elseif HScommand == "shift" then 
		if HSoption == "on" then
			HSShiftUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto Powershift |cffecd226Enabled. |cffd08524HSShiftUse = |cffffffff'..HSShiftUse)
		elseif HSoption == "off" then
			HSShiftUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto Powershift |cffecd226Disabled. |cffd08524HSShiftUse = |cffffffff'..HSShiftUse)
		end
	elseif HScommand == "cower" then 
		if HSoption == "on" then
			HSCowerUse = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto Cower |cffecd226Enabled. |cffd08524HSCowerUse = |cffffffff'..HSCowerUse)
		elseif HSoption == "off" then
			HSCowerUse = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto Cower |cffecd226Disabled. |cffd08524HSCowerUse = |cffffffff'..HSCowerUse)
		end
	elseif HScommand == "deathrate" then 
		if HSoption == "on" then
			HSDeathrate = 1
			HSPrint('|cffd08524HolyShift |cffffffffDeathrate Report |cffecd226Enabled. |cffd08524HSDeathrate = |cffffffff'..HSDeathrate)
		elseif HSoption == "off" then
			HSDeathrate = 0
			HSPrint('|cffd08524HolyShift |cffffffffDeathrate Report |cffecd226Disabled. |cffd08524HSDeathrate = |cffffffff'..HSDeathrate)
		end
	elseif HScommand == "ff" then 
		if HSoption == "on" then
			HSAutoFF = 1
			HSPrint('|cffd08524HolyShift |cffffffffAuto Faerie Fire |cffecd226Enabled. |cffd08524HSAutoFF = |cffffffff'..HSAutoFF)
		elseif HSoption == "off" then
			HSAutoFF = 0
			HSPrint('|cffd08524HolyShift |cffffffffAuto Faerie Fire |cffecd226Disabled. |cffd08524HSAutoFF = |cffffffff'..HSAutoFF)
		end
	elseif HScommand == "weapon" then 
		HSWeapon = HSoption
		HSPrint('|cffd08524HolyShift HSWeapon = |cffecd226'..HSWeapon)
	elseif HScommand == "offhand" then 
		HSOffhand = HSoption
		HSPrint('|cffd08524HolyShift HSOffhand = |cffecd226'..HSOffhand)
	elseif HSCommand == nil or HSCommand == "" then
		--HSPrint(HSCommand)
		HSPrint("---------------------")
		HSPrint('|cffd08524HolyShift: |cffffffffMake a macro that just says |cffecd226/hsdps dps |cffffffffand put on the same key in human and cat form.')
		if HSInnervateUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffInnervate |cff24D040Enabled|cffd08524.|cffecd226 /hsdps innervate on |cffd08524or|cffecd226 /hsdps innervate off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffInnervate |cffD02424Disabled|cffd08524.|cffecd226 /hsdps innervate on |cffd08524or|cffecd226 /hsdps innervate off |cffd08524to change')
		end
		if HSMCPUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffManual Crowd Pummeler |cff24D040Enabled|cffd08524.|cffecd226 /hsdps mcp on |cffd08524or|cffecd226 /hsdps mcp off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffManual Crowd Pummeler |cffD02424Disabled|cffd08524.|cffecd226 /hsdps mcp on |cffd08524or|cffecd226 /hsdps mcp off |cffd08524to change')
		end
		if HSMPUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffMana pot use |cff24D040Enabled|cffd08524.|cffecd226 /hsdps manapot on |cffd08524or|cffecd226 /hsdps manapot off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffMana pot use |cffD02424Disabled|cffd08524.|cffecd226 /hsdps manapot on |cffd08524or|cffecd226 /hsdps manapot off |cffd08524to change')
		end
		if HSDRUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffDemonic rune use |cff24D040Enabled|cffd08524.|cffecd226 /hsdps demonicrune on |cffd08524or|cffecd226 /hsdps demonicrune off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffDemonic rune use |cffD02424Disabled|cffd08524.|cffecd226 /hsdps demonicrune on |cffd08524or|cffecd226 /hsdps demonicrune off |cffd08524to change')
		end
		if HSFLUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffJuju flurry use |cff24D040Enabled|cffd08524.|cffecd226 /hsdps flurry on |cffd08524or|cffecd226 /hsdps flurry off to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffJuju flurry use |cffD02424Disabled|cffd08524.|cffecd226 /hsdps flurry on |cffd08524or|cffecd226 /hsdps flurry off to change')
		end
		if HSClawAdd == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffClaw non-bosses |cff24D040Enabled|cffd08524.|cffecd226 /hsdps clawadds on |cffd08524or|cffecd226 /hsdps clawadds off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffClaw non-bosses |cffD02424Disabled|cffd08524.|cffecd226 /hsdps clawadds on |cffd08524or|cffecd226 /hsdps clawadds off |cffd08524to change')
		end
		if HSTigerUse == 1 then
			HSPrint("|cffd08524HolyShift: |cffffffffTiger's Fury |cff24D040Enabled|cffd08524.|cffecd226 /hsdps tiger on |cffd08524or|cffecd226 /hsdps tiger off |cffd08524to change")
		else
			HSPrint("|cffd08524HolyShift: |cffffffffTiger's Fury |cffD02424Disabled|cffd08524.|cffecd226 /hsdps tiger on |cffd08524or|cffecd226 /hsdps tiger off |cffd08524to change")
		end
		if HSShiftUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffPowershift |cff24D040Enabled|cffd08524.|cffecd226 /hsdps shift on |cffd08524or|cffecd226 /hsdps shift off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffPowershift |cffD02424Disabled|cffd08524.|cffecd226 /hsdps shift on |cffd08524or|cffecd226 /hsdps shift off |cffd08524to change')
		end
		if HSCowerUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Cower |cff24D040Enabled|cffd08524.|cffecd226 /hsdps cower on |cffd08524or|cffecd226 /hsdps cower off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Cower |cffD02424Disabled|cffd08524.|cffecd226 /hsdps cower on |cffd08524or|cffecd226 /hsdps cower off |cffd08524to change')
		end
		if HSDeathrate == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffDeathrate report |cff24D040Enabled|cffd08524.|cffecd226 /hsdps deathrate on |cffd08524or|cffecd226 /hsdps deathrate off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffDeathrate report |cffD02424Disabled|cffd08524.|cffecd226 /hsdps deathrate on |cffd08524or|cffecd226 /hsdps deathrate off |cffd08524to change')
		end
		if HSAutoFF == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Faerie Fire |cff24D040Enabled|cffd08524.|cffecd226 /hsdps ff on |cffd08524or|cffecd226 /hsdps ff off |cffd08524to change')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Faerie Fire |cffD02424Disabled|cffd08524.|cffecd226 /hsdps ff on |cffd08524or|cffecd226 /hsdps ff off |cffd08524to change')
		end
		if HSWeapon == nil then
			HSPrint('|cffd08524HolyShift: |cffffffffWEAPON SWAP: |cffecd226No weapon assigned for HSWeapon|cffd08524.|cffecd226 /hsdps weapon Weapon Name |cffd08524to change or|cffecd226 /hsdps weapon none |cffd08524to disable')
		elseif HSWeapon == 'none' or HSWeapon == 'None' then
			HSPrint('|cffd08524HolyShift: |cffffffffWEAPON SWAP: HSWeapon = |cffD02424'..HSWeapon..'|cffd08524.|cffecd226 /hsdps weapon Weapon Name |cffd08524to change or|cffecd226 /hsdps weapon none |cffd08524to disable')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffWEAPON SWAP: HSWeapon = |cff24D040'..HSWeapon..'|cffd08524.|cffecd226 /hsdps weapon Weapon Name |cffd08524to change or|cffecd226 /hsdps weapon none |cffd08524to disable')
		end
		if HSOffhand == nil then
			HSPrint('|cffd08524HolyShift: |cffffffffOFFHAND SWAP: |cffecd226No offhand assigned for HSOffhand|cffd08524.|cffecd226 /hsdps offhand Offhand Name |cffd08524to change or|cffecd226 /hsdps offhand none |cffd08524to disable')
		elseif HSOffhand == 'none' or HSOffhand == 'None' then
			HSPrint('|cffd08524HolyShift: |cffffffffOFFHAND SWAP: HSOffhand = |cffD02424'..HSOffhand..'|cffd08524.|cffecd226 /hsdps offhand Offhand Name |cffd08524to change or|cffecd226 /hsdps offhand none |cffd08524to disable')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffOFFHAND SWAP: HSOffhand = |cff24D040'..HSOffhand..'|cffd08524.|cffecd226 /hsdps offhand Offhand Name |cffd08524to change or|cffecd226 /hsdps offhand none |cffd08524to disable')
		end
	end
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
		if HSDeathrate == 1 then
			DeathRate()
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
		end
		if (strfind(arg1, "No charges remain")) then
			SwapOutMCP(HSWeapon,HSOffhand)
		end
	end
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if (strfind(arg1, "Your Claw")) then
			if doclaw == 1 then
				doclaw = 2
			elseif doclaw == 2 then
				doclaw = 0
			end
		end
		if (strfind(arg1, "Your Shred")) then
			if doclaw ~= 0 then
				doclaw = 0
			end
		end
	end
	
	if event == "VARIABLES_LOADED" then
		HSPrint('|cffd08524HolyShift by Maulbatross Loaded')
		HSPrint('|cffd08524HolyShift: |cffffffffType |cffecd226/hsdps |cffffffffto show options')
		if HSInnervateUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffInnervate |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffInnervate |cffD02424Disabled')
		end
		if HSMCPUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffManual Crowd Pummeler |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffManual Crowd Pummeler |cffD02424Disabled')
		end
		if HSMPUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffMana pot use |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffMana pot use |cffD02424Disabled')
		end
		if HSDRUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffDemonic rune use |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffDemonic rune use |cffD02424Disabled')
		end
		if HSFLUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffJuju flurry use |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffJuju flurry use |cffD02424Disabled')
		end
		if HSClawAdd == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffClaw non-bosses |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffClaw non-bosses |cffD02424Disabled')
		end
		if HSTigerUse == 1 then
			HSPrint("|cffd08524HolyShift: |cffffffffTiger's Fury |cff24D040Enabled")
		else
			HSPrint("|cffd08524HolyShift: |cffffffffTiger's Fury |cffD02424Disabled")
		end
		if HSShiftUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffPowershift |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffPowershift |cffD02424Disabled')
		end
		if HSCowerUse == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Cower |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Cower |cffD02424Disabled')
		end
		if HSDeathrate == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffDeathrate report |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffDeathrate report |cffD02424Disabled')
		end
		if HSAutoFF == 1 then
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Faerie Fire |cff24D040Enabled')
		else
			HSPrint('|cffd08524HolyShift: |cffffffffAuto Faerie Fire |cffD02424Disabled')
		end
		if HSWeapon == nil then
			HSPrint('|cffd08524HolyShift: |cffffffffWEAPON SWAP: |cffecd226No weapon assigned for HSWeapon')
		elseif HSWeapon == 'none' or HSWeapon == 'None' then
			HSPrint('|cffd08524HolyShift: |cffffffffWEAPON SWAP: HSWeapon = |cffD02424'..HSWeapon)
		else
			HSPrint('|cffd08524HolyShift: |cffffffffWEAPON SWAP: HSWeapon = |cff24D040'..HSWeapon)
		end
		if HSOffhand == nil then
			HSPrint('|cffd08524HolyShift: |cffffffffOFFHAND SWAP: |cffecd226No offhand assigned for HSOffhand')
		elseif HSOffhand == 'none' or HSOffhand == 'None' then
			HSPrint('|cffd08524HolyShift: |cffffffffOFFHAND SWAP: HSOffhand = |cffD02424'..HSOffhand)
		else
			HSPrint('|cffd08524HolyShift: |cffffffffOFFHAND SWAP: HSOffhand = |cff24D040'..HSOffhand)
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
			if HSWeapon == nil then
                HSWeapon = 'None'
            end
			if HSOffhand == nil then
                HSOffhand = 'None'
            end
			if HSDeathrate == nil then
                HSDeathrate = 0
            else
                tonumber(HSDeathrate)
            end
			if HSAutoFF == nil then
                HSAutoFF = 0
            else
                tonumber(HSAutoFF)
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
        CastShapeshiftForm(c)
    elseif(not IsSpellOnCD('Cat Form')) then
        CastShapeshiftForm(a)
        ToggleAutoAttack("off")
    end
end
function QuickShift()
    local a,c=GetActiveForm()
    if(a==0) then
        CastShapeshiftForm(c)
    else
        CastShapeshiftForm(a)
        ToggleAutoAttack("off")
    end
end
function ToggleAutoAttack(switch)
    if(switch == "off") then
        if(FindAttackActionSlot() ~= 0) then
            AttackTarget()
        end
    elseif(switch == "on") then
        if(FindAttackActionSlot() == 0) then
            AttackTarget()
        end
    end
end
function HolyShiftAddon()
	local tot,rot=UnitName("targettarget")
	local romactive = HSBuffChk("INV_Misc_Rune")
	local stealthed = HSBuffChk("Ability_Ambush")
	local partynum = GetNumPartyMembers()
	local romcooldown,romeq,rombag,romslot = ItemInfo('Rune of Metamorphosis')
	local jgcd,jgeq,jgbag,jgslot = ItemInfo('Jom Gabbar')
	local clawab = "Claw"
	local shredab = "Shred"
	local flcd,_,flbag,flslot = ItemInfo('Juju Flurry')
	local lipcd,_,lipbag,lipslot = ItemInfo('Limited Invulnerability Potion')
	local natshapeshiftr = SpecCheck(1,7)
	if UnitAffectingCombat('player') and HSDeathrate == 1 then
		DeathRate()
	end
	if UnitPowerType("Player") == 3 then
		if stealthed == true then
			if HSBuffChk('Ability_Mount_JungleTiger') == false then
				CastSpellByName("Tiger's Fury(Rank 4)")
			end
			if CheckInteractDistance('target',3) == 1 then
				CastSpellByName("Ravage")
			end
		else
			if tot == playername then
				if UnitLevel('target') == -1 then --If target is a boss then shift out so you can LIP
					if lipcd == 0 and lipslot ~= 0 then
						EShift()
					elseif(not IsSpellOnCD("Cower")) then
						CastSpellByName("Cower")
					elseif(not IsSpellOnCD("Barkskin")) then
						EShift()
					else
						Atk(clawab,stealthed,romactive,romcooldown)
					end
				else --Else if target is not a boss
					if partynum > 2 then
						if(not IsSpellOnCD("Cower")) and HSCowerUse == 1 then
							CastSpellByName("Cower")
						else
							Atk(clawab,stealthed,romactive,romcooldown)
						end
					else
						Atk(clawab,stealthed,romactive,romcooldown)
					end
				end
			else
				if HSClawAdd == 1 then
					Atk(clawab,stealthed,romactive,romcooldown)
				else
					if doclaw == 0 then 
						Atk(shredab,stealthed,romactive,romcooldown)
					elseif doclaw == 1 then
						Atk(clawab,stealthed,romactive,romcooldown)
					elseif doclaw == 2 then
						Atk(clawab,stealthed,romactive,romcooldown)
					end
				end
			end
		end
	else
		if UnitLevel('target') == -1
		and UnitAffectingCombat('Player')
		and UnitInRaid('Player') then
			if tot == playername then
				if UnitName('target') ~= "Eye of C'Thun" 
				and UnitName('target') ~= "Anub'Rekhan" then
					if lipcd == 0 and lipslot ~= 0 then
						UseItemByName("Limited Invulnerability Potion")
					elseif(not IsSpellOnCD("Barkskin")) then
						CastSpellByName("Barkskin")
					end
				end
			else
				if UnitHealth('target') > 10 then
					Restore(romeq,romactive,romcooldown)
				end
			end
			if flcd == 0 and HSFLUse == 1 and CheckInteractDistance('target',3) == 1 then
				UseContainerItem(flbag, flslot)
				if SpellIsTargeting() then
					SpellTargetUnit("player")
				end
			end
			if UnitAffectingCombat('Player') and jgeq ~= -1 and jgcd == 0 and UnitName('target') ~= "Razorgore the Untamed" and CheckInteractDistance('target',3) == 1 then
				UseItemByName("Jom Gabbar")
			end
			if UnitName('target') == 'Chromaggus' then BrzRmv() end
		end
		if(not IsSpellOnCD("Cat Form")) then
			EShift()
		end
	end
end
function Atk(CorS,stealthyn,romyn,romcd)
	StAttack(1)
	local abiltext = nil
	local ferocity = SpecCheck(2,1)
	local idolofferocity = 0
	local shth = 15
	local impshred = SpecCheck(2,9)
	local copobu = 100 - (40 + impshred*6 + 20)
	local currentMana, maxMana = AceLibrary("DruidManaLib-1.0"):GetMana()
	local shredtext = "Spell_Shadow_VampiricAura"
	local clawtext = "Ability_Druid_Rake"
	local kotscd,kotseq,kotsbag,kotsslot = ItemInfo('Kiss of the Spider')
	local escd,eseq,esbag,esslot = ItemInfo('Earthstrike')
	local zhmcd,zhmeq,zhmbag,zhmslot = ItemInfo('Zandalarian Hero Medallion')
	local fbthresh = 5
	if(romyn == true) then
		shth = 30
	end
	if GetInventoryItemLink('player',18) ~= nil then
		if(string.find(GetInventoryItemLink('player',18), 'Idol of Ferocity')) then
			idolofferocity = 3
		end
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
		if HSMCPUse == 1 then 
			Pummel() 
		end
		if UnitAffectingCombat('Player') and kotseq ~= -1 and kotscd == 0 and UnitName('target') ~= "Razorgore the Untamed" and CheckInteractDistance('target',3) == 1 then
			UseItemByName("Kiss of the Spider")
		end 
		if UnitAffectingCombat('Player') and eseq ~= -1 and escd == 0 and UnitName('target') ~= "Razorgore the Untamed" and CheckInteractDistance('target',3) == 1 then
			UseItemByName("Earthstrike")
		end
		if UnitAffectingCombat('Player') and zhmeq ~= -1 and zhmcd == 0 and UnitName('target') ~= "Razorgore the Untamed" and CheckInteractDistance('target',3) == 1 then
			UseItemByName("Zandalarian Hero Medallion")
		end
	end
	if UnitIsDead('target') then
		doclaw = 0
	end
	if CorS == "Claw" then
		abiltext = clawtext
		copobu = 100 - (55 + ferocity + 20 + idolofferocity)
	elseif CorS == "Shred" then
		abiltext = shredtext
	end

	if CheckInteractDistance('target',3) ~= 1 then
		if IsTDebuff('target', 'Spell_Nature_FaerieFire') == false and stealthyn == false then
			CastSpellByName("Faerie Fire (Feral)(Rank 4)")
		end
		if HSBuffChk('Ability_Mount_JungleTiger') == false and UnitMana('Player') >= copobu + 30 and HSTigerUse == 1 then
			CastSpellByName("Tiger's Fury(Rank 4)")
		end
	end
	if (HSBuffChk("Spell_Shadow_ManaBurn") == false) then
		if(GetComboPoints("unit","target")<fbthresh) then
			if UnitMana('Player')>=copobu then
				if IsUse(FindActionSlot(abiltext)) == 1 then
					if not IsSpellOnCD(CorS) then
						CastSpellByName(CorS)
						--HSPrint(doclaw)
					end
				end
			else
				if UnitAffectingCombat('Player') and UnitExists("target") then
					if IsTDebuff('target', 'Spell_Nature_FaerieFire') == false and stealthyn == false and (not IsSpellOnCD("Faerie Fire (Feral)")) and HSAutoFF == 1 then
						CastSpellByName("Faerie Fire (Feral)(Rank 4)")
					end
					
					if CanShift() == true then
						EShift()
					end
				end
			end
		else
			if UnitMana('Player')>=shth then
				if IsUse(FindActionSlot("Ability_Druid_FerociousBite")) == 1 then
					if not IsSpellOnCD("Ferocious Bite") then
						CastSpellByName("Ferocious Bite")
					end
				end
			else
				if UnitAffectingCombat('Player') and UnitExists("target") then
					if IsTDebuff('target', 'Spell_Nature_FaerieFire') == false and stealthyn == false and (not IsSpellOnCD("Faerie Fire (Feral)")) and HSAutoFF == 1 then
						CastSpellByName("Faerie Fire (Feral)(Rank 4)")
					end
					if CanShift() == true then
						EShift()
					end
				end
			end
		end
	elseif (not IsSpellOnCD(CorS)) then
		CastSpellByName(CorS)
	end
end
function CanShift()
	local canshift = false
	local currentMana, maxMana = AceLibrary("DruidManaLib-1.0"):GetMana()
	local manathreshold = 90
	local mpcd,_,mpbag,mpslot = ItemInfo('Major Mana Potion')
	local smcd,_,smbag,smslot = ItemInfo('Superior Mana Potion')
	local drcd,_,drbag,drslot = ItemInfo('Demonic Rune')
	local nervst, nervdur,_ = GetSpellCooldown(GetSpellID('Innervate'), "spell")
	local nervcd = nervdur - (GetTime() - nervst)
	local romcooldown,romeq,rombag,romslot = ItemInfo('Rune of Metamorphosis')
	local romactive = HSBuffChk("INV_Misc_Rune")
	if UnitName('target') == 'Loatheb' then
		--manathreshold = 900
	end
	if (currentMana >= manathreshold 
	or (romcooldown == 0 and romeq ~= -1 and UnitLevel('target') == -1)
	or (romactive == true and romcooldown > 282 and UnitLevel('target') == -1)
	or (mpcd == 0 and HSMPUse == 1 and UnitLevel('target') == -1 )
	or (drcd == 0 and HSDRUse == 1 and UnitLevel('target') == -1 )) 
	and HSShiftUse == 1 then
		canshift = true
	end
	
	return canshift
end
function Restore(rom,romyn,romcd)
	local resto = 1500
	local hthresh = 5
	local mpcd,_,mpbag,mpslot = ItemInfo('Major Mana Potion')
	local smcd,_,smbag,smslot = ItemInfo('Superior Mana Potion')
	local drcd,_,drbag,drslot = ItemInfo('Demonic Rune')
	local hscd,_,hsbag,hsslot = ItemInfo('Major Healthstone')
	local nervst, nervdur,_ = GetSpellCooldown(GetSpellID('Innervate'), "spell")
	local nervcd = nervdur - (GetTime() - nervst)
	local mpot = mpslot + smslot
	local curhp = Num_Round((UnitHealth('player')/UnitHealthMax('player')),2)
	if curhp < 0.4 and hsslot ~= 0 and hscd == 0 then
		UseItemByName("Major Healthstone")
	end
	if HSBuffChk("INV_Potion_97") == true  then
		resto = 2800
		hthresh = 1
	end
	if UnitHealth('target') > hthresh then
		if UnitMana('Player')<resto then
			if(not IsSpellOnCD("Innervate")) and HSInnervateUse == 1 then
				CastSpellByName("Innervate",1)
			elseif ((HSBuffChk("Spell_Nature_Lightning") == false and nervcd < 340) or UnitMana('Player') < 478) and romyn == false then
				if rom ~= -1 and romcd == 0 then
					if CheckInteractDistance('target',3) == 1 then
						UseItemByName("Rune of Metamorphosis")
					end
				else
					if (mpcd == 0 or smcd == 0) and (drcd == 0 or drcd == -1) and mpot ~= 0 and HSMPUse == 1 then
						if mpslot ~= 0 then
							UseItemByName("Major Mana Potion")
						else
							UseItemByName("Superior Mana Potion")
						end
					else
						--HSPrint('1 attempting to use demonic rune')
						if (mpcd > 0 or smcd > 0 or mpot == 0 or mpcd == -1 or smcd == -1) and drcd == 0 and drslot ~= 0 and HSDRUse == 1 and UnitHealth('player') > 1000 then
							--HSPrint('2 attempting to use demonic rune')
							UseItemByName("Demonic Rune")
						elseif (drcd > 0 or drcd == -1) and (mpcd == 0 or smcd == 0) and mpot ~= 0 and HSMPUse == 1 then
							if mpslot ~= 0 then
								UseItemByName("Major Mana Potion")
							else
								UseItemByName("Superior Mana Potion")
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
	local ItemCdr = -1
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
		if ItemCdr < 0 then ItemCdr = 0 end
	elseif ContainerSlot ~= 0 then -- Item is in container slot
		icdstart, icddur,_ = GetContainerItemCooldown(ContainerBag, ContainerSlot)
		ItemCdr = Num_Round(icddur - (GetTime() - icdstart),2)
		if ItemCdr < 0 then ItemCdr = 0 end
	end
	
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
function FindAttackActionSlot()
    for i = 1, 120, 1
        do
        if(IsAttackAction(i) == 1 and IsCurrentAction(i) == 1) then
        return i end
    end
    return 0
end
function FindActionSlot(spellTexture)	
	for i = 1, 120, 1
		do
		if(GetActionTexture(i) ~= nil) then 
		if(string.find(GetActionTexture(i), spellTexture)) then return i end end
	end
	return 0
end
function IsUse(abil)
	isUsable, notEnoughMana = IsUsableAction(abil)
	if isUsable == nil then
		isUsable = 0
	end
	return isUsable
end
function PopSkeleton()
	local ohloc = GetInventoryItemLink("player", 17)
	local ohcd,oheq,ohbag,ohslot = ItemInfo(HSOffhand)
	local offhand = 'Ancient Cornerstone Grimoire'
	if ohloc ~= nil then
		if(string.find(ohloc, offhand)) then
			local acgcdr,acgeq,acgbag,acgslot = ItemInfo(offhand)
			if acgcdr == 0 and CheckInteractDistance('target',3) == 1 then
				UseItemByName('Ancient Cornerstone Grimoire')
			elseif acgcdr > 30 and HSOffhand ~= 'Ancient Cornerstone Grimoire' then
				PickupInventoryItem('17')
				PickupContainerItem(ohbag,ohslot)
			end
		end
	end
end
function Pummel()
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
function SwapOutMCP(weapon,offhand)
	local weploc = GetInventoryItemLink("player", 16)
	local wep = 'Manual Crowd Pummeler'
	local wepcd,wepeq,wepbag,wepslot = ItemInfo(weapon)
	local tokcd,tokeq,tokbag,tokslot = ItemInfo(offhand)
	if weploc ~= nil and weapon ~= "none" and weapon ~= "None" then
		if(string.find(weploc, wep)) then
			PickupInventoryItem('16')
			PickupContainerItem(wepbag,wepslot)
		end
	end
	if offhand ~= "none" and offhand ~= "None" and weapon ~= "none" and weapon ~= "None" then
		UseItemByName(offhand)
	end
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
function IsTDebuff(target, debuff)
    local isDebuff = false
    for i = 1, 40 do
        if(strfind(tostring(UnitDebuff(target,i)), debuff)) then 
			isDebuff = true 
		end
    end
    return isDebuff
end
function DeathRate()
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
			if UnitAffectingCombat('player') then
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
function HelmCheck()
	local _,whheq,whhbag,whhslot = ItemInfo('Wolfshead Helm')
	HSPrint(whheq)
end
--------------------------------------------MISC Feral Macros. Call with /run 'function name'---------------
function AutoBuff()
	local _,whheq,whhbag,whhslot = ItemInfo('Wolfshead Helm')
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
		elseif HSBuffChk('Thorns') == false and whheq ~= 1 then
			CastSpellByName('Thorns',1)
		end
	end
	if UnitInRaid('player') then
		if HSBuffChk('Potion_32') == false and mongslot ~= 0 then
			UseContainerItem(mongbag, mongslot)
		elseif HSBuffChk('Potion_44') == false and fortslot ~= 0 and whheq ~= 1 then
			UseContainerItem(fortbag, fortslot)
		elseif HSBuffChk('Potion_86') == false and supdslot ~= 0 and whheq ~= 1 then
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
		elseif HSBuffChk('Drink_03') == false and HSBuffChk('Drink_05') == false and HSBuffChk('Drink_04') == false and lqrbuff ~= 0 and whheq ~= 1 then
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
	local curMana, mxMana = AceLibrary("DruidManaLib-1.0"):GetMana()
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
function QuickStone()
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
	local curMana, mxMana = AceLibrary("DruidManaLib-1.0"):GetMana()
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