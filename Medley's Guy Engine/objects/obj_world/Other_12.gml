/// @description Settings
function handle_index_array_length(){
	var _len1 = 0;
	
	for(var _i = 0; _i < array_length(settings_array_of_index); _i++){
		var _len2 = array_length(settings_array_of_index[_i]);
		
		if(_len2 < 1){
			continue;
		}
		
		_len1++;
	}
	
	return _len1;
}

function handle_index_arrow1_row_index(_row_index){
	var _index1 = !ENABLE_SKIN && !ENABLE_ITEM_AND_INVENTORY && !ENABLE_PLAYER_BACKSTEP ? 0 : undefined;
	var _index2 = !ENABLE_ACHIEVEMENT ? 1 : undefined;
	var _indexes = [_index1, _index2];
	
	var _len = array_length(_indexes);
	for(var _i = 0; _i < _len; _i++){
		if(_indexes[_i] != undefined){
			if(_row_index > _indexes[_i]){
				_row_index--;
			}
			
			for(var _j = _i + 1; _j < _len; _j++){
				if(_indexes[_j] == undefined){
					continue;
				}
				
				_indexes[_j]--;
			}
		}
	}

	return _row_index;
}

function handle_player_info_on_index_array(){
	var _player_info = [];
	
	if(ENABLE_SKIN){
		array_push(_player_info, "skin");
	}
	
	if(ENABLE_ITEM_AND_INVENTORY){
		array_push(_player_info, "item", "inventory", "swap_items_with_number_keys");
	}
	
	if(ENABLE_PLAYER_BACKSTEP){
		array_push(_player_info, "backstep");
	}
	
	return _player_info;
}

function handle_keyboard_control_on_index_array(){
	var _keyboard_control = [];
	
	if(ENABLE_ITEM_AND_INVENTORY){
		_keyboard_control = ["Jump", "Shoot", "UP", "Down", "Right", "Left", "Save", "Load", "Item Swap"];
	}
	else{
		_keyboard_control = ["Jump", "Shoot", "UP", "Down", "Right", "Left", "Save", "Load"];
	}
	
	return _keyboard_control;
}

function handle_settings_array_of_index(){
	var _indexes = [];
	
	var _player_info = handle_player_info_on_index_array();
	array_push(_indexes, _player_info);
	
	var _achievment = ENABLE_ACHIEVEMENT ? ["achievement"] : [];
	array_push(_indexes, _achievment);
	
	var _display = ["fullscreen", "smoothing_mode"];
	array_push(_indexes, _display);
	
	var _audio = ["master_volume", "music_volume", "effect_volume", "fps_sync"];
	array_push(_indexes, _audio);
	
	var _keyboard_control = handle_keyboard_control_on_index_array();
	array_push(_indexes, _keyboard_control);
	
	array_push(_indexes, ["back_to_title"]);
	
	array_push(_indexes, ["quit_game"]);
	
	return _indexes;
}

function handle_name_list_on_keyboard_control(){
	var _name_list = [];
	
	if(ENABLE_ITEM_AND_INVENTORY){
		_name_list = ["jump", "shoot", "up", "down", "right", "left", "save", "load", "item_swap"];
	}
	else{
		_name_list = ["jump", "shoot", "up", "down", "right", "left", "save", "load"];
	}
	
	return _name_list;
}

function handle_snapshot(){
	if(global.in_game && !global.game_paused && surface_exists(application_surface)){
		if(!directory_exists("SnapShot")){
			directory_create("SnapShot");
		}
		
		var _w = surface_get_width(application_surface);
		var _h = surface_get_height(application_surface);
		var _surf = surface_create(_w, _h);
		surface_set_target(_surf);
		draw_clear_alpha(c_black, 0);
		var _res = shader_get_uniform(sh_snapshot, "iResolution");
		shader_set(sh_snapshot);
		shader_set_uniform_f(_res, _w, _h);
		draw_surface(application_surface, 0, 0);
		shader_reset();
		surface_reset_target();
		
		surface_save(_surf, "SnapShot\\SnapShot" + string(global.savedata_index) + ".png");
	}
}

