/// @description BoxKill
function handle_stucking_in_block(){
	var _col1 = place_meeting(x, y, obj_block);
	var _col2 = place_meeting(old_x, old_y, obj_block);
	
	if(_col1 && _col2){
		play_sound(snd_break, 0);
		sprite_index = spr_noone;
		box_kill = true;
	}
}

function initialize_box_kill_effect(){
	if(box_kill_initialized){
		return;	
	}
	
	surf_list = [];

	repeat(4){
		array_push(surf_list, surface_create(sprite_width / 2, sprite_height / 2));
	}

	surf_pos_list = [];
	surf_spd_list = [];
	surf_start_xscale = image_xscale;
	surf_start_yscale = image_yscale;
	surf_start_angle = image_angle;
	surf_start_alpha = image_alpha;
	surf_alpha = surf_start_alpha;
	surf_anim_time = 0;

	var _index = 0;
	
	randomize();
	
	var _xoffset = sprite_get_xoffset(surf_sprite) * image_xscale;
	var _yoffset = sprite_get_yoffset(surf_sprite) * image_yscale;
	var _horizontal_xoffset = lengthdir_x(_xoffset, image_angle);
	var _vertical_xoffset = lengthdir_y(_xoffset, image_angle);
	var _horizontal_yoffset = lengthdir_x(_yoffset, image_angle - 90);
	var _vertical_yoffset = lengthdir_y(_yoffset, image_angle - 90);
			
	var _width = sprite_width / 2;
	var _height = sprite_height / 2; 
	var _horizontal_width = lengthdir_x(_width, image_angle);
	var _vertical_width = lengthdir_y(_width, image_angle);
	var _horizontal_height = lengthdir_x(_height, image_angle - 90);
	var _vertical_height = lengthdir_y(_height, image_angle - 90);
	
	for(var _i = 0; _i < 2; _i++){
		for(var _j = 0; _j < 2; _j++){
			array_push(surf_pos_list, {
				x : other.x - _horizontal_xoffset - _horizontal_yoffset + _i * _horizontal_width + _j * _horizontal_height, 
				y : other.y - _vertical_xoffset - _vertical_yoffset + _i * _vertical_width + _j * _vertical_height
			});
		
			var _hspd = _i > 0 ? random_range(2, 1) : random_range(-1, -2);
			var _vspd = _j > 0 ? random_range(1, 2) : random_range(-1, -2);
		
			array_push(surf_spd_list, {
				hspd : _hspd,
				vspd : _vspd,
			});
		
			surface_set_target(surf_list[_index]);
			
			var _left = _i * sprite_get_width(surf_sprite) / 2;
			var _top = _j * sprite_get_height(surf_sprite) / 2;
			
			draw_sprite_part_ext(surf_sprite, image_index, _left, _top, sprite_get_width(surf_sprite) / 2, sprite_get_height(surf_sprite) / 2, 0, 0, image_xscale, image_yscale, c_white, 1);
			
			surface_reset_target();
			
			_index++;
		}
	}
	
	box_kill_initialized = true;
}

function handle_box_kill_effect(){
	if(surf_anim_time > 1){
		for(var _i = 0; _i < 4; _i++){
			if(surface_exists(surf_list[_i])){
				surface_free(surf_list[_i]);
			}
		}
		return;
	}
	
	for(var _i = 0; _i < array_length(surf_list); _i++){
		if(!surface_exists(surf_list[_i])){
			box_kill_initialized = false;
			initialize_box_kill_effect();
		}
	}
	
	if(surf_anim_time < 1){
		surf_anim_time += 0.03;
	}
	
	var _channel = animcurve_get_channel(ac_fade_out2, 0);
	var _amount = animcurve_channel_evaluate(_channel, surf_anim_time);
	
	surf_alpha = _amount * surf_start_alpha;
	
	for(var _i = 0; _i < 4; _i++){
		if(surf_pos_list[_i].x < 0 || 
		   surf_pos_list[_i].x > room_width || 
		   surf_pos_list[_i].y < 0 || 
		   surf_pos_list[_i].y > room_height){
			continue;
		}

		draw_surface_ext(surf_list[_i], surf_pos_list[_i].x, surf_pos_list[_i].y, _amount, _amount, surf_start_angle, c_white, surf_alpha);
		
		surf_vspd += 0.1;
		
		var _horizontal_hspd = lengthdir_x(surf_spd_list[_i].hspd, surf_start_angle);
		var _vertical_hspd = lengthdir_y(surf_spd_list[_i].hspd, surf_start_angle);
		var _horizontal_vspd = lengthdir_x(surf_spd_list[_i].vspd, surf_start_angle - 90);
		var _vertical_vspd = lengthdir_y(surf_spd_list[_i].vspd, surf_start_angle - 90);
		
		surf_pos_list[_i].x += _horizontal_hspd + _horizontal_vspd;
		surf_pos_list[_i].y += _vertical_hspd + _vertical_vspd + surf_vspd;
	}
}