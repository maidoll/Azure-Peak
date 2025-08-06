/mob/dead/new_player/Login()
	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	sight |= SEE_TURFS

	addtimer(CALLBACK(src, PROC_REF(do_after_login)), 4 SECONDS)
	new_player_panel()

	if(client)
		client.playtitlemusic()

/mob/dead/new_player/proc/do_after_login()
	PRIVATE_PROC(TRUE)
	if(!client)
		return

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.rogue_round_id)
		to_chat(src, span_info("ROUND ID: [GLOB.rogue_round_id]"))

	if(client.is_new_player())
		to_chat(src, span_userdanger("Due to an invasion of goblins trying to play ROGUETOWN, you need to register your discord account or support us on patreon to join."))
		to_chat(src, span_info("We dislike discord too, but it's necessary. To register your discord or patreon, please click the 'Register' tab in the top right of the window, and then choose one of the options."))
	else
		var/shown_patreon_level = client.patreonlevel()
		if(!shown_patreon_level)
			shown_patreon_level = "<font color='#41acc7'><b>Azurean Chad</b></font>"
		switch(shown_patreon_level)
			if(1)
				shown_patreon_level = "Silver"
			if(2)
				shown_patreon_level = "Gold"
			if(3)
				shown_patreon_level = "Mythril"
			if(4)
				shown_patreon_level = "Merchant"
			if(5)
				shown_patreon_level = "Lord"
		to_chat(src, span_info("Donator Level: [shown_patreon_level]"))
	client.recent_changelog()

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>Admin Notice:</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "in about [DisplayTimeText(tl)]"
		else
			postfix = "soon"
		to_chat(src, "The game will start [postfix].")

		SSvote.send_vote(client)
		var/usedkey = (ckey in GLOB.anonymize) ? get_fake_key(ckey) : ckey
		var/list/thinz = list("takes a seat.", "settles in.", "joins the session", "joins the table.", "becomes a player.")
		SEND_TEXT(world, span_notice("[usedkey] [pick(thinz)]"))
