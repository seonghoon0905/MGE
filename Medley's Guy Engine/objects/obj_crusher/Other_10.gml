/// @description local library
function handle_respawning_mode(){
	if(keyboard_check_pressed(global.key_config.load)){
		x = xstart;
		y = ystart;
		hspd = 0;
		vspd = 0;
		is_crusher_moving = false;
		frozen_time = frozen_time_limit;	
	}
}

function find_player(){
	if(!instance_exists(obj_player) || global.game_over){
		return;
	}
	
	if(!is_crusher_moving && frozen_time < frozen_time_limit){
		frozen_time++;
	}
	
	if(is_crusher_moving || frozen_time < frozen_time_limit){
		return;
	}
	
	var _is_there_block_between_us = false;
	
	if(collision_line(x, y, obj_player.x, obj_player.y, obj_block, true, true) != noone){
		_is_there_block_between_us = true;
	}
	
	
	if(!_is_there_block_between_us){
		var _normal1 = {
			x : lengthdir_x(1, 0),
			y : lengthdir_y(1, 0)
		}
		
		var _normal2 = {
			x : other.x - obj_player.x,
			y : other.y - obj_player.y
		}
	
		var _go_horizontally = false;
		var _go_vertically = false;
		
		var _player_points;
	
		with(obj_player){
			_player_points = get_player_points();
		}
		
		var _names = struct_get_names(_player_points);
	
		
		for(var _i = 0; _i < array_length(_names); _i++){
			var _x = _player_points[$ _names[_i]].x;
			var _y = _player_points[$ _names[_i]].y;
			
			if(_x >= bbox_left && _x <= bbox_right){
				_go_vertically = true;
				break;
			}
			
			if(_y <= bbox_bottom && _y >= bbox_top){
				_go_horizontally = true;
				break;
			}
		}
		
		if(_go_vertically){
			if(cross(_normal1, _normal2) > 0){
				vspd = -max_spd;
				is_crusher_moving = true;
				frozen_time = 0;
			}
			else if(cross(_normal1, _normal2) < 0){
				vspd = max_spd;	
				is_crusher_moving = true;
				frozen_time = 0;
			}
		}
		else if(_go_horizontally){	
			if(dot(_normal1, _normal2) > 0){
				hspd = -max_spd;
				is_crusher_moving = true;
				frozen_time = 0;
			}
			else if(dot(_normal1, _normal2) < 0){
				hspd = max_spd;	
				is_crusher_moving = true;
				frozen_time = 0;
			}
		}
	}
	else{
		hspd = 0;
		vspd = 0;
	}
}

function go_to_player(){
	if(!place_meeting(x + hspd, y + vspd, obj_block)){
		x += hspd;
		y += vspd;
		return;
	}
	
	if(place_meeting(x + hspd, y, obj_block)){
		var _dir = hspd > 0 ? 0 : 180;
		move_contact(_dir, abs(hspd), obj_block);
		is_crusher_moving = false;
		hspd = 0;
	}
	
	if(place_meeting(x, y + vspd, obj_block)){
		var _dir = vspd > 0 ? 270 : 90;
		move_contact(_dir, abs(vspd), obj_block);
		is_crusher_moving = false;
		vspd = 0;
	}
	
	x += hspd;
	y += vspd;
}
