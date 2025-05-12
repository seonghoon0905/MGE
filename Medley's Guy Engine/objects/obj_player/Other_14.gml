/// @description Drawing
function handle_default_skin(){
	switch(global.other_player_data.skins[global.other_player_data.skin_index]){
		case "standard":
			skin = {
				idle : spr_standard_idle,
				run : spr_standard_run,
				jump : spr_standard_jump,
				fall : spr_standard_fall,
				slide : spr_standard_slide,
				climb_horizontal : spr_standard_climb_horizontal,
				climb_vertical : spr_standard_climb_vertical,
				climb : spr_standard_climb
			}
			break;
		case "crimson":
			skin = {
				idle : spr_crimson_idle,
				run : spr_crimson_run,
				jump : spr_crimson_jump,
				fall : spr_crimson_fall,
				slide : spr_crimson_slide,
				climb_horizontal : spr_crimson_climb_horizontal,
				climb_vertical : spr_crimson_climb_vertical,
				climb : spr_crimson_climb
			}
			break;
		case "round":
			skin = {
				idle : spr_round_idle,
				run : spr_round_run,
				jump : spr_round_jump,
				fall : spr_round_fall,
				slide : spr_round_slide,
				climb_horizontal : spr_round_climb_horizontal,
				climb_vertical : spr_round_climb_vertical,
				climb : spr_round_climb
			}
			break;
	}
}

function handle_skin(){
	switch(global.player.kid_mode){
		case "dotkid":
			skin = spr_dotkid;
			break;
		case "telekid":
			skin = {
				idle : spr_telekid_idle,
				run : spr_telekid_run,
				jump : spr_telekid_jump,
				fall : spr_telekid_fall,
				slide : spr_telekid_slide,
				climb_horizontal : spr_telekid_climb_horizontal,
				climb_vertical : spr_telekid_climb_vertical,
				climb : spr_telekid_climb
			}
			break;
		case "vkid":
			skin = {
				idle : spr_vkid_idle,
				run : spr_vkid_run,
				jump : spr_vkid_jump,
				fall : spr_vkid_fall,
				slide : spr_vkid_slide,
				climb_horizontal : spr_vkid_climb_horizontal,
				climb_vertical : spr_vkid_climb_vertical,
				climb : spr_vkid_climb
			}
			break;
		case "default": 
			handle_default_skin();
			break;
	}
}

function get_player_points(){ 
	var _left = global.player.gravity_dir >= 180 ? -5 : -4;
	var _right = global.player.gravity_dir >= 180 ? 5 : 6;
	var _top = (global.player.gravity_dir > 0 && global.player.gravity_dir <= 180) ? -11 : -13;
	var _bottom = (global.player.gravity_dir > 0 && global.player.gravity_dir <= 180) ? 9 : 7;
	
	_left *= abs(global.player.xscale);
	_right *= abs(global.player.xscale);
	_top *= global.player.yscale;
	_bottom *= global.player.yscale;
	
	var _top_left = {x : _left, y : _top};
	var _top_right = {x : _right, y : _top};
	var _bottom_right = {x : _right, y : _bottom};
	var _bottom_left = {x : _left, y : _bottom};
	
	var _dir = -angle_difference(270, global.player.gravity_dir);
	
	_top_left = rotate2d(_top_left, _dir);
	_top_right = rotate2d(_top_right, _dir);
	_bottom_right = rotate2d(_bottom_right, _dir);
	_bottom_left = rotate2d(_bottom_left, _dir);
	
	return{
		top_left : {x : x + _top_left.x, y : y + _top_left.y},
		top_right : {x : x + _top_right.x, y : y + _top_right.y},
		bottom_right : {x : x + _bottom_right.x, y : y + _bottom_right.y},
		bottom_left : {x : x + _bottom_left.x, y : y + _bottom_left.y}
	}
}

function raycast(_src_x, _src_y, _len){
	var _dir = global.player.gravity_dir;
	var _dest_x, _dest_y;
	var _is_start = true;
	var _gap = _len;
	var _epsilon = 0.01;
	
	while(true){
		_dest_x = _src_x + lengthdir_x(_len, _dir);
		_dest_y = _src_y + lengthdir_y(_len, _dir);
		var _col = collision_line(_src_x, _src_y, _dest_x, _dest_y, [obj_block, obj_platform], true, false);
		_gap = _gap / 2;
		if(_gap < _epsilon){
			break;
		}
		if(_col == noone){
			if(_is_start){
				return undefined;
			}
			_len += _gap;
		}
		else{
			_len -= _gap;
		}
		_is_start = false;
	}
	
	return {
		src : {x : _src_x, y : _src_y},
		dest : {x : _dest_x, y : _dest_y},
		dist : point_distance(_src_x, _src_y, _dest_x, _dest_y)
	};
}


