GLOBAL_VAR(lordsurname)
GLOBAL_LIST_EMPTY(lord_titles)

/datum/job/roguetown/lord
	title = "Grand Duke"
	f_title = "Grand Duchess"
	flag = LORD
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_NOBLE
	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	advclass_cat_rolls = list(CTAG_LORD = 20)

	spells = list(
		/obj/effect/proc_holder/spell/self/grant_title,
		/obj/effect/proc_holder/spell/self/convertrole/servant,
		/obj/effect/proc_holder/spell/self/convertrole/guard,
		/obj/effect/proc_holder/spell/self/grant_nobility,
		/obj/effect/proc_holder/spell/self/convertrole/bog
	)
	outfit = /datum/outfit/job/roguetown/lord
	visuals_only_outfit = /datum/outfit/job/roguetown/lord/visuals

	display_order = JDO_LORD
	tutorial = "Elevated upon your throne through a web of intrigue and political upheaval, you are the absolute authority of these lands and at the center of every plot within it. Every man, woman and child is envious of your position and would replace you in less than a heartbeat: Show them the error of their ways."
	whitelist_req = FALSE
	min_pq = 10
	max_pq = null
	round_contrib_points = 4
	give_bank_account = 1000
	required = TRUE
	cmode_music = 'sound/music/combat_noble.ogg'

/datum/outfit/job/roguetown/lord
	job_bitflag = BITFLAG_ROYALTY

/datum/job/roguetown/lord/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/Q = L
		Q.advsetup = 1
		Q.invisibility = INVISIBILITY_MAXIMUM
		Q.become_blind("advsetup")
	if(L)
		var/list/chopped_name = splittext(L.real_name, " ")
		if(length(chopped_name) > 1)
			chopped_name -= chopped_name[1]
			GLOB.lordsurname = jointext(chopped_name, " ")
		else
			GLOB.lordsurname = "of [L.real_name]"
		SSticker.set_ruler_mob(L)
		to_chat(world, "<b><span class='notice'><span class='big'>[L.real_name] is [SSticker.rulertype] of Azure Peak.</span></span></b>")
		if(istype(SSticker.regentmob, /mob/living/carbon/human))
			var/mob/living/carbon/human/regentbuddy = SSticker.regentmob
			to_chat(L, span_notice("Word reached me on the approach that [regentbuddy.real_name], the [regentbuddy.job], served as regent in my absence."))
		SSticker.regentmob = null //Time for regent to give up the position.
		
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_marriage_choice)), 50)
		if(STATION_TIME_PASSED() <= 10 MINUTES) //Late to the party? Stuck with default colors, sorry!
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_color_choice)), 50)

/datum/outfit/job/roguetown/lord
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	cloak = /obj/item/clothing/cloak/lordcloak
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/storage/keyring/lord
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1)
	id = /obj/item/scomstone/garrison

/datum/outfit/job/roguetown/lord/pre_equip(mob/living/carbon/human/H)
	..()
	if(SSroguemachine.crown == null || (QDELETED(SSroguemachine.crown)))
		SSroguemachine.crown = null
		head = /obj/item/clothing/head/roguetown/crown/serpcrown
	else
		to_chat(H, span_warning("My crown must be yet in the realm. I shall search it out."))
	if(should_wear_femme_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		wrists = /obj/item/clothing/wrists/roguetown/royalsleeves
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
		shoes = /obj/item/clothing/shoes/roguetown/boots
	if(H.wear_mask)
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask/l
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

//	SSticker.rulermob = H
/** 
	Warrior Lord subclass. An evolution from the Daring Twit. This is the original Lord Class.
*/
/datum/advclass/lord/warrior
	name = "Valiant Warrior"
	tutorial = "You're a noble warrior. You rose to your rank through your own strength and skill, whether by leading your men or by fighting alongside them. Or perhaps you are none of that, but simply a well-trained heir elevated to the position of Lord. You're trained in the usage of heavy armor, and knows swordsmanship well."
	outfit = /datum/outfit/job/roguetown/lord/warrior
	category_tags = list(CTAG_LORD)

/datum/outfit/job/roguetown/lord/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter

	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.change_stat("strength", 1)
	H.change_stat("intelligence", 3)
	H.change_stat("endurance", 3)
	H.change_stat("speed", 1)
	H.change_stat("perception", 2)
	H.change_stat("fortune", 5)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

/** 
	Merchant Lord subclass. Consider this an evolution from Sheltered Aristocrat.
	Gets the same weighted 12 statspread + 5 fortune, but no strength. +2 Int, trade 2 End for 2 Perception. Keep speed. Deals gotta be quick. 
	Get nice traits for seeing price, secular appraise and keen ears for spying.
	Weapon skills are worse across the board compared to the warrior lord, apprentice only.
	Has a high noble income plus a starting pouch with insane amount of money.
*/
/datum/advclass/lord/merchant
	name = "Merchant Lord"
	tutorial = "You were always talented with coins and trade. And your talents have brought you to the position of the Lord of Azure Peak. You could be a merchant who bought his way into nobility and power, or an exceptionally talented noble who were inclined to be good with coins. Fighting directly is not your forte\
	But you have plenty of wealth, keen ears, and know a good deal from a bad one."
	outfit = /datum/outfit/job/roguetown/lord/merchant
	category_tags = list(CTAG_LORD)
	noble_income = 400 // Let's go crazy. This is +400 per day for a total of 2400 per round at the end of a day. This is probably equal to doubling passive incomes of the keep.

/datum/outfit/job/roguetown/lord/merchant/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter

	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE) // Weapons suitable for defending yourself as a merchant.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
	H.change_stat("intelligence", 5)
	H.change_stat("endurance", 1)
	H.change_stat("speed", 1)
	H.change_stat("perception", 4)
	H.change_stat("fortune", 5)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC) // It is a dangerous world out there.
	ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC) // And you can overhear conversations easily.
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC) // Medium Armor only.

/** 
	Inbred Lord subclass. A joke class, evolution of the Inbred Wastrel.
	Literally the same stat line and skills line, but with one exception - 10 Fortune.
	Why? Because it is funny, that's why. They also have heavy armor training.
	The fact that the inbred wastrel with 20 fortune and critical weakness 
	can get into heavy armor and try to fight is hilarious.
*/
/datum/advclass/lord/inbred
	name = "Inbred Lord"
	tutorial = "Psydon and Astrata smiles upon you. For despite your inbred and weak body, and your family's conspiracies to remove you from succession, you have somehow become the Lord of Azure Peak. May your reign lasts a hundred years."
	outfit = /datum/outfit/job/roguetown/lord/inbred
	category_tags = list(CTAG_LORD)

/datum/outfit/job/roguetown/lord/inbred/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter

	ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE) // Sorry you get +1 :)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(0,0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.change_stat("strength", -2)
	H.change_stat("perception", -2)
	H.change_stat("intelligence", -2)
	H.change_stat("constitution", -2)
	H.change_stat("endurance", -2)
	H.change_stat("fortune", 10) // You made it. Xylix smiles upon you!
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC) // It's like valiant warrior, but you can't fight.

/datum/outfit/job/roguetown/lord/visuals/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/crown/fakecrown //Prevents the crown of woe from happening again.

/proc/give_lord_surname(mob/living/carbon/human/family_guy, preserve_original = FALSE)
	if(!GLOB.lordsurname)
		return
	if(preserve_original)
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
		return family_guy.real_name
	var/list/chopped_name = splittext(family_guy.real_name, " ")
	if(length(chopped_name) > 1)
		family_guy.fully_replace_character_name(family_guy.real_name, chopped_name[1] + " " + GLOB.lordsurname)
	else
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
	return family_guy.real_name

/obj/effect/proc_holder/spell/self/grant_title
	name = "Grant Title"
	desc = "Grant someone a title of honor... Or shame."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Maximum range for title granting
	var/title_range = 3
	/// Maximum length for the title
	var/title_length = 42

/obj/effect/proc_holder/spell/self/grant_title/cast(list/targets, mob/user = usr)
	. = ..()
	var/granted_title = input(user, "What title do you wish to grant?", "[name]") as null|text
	granted_title = reject_bad_text(granted_title, title_length)
	if(!granted_title)
		return
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/village_idiot in (get_hearers_in_view(title_range, user) - user))
		//not allowed
		if(!can_title(village_idiot))
			continue
		recruitment[village_idiot.name] = village_idiot
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential honoraries in range."))
		return
	var/inputty = input(user, "Select an honorary!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(title_range, user)))
			INVOKE_ASYNC(src, PROC_REF(village_idiotify), recruit, user, granted_title)
		else
			to_chat(user, span_warning("Honorific failed!"))
	else
		to_chat(user, span_warning("Honorific cancelled."))

/obj/effect/proc_holder/spell/self/grant_title/proc/can_title(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/grant_title/proc/village_idiotify(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter, granted_title)
	if(QDELETED(recruit) || QDELETED(recruiter) || !granted_title)
		return FALSE
	if(GLOB.lord_titles[recruit.real_name])
		recruiter.say("I HEREBY STRIP YOU, [uppertext(recruit.name)], OF THE TITLE OF [uppertext(GLOB.lord_titles[recruit.real_name])]!")
		GLOB.lord_titles -= recruit.real_name
		return FALSE
	recruiter.say("I HEREBY GRANT YOU, [uppertext(recruit.name)], THE TITLE OF [uppertext(granted_title)]!")
	GLOB.lord_titles[recruit.real_name] = granted_title
	return TRUE

/obj/effect/proc_holder/spell/self/grant_nobility
	name = "Grant Nobility"
	desc = "Make someone a noble, or strip them of their nobility."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Maximum range for nobility granting
	var/nobility_range = 3

/obj/effect/proc_holder/spell/self/grant_nobility/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/village_idiot in (get_hearers_in_view(nobility_range, user) - user))
		//not allowed
		if(!can_nobility(village_idiot))
			continue
		recruitment[village_idiot.name] = village_idiot
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential honoraries in range."))
		return
	var/inputty = input(user, "Select an honorary!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(nobility_range, user)))
			INVOKE_ASYNC(src, PROC_REF(grant_nobility), recruit, user)
		else
			to_chat(user, span_warning("Honorific failed!"))
	else
		to_chat(user, span_warning("Honorific cancelled."))

/obj/effect/proc_holder/spell/self/grant_nobility/proc/can_nobility(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_DEFILED_NOBLE)) // Their lux was tainted by evil matthios rite. They are utterly fucked.
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/grant_nobility/proc/grant_nobility(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_NOBLE))
		if(!HAS_TRAIT(recruit,TRAIT_OUTLANDER))
			recruiter.say("I HEREBY STRIP YOU, [uppertext(recruit.name)], OF NOBILITY!!")
			REMOVE_TRAIT(recruit, TRAIT_NOBLE, TRAIT_GENERIC)
			REMOVE_TRAIT(recruit, TRAIT_NOBLE, TRAIT_VIRTUE)
			return FALSE
		else
			to_chat(recruiter, span_warning("Their nobility is not mine to strip!"))
			return FALSE
	recruiter.say("I HEREBY GRANT YOU, [uppertext(recruit.name)], NOBILITY!")
	ADD_TRAIT(recruit, TRAIT_NOBLE, TRAIT_GENERIC)
	REMOVE_TRAIT(recruit, TRAIT_OUTLANDER, ADVENTURER_TRAIT)
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "Recruit Servant"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100

/obj/effect/proc_holder/spell/self/convertrole/bog
	name = "Recruit Warden"
	new_role = "Warden"
	recruitment_faction = "Bog Guard"
	recruitment_message = "Serve the Wardens, %RECRUIT!"
	accept_message = "FOR THE GROVE!"
	refuse_message = "I refuse."
