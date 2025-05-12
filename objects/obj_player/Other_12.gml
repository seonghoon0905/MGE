/// @description PlayerDeath
function handle_touching_player_killer(){
	if(global.debug_config.god_mode){
		var _epsilon = 0.01;
		
		var _flag = !debug_player_death &&
					place_meeting(x, y, obj_killer_parent) && 
					alpha > 1 - _epsilon;
					
		if(_flag){
			play_sound(snd_death, 0);
			debug_player_death = true;
		}
		
		return;
	}
	
	if(!global.game_over && place_meeting(x, y, obj_killer_parent)){
		play_sound(snd_death, 0);
		global.game_over = true;
		global.other_player_data.death_count++;
	}
}

function handle_stucking_in_block(){
	var _col1 = place_meeting(x, y, obj_block);
	var _col2 = place_meeting(old_x, old_y, obj_block);

	if(global.debug_config.god_mode){
		var _epsilon = 0.01;
		if(!debug_player_death && _col1 && _col2 && alpha > 1 - _epsilon){
			play_sound(snd_death, 0);
			debug_player_death = true;
		}
	
		return;
	}
		
	if(!global.game_over && _col1 && _col2){
		play_sound(snd_death, 0);
		
		if(!global.game_over && panda_anim_time < panda_anim_time_limit){
			global.player.screen_rotated = global.player.screen_rotated ? false : true;
		}
		
		global.game_over = true;
		global.other_player_data.death_count++;
	}
}

function kill_player_in_posion_water(){
	if(!global.game_over && poison_water_time >= poison_water_time_limit){
		play_sound(snd_death, 0);
		poison_water_time = 0;
		
		if(global.debug_config.god_mode){
			if(!debug_player_death){
				debug_player_death = true;
			}
			return;
		}
		
		global.game_over = true;
		global.other_player_data.death_count++;
	}
}

function kill_player_on_border(){
	if(!KILL_PLAYER_ON_BORDER){
		return;
	}
	
	if(global.game_over){
		return;
	}
	
	var _flag = x < 0 ||
				x > room_width ||
				y < 0 ||
				y > room_height;
	
	var _epsilon = 0.01;
	
	if(_flag){
		if(global.debug_config.god_mode){
			if(!debug_player_death && alpha > 1 - _epsilon){
				play_sound(snd_death, 0);
				debug_player_death = true;
			}
			
			return;
		}
		
		play_sound(snd_death, 0);
		global.game_over = true;
		global.other_player_data.death_count++;
	}
}

function handle_game_over_effect(){
	if(global.debug_config.god_mode){
		var _latency = 5;
		alpha += (!debug_player_death - alpha) / _latency;
		alpha = clamp(0.2, alpha, 1);
		
		if(alpha == 0.2){
			debug_player_death = false;
		}
		
		return;
	}
	
	if(global.game_over){
		alpha = max(0.1, alpha - 0.1);
		image_speed = 0;
	}
}

function handle_player_death(){
	handle_touching_player_killer();
	handle_stucking_in_block();
	kill_player_in_posion_water();
	kill_player_on_border();
	handle_game_over_effect();
}