if(!surface_exists(surf)){
	surf = surface_create(192, 192);
}

var _cam = cam_properties(0);

if(anim_time == 0){
	play_sound(snd_achievement_effect, 0);
		
	if(instance_exists(obj_player)){
		// Set what position will achievement effect will appear
		
		var _flag1 = obj_player.x < _cam.x + _cam.w / 2;
		var _flag2 = obj_player.x >= _cam.x + _cam.w / 2;
		var _flag3 = obj_player.y < _cam.y + _cam.h / 2;
		var _flag4 = obj_player.y >= _cam.y + _cam.h / 2;
		
		if(_flag1 && _flag3){
			effect_x = 800 - 192 - 16;
			effect_y = 608 - 192;
		} // The player is in the area of the top-left side of the camera
		else if(_flag2 && _flag3){
			effect_x = 16;
			effect_y = 608 - 192;
		} // The player is in the area of the top-right side of the camera
		else if(_flag1 && _flag4){
			effect_x = 800 - 192 - 16;
			effect_y = -192;
		} // The player is in the area of the bottom-left side of the camera
		else if(_flag2 && _flag4){
			effect_x = 16;
			effect_y = -192;
		} // The player is in the area of the bottom-right side of the camera
	}
	else{
		effect_x = 8;
		effect_y = 8;
		// Default is top-left
	}
}

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

var _icon_surf = surface_create(icon_size, icon_size);

surface_set_target(_icon_surf);
var _spr = get_achievement_icon(index);
var _spr_width = sprite_get_width(_spr);
var _spr_height = sprite_get_height(_spr);
draw_sprite_ext(_spr, 0, 0, 0, icon_size / _spr_width, icon_size / _spr_height, 0, c_white, 1);

if(!SQUARED_ACHIEVEMENT_ICON){
	gpu_set_blendmode(bm_subtract);
	draw_surface(_mask, 0, 0);
	gpu_set_blendmode(bm_normal);
		
	surface_free(_mask);
}

surface_reset_target();

surface_set_target(surf);
draw_clear_alpha(c_black, 0);

shader_set(sh_achievement_spotlight_shading);
draw_sprite_ext(spr_achievement_spotlight, 0, 96, 96, 1, 1, anim_time, c_white, 1);
shader_reset();
draw_surface(_icon_surf, surface_get_width(surf) / 2 - icon_size / 2, surface_get_height(surf) / 2 - icon_size / 2);
		
surface_reset_target();

surface_free(_icon_surf);
	
var _channel1 = animcurve_get_channel(ac_stubby_mountain, 0);
var _amount1 = animcurve_channel_evaluate(_channel1, anim_time / anim_time_limit);
var _dy = _amount1 * 192;

if(effect_y > 304){
	_dy = 192 - _amount1 * 192;
}

var _channel2 = animcurve_get_channel(ac_stubby_mountain, 0);
var _alpha = animcurve_channel_evaluate(_channel2, anim_time / anim_time_limit);

draw_surface_ext(surf, effect_x, effect_y + _dy, 1, 1, 0, c_white, _alpha);

scribble(string("New Achievement!\n[scale, 0.65]#{0} {1}", index + 1, get_achivement_name(index)))
	.starting_format("fnt_serif_bold_24", c_white)
	.blend(c_white, _alpha)
	.transform(16 / 24, 16 / 24)
	.align(fa_center, fa_middle)
	.sdf_shadow(c_black, 1, 1, 1)
	.draw(effect_x + 96, effect_y + 170 + _dy);

anim_time++;

if(anim_time == anim_time_limit){
	instance_destroy();
}