function handle_settings_skin(){
	if(!global.in_game){
		return;
	}
	
	if(keyboard_check_pressed(vk_right)){
		var _index = settings_skin_index;
		var _len = array_length(global.other_player_data.skins);
		settings_skin_index = _index < _len - 1 ? _index + 1 : _index;
		settings_skin_ui_anim_time = 0;
		global.other_player_data.skin_index = settings_skin_index;
		global.player.default_skin = global.other_player_data.skins[global.other_player_data.skin_index];
	}
	else if(keyboard_check_pressed(vk_left)){
		var _index = settings_skin_index;
		var _len = array_length(global.other_player_data.skins);
		settings_skin_index = _index > 0 ? _index - 1 : _index;
		settings_skin_ui_anim_time = 0;
		global.other_player_data.skin_index = settings_skin_index;
		global.player.default_skin = global.other_player_data.skins[global.other_player_data.skin_index];
	}
}

function handle_settings_item(){
	if(!global.in_game){
		return;
	}
	
	if(keyboard_check_pressed(vk_right)){
		var _index = settings_item_index;
		var _len = array_length(global.other_player_data.item);
		settings_item_index = _index < _len - 1 ? _index + 1 : _index;
		settings_item_ui_anim_time = 0;
	}
	else if(keyboard_check_pressed(vk_left)){
		var _index = settings_item_index;
		var _len = array_length(global.other_player_data.item);
		settings_item_index = _index > 0 ? _index - 1 : _index;
		settings_item_ui_anim_time = 0;
	}
	
	if(keyboard_check_pressed(vk_shift)){
		if(!array_contains(global.other_player_data.inventory, global.other_player_data.item[settings_item_index])){
			array_push(global.other_player_data.inventory, global.other_player_data.item[settings_item_index]);
		}
	}
}

function handle_settings_inventory(){
	if(!global.in_game){
		return;
	}
	
	if(keyboard_check_pressed(vk_right)){
		var _index = settings_inventory_index;
		var _len = array_length(global.other_player_data.inventory);
		settings_inventory_index = _index < _len - 1 ? _index + 1 : _index;
		settings_inventory_ui_anim_time = 0;
	}
	else if(keyboard_check_pressed(vk_left)){
		var _index = settings_inventory_index;
		var _len = array_length(global.other_player_data.inventory);
		settings_inventory_index = _index > 0 ? _index - 1 : _index;
		settings_inventory_ui_anim_time = 0;
	}
	
	if(array_length(global.other_player_data.inventory) > 1 && keyboard_check_pressed(vk_shift)){
		var _index = settings_inventory_index;
		var _len = array_length(global.other_player_data.inventory);
		array_delete(global.other_player_data.inventory, _index, 1);
		settings_inventory_index = _index == _len - 1 ? _len - 2 : _index;
		global.other_player_data.inventory_index = min(array_length(global.other_player_data.inventory) - 1, global.other_player_data.inventory_index);
	}
}

function handle_settings_backstep(){
	if(keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)){
		global.settings.backstep = !global.settings.backstep;
	}
}

function handle_settings_swap_items_with_number_keys(){
	if(keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)){
		global.settings.swap_items_with_number_keys = !global.settings.swap_items_with_number_keys;
	}
}

function handle_settings_master_volume(){	
	if(keyboard_check(vk_right)){
		var _master_volume = global.settings.master_volume;
		global.settings.master_volume = min(100, _master_volume + 1);
	}
	if(keyboard_check(vk_left)){
		var _master_volume = global.settings.master_volume;
		global.settings.master_volume = max(0, _master_volume - 1);
	}
	
	audio_master_gain(global.settings.master_volume / 100);
}

