# HolyShift
# Created by: Maulbatross (Kronos 3)
- Some functions borrowed from CatDruidDPS by Cernie

A cat druid one-button dps addon for vanilla WoW 1.12 and other useful feral druid functions.

Note: This is designed for use at level 60. I have not tested it below level 60.

To open settings type: /hsdps

To use one button cat dps: 
  - Create a macro that only has the text: /hsdps dps
  - If you put the macro button on your main bar, put it in the same spot for human form and cat form. (Otherwise you will have to 
    constantly alternate keys)

- Automatically power-shifts when you don't have enough energy to use your combo point builder or Ferocious bite. (can be switched off)
  - I turn this off when I am solo farming in the world.
- Will not shift you out of cat form if you do not have enough mana to go back in.
- Prioritizes your combo point builder when clearcasting is procced.
- Dynamically changes the combo point threshold for Ferocious Bite so as to not waste combo points if a mob is about to die.
  - Always set to 5 combo points for bosses.
- Automatically applies Faerie Fire at moments where it will minimally affect DPS or GCD
  - When you are too far away to hit with a melee ability.
  - When you are about to power shift and the target doesn't already have Faerie Fire.
- Automatically uses Cower if you are in a group and you have agro (can be switched off)
- If you pull agro on a boss it will (in order):
  - 1. Shift you out of cat form and use a Limited Invulnerability Potion.
    - Will not use on bosses that briefly change target at random such as C'Thun and Anub'Rekhan.
  - 2. Cower if Cower is not on cooldown.
  - 3. Shift you out of cat form and cast Bark Skin if Bark Skin is not on cooldown.
- Automatically uses Tiger's Fury when approaching a mob(can be switched off)
- When stealthed, automatically pops Tiger's Fury and opens with Ravage
- Automatically switches from Shred to Claw if you are not behind a target or the target is targeting you.
- Option to primarily use Claw on mobs other than bosses. (can be switched off)
- Automatically uses Innervate, Mana Potions, Rune of Metamorphosis, and Demonic Runes when you are low on mana (only on bosses to conserve consumables.)
  - Will not use a demonic rune if it will potentially kill you.
  - Option to swith off Innervate, Mana Potions, and Demonic runes. 
- Automatically uses dps trinkets on bosses such as: Earthstrike, Kiss of the Spider.
- Automatically uses Ancient Cornerstone Grimoire on bosses.
- Automatically uses Juju Flurry on bosses.
- Automatically uses Manual Crowd Pummeler on bosses and switches out manual crowd pummeler if the mcp you have equipped has no charges.
- Automatically uses Hourglass Sand when you have the Bronze debuff on Chromaggus.
- Automatically uses a major healthstone if you have a major healthstone and when you are below 40% health.
- Provides estimated time remaining in fight and the option to turn this feature off.

Included misc functions that can be called with /run FunctionName():
- Make sure to match capitization and spelling exactly to use these functions.
- AutoBuff()
  - Uses consumables for cat dps in a raid. (Make sure you have yourself targeted so as not to put Jujus on someone else XD)
    - Will not overwrite buffs that are already active. 
- pummeler()
  - A spammable macro to pop Manual Crowd Pummeler so as not to accidentally burn two charges in quick succession.
- PatchHeal()
  - Designed for use on Patchwerk. Typically druids are not hateful strike healers so it is unlikely that you will use this one.
  - Only heals the target (not a mouseover macro) if the target is less than full health. Cancels current spell cast if target's health
    becomes full during spell cast.
- BLTaunt()
  - Only taunts target if the target is not already targeting you or another feral druid in bear form.
  - I use this in addition to a normal taunt just in case I need to override it. 
    - For example when the need arises to taunt off of another tank.
  - You can add blacklist names if you are comfortable editing the HolyShiftCore.lua file. Leave this alone if you don't know what you
    are doing.
- QkStone()
  - For use when you are tanking a very hard-hitting mob.
  - Shifts you out of bear form, uses a Greater Stoneshield Potion, then shifts you back into Bear Form. Spammable.
- QuickHT()
  - Casts the highest Healing Touch ON YOURSELF required to heal to full health (or close to it) while leaving enough mana to go back 
    into cat or bear form. 
  - Designed for pvp or farming in the world. 
- QuickCast(spell,target)
  - Shifts you out of whatever form you are in and casts the desired spell.
  - If no target is entered then spell is attempted on current target.
  - Can be combined with QuickHT by typing: QuickCast(QuickHT)
  - Ex: QuickCast('Healing Touch(Rank 5)',1) --Put 1 for the target if you want to cast the spell on yourself.
  - Ex2: QuickCast('Entangling Roots(Rank 6)')
  - Ex3: QuickCast('Dire Bear Form')
  - Ex4: QuickCast('Bandage')
    - Cannot put a target for this one, it will target whoever you currently have targeted, or if you are targeting nothing or an enemy
      mob, it will target you.
    - Currently only uses Heavy Runecloth Bandage. I really only made this for Loatheb.
  - Ex5: QuickCast('Abolish Poison',1) 
    - Again, 1 is used here to apply Abolish Poison to self.
    - Good for Bug Trio, Viscidus, Naxxramas trash, and PVP(especially against rogues to prevent Blind)
