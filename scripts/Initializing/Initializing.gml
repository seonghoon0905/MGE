function initialize_world(){
	#macro GAME_NAME "Medley's Guy Engine" // Game name on the window caption
	#macro GAME_SPEED 50 
	game_set_speed(GAME_SPEED, gamespeed_fps);	
	#macro DEFAULT_CAMERA_WIDTH 800
	#macro DEFAULT_CAMERA_HEIGHT 608
	
	/* Macros for general settings */
	#macro DATA_SLOT 3 // Define amount of player datas on the data selection screen. 
    #macro LOCK_AND_KEY_NUMBER 0x32495613 
    // For encrypting saved datas
    // You can change "0x32495613" to any combo of numbers as long as it still starts with 0x
    #macro DATA_SELECTION_SCREEN_TYPE 0
    // 0 : Standard IWBTG data selection screen
    // 1 : Big Preview Snapshot
	
	#macro ENABLE_ACHIEVEMENT true // Define whether to enable the achivement system.
	#macro ACHIEVEMENT_SLOT 4 // Define amount of achievements.
	#macro SQUARED_ACHIEVEMENT_ICON true // If you set this false, all achievement icons will be displayed in a circular arrangement.
	#macro SHOW_ACHIEVEMENT_NAME true // Set whether to show the achievement's name in the settings screen
	#macro SHOW_ACHIEVEMENT_EXPLANATION false // Set whether to show the achievement's explanation in the settings screen
	#macro SHOW_ACHIEVEMENT_ICON false // Set whether to show the achievement's icon in the settings screen
	#macro SHOW_ACHIEVEMENT_COMPLETE_SIGN false // Set whether to show the "Complete!" message below completed achievement icons.
	
	#macro ENABLE_SKIN true // Define whether to enable skin system.
	#macro ENABLE_ITEM_AND_INVENTORY true // Define whether to enable item and inventory system.
	#macro ENABLE_PLAYER_BACKSTEP true // Define whether to enable backstep system.
	#macro ENABLE_PLAYER_BACKSTEP_FOREVER false // If you make this true, the player can use backstep anywhere.
												// So you should make ENABLE_PLAYER_BACKSTEP false. 
	#macro STARTING_ROOM rm_total_test // Choose which room to appear when the player first enters the game.
	#macro ENABLE_RESPAWNING_WITH_ROOM_RESTART true // Define whether the room restarts when the player presses the load key.
	/* <Notice>
	If you make ENABLE_RESPAWNING_WITH_ROOM_RESTART false, you should code all consumable objects 
	can be regenerated. I recommend to use this macro only if room restart is causing issues. 
	(Don't worry, at least all objects in the engine are designed to be regenerated with restarting room.) */
	
	/* Macros for player control */
	#macro PRESERVE_FLOATING_POINT true // If you make it true, floating points of the player's position will be removed every time when respawning.
	#macro KILL_PLAYER_ON_BORDER true // Set whether the player to be kiiled on the borders of the room.
	#macro PLAYER_SPEED_ALONG_SCALE true // Set whether the player goes same speed on different image scales.
	#macro ENABLE_GRAVITY_CHANGING_ANIMATION false // If you make it true, the player will keep spinning until he reaches the next gravity direction.
	#macro ENABLE_SLOPE_ANIMATION true // If you make it true, the player's image angle will be changed same as the slope's angle.
	
	/* Macros for debugging */
	#macro ENABLE_DEBUG_MODE true 
	// (WARNING!) YOU MUST MAKE THE ABOVE ONE "false" BEFORE RELEASING THE GAME.
	#macro SHOW_EXTENSIVE_YALIGN false // You can see the 10 digits of the floating point of the player's y position if you make it true.
	#macro MAX_DEBUG_GAME_SPEED 300
	#macro MIN_DEBUG_GAME_SPEED 1 
	// In debug mode, you can change the speed of the room with F11 and F12 and you can set range of room speed with above two macros.
	#macro DEBUG_ROOM rm_debug_hub // Choose which room to appear when the player presses F1 on debug mode
	#macro MAX_DEBUG_CAMERA_ZOOM 3
	#macro MIN_DEBUG_CAMERA_ZOOM 0.4
	
	global.savedata_index = 0; 
	
	global.player = {
		jump_total : undefined,
		xscale : undefined,
		yscale : undefined,
		gravity_dir : undefined,
		kid_mode : undefined,
		screen_rotated : undefined
	}
	
	global.player_data = {
		x : undefined,
		y : undefined,
		room : undefined,
		jump_total : 2,
		xscale : 1,
		yscale : 1,
		gravity_dir : 270,
		kid_mode : "default",
		screen_rotated : false
	}
	
	global.other_player_data = {
		time : 0,
		death_count : 0,
		item : ["pop_gun", "machine_gun", "shot_gun", "rocket_gun"],
		inventory : ["pop_gun"],
		skins : ["standard", "crimson", "round"],
		skin_index : 0,
		inventory_index : 0,
		achievements : array_create(ACHIEVEMENT_SLOT, false)
	}
	
	global.warp = {
		room : undefined,
		x : undefined,
		y : undefined
	}

	global.game_over = false;

	global.settings = {
		fullscreen : false,
        window_size : 0,
		smoothing_mode : false,
        vsync : false,
		backstep : false,
		swap_items_with_number_keys : false,
		master_volume : 100,
		music_volume : 100,
		effect_volume : 100,
		music_id : audio_play_sound(snd_no_music, 0, true),
		fps_sync : false,
		no_pause : false,
	}
	
	global.game_paused = false;
	global.no_pause = false;
	global.in_game = false;
	
	global.key_config = {
		jump : vk_shift,
		shoot : ord("Z"),
		up : vk_up,
		down : vk_down,
		right : vk_right,
		left : vk_left,
		save : ord("S"),
		load : ord("R"),
		item_swap : ord("A"),
		pause : ord("P"),
		setting : vk_escape
	}
	
	global.debug_config = {
		god_mode : false,
		inf_jump : false,
		show_player_mask : false,
	}
	
	global.debug_key_config = {
		god_mode : ord("G"),
		teleport : vk_tab,
		show_player_mask : vk_home,
		inf_jump : vk_end,
		next_room : vk_pageup,
		previous_room : vk_pagedown,
		room_speed_reset : vk_f10,
		room_speed_up : vk_f12,
		room_speed_down : vk_f11,
		debug_room : vk_f1,
		debug_camera : vk_delete
	}
}