function handle_settings_music_volume(){	
	if(keyboard_check(vk_right)){
		var _music_volume = global.settings.music_volume;
		global.settings.music_volume = min(100, _music_volume + 1);
	}
	if(keyboard_check(vk_left)){
		var _music_volume = global.settings.music_volume;
		global.settings.music_volume = max(0, _music_volume - 1);
	}
	
	if(audio_get_name(global.settings.music_id) == "snd_no_music"){
		return;
	}
	
	audio_sound_gain(global.settings.music_id, global.settings.music_volume / 100, 0);
}

function handle_settings_effect_volume(){
	if(keyboard_check(vk_right)){
		var _effect_volume = global.settings.effect_volume;
		global.settings.effect_volume = min(100, _effect_volume + 1);
	}
	if(keyboard_check(vk_left)){
		var _effect_volume = global.settings.effect_volume;
		global.settings.effect_volume = max(0, _effect_volume - 1);
	}
}

function handle_settings_fps_sync(){
	if(keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)){
		global.settings.fps_sync = !global.settings.fps_sync;
	}
}

function handle_settings_keyboard_controls(){
	settings_keyboard_controls_skip_key_action = false;
	
	var _name_list = handle_name_list_on_keyboard_control(), _flag = false;
	
	for(var _i = 0; _i < array_length(_name_list); _i++){
		
		_flag = settings_column_index == _i &&
				settings_is_key_selected &&
				keyboard_check_pressed(vk_anykey);
					
		if(_flag){
			global.key_config[$ _name_list[_i]] = keyboard_key;
			settings_keyboard_controls_skip_key_action = true;
			settings_is_key_selected = false;
			break;
		}
	}
	
	_flag = !settings_keyboard_controls_skip_key_action &&
			keyboard_check_pressed(vk_shift) && 
			!settings_is_key_selected;
			
	if(_flag){
		settings_is_key_selected = true;
	}
}

function handle_settings_fullscreen(){
	if(keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)){
		if(!window_get_fullscreen()){
			window_set_fullscreen(true);
			global.settings.fullscreen = true;
		}
		else if(window_get_fullscreen()){
			window_set_fullscreen(false);
			global.settings.fullscreen = false;
		}
	}
}

function handle_settings_smoothing_mode(){
	if(keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)){
		if(!global.settings.smoothing_mode){
			global.settings.smoothing_mode = true;
		}
		else{
			global.settings.smoothing_mode = false;
		}
	}
}

function handle_settings_back_to_title(){	
	instance_activate_all();
	
	settings_item_index = 0;
	settings_inventory_index = 0;
	settings_achievement_index = 0;
	
	settings_skin_ui_anim_time = 0;
	settings_item_ui_anim_time = 0;
	settings_inventory_ui_anim_time = 0;
	
	global.game_paused = false;
	on_setting = false;
	sprite_delete(pause_sprite);
	
	save_other_player_data();
	
	refresh_global_other_player_data();
	refresh_global_player_data();
	
	global.in_game = false;
	global.game_over = false;
	global.savedata_index = 0;
	
	room_goto(rm_title);
}

function back_to_title_with_f2(){
	var _flag = keyboard_check_pressed(vk_f2) &&
				!simple_pause &&
				!global.game_paused &&
				settings_master_alpha == 0;
				
	if(_flag){
		
		handle_snapshot();
			
		save_other_player_data();
		refresh_global_other_player_data();
		refresh_global_player_data();
		
		global.in_game = false;
			
		settings_item_index = 0;
		settings_inventory_index = 0;
		settings_achievement_index = 0;
			
		global.game_over = false;
		global.game_paused = false;
		on_setting = false;
		global.savedata_index = 0;
		room_goto(rm_title);
	}
}

function synchronize_music_with_fps(){
	if(audio_get_name(global.settings.music_id) != "snd_no_music" && global.settings.fps_sync){
		audio_sound_pitch(global.settings.music_id, fps / game_get_speed(gamespeed_fps));
	}
}

