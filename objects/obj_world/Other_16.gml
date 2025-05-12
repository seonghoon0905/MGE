/// @description Debug 
function handle_debug(){
	// Exit if ENABLE_DEBUG_MODE is false 
	//(If you want to modify, go to the initialize_world)
	if(!ENABLE_DEBUG_MODE){
		return;
	}
	
	if(keyboard_check_pressed(global.debug_key_config.god_mode)){
		// Check if the player pressed god mode key
		if(global.debug_config.god_mode){
			global.debug_config.god_mode = false;
			global.debug_config.show_player_mask = false;
			global.debug_config.inf_jump = false;
			global.player.jump_total = 2;
			global.debug_config.debug_camera = false;
			game_set_speed(GAME_SPEED, gamespeed_fps); 
		} // Refresh every variable of debug config if god_mode is true and make god_mode false
		else{
			global.debug_config.god_mode = true;
		}
	}
	
	// Exit if god mode is false
	if(!global.debug_config.god_mode){
		return;
	}
	
	if(keyboard_check_pressed(global.debug_key_config.teleport) && instance_exists(obj_player)){
		obj_player.x = mouse_x;
		obj_player.y = mouse_y;
	} // Let the player follow mouse when pressing teleport key
	
	if(keyboard_check_pressed(global.debug_key_config.next_room)){
		if(room_next(room) != -1){
			room_goto_next();
		}
	} // Go to the next room
	
	if(keyboard_check_pressed(global.debug_key_config.previous_room)){
		if(room_previous(room) != rm_init && room_previous(room) != -1){
			room_goto_previous();
		}
	} // Go to the previous room except rm_init
	
	if(keyboard_check_pressed(global.debug_key_config.debug_room)){
		room_goto(DEBUG_ROOM);
	} // Let the player go to the debug room when you pressed debug room key
	
	if(keyboard_check_pressed(global.debug_key_config.show_player_mask) && instance_exists(obj_player)){
		if(global.debug_config.show_player_mask){
			global.debug_config.show_player_mask = false;
		}
		else{
			global.debug_config.show_player_mask = true;
		}
	}
	
	if(keyboard_check_pressed(global.debug_key_config.inf_jump) && instance_exists(obj_player)){
		if(global.debug_config.inf_jump){
			global.debug_config.inf_jump = false;
			global.player.jump_total = 2;
		}
		else{  
			global.debug_config.inf_jump = true;
			global.player.jump_total = infinity;
		}
	}
	
	if(keyboard_check(global.debug_key_config.room_speed_up)){
		game_set_speed(min(MAX_DEBUG_GAME_SPEED, game_get_speed(gamespeed_fps) + 1), gamespeed_fps);
	}
	
	if(keyboard_check(global.debug_key_config.room_speed_down)){
		game_set_speed(max(MIN_DEBUG_GAME_SPEED, game_get_speed(gamespeed_fps) - 1), gamespeed_fps);
	}
	
	if(keyboard_check_pressed(global.debug_key_config.room_speed_reset)){
		game_set_speed(GAME_SPEED, gamespeed_fps);
	}
}

function draw_debug_info(){
	if(!ENABLE_DEBUG_MODE){
		return;
	}
	
	if(!global.debug_config.god_mode){
		return;
	}
	
	draw_set_font(fnt_arial_11);
	draw_set_color(c_white);
	font_enable_effects(fnt_arial_11, true,{
		outlineEnable : true,
		outlineDistance : 0,
		outlineColor : c_black
	});
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_text(32, 32, "Godmode");
}