function handle_rays(){
	var _points = get_player_points();
	r1 = raycast(_points.bottom_right.x, _points.bottom_right.y, min_distance);
	r2 = raycast(_points.bottom_left.x, _points.bottom_left.y, min_distance);
}


function handle_draw_angle(){
	var _angle = global.player.gravity_dir - 270;
	
	if(ENABLE_SLOPE_ANIMATION){
		var _dx = lengthdir_x(1, global.player.gravity_dir);
		var _dy = lengthdir_y(1, global.player.gravity_dir);
	
		if(place_meeting(x + _dx, y + _dy, obj_slope)){
			handle_rays();
		
			if(r1 != undefined && r2 != undefined){
				var _v1 = {
					x : r1.dest.x - r2.dest.x,
					y : r1.dest.y - r2.dest.y,
					z : 0
				}
		
				var _v2 = {
					x : lengthdir_x(1, global.player.gravity_dir),
					y : lengthdir_y(1, global.player.gravity_dir),
					z : 0
				}
		
				var _v = triple_product(_v1, _v2, _v1);
		
				_angle = point_direction(0, 0, _v.x, _v.y) - 270;
			
			}
		}
	}
	
	if(!no_draw_angle_animation){
		var _latency = 3;
		var _dir_diff = angle_difference(draw_angle, _angle);
		draw_angle = lerp(draw_angle,draw_angle - _dir_diff, 1 / _latency);
	}
	else{
		draw_angle = _angle;
		no_draw_angle_animation = false;
	}
}

function handle_image_scale(){
	if(frozen){
		return;
	}
	
	var _button_right = false;
	var _button_left = false;
	
	if(!global.player.screen_rotated){
		_button_right = keyboard_check(global.key_config.right);
		_button_left = keyboard_check(global.key_config.left);
	}
	else{
		_button_right = keyboard_check(global.key_config.left);
		_button_left = keyboard_check(global.key_config.right);
	}
	
	var _sign_adjust = floor(global.player.gravity_dir / 180) % 2 == 1 ? 1 : -1;
	_sign_adjust = global.player.gravity_dir == 0 ? 1 : _sign_adjust;
	
	var _abs_xscale = abs(global.player.xscale);
	
	if(_button_right && _button_left && (global.settings.backstep || ENABLE_PLAYER_BACKSTEP_FOREVER)){
		global.player.xscale = -_abs_xscale * backstep_sign;
	}
	else if(!global.player.screen_rotated && (_button_right || _button_left)){
		if(_button_right){
			global.player.xscale = _abs_xscale * _sign_adjust;
		}
		else if(_button_left){
			global.player.xscale = -_abs_xscale * _sign_adjust;
		}
	}
	else if(global.player.screen_rotated && (_button_right || _button_left)){
		if(_button_left){
			global.player.xscale = -_abs_xscale * _sign_adjust;
		}
		else if(_button_right){
			global.player.xscale = _abs_xscale * _sign_adjust;
		}
	}
	
	image_xscale = _abs_xscale;
	image_yscale = global.player.yscale;
}

function handle_dotkid_indicator(){
	if(global.player.kid_mode != "dotkid"){
		return;
	}
	
	if(enable_dotkid_indicator){
		var _w = 128;
		var _h = 128;
		shader_set(sh_dotkid_indicator);
		var _res = shader_get_uniform(sh_dotkid_indicator, "iResolution");
		var _pos = shader_get_uniform(sh_dotkid_indicator, "pos");
		shader_set_uniform_f(_res, _w, _h, 0);
		shader_set_uniform_f(_pos, x - _w / 2, y - _h / 2);
		draw_rectangle(x - _w / 2, y - _h / 2, x + _w / 2, y + _h / 2, false);
		shader_reset();
	}
}