function toggle_fullscreen(){
	if(keyboard_check_pressed(vk_f4) && !settings_keyboard_controls_skip_key_action){
		if(!window_get_fullscreen()){
			window_set_fullscreen(true);
			global.settings.fullscreen = true;
		}
		else if(window_get_fullscreen()){
			window_set_fullscreen(false);
			global.settings.fullscreen = false;
		}
	}
	
	window_set_fullscreen(global.settings.fullscreen);
}

function handle_smoothing_mode(){
	gpu_set_texfilter(global.settings.smoothing_mode);
}

function handle_sub_categories(_category){
	switch(_category){
		case "skin":
			handle_settings_skin();
			break;
		case "item":
			handle_settings_item();
			break;
		case "inventory":
			handle_settings_inventory();
			break;
		case "swap_items_with_number_keys":
			handle_settings_swap_items_with_number_keys();
			break;
		case "backstep":
			handle_settings_backstep();
			break;
			
			
		case "master_volume":
			handle_settings_master_volume();
			break;
		case "music_volume":
			handle_settings_music_volume();
			break;
		case "effect_volume":
			handle_settings_effect_volume();
			break;
		case "fps_sync":
			handle_settings_fps_sync();
			break;
				
				
		case "Jump":
		case "Shoot":
		case "UP":
		case "Down":
		case "Right":
		case "Left":
		case "Save":
		case "Load":
		case "Item Swap":
			handle_settings_keyboard_controls();
			break;
				
				
		case "fullscreen":
			handle_settings_fullscreen();
			break;
		case "smoothing_mode":
			handle_settings_smoothing_mode();
			break;
			
			
		case "back_to_title":
			handle_settings_back_to_title();
			break;
			
			
		case "quit_game":
			game_end();
			break;
	}
}

