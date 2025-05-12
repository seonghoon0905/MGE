/// @description Debug
function handle_debug(){
	if(!ENABLE_DEBUG_MODE){
		return;
	}
	
	if(!global.debug_config.god_mode){
		return;
	}
	
	if(keyboard_check_pressed(vk_insert)){
		if(!show_debug_info){
			show_debug_info = true;
		}
		else{
			show_debug_info = false;
		}
	}
	
	var _h = keyboard_check_pressed(ord("F")) - keyboard_check_pressed(ord("D"));
	var _horizontal_dx = lengthdir_x(_h, global.player.gravity_dir + 90);
	var _horizontal_dy = lengthdir_y(_h, global.player.gravity_dir + 90);
	
	if(!place_meeting(x + _horizontal_dx, y + _horizontal_dy, obj_block)){
		x += _horizontal_dx;
		y += _horizontal_dy;
	}
	
	if(keyboard_check_pressed(ord("S"))){
		save_player_data();
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
	
	var _y;
	
	if(SHOW_EXTENSIVE_YALIGN){
		var _num_y = string_length(string(floor(y)));
		_y = string_format(y, _num_y, 15);
	}
	else{
		_y = y;
	}
	
	font_enable_effects(fnt_arial_11, true,{
		outlineEnable : true,
		outlineDistance : 0,
		outlineColor : c_black
	});
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_text(32, 32, string("\nx : {0}\ny : {1}\nfps : {2}", x, _y, game_get_speed(gamespeed_fps)));
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_right);
	var _str = "jump total : " + string(global.player.jump_total) + "\n";
	_str += "can_coyote_jump : " + string(can_coyote_jump) + "\n";
	_str += "hspd : " + string(hspd) + "\n";
	_str += "vspd : " + string(vspd) + "\n";
	_str += "gravity_dir : " + string(global.player.gravity_dir) + "\n";
	_str += "xscale : " + string(global.player.xscale) + "\n";
	_str += "kid_mode : " + global.player.kid_mode + "\n";
	_str += "Insert : DebugInfo";
	draw_text(768, 32, _str);

	draw_set_valign(fa_bottom);
	draw_set_halign(fa_right);
	
	_str = "F1 to go hub\n";
	_str += "F11 / F12 to adjust room speed\n"
	_str += "F10 to reset room speed\n";
	_str += "Tab to teleport\n";
	_str += "Home to show mask\n";
	_str += "End to jump infinitely\n";
	_str += "Delete to use debug camera\n";
	_str += "Page Up / Down to transfer rooms\n";
	_str += "S to save anywhere\n";
	_str += "F / D to move one frame horizontally";
	
	if(show_debug_info){
		draw_text(768, 576, _str);
	}
}

function draw_debug_player_mask(){
	if(!ENABLE_DEBUG_MODE){
		return;
	}
	
	if(global.debug_config.show_player_mask){
		draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
	}
}