function handle_skin_changing_sfx(){
	if(skin_changing_sfx_start){
		var _amount = skin_changing_sfx_value / skin_changing_sfx_value_limit;
		var _size = lerp(1, 2, _amount);
		var _alpha = lerp(1, 0, _amount);
		draw_sprite_ext(sprite_index, image_index, x, y, _size * sign(global.player.xscale), _size, 0, c_white, _alpha);
		
		if(skin_changing_sfx_value < skin_changing_sfx_value_limit){
			skin_changing_sfx_value++;
		}
		else{
			skin_changing_sfx_value = 0;
			skin_changing_sfx_start = false;
		}
	}
}

function draw_poison_water_time(){
	var _horizontal_dx = lengthdir_x(20, global.player.gravity_dir - 90);
	var _horizontal_dy = lengthdir_y(20, global.player.gravity_dir - 90);
	var _vertical_dx = lengthdir_x(22, global.player.gravity_dir - 180);
	var _vertical_dy = lengthdir_y(22, global.player.gravity_dir - 180);
	var _x = x + _horizontal_dx + _vertical_dx;
	var _y = y + _horizontal_dy + _vertical_dy;
	var _angle = global.player.gravity_dir - 270;
	var _latency = 4;
	var _meet = water_id != noone && water_id.object_index == obj_poison_water && !global.game_over;
	poison_water_time_alpha += (_meet - poison_water_time_alpha) / _latency;
	
	var _xscale = lerp(1, 0, poison_water_time / poison_water_time_limit);
	
	var _color = merge_color(c_blue, c_red, 1 - _xscale);
	if(!global.game_over){
		draw_sprite_ext(spr_poison_water_time, 1, _x, _y, _xscale * abs(global.player.xscale), global.player.yscale, _angle, _color, poison_water_time_alpha);
	}
	
	draw_sprite_ext(spr_poison_water_time, 0, _x, _y, abs(global.player.xscale), global.player.yscale, _angle, c_white, poison_water_time_alpha);
}

function handle_general_sprites(){
	sprite_index = skin.idle;
	
	var _button_right = false;
	var _button_left = false;
	
	if(!global.player.screen_rotated){
		_button_right = keyboard_check(global.key_config.right);
		_button_left = keyboard_check(global.key_config.left);
	}
	else{
		_button_right = keyboard_check(global.key_config.left);
		_button_left = keyboard_check(global.key_config.right);
	}
	
	var _on_ground = on_block || platform_id != noone;

	if(!frozen && _on_ground && (_button_right || _button_left)){
		sprite_index = skin.run;
	}
	else if(!_on_ground){
		if(vspd < -0.05){
			sprite_index = skin.jump;
		}
		else if(vspd > 0.05){
			sprite_index = skin.fall;
		}
	}
	
	if(!on_block){
		if(touching_walljump){
			sprite_index = skin.slide;
		}
	}
	
	var _button_up = keyboard_check(global.key_config.up);
	var _button_down = keyboard_check(global.key_config.down);
	
	if(on_ladder){
		sprite_index = skin.climb;
		if(_button_up || _button_down){
			sprite_index = skin.climb_vertical;
		}
		else if(_button_right || _button_left){
			sprite_index = skin.climb_horizontal;
		}
	}
}

function handle_sprites(){
	if(global.game_over){
		image_speed = 0;
		return;
	}
	
	if(skin == undefined){
		handle_skin();
	}
	
	handle_draw_angle();
	
	if(screen_rotate_anim_time < screen_rotate_anim_time_limit){
		image_speed = 0;
		return;
	}
	else{
		image_speed = 1;
	}
	
	
	if(panda_anim_time < panda_anim_time_limit){
		image_speed = 0;
		return;
	}
	else{
		image_speed = 1;
	}
	
	handle_image_scale();
	
	if(global.player.kid_mode == "dotkid"){
		sprite_index = skin;
	}
	else{
		handle_general_sprites();
	}
}

