/datum/ai_controller/mirespider
    movement_delay = MIRESPIDER_MOVEMENT_SPEED

    ai_movement = /datum/ai_movement/hybrid_pathing

    blackboard = list(
        BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
    )

    planning_subtrees = list(
        /datum/ai_planning_subtree/target_retaliate,
        /datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
        
        /datum/ai_planning_subtree/basic_melee_attack_subtree,

        /datum/ai_planning_subtree/simple_self_recovery,
        /datum/ai_planning_subtree/find_food,
        /datum/ai_planning_subtree/eat_food,
        /datum/ai_planning_subtree/being_a_minion/mirespider
    )

    idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/mirespider_lurker
    movement_delay = MIRESPIDER_MOVEMENT_SPEED

    ai_movement = /datum/ai_movement/hybrid_pathing

    blackboard = list(
        BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
    )

    planning_subtrees = list(
        /datum/ai_planning_subtree/target_retaliate,
        /datum/ai_planning_subtree/simple_find_target/closest,
        /datum/ai_planning_subtree/basic_ranged_attack_subtree/mirespider_lurker,
        /datum/ai_planning_subtree/find_cocoon_target,
        /datum/ai_planning_subtree/cocoon_target
    )

    idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/mirespider_paralytic
    movement_delay = MIRESPIDER_MOVEMENT_SPEED

    ai_movement = /datum/ai_movement/hybrid_pathing

    blackboard = list(
        BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
    )

    planning_subtrees = list(
        /datum/ai_planning_subtree/target_retaliate,
        /datum/ai_planning_subtree/simple_find_target/closest,
        /datum/ai_planning_subtree/find_cocoon_target,
        /datum/ai_planning_subtree/cocoon_target
    )

    idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_planning_subtree/being_a_minion/mirespider
    /// Blackboard key where we travel a place
    location_key = BB_TRAVEL_DESTINATION
    /// Who we're following
    follow_target = BB_FOLLOW_TARGET
    /// What do we do in order to travel
    travel_behavior = /datum/ai_behavior/travel_towards/stop_on_arrival

/datum/ai_planning_subtree/being_a_minion/mirespider/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
    . = ..()
    var/turf/travel = controller.blackboard[BB_TRAVEL_DESTINATION]
    var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/following = controller.blackboard[BB_FOLLOW_TARGET]
    var/mob/living/pawn = controller.pawn

    if (travel)  // Check if travel is defined
        controller.queue_behavior(travel_behavior, BB_TRAVEL_DESTINATION)
        return SUBTREE_RETURN_FINISH_PLANNING  // end here
    
    else if (following)  // If we're following someone
        var/mob/target = following.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
        following.add_follower(pawn)

        // If the follow target has a target, stop following
        if (target)
            controller.clear_blackboard_key(BB_FOLLOW_TARGET)

        // If too far from the following target, stop following
        else if (get_dist(pawn, following) > 12)
            controller.clear_blackboard_key(BB_FOLLOW_TARGET)

        // Otherwise, continue following
        else
            controller.queue_behavior(/datum/ai_behavior/follow_friend/mirespider, BB_FOLLOW_TARGET)

        return SUBTREE_RETURN_FINISH_PLANNING  // end here
    return  // No travel target and no one to follow, being a minion in other ways

/datum/ai_behavior/follow_friend/mirespider
    behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/follow_friend/mirespider/setup(datum/ai_controller/controller, target_key)
    . = ..()
    var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/target = controller.blackboard[target_key]
    var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/target_target = target.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

    if (target_target)
        return FALSE

    if (QDELETED(target))
        return FALSE
    set_movement_target(controller, target)

/datum/ai_behavior/follow_friend/mirespider/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
    var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/target = controller.blackboard[target_key]
    var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/target_target = target.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

    if (target_target)
        return  // Stop following if the target has a target

    if (QDELETED(target))
        return

    return

/datum/ai_planning_subtree/basic_ranged_attack_subtree/mirespider_lurker
    ranged_attack_behavior = /datum/ai_behavior/basic_ranged_attack