function handle_settings(){
	if(global.no_pause){
		return;
	}
	
	var _flag = !simple_pause &&
				keyboard_check_pressed(global.key_config.setting) &&
				!settings_keyboard_controls_skip_key_action;
				
	if(_flag){
		
		if(!global.game_paused && settings_master_alpha == 0 && surface_exists(application_surface)){
		
			if(global.in_game){
				
				if(!directory_exists("SnapShot")){
					directory_create("SnapShot");
				}
		
				var _w = surface_get_width(application_surface);
				var _h = surface_get_height(application_surface);
				var _surf = surface_create(_w, _h);
				surface_set_target(_surf);
				draw_clear_alpha(c_black, 0);
				var _res = shader_get_uniform(sh_snapshot, "iResolution");
				shader_set(sh_snapshot);
				shader_set_uniform_f(_res, _w, _h);
				draw_surface(application_surface, 0, 0);
				shader_reset();
				surface_reset_target();
		
				surface_save(_surf, "SnapShot\\SnapShot" + string(global.savedata_index) + ".png");
			}
			/* Save a snapshot before entering the settings screen.
			(Since the player can either exit the game or return to the title screen from the settings,
			we need to save a snapshot for the data selection screen.) */
			
			settings_row_index = 0;
			
			var _flag1 = !ENABLE_SKIN && !ENABLE_ITEM_AND_INVENTORY && !ENABLE_PLAYER_BACKSTEP;
			var _flag2 = !ENABLE_ACHIEVEMENT;
			
			if(_flag1 && _flag2){
				settings_row_index = 2;
			}
			else if(_flag1){
				settings_row_index = 1;
			}
			
			settings_column_index = 0;
			is_settings_row_index_selected = false;
			settings_is_key_selected = false;
			global.game_paused = true;
			on_setting = true;
		
			var _w = surface_get_width(application_surface);
			var _h = surface_get_height(application_surface);
			var _pause_surf = surface_create(_w, _h);
			surface_set_target(_pause_surf);
			draw_clear_alpha(c_black, 0);
			var _res = shader_get_uniform(sh_snapshot, "iResolution");
			shader_set(sh_snapshot);
			shader_set_uniform_f(_res, _w, _h);
			draw_surface(application_surface, 0, 0);
			shader_reset();
			surface_reset_target();
			
			pause_sprite = sprite_create_from_surface(_pause_surf, 0, 0, DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT, false, true, 0, 0);
			
			surface_free(_pause_surf);
			
			instance_deactivate_all(true);
		}
		else if(settings_master_alpha == 1){
			instance_activate_all();
			
			settings_item_index = 0;
			settings_inventory_index = 0;
			
			settings_skin_ui_anim_time = 0;
			settings_item_ui_anim_time = 0;
			settings_inventory_ui_anim_time = 0;
			
			global.game_paused = false;
			on_setting = false;
			sprite_delete(pause_sprite);
			
			if(instance_exists(obj_player)){
				with(obj_player){
					handle_skin();
				}
			}
			
		}
	}
	
	if(!(global.game_paused && on_setting && !simple_pause)){
		return;
	}
	
	if(is_settings_row_index_selected){
		var _row = settings_row_index;
		var _column = settings_column_index;
	
		handle_sub_categories(settings_array_of_index[_row][_column]);
	}
	
	if(settings_keyboard_controls_skip_key_action){
		return;
	}
	
	// Control the general key actions of settings screen
	
	if(keyboard_check_pressed(vk_shift)){
		if(!is_settings_row_index_selected){
			is_settings_row_index_selected = true;
		}
	}
	
	
	if(keyboard_check_pressed(ord("Z"))){
		if(is_settings_row_index_selected){
			settings_column_index = 0;
			is_settings_row_index_selected = false;
		}
	}
	
	if(!is_settings_row_index_selected){
		var _len = array_length(settings_array_of_index);
		if(keyboard_check_pressed(vk_down)){
			settings_row_index = settings_row_index + 1 < _len ? settings_row_index + 1 : 0;
			
			while(array_length(settings_array_of_index[settings_row_index]) < 1){
				settings_row_index = settings_row_index + 1 < _len ? settings_row_index + 1 : 0;
				// If the next category's array is empty, go next index. 
			}
		}
		else if(keyboard_check_pressed(vk_up)){
			settings_row_index = settings_row_index - 1 < 0 ? _len - 1 : settings_row_index - 1;
			
			while(array_length(settings_array_of_index[settings_row_index]) < 1){
				settings_row_index = settings_row_index - 1 < 0 ? _len - 1 : settings_row_index - 1;
				// If the previous category's array is empty, go previous index. 
			}
		}
	}
	else{
		if(keyboard_check_pressed(vk_down)){
			var _len = array_length(settings_array_of_index[settings_row_index]);
			settings_column_index = settings_column_index + 1 < _len ? settings_column_index + 1 : 0;
			settings_is_key_selected = false;
		}
		else if(keyboard_check_pressed(vk_up)){
			var _len = array_length(settings_array_of_index[settings_row_index]);
			settings_column_index = settings_column_index - 1 < 0 ? _len - 1 : settings_column_index - 1;
			settings_is_key_selected = false;
		}
		
		_flag = instance_exists(obj_world_item_ui) &&
				keyboard_check_pressed(vk_down) || 
				keyboard_check_pressed(vk_up);
				
		if(_flag){
			settings_skin_ui_anim_time = 0;
			settings_item_ui_anim_time = 0;
			settings_inventory_ui_anim_time = 0;
		}
	}
	
	if(settings_row_index != 0){
		with(obj_world_skin_ui){
			instance_destroy();
		}
		
		with(obj_world_item_ui){
			instance_destroy();
		}
		
		with(obj_world_inventory_ui){
			instance_destroy();
		}
	}
	
	if(settings_row_index != 1){
		with(obj_world_achievement_ui){
			instance_destroy();
		}
	}
	
}