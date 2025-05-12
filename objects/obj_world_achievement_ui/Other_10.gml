/// @description local library
function update_achievement_index(){
	if(anim_time <= anim_time_limit){
		return;
	}
	
	if(go_up){
		obj_world.achievement_index--;
		now_index--;
		go_up = false;
	}
	
	if(go_down){
		obj_world.achievement_index++;
		now_index++;
		go_down = false;
	}
	
	if(keyboard_check_pressed(vk_up) && now_index > 0){
		anim_time = 0;
		go_up = true;
	}
	
	if(keyboard_check_pressed(vk_down) && now_index < ACHIEVEMENT_SLOT - 1){
		anim_time = 0;
		go_down = true;
	}
}

function handle_achievement_surf_dy(){
	if(anim_time > anim_time_limit){
		surf_dy = 0;
		return;
	}
	
	var _channel = animcurve_get_channel(ac_ease, 0);
	var _amount = animcurve_channel_evaluate(_channel, anim_time / anim_time_limit);
	
	if(go_up){
		surf_dy = lerp(0, ach_height + gap, _amount);
	}
	
	if(go_down){
		surf_dy = lerp(0, -ach_height - gap, _amount);
	}
	
	
	anim_time++;
}

function draw_single_achievement(_x, _y, _index){
	if(_index < 0 || _index >= ACHIEVEMENT_SLOT){
		return;
	}
	
	var _alpha = obj_world.settings_master_alpha;
	
	if(global.other_player_data.achievements[_index] || SHOW_ACHIEVEMENT_ICON){
		var _mask;
		
		if(!SQUARED_ACHIEVEMENT_ICON){
			_mask = surface_create(icon_size, icon_size);
			surface_set_target(_mask);
			draw_clear(c_black);
			gpu_set_blendmode(bm_subtract);
			draw_circle(icon_size / 2, icon_size / 2, icon_size / 2, false);
			gpu_set_blendmode(bm_normal);
			surface_reset_target();
		}
		
		var _spr = get_achievement_icon(_index);
		var _width = sprite_get_width(_spr);
		var _height = sprite_get_height(_spr);
		
		var _dx = ach_height / 2 - icon_size / 2;
		var _dy = ach_height / 2 - icon_size / 2;
		
		var _icon_surf = surface_create(icon_size, icon_size);
		surface_set_target(_icon_surf);
		draw_sprite_ext(_spr, 0, 0, 0, icon_size / _width, icon_size / _height, 0, c_white, 1);
		
		if(!SQUARED_ACHIEVEMENT_ICON){
			gpu_set_blendmode(bm_subtract);
			draw_surface(_mask, 0, 0);
			gpu_set_blendmode(bm_normal);
		}
		
		surface_reset_target();
		
		draw_surface_ext(_icon_surf, _x + _dx, _y + _dy, 1, 1, 0, c_white, _alpha);
		
		
		if(!SQUARED_ACHIEVEMENT_ICON){
			surface_free(_mask);
		}
		surface_free(_icon_surf);
	}
	else{
		draw_set_color(c_white);
		
		if(!SQUARED_ACHIEVEMENT_ICON){
			draw_circle(_x + ach_height / 2, _y + ach_height / 2, icon_size / 2, false);
		}
		else{
			draw_set_alpha(_alpha);
			var _x1 = _x + ach_height / 2 - icon_size / 2;
			var _x2 = _x + ach_height / 2 + icon_size / 2;
			var _y1 = _y + ach_height / 2 - icon_size / 2;
			var _y2 = _y + ach_height / 2 + icon_size / 2;
			draw_rectangle(_x1, _y1, _x2, _y2, false);
			draw_set_alpha(1);
		}
	
		scribble("???")
			.starting_format("fnt_serif_bold_24", c_black)
			.align(fa_center, fa_middle)
			.transform(12 / 24, 12 / 24)
			.blend(c_white, _alpha)
			.draw(_x + ach_height / 2, _y + ach_height / 2);
	}
	
	var _mdy = 15;
	draw_set_color(c_white);
	var _h = 2;
	draw_set_alpha(_alpha);
	draw_rectangle(_x + ach_height + 10, _y + ach_height / 2 - _mdy - _h / 2, _x + 480, _y + ach_height / 2 - _mdy  + _h / 2, false);
	draw_set_alpha(1);
	
	if(global.other_player_data.achievements[_index] || SHOW_ACHIEVEMENT_NAME){
		var _str = "#" + string(_index + 1) + " ";
		scribble(_str + get_achivement_name(_index))
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_left, fa_bottom)
			.transform(12 / 24, 12 / 24)
			.blend(c_white, _alpha)
			.draw(_x + ach_height + 10, _y + ach_height / 2 - _mdy  - 5);
	}
	else{
		var _str = "#" + string(_index + 1) + " ";
		scribble(_str + "???")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_left, fa_bottom)
			.transform(12 / 24, 12 / 24)
			.blend(c_white, _alpha)
			.draw(_x + ach_height + 10, _y + ach_height / 2 - _mdy  - 5);
	}
	
	if(global.other_player_data.achievements[_index] || SHOW_ACHIEVEMENT_EXPLANATION){
		scribble(get_achivement_explanation(_index))
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_left, fa_top)
			.transform(12 / 24, 12 / 24)
			.blend(c_white, _alpha)
			.draw(_x + ach_height + 10, _y + ach_height / 2 - _mdy  + 10);
			
		if(global.other_player_data.achievements[_index] && SHOW_ACHIEVEMENT_COMPLETE_SIGN){
			scribble("Completed!")
				.starting_format("fnt_serif_bold_24", c_white)
				.align(fa_middle, fa_bottom)
				.transform(12 / 24, 12 / 24)
				.blend(c_white, _alpha)
				.sdf_shadow(c_black, 1, 1, 1)
				.draw(_x + ach_height / 2, _y + ach_height - 10);
		}
	}
	else{
		scribble("???")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_left, fa_top)
			.transform(12 / 24, 12 / 24)
			.blend(c_white, _alpha)
			.draw(_x + ach_height + 10, _y + ach_height / 2 - _mdy  + 10);
	}
}

function draw_achievements(){

	draw_single_achievement(300, gap + surf_dy, now_index - 1);
	draw_single_achievement(300, 2 * gap + ach_height + surf_dy, now_index);
	draw_single_achievement(300, 3 * gap + 2 * ach_height + surf_dy, now_index + 1);

	if(go_up){
		draw_single_achievement(300, -ach_height + surf_dy, now_index - 2);
	}
		
	if(go_down){
		draw_single_achievement(300, 4 * gap + 3 * ach_height + surf_dy, now_index + 2);
	}

	scribble("Progress : " + string(progress) + "%")
		.starting_format("fnt_serif_bold_24", c_white)
		.align(fa_left, fa_top)
		.transform(12 / 24, 12 / 24)
		.blend(c_white, obj_world.settings_master_alpha)
		.draw(300, 16);
}
