/// @description Saving & Loading Datas
function load_settings_and_key_config_data(){
	if(load_json("Settings") != undefined){
		global.settings = load_json("Settings");
		global.game_paused = false;
	}
	if(load_json("KeyConfig") != undefined){
		global.key_config = load_json("KeyConfig");
	}
}

function save_settings_and_key_config_data(){
	save_json(global.settings, "Settings");
	save_json(global.key_config, "KeyConfig");
}

function handle_data_selection(){
	if(!instance_exists(obj_data_selection_ui_manager)){
		return;
	}
	
	if(global.game_paused){
		return;
	}
	
	if(!obj_title_ui_manager.data_deleting_pause){
		if(keyboard_check_pressed(vk_right)){
			var _index = global.savedata_index;
			global.savedata_index = _index < DATA_SLOT - 1 ? _index + 1 : 0;
		
			obj_data_selection_ui_manager.animation_value = 0;
		
			obj_title_ui_manager.data_selection_other_data = load_other_player_data();
			
			if(obj_title_ui_manager.data_selection_other_data == undefined){
				obj_title_ui_manager.data_selection_death_count = 0;
			}
			else{
				var _death_count = obj_title_ui_manager.data_selection_other_data.death_count;
				obj_title_ui_manager.data_selection_death_count = _death_count;
			}
			
			if(obj_title_ui_manager.data_selection_other_data == undefined){
				obj_title_ui_manager.data_selection_time = 0;
			}
			else{
				var _time = obj_title_ui_manager.data_selection_other_data.time;
				obj_title_ui_manager.data_selection_time = _time;
			}
		}
		else if(keyboard_check_pressed(vk_left)){
			var _index = global.savedata_index;
			global.savedata_index = _index > 0 ? _index - 1 : DATA_SLOT - 1;
		
			obj_data_selection_ui_manager.animation_value = 0;
		
			obj_title_ui_manager.data_selection_other_data = load_other_player_data();
			
			if(obj_title_ui_manager.data_selection_other_data == undefined){
				obj_title_ui_manager.data_selection_death_count = 0;
			}
			else{
				var _death_count = obj_title_ui_manager.data_selection_other_data.death_count;
				obj_title_ui_manager.data_selection_death_count = _death_count;
			}
			
			if(obj_title_ui_manager.data_selection_other_data == undefined){
				obj_title_ui_manager.data_selection_time = 0;
			}
			else{
				var _time = obj_title_ui_manager.data_selection_other_data.time;
				obj_title_ui_manager.data_selection_time = _time;
			}
		}
	}
	
	if(!obj_title_ui_manager.data_deleting_pause && keyboard_check_pressed(vk_shift)){
		global.in_game = true;
		
		achievement_index = 0;
		
		if(load_player_data() != undefined){
			global.player_data = load_player_data();
		}
		
		if(load_other_player_data() != undefined){
			global.other_player_data = load_other_player_data();
		}
		
		settings_skin_index = global.other_player_data.skin_index;
		
		apply_macros_to_datas();
		
		apply_player_data();

		var _room = global.player_data.room == undefined ? STARTING_ROOM : global.player_data.room;
		room_goto(_room);
	}
	
	if(keyboard_check_pressed(vk_delete)){
		obj_title_ui_manager.data_deleting_pause = true;
	}
	
	if(obj_title_ui_manager.data_deleting_pause){
		if(keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_left)){
			obj_title_ui_manager.can_delete_data = !obj_title_ui_manager.can_delete_data;
		}
		
		if(obj_title_ui_manager.can_delete_data && keyboard_check_pressed(vk_shift)){
			
			if(obj_data_selection_ui_manager.snapshot[global.savedata_index] != undefined){
				sprite_delete(obj_data_selection_ui_manager.snapshot[global.savedata_index]);
				obj_data_selection_ui_manager.snapshot[global.savedata_index] = undefined;
				file_delete("SnapShot\\SnapShot" + string(global.savedata_index) + ".png");
			}
			
			obj_title_ui_manager.can_delete_data = false;
			obj_title_ui_manager.data_deleting_pause = false;
			
			refresh_global_player_data();
			refresh_global_other_player_data();
		
			play_sound(snd_death, 0);
		
			save_json_encrypted(global.player_data, string("PlayerData\\PlayerData{0}.sav", global.savedata_index));
			save_json_encrypted(global.other_player_data, string("OtherPlayerData\\OtherPlayerData{0}.sav", global.savedata_index));
			
			obj_data_selection_ui_manager.time_list[global.savedata_index] = 0;
			obj_data_selection_ui_manager.death_list[global.savedata_index] = 0;
			
			obj_title_ui_manager.data_selection_other_data = undefined;
			obj_title_ui_manager.data_selection_death_count = 0;
			obj_title_ui_manager.data_selection_time = 0;
		}
		else if(!obj_title_ui_manager.can_delete_data && keyboard_check_pressed(vk_shift)){
			obj_title_ui_manager.can_delete_data = false;
			obj_title_ui_manager.data_deleting_pause = false;
		}
	}
}

function handle_player_spawning(){
	if(!instance_exists(obj_player_start)){
		return;
	}

	var _x = obj_player_start.x + 17;
	var _y = obj_player_start.y + 23;

	if(room != global.player_data.room){
		var _inst = instance_create_layer(_x, _y, layer_get_id("Player"), obj_player);
		
		if(global.player_data.room == undefined){
			global.player_data.x = _x;
			global.player_data.y = _y;
			global.player_data.room = room;
			save_player_data(false);
		}
		else if(global.warp.room != undefined && global.warp.x != undefined && global.warp.y != undefined){
			_inst.x = global.warp.x;
			_inst.y = global.warp.y;
		}
		
		apply_player_data(_inst);
	}
	else{
		var _inst;
		if(global.warp.room != undefined && (global.warp.x == undefined || global.warp.y == undefined)){
			_inst = instance_create_layer(_x, _y, layer_get_id("Player"), obj_player);
		}
		else if(global.warp.room != undefined && global.warp.x != undefined && global.warp.y != undefined){
			_inst = instance_create_layer(global.warp.x, global.warp.y, layer_get_id("Player"), obj_player);
		}
		else{
			_inst = instance_create_layer(global.player_data.x, global.player_data.y, layer_get_id("Player"), obj_player);
		}
		
		apply_player_data(_inst);
	}
	
	global.warp.room = undefined;
	global.warp.x = undefined;
	global.warp.y = undefined;
}


function handle_player_respawning(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(keyboard_check_pressed(global.key_config.load)){
		if(!ENABLE_RESPAWNING_WITH_ROOM_RESTART){
			instance_destroy(obj_player);
			global.game_over = false;
		
			if(room != global.player_data.room){
				room_goto(global.player_data.room);
			}
			else{
				var _x = obj_player_start.x + 17;
				var _y = obj_player_start.y + 23;
				var _inst = instance_create_layer(_x, _y, layer_get_id("Player"), obj_player);
		
				_inst.x = global.player_data.x;
				_inst.y = global.player_data.y;
		
				apply_player_data(_inst);
			}
		}
		else{
			if(room != global.player_data.room){
				room_goto(global.player_data.room);
			}
			else{
				room_restart();
			}
		}
	}
}