/datum/ai_planning_subtree/basic_ranged_attack_subtree/mirespider_lurker/SelectBehaviors(datum/ai_controller/controller, delta_time)
    . = ..()
    var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
    if(QDELETED(target))
        return

    if(isliving(target))
        var/mob/living/carbon/L = target
        if(L)
            if(L.stat || L.getBruteLoss() > 500)
                controller.set_blackboard_key(BB_BASIC_MOB_COCOON_TARGET, L)
                controller.queue_behavior(/datum/ai_behavior/cocoon_target, BB_BASIC_MOB_COCOON_TARGET)
                return SUBTREE_RETURN_FINISH_PLANNING

    var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/lurker = controller.pawn
    if (lurker)
        lurker.clear_followers_if_any()
    
    controller.queue_behavior(ranged_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
    return SUBTREE_RETURN_FINISH_PLANNING 

/datum/ai_behavior/cocoon_target
    behavior_flags = AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_REQUIRE_MOVEMENT
    action_cooldown = 1 SECONDS

/datum/ai_behavior/cocoon_target/setup(datum/ai_controller/controller, target_key)
    . = ..()
    var/mob/living/target = controller.blackboard[target_key]
    if (!target || QDELETED(target) || !isliving(target))
        return FALSE

    set_movement_target(controller, (target))

/datum/ai_behavior/cocoon_target/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
    . = ..()
    var/mob/living/simple_animal/pawn = controller.pawn
    var/mob/living/target = controller.blackboard[target_key]
    if (!target || QDELETED(target) || !isliving(target))
        finish_action(controller, FALSE, target_key)
        return

    if (istype(target.loc, /obj/structure/spider/cocoon))
        finish_action(controller, TRUE, target_key)
        return

    if (target.stat)
        if (do_after(pawn, 5 SECONDS, FALSE, target))
            if (istype(target.loc, /obj/structure/spider/cocoon))
                finish_action(controller, TRUE, target_key)
                return
            var/turf/T = get_turf(target)
            var/cocoon = new /obj/structure/spider/cocoon(T)
            target.forceMove(cocoon)
            // Very gentle healing effect that restores a lot of bloodloss. Allows the target to break out later.
            target.apply_status_effect(/datum/status_effect/buff/healing/spider_cocoon, 0.25)
            finish_action(controller, TRUE, target_key)

/datum/ai_behavior/cocoon_target/finish_action(datum/ai_controller/controller, succeeded, target_key)
    . = ..()
    if(!succeeded)
        controller.clear_blackboard_key(target_key)
    controller.clear_blackboard_key(target_key)

/datum/ai_planning_subtree/cocoon_target
	var/datum/ai_behavior/cocoon_target/behavior = /datum/ai_behavior/cocoon_target

/datum/ai_planning_subtree/cocoon_target/SelectBehaviors(datum/ai_controller/controller, delta_time)
    . = ..()
    var/obj/item/target = controller.blackboard[BB_BASIC_MOB_COCOON_TARGET]
    if(QDELETED(target))
        controller.clear_blackboard_key(BB_BASIC_MOB_COCOON_TARGET)
        return
    var/mob/living/pawn = controller.pawn
    if(pawn.doing)
        return
    if(!istype(target, /mob/living/carbon))
        behavior = /datum/ai_behavior/cocoon_target

    controller.queue_behavior(behavior, BB_BASIC_MOB_COCOON_TARGET)
    return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/find_cocoon_target
    var/vision_range = 6
    var/datum/ai_behavior/find_and_set/cocoon_target/behavior = /datum/ai_behavior/find_and_set/cocoon_target
    var/cocoon_target_key = BB_BASIC_MOB_COCOON_TARGET

/datum/ai_planning_subtree/find_cocoon_target/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
    . = ..()

    var/atom/target = controller.blackboard[cocoon_target_key]
    if(!QDELETED(target))
        // Busy with something
        return
    
    controller.queue_behavior(behavior, cocoon_target_key, controller.blackboard[BB_BASIC_FOODS], vision_range)

/datum/ai_behavior/find_and_set/cocoon_target
    action_cooldown = 20 SECONDS

/datum/ai_behavior/find_and_set/cocoon_target/search_tactic(datum/ai_controller/controller, locate_paths, search_range)
    var/list/found = list()
    for(var/mob/living/carbon/mob in oview(search_range, controller.pawn))
        var/obj/structure/spider/cocoon/cocoon = mob.loc
        if(istype(cocoon, /obj/structure/spider/cocoon))
            continue
        if(mob.stat == DEAD)
            continue
        found |= mob
    if(!length(found))
        return null
    return pick(found)