function draw_descendable_platform_info(){
	var _latency = 4;
	var _message_on = platform_id != noone && platform_id.descendable && platform_id.help_message;
					  
	descendable_platform_message_alpha += (_message_on - descendable_platform_message_alpha) / _latency;	
	
	var _epsilon = 0.01;
	
	if(descendable_platform_message_alpha < _epsilon){
		return;
	}
	var _horizontal_dx = lengthdir_x(20, global.player.gravity_dir - 90);
	var _horizontal_dy = lengthdir_y(20, global.player.gravity_dir - 90);
	var _vertical_dx = lengthdir_x(24 * global.player.yscale, global.player.gravity_dir - 180);
	var _vertical_dy = lengthdir_y(24 * global.player.yscale, global.player.gravity_dir - 180);
	var _x = x + _vertical_dx;
	var _y = y + _vertical_dy;
	var _angle = global.player.gravity_dir - 270;
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fnt_serif_bold_24);
	
	var _sc = 11 / 24;
	var _alpha = descendable_platform_message_alpha * 0.8;
	draw_text_transformed_color(_x + 1, _y, "Press down to descend", _sc, _sc, _angle, c_black, c_black, c_black, c_black, _alpha);
	draw_text_transformed_color(_x, _y + 1, "Press down to descend", _sc, _sc, _angle, c_black, c_black, c_black, c_black, _alpha);
	draw_text_transformed_color(_x - 1, _y, "Press down to descend", _sc, _sc, _angle, c_black, c_black, c_black, c_black, _alpha);
	draw_text_transformed_color(_x, _y - 1, "Press down to descend", _sc, _sc, _angle, c_black, c_black, c_black, c_black, _alpha);

	draw_text_transformed_color(_x, _y, "Press down to descend", _sc, _sc, _angle, c_white, c_white, c_white, c_white, _alpha);
}

function draw_panda_info(){
	var _latency = 4;
	var _message_on = panda_block_id != noone && panda_anim_time >= panda_anim_time_limit;
	panda_message_alpha += (_message_on - panda_message_alpha) / _latency;
	var _epsilon = 0.01;
	
	if(panda_message_alpha < _epsilon){
		return;
	}
	
	var _vertical_dx = lengthdir_x(24 * global.player.yscale, global.player.gravity_dir - 180);
	var _vertical_dy = lengthdir_y(24 * global.player.yscale, global.player.gravity_dir - 180);
	var _x = x + _vertical_dx;
	var _y = y + _vertical_dy;
	var _angle = global.player.screen_rotated ? 180 : 0;
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle)
	draw_set_font(fnt_serif_bold_24);
	
	var _sc = 11 / 24;
	var _col = global.player.screen_rotated ? c_white : c_black;
	var _alpha = panda_message_alpha * 0.8;
	draw_text_transformed_color(_x + 1, _y, "Press down to flip", _sc, _sc, _angle, _col, _col, _col, _col, _alpha);
	draw_text_transformed_color(_x, _y + 1, "Press down to flip", _sc, _sc, _angle, _col, _col, _col, _col, _alpha);
	draw_text_transformed_color(_x - 1, _y, "Press down to flip", _sc, _sc, _angle, _col, _col, _col, _col, _alpha);
	draw_text_transformed_color(_x, _y - 1, "Press down to flip", _sc, _sc, _angle, _col, _col, _col, _col, _alpha);

	_col = global.player.screen_rotated ? c_black : c_white;
	draw_text_transformed_color(_x, _y, "Press down to flip", _sc, _sc, _angle, _col, _col, _col, _col, _alpha);
}

function draw_panda_player_sprite(){
	var _xoffset = sprite_get_xoffset(sprite_index);
	var _yoffset = sprite_get_yoffset(sprite_index);
	var _bbox_bottom = sprite_get_bbox_bottom(sprite_index);
	var _sign =	panda_anim_time > round(panda_anim_time_limit / 2) ? -1 : 1;
	_sign *= global.player.screen_rotated ? 1 : -1;
	sprite_set_offset(sprite_index, _xoffset, _bbox_bottom);
	draw_sprite_ext(sprite_index, -1, x, y + _sign * (_bbox_bottom - _yoffset), global.player.xscale, draw_yscale, draw_angle, c_white, alpha);
	sprite_set_offset(sprite_index, _xoffset, _yoffset);
}

function handle_external_drawing(){
	handle_dotkid_indicator();
	handle_skin_changing_sfx();
	draw_poison_water_time();
	draw_descendable_platform_info();
	draw_panda_info();
}

function draw_player_sprite(){
	if(panda_anim_time < panda_anim_time_limit){
		draw_panda_player_sprite()
		return;	
	}
	
	image_index_ext += sprite_get_speed(sprite_index) / GAME_SPEED;
	image_index_ext %= image_number;
	image_index_ext *= image_speed;
	
	/*  Here's why I use this custom variable instead of image_index:
	Actually, image_index doesn't work well when you're constantly changing the sprite_index. 
	I couldn't pinpoint exactly why that happens, but using a custom variable like image_index_ext 
	resolves the issue easily.  */
	
	draw_sprite_ext(sprite_index, image_index_ext, x, y, global.player.xscale, draw_yscale, draw_angle, c_white, alpha);
}