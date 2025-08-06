#define VALID_FISHING_SPOTS list(\
	/turf/open/water/river,\
	/turf/open/water/cleanshallow,\
	/turf/open/water/ocean,\
	/turf/open/water/ocean/deep,\
	/turf/open/water/swamp,\
	/turf/open/water/swamp/deep )

//Valid spots for fishing add to it if there's more.
/proc/is_valid_fishing_spot(turf/T)
	for(var/i in VALID_FISHING_SPOTS)
		if(istype(T, i))
			return TRUE
	return FALSE

/proc/createFreshWaterFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/list/weightList = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 270*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/sunny = 340*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 180*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/eel = 180*commonMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick = 1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a fish...?
 		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createFreshWaterFishWeightListModlist(list/fishingMods)
	return createFreshWaterFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createCoastalSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 300*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 60*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 70*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 210*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 40*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 10*rareMod + 100*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 15*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 15*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 50*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 10*ceruleanMod,
		/obj/item/grown/log/tree/stick =  1*trashMod,
		/obj/item/natural/cloth = 1*trashMod,
		/obj/item/ammo_casing/caseless/rogue/arrow = 1*trashMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a coastal fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,
	)
	return counterlist_ceiling(weightList)

/proc/createCoastalSeaFishWeightListModlist(list/fishingMods) 
	return createCoastalSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createDeepSeaFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/cod = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/sole = 50*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/angler = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 100*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/bass = 100*commonMod,
		/obj/item/reagent_containers/food/snacks/fish/clam = 150*rareMod,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 50*rareMod + 200*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1*treasureMod + 30*ceruleanMod,
		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1*treasureMod + 75*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 40*ceruleanMod,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 15*ceruleanMod,
		/obj/item/reagent_containers/glass/bottle/rogue = 1*trashMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //That's not a deep sea fish...?
		/mob/living/carbon/human/species/goblin/npc/sea = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone = 50*dangerMod,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 50*dangerMod,
	)
	return counterlist_ceiling(weightList)

/proc/createDeepSeaFishWeightListModlist(list/fishingMods) 
	return createDeepSeaFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createMudFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list (
		/obj/item/reagent_containers/food/snacks/fish/mudskipper = 790*commonMod,
		/obj/item/natural/worms/leech = 180*rareMod,
 		/obj/item/clothing/ring/gold = 1*treasureMod + 30*ceruleanMod,
		/obj/item/reagent_containers/food/snacks/smallrat = 1, //Thats one dirty... not a fish...?
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = 30,	
	)
	return counterlist_ceiling(weightList)

/proc/createMudFishWeightListModlist(list/fishingMods)
	return createMudFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])

/proc/createCageFishWeightList(commonMod, rareMod, treasureMod, trashMod, dangerMod, ceruleanMod)
	var/weightList = list(
			/obj/item/reagent_containers/food/snacks/fish/oyster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/shrimp = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/fish/crab = 250*rareMod,
			/obj/item/reagent_containers/food/snacks/fish/lobster = 250*commonMod,
			/obj/item/reagent_containers/food/snacks/smallrat = 1, //Oh for fucks sake!
		)	
	return counterlist_ceiling(weightList)

/proc/createCageFishWeightListModlist(list/fishingMods)
	return createCageFishWeightList(fishingMods["commonFishingMod"],fishingMods["rareFishingMod"],fishingMods["treasureFishingMod"],fishingMods["trashFishingMod"],fishingMods["dangerFishingMod"],fishingMods["ceruleanFishingMod"])
