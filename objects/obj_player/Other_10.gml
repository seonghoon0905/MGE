 /// @description Movement & Collision
function handle_collided_instances(){
	var _list = ds_list_create(); // Make an empty list to add instance ids
	var _num = instance_place_list(x, y, all, _list, false);
	
	if(_num > 0){
		for(var _i = 0; _i < _num; _i++){ 
			array_push(collided_instances, _list[| _i]);
		}
	}
	
	ds_list_destroy(_list); 
}

function handle_old_variables(){
	// Save old variables before x, y, hspd, and vspd change
	old_x = x;
	old_y = y;
	old_hspd = hspd;
	old_vspd = vspd;
}


function handle_jump_star(){
	if(jump_star_id == noone){
		return;
	} // Exit if the player isn't touching a jump star
	
	var _jump_total = jump_star_id.jump_total;
	
	if(_jump_total != global.player.jump_total){
		with(jump_star_id){
			animation_start = true;
			animation_value = 0;
		}
		
		if(global.player.jump_total > _jump_total){
			jump_total = _jump_total - 1;
		}
		
		play_sound(snd_jump_star, 0);
		global.player.jump_total = _jump_total;
	}
}

function handle_jump_refresher(){
	if(jump_refresher_id == noone){
		return;
	}
	
	if(global.player.jump_total == 1){
		return;
	}
	
	with(jump_refresher_id){
		if(!touched && !other.on_block){
			if(other.jump_total - 1 == 0 || other.jump_total == 0){
				other.jump_total = 1;
			}
			touched = true;
			image_alpha = 0.5;
			alarm[0] = 100;
		}
	}
}

function handle_vkid_flip(_flip_anywhere = false, _play_snd = true){
	if(!_flip_anywhere){
		if(!(on_block || platform_id != noone || on_ladder)){
			return;
		}
	}
	
	global.player.xscale *= -1;
	global.player.gravity_dir = (global.player.gravity_dir + 180) % 360;
	image_angle = global.player.gravity_dir - 270;
	
	x += lengthdir_x(4 * global.player.yscale, global.player.gravity_dir);
	y += lengthdir_y(4 * global.player.yscale, global.player.gravity_dir);

	on_ladder = false;
	
	if(_play_snd){
		play_sound(snd_vkid_flip, 0);
	}
	
	no_draw_angle_animation = true;
}

function handle_jumping(){
	if(frozen){
		return;
	}
	
	if(global.debug_config.inf_jump){
		jump_total = infinity;
	}
	
	if(oak_cask_mode){
		return;
	}
	
	if(screen_rotate_anim_time < screen_rotate_anim_time_limit){
		return;
	}
	
	if(panda_anim_time < panda_anim_time_limit){
		return;
	}
	
	handle_jump_star();
	handle_jump_refresher();
	
	if(touching_walljump){
		return; // Exit if the player is touching walljumps
	}
	
	if(!keyboard_check_pressed(global.key_config.jump)){
		return; // Exit if the player didn't press the jump key
	}
	
	if(global.player.kid_mode == "vkid"){
		handle_vkid_flip();
		return;
	}
	
	var _platform_id = get_id_in_collided_instances_ext(obj_platform);

	if(_platform_id != noone){
		if(keyboard_check_pressed(global.key_config.jump)){
			jump_total = global.player.jump_total;
		}
	}
	
	var _on_water1 = false, _on_water2 = false, _on_water3 = false;
	
	if(water_id != noone){
		switch(water_id.water_mode){
			case 1:
				_on_water1 = true;
				break;
			case 2:
				_on_water2 = true;
				break;
			case 3:
				_on_water3 = true;
				break;
		}	
	}
	// For jump flags
	
	var _jump_flag = 
		on_block || 
		on_ladder || 
		platform_id != noone || 
		dynamic_block_id != noone ||
		_platform_id != noone ||
		_on_water1;
		
	var _djump_flag = 
		_on_water2 ||
		_on_water3;
		
	// These flags determine how fast the player jumps on the first jump
	
	if(global.player.jump_total == 1){
		can_coyote_jump = false;
	}
	// The player can't coyote jump when the global jump total is 1
	
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	
	if(_jump_flag){
		play_sound(snd_jump, 1, false);
		vspd = -jump_spd * _yscale;
		jump_total--;
		can_coyote_jump = false;
		dynamic_block_id = noone;
		on_ladder = false;
	}
	else if(_djump_flag){
		play_sound(snd_double_jump, 1, false);
		vspd = -djump_spd * _yscale;
		jump_total--;
		can_coyote_jump = false;
	}
	else if(can_coyote_jump){
		play_sound(snd_double_jump, 1, false);
		vspd = -djump_spd * _yscale;
		jump_total = global.player.jump_total - 2;
		can_coyote_jump = false;
	}
	else if(jump_total > 0){
		play_sound(snd_double_jump, 1, false);
		vspd = -djump_spd * _yscale;	
		if(jump_total == 1){
			var _col = undefined;
			switch(global.player.jump_total){
				case 3:
					_col = c_yellow;
					break;
				case 4:
					_col = c_aqua;
					break;
				case 5:
					_col = c_red;
					break;
			}
			handle_jump_star_particle(_col);
		}
		jump_total--;
	}
}


function handle_vjump(){
	if(global.player.kid_mode == "vkid"){
		return;
	}
	
	if(keyboard_check_released(global.key_config.jump) && vspd < 0){
		vspd *= vjump;
	}
}

function handle_hspd_on_slip_block(_hspd, _max_hspd){
	if(slip_block_id != noone){
		if(_hspd != 0 && abs(hspd_on_slip_block) < _max_hspd){
			hspd_on_slip_block += slip_block_id.slip * sign(_hspd);
		}
		else if(hspd_on_slip_block > 0){
			hspd_on_slip_block -= slip_block_id.slip;
			
			if(hspd_on_slip_block <= 0){
				hspd_on_slip_block = 0;
			}
		}
		else if(hspd_on_slip_block < 0){
			hspd_on_slip_block += slip_block_id.slip;
			
			if(hspd_on_slip_block >= 0){
				hspd_on_slip_block = 0;
			}
		}
	}
	else{
		hspd_on_slip_block = _hspd;
	}
	
	hspd = round(hspd_on_slip_block);
}

function handle_hspd_on_slide_block(){
	if(slide_block_id == noone){
		return;
	}
	
	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	}
	
	var _normal2 = {
		x : lengthdir_x(1, slide_block_id.image_angle),
		y : lengthdir_y(1, slide_block_id.image_angle)
	}
	
	var _epsilon = 0.01;
	
	if(dot(_normal1, _normal2) < _epsilon){
		if(cross(_normal1, _normal2) < 0){
			hspd += slide_block_id.move_speed;
		}
		else{
			hspd -= slide_block_id.move_speed;
		}
	}
}

function handle_hspd_and_vspd(){
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
	
	var _xscale = PLAYER_SPEED_ALONG_SCALE ? abs(global.player.xscale) : 1;
	
	var _sign_adjust = floor(global.player.gravity_dir / 180) % 2 == 1 ? 1 : -1;
	_sign_adjust = global.player.gravity_dir == 0 ? 1 : _sign_adjust;
	
	// Value for Preventing key changing
	
	var _max_hspd = max_hspd;
	
	if(in_high_speed_field){
		_max_hspd = 6;
	}
	else if(in_low_speed_field){
		_max_hspd = 1;
	}
	
	if(fire_walljumping){
		_max_hspd = 6; 
	}
	
	
	if(frozen){
		hspd = 0; // Don't let the player move horizontally if frozen is true
	}
	else if(_button_right && _button_left && (global.settings.backstep || ENABLE_PLAYER_BACKSTEP_FOREVER)){
		/* In the backstep mode, hspd indicating to the backstep_sign
		if the player is pressing left and right key simultaneosly */
		hspd = backstep_sign * _max_hspd * _xscale;
	}
	else if(!global.player.screen_rotated && (_button_right || _button_left)){
		if(_button_right){
			hspd = _sign_adjust * _max_hspd * _xscale;
			backstep_sign = -sign(hspd); 
		}
		else if(_button_left){
			hspd = -_sign_adjust * _max_hspd * _xscale;
			backstep_sign = -sign(hspd);
		} 
	}
	else if(global.player.screen_rotated && (_button_right || _button_left)){
		if(_button_left){
			hspd = -_sign_adjust * _max_hspd * _xscale;
			backstep_sign = -sign(hspd);
		} 
		else if(_button_right){
			hspd = _sign_adjust * _max_hspd * _xscale;
			backstep_sign = -sign(hspd); 
		}
	}
	else{
		hspd = 0;
	}
	
	handle_hspd_on_slip_block(hspd, _max_hspd);
	handle_hspd_on_slide_block();
	
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	
	var _gravity_pull = gravity_pull;
	
	if(in_high_gravity_field){
		_gravity_pull = 0.7;
	}
	else if(in_low_gravity_field){
		_gravity_pull = 0.2;
	}
	
	if(purple_walljumping){
		_gravity_pull = 0.3;
	}
	
	var _no_accerleration = platform_id != noone &&
							(platform_id.object_index == obj_verve_platform ||
							object_is_ancestor(platform_id.object_index, obj_verve_platform));

	// Accelerate vspd with gravity_pull
	if(!_no_accerleration){
		vspd += _gravity_pull * _yscale;
	}
	
	if(vspd > max_vspd * _yscale){
		vspd = max_vspd * _yscale;
	}
}

function handle_oak_cask(){
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	
	if(oak_cask_mode){
		vspd = -_yscale * 7;
		handle_oak_cask_particle();
	}
	else{
		var _inst = get_id_in_collided_instances(obj_oak_cask);
		
		if(_inst == noone){
			return;
		}
	
		var _epsilon = 0.01;
	
		var _normal1 = {
			x : lengthdir_x(1, global.player.gravity_dir),
			y : lengthdir_y(1, global.player.gravity_dir)
		}
	
		var _normal2 = {
			x : lengthdir_x(1, _inst.image_angle + 270),
			y : lengthdir_y(1, _inst.image_angle + 270)
		}
	
		var _dot = dot(_normal1, _normal2);
	
		if(_dot < 1 - _epsilon){
			return;
		}
		
		if(_inst.touch){
			return;
		}
		
		oak_cask_mode = true;
		_inst.touch = true;
		
		jump_total = global.player.jump_total;
		can_coyote_jump = true;
		vspd = -_yscale;
		
		previous_platform_id = noone;
		fall_from_platform = false;
		
		play_sound(snd_oak_cask, 0);
	}
}

function activate_screen_rotator(){
	if(not(global.player.gravity_dir == 270 || global.player.gravity_dir == 90)){
		return;
	}
	
	var _inst = noone;
	
	if(!global.player.screen_rotated){
		_inst = get_id_in_collided_instances(obj_screen_rotate_up);
	}
	else{
		_inst = get_id_in_collided_instances(obj_screen_rotate_down);
	}
	
	if(_inst == noone){
		return;
	}
	
	var _flag = (!global.player.screen_rotated && global.player.gravity_dir == 270) ||
				(global.player.screen_rotated && global.player.gravity_dir == 90);
	
	if(_flag){
		var _adj = global.player.screen_rotated ? 3 : -3;
		y += _adj * global.player.yscale;
	}
	
	global.player.gravity_dir = global.player.screen_rotated ? 270 : 90;
	
	image_angle = global.player.gravity_dir - 270;
	
	vspd = 0;
	jump_count = 0;
	can_coyote_jump = true;
	
	if(global.player.screen_rotated){
		saved_screen_angle = 180;
		global.player.screen_rotated = false;
		screen_rotate_anim_time = 0;
		
		update_panda_collision();
		play_sound(snd_block_change, 0);

	}
	else{
		saved_screen_angle = 0;
		global.player.screen_rotated = true;
		screen_rotate_anim_time = 0;
		
		update_panda_collision();
		play_sound(snd_block_change, 0);

	}
}

function rotate_screen(){
	if(screen_rotate_anim_time >= screen_rotate_anim_time_limit){
		return;
	}
	
	hspd = 0;
	vspd = 0;
	
	if(screen_rotate_anim_time < screen_rotate_anim_time_limit){
		screen_rotate_anim_time++;
	}
	
	var _channel = animcurve_get_channel(ac_arctan, 0);
	var _amount = animcurve_channel_evaluate(_channel, screen_rotate_anim_time / screen_rotate_anim_time_limit);
	
	screen_angle = lerp(saved_screen_angle, global.player.screen_rotated * 180, _amount);
	
	camera_set_view_angle(view_camera[0], screen_angle);
}

function handle_screen_rotator(){
	activate_screen_rotator();
	rotate_screen();
}

function update_panda_collision(){
	if(global.player.screen_rotated){
		make_collidable(obj_panda_black_block);
		make_collidable(obj_panda_black_spike);
		make_collidable(obj_panda_mini_black_spike);
		make_collidable(obj_panda_half_black_spike);
		make_collidable(obj_panda_half_mini_black_spike);
		
		make_incollidable(obj_panda_white_block);
		make_incollidable(obj_panda_white_spike);
		make_incollidable(obj_panda_mini_white_spike);
		make_incollidable(obj_panda_half_white_spike);
		make_incollidable(obj_panda_half_mini_white_spike);
	}
	else{
		make_collidable(obj_panda_white_block);
		make_collidable(obj_panda_white_spike);
		make_collidable(obj_panda_mini_white_spike);
		make_collidable(obj_panda_half_white_spike);
		make_collidable(obj_panda_half_mini_white_spike);
		
		make_incollidable(obj_panda_black_block);
		make_incollidable(obj_panda_black_spike);
		make_incollidable(obj_panda_mini_black_spike);
		make_incollidable(obj_panda_half_black_spike);
		make_incollidable(obj_panda_half_mini_black_spike);
	}
}

function activate_panda(){
	if(panda_block_id == noone){
		return;
	}
	
	if(not(global.player.gravity_dir == 270 || global.player.gravity_dir == 90)){
		return;
	}
	
	if(panda_anim_time < panda_anim_time_limit){
		return;
	}
	
	if(keyboard_check_pressed(global.key_config.down)){
		panda_anim_time = 0;
		
		if(!global.player.screen_rotated){
			global.player.screen_rotated = true;
			saved_screen_angle = 0;
		}
		else{
			global.player.screen_rotated = false;
			saved_screen_angle = 180;
		}
		
		play_sound(snd_panda, 0);
	}
}

function handle_panda_objects(){
	activate_panda();
	
	if(panda_anim_time >= panda_anim_time_limit){
		return;
	}
	
	panda_anim_time++;
	
	if(panda_anim_time == round(panda_anim_time_limit / 2)){
		update_panda_collision();
		
		global.player.xscale *= -1;
		no_draw_angle_animation = true;
		global.player.gravity_dir = global.player.screen_rotated ? 90 : 270;
		image_angle = global.player.gravity_dir - 270;
		var _adj = abs(global.player.xscale);
		
		
		x += _adj * (global.player.screen_rotated ? 1 : -1);
		
		if(global.player.kid_mode == "dotkid"){
			y += lengthdir_y(2 * abs(global.player.yscale), global.player.gravity_dir - 180);
		}
		else{
			y += lengthdir_y(17 * abs(global.player.yscale), global.player.gravity_dir - 180);
		}
		
		move_contact(global.player.gravity_dir, abs(vspd) + 1, obj_block);
	}
	else{
		hspd = 0;
		vspd = 0;
	}
	
	var _channel1 = animcurve_get_channel(ac_flipped_mountain, 0);
	var _amount1 = animcurve_channel_evaluate(_channel1, panda_anim_time / panda_anim_time_limit);
	
	var _channel2 = animcurve_get_channel(ac_arctan, 0);
	var _amount2 = animcurve_channel_evaluate(_channel2, panda_anim_time / panda_anim_time_limit);
	
	draw_yscale = _amount1 * global.player.yscale;
	screen_angle = lerp(saved_screen_angle, global.player.screen_rotated * 180, _amount2);
	camera_set_view_angle(view_camera[0], screen_angle);
}

function handle_pastel_green_water(){
	var _inst = get_id_in_collided_instances(obj_pastel_green_water);
	
	if(_inst != noone && rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _inst.bbox_left, _inst.bbox_top, _inst.bbox_right, _inst.bbox_bottom)){
		with(_inst){
			var _list = ds_list_create(); 
			var _num = instance_place_list(x, y, obj_block, _list, false);
	
			if(_num > 0){
				for(var _i = 0; _i < _num; _i++){ 
					var _block_inst = _list[| _i]; 
					make_incollidable(_block_inst);
					array_push(other.pastel_incollidable_instances, _block_inst);
				}
			}
	
			ds_list_destroy(_list);
		}
		return;
	}
	
	if(array_length(pastel_incollidable_instances) < 1){
		return;
	}
	
	for(var _i = 0; _i < array_length(pastel_incollidable_instances); _i++){
		make_collidable(pastel_incollidable_instances[_i]);
	}
	
	pastel_incollidable_instances = [];
}

function handle_ladder(){
	if(oak_cask_mode){
		return;
	}
	
	if(screen_rotate_anim_time < screen_rotate_anim_time_limit){
		return;
	}
	
	if(!on_ladder){
		var _ladder_id = get_id_in_collided_instances(obj_ladder);
		if(_ladder_id != noone && keyboard_check_pressed(global.key_config.up)){
			on_ladder = true;
			vspd = 0;
			can_coyote_jump = true;
			jump_total = global.player.jump_total;
			// Refresh vspd and jump
		}
	}
	else{
		var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
		
		if(frozen){
			vspd = 0;
		}
		else if(keyboard_check(global.key_config.up)){
			vspd = -max_hspd * _yscale;
		}
		else if(keyboard_check(global.key_config.down)){
			vspd = max_hspd * _yscale;
		}
		else{
			vspd = 0;
		}
	}
}

function handle_gravity_changer(){
	if(gravity_changer_id == noone){
		return;
	}
	
	if(gravity_changer_id.touched){
		return;
	}
	
	if(gravity_changer_id.image_angle == global.player.gravity_dir){
		return;
	}
	
	if(!ENABLE_GRAVITY_CHANGING_ANIMATION){
		no_draw_angle_animation = true;
	}
	
	gravity_changer_id.touched = true;
	
	var _depth = 6 * abs(global.player.xscale);
	
	var _on_ground = false, _under_ceiling = false;
	var _right_to_wall = false, _left_to_wall = false;
	
	var _dx = lengthdir_x(_depth, global.player.gravity_dir);
	var _dy = lengthdir_y(_depth, global.player.gravity_dir);
	
	if(place_meeting(x + _dx, y + _dy, obj_block)){
		_on_ground = true;
	}
	
	_dx = lengthdir_x(_depth, global.player.gravity_dir - 180);
	_dy = lengthdir_y(_depth, global.player.gravity_dir - 180);
	
	if(place_meeting(x + _dx, y + _dy, obj_block)){
		_under_ceiling = true;
	}
	
	_dx = lengthdir_x(_depth, global.player.gravity_dir + 90);
	_dy = lengthdir_y(_depth, global.player.gravity_dir + 90);
	
	if(place_meeting(x + _dx, y + _dy, obj_block)){
		_right_to_wall = true;
	}
	_dx = lengthdir_x(_depth, global.player.gravity_dir - 90);
	_dy = lengthdir_y(_depth, global.player.gravity_dir - 90);
	
	if(place_meeting(x + _dx, y + _dy, obj_block)){
		_left_to_wall = true;
	}
	
	var _dist = 8 * abs(global.player.xscale);
	var _saved_dir = global.player.gravity_dir;
	image_angle = gravity_changer_id.image_angle - 270;
	global.player.gravity_dir = gravity_changer_id.image_angle;
	
	if(place_meeting(x, y, obj_block)){
		if(_on_ground){
			move_outside(_saved_dir, _dist, obj_block);
		}
		
		if(_under_ceiling){
			move_outside(_saved_dir - 180, _dist, obj_block);
		}
		
		if(_right_to_wall){
			move_outside(_saved_dir + 90, _dist, obj_block);
		}
		
		if(_left_to_wall){
			move_outside(_saved_dir - 90, _dist, obj_block);
		}
	}
	
	global.player.xscale *= -1;
	x = round(x);
	y = round(y);
	
	vspd = 0;
	jump_count = 0;
	can_coyote_jump = true;
}

function handle_speed_field(){
	if(get_id_in_collided_instances(obj_high_gravity_field) != noone){
		in_high_gravity_field = true;
	}
	else{
		in_high_gravity_field = false;
	}
	
	if(get_id_in_collided_instances(obj_low_gravity_field) != noone){
		in_low_gravity_field = true;
	}
	else{
		in_low_gravity_field = false;
	}
	
	if(get_id_in_collided_instances(obj_high_speed_field) != noone){
		in_high_speed_field = true;
	}
	else{
		in_high_speed_field = false;
	}
	
	if(get_id_in_collided_instances(obj_low_speed_field) != noone){
		in_low_speed_field = true;
	}
	else{
		in_low_speed_field = false;
	}
}

function handle_water1(){
	if(global.player.jump_total == 1){
		jump_total = 0;
	}
	else if(jump_total < global.player.jump_total){
		jump_total = global.player.jump_total - 1;
	}
	
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	if(vspd > 2 * _yscale){
		vspd = 2 * _yscale;
	}
}

function handle_water2(){
	if(keyboard_check_pressed(global.key_config.jump)){
		jump_total = 0;
	}
	
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	if(vspd > 2 * _yscale){
		vspd = 2 * _yscale;
	}
}

function handle_catharsis_water(){
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	if(vspd > 2 * _yscale){
		vspd = 2 * _yscale;
	}
}

function handle_water(){
	if(water_id == noone){
		poison_water_time = 0;
		return;
	}
	// Exit if there's no instance 

	if(water_id != noone && water_id.object_index != obj_poison_water){
		poison_water_time = 0;
	}
	
	switch(water_id.water_mode){ 
		// Call a function depending on the instance's object
		case 1:
		case 3:
			handle_water1();
			break;
		case 2:
			handle_water2();
			break;
		case 4:
			handle_catharsis_water();
			break;
	}

	if(water_id.object_index == obj_poison_water){
		if(poison_water_time < poison_water_time_limit){
			poison_water_time++;
		}
	}
}

function escape_from_walljump(_inst){
	var _xscale = PLAYER_SPEED_ALONG_SCALE ? abs(global.player.xscale) : 1;
	var _yscale = PLAYER_SPEED_ALONG_SCALE ? global.player.yscale : 1;
	
	hspd = 0;
	
	var _flag = _inst.object_index == obj_ice_walljump ||
				_inst.object_index == obj_lagacy_ice_walljump;
				
	if(!_flag){
		vspd = 2.4 * _yscale;
	}
	
	_flag = _inst.object_index == obj_red_walljump ||
			_inst.object_index == obj_lagacy_red_walljump;
				
	if(_flag){
		vspd = -2.4 * _yscale;
	}
	
	_flag = _inst.object_index == obj_yellow_walljump ||
			_inst.object_index == obj_lagacy_yellow_walljump;
				
	if(_flag){
		vspd = 0;
	}
	
	if(frozen){
		return;
	}
	
	_flag = (_inst.object_index == obj_lagacy_walljump ||
			_inst.object_index == obj_lagacy_red_walljump ||
			_inst.object_index == obj_lagacy_yellow_walljump ||
			_inst.object_index == obj_lagacy_ice_walljump || 
			_inst.object_index == obj_lagacy_blue_walljump ||
			_inst.object_index == obj_lagacy_purple_walljump ||
			_inst.object_index == obj_lagacy_fire_walljump ||
			_inst.object_index == obj_lagacy_black_walljump ||
			_inst.object_index == obj_lagacy_white_walljump) &&
			keyboard_check_pressed(global.key_config.jump) &&
			jump_total > 0 &&
			global.player.kid_mode != "vkid";
	
	if(_flag){
		jump_total--;
	} // Prevent none-full jumping on walljump 
	
	
	if(!keyboard_check_pressed(walljump_key)){
		return;
	}
	// Exit if the player didn't pressed escaping key
	
	var _sign_adjust = floor(global.player.gravity_dir / 180) % 2 == 1 ? 1 : -1;
	_sign_adjust = global.player.gravity_dir == 0 ? 1 : _sign_adjust;
	
	// Value for hspd adjustment to prevent key change
	_sign_adjust *= global.player.screen_rotated ? -1 : 1;
	
	// If the player pressed escaping key while pressing jump key, the player can escape with jumping
	if(keyboard_check(global.key_config.jump)){
		_flag = _inst.object_index == obj_blue_walljump ||
				_inst.object_index == obj_lagacy_blue_walljump;
		
		if(global.player.kid_mode == "vkid" || _flag){
			handle_vkid_flip(true, global.player.kid_mode == "vkid");
			_sign_adjust *= -1;
		}
		
		_flag = _inst.object_index == obj_purple_walljump ||
				_inst.object_index == obj_lagacy_purple_walljump;
	
		if(_flag){
			purple_walljumping = true;
		}
		
		_flag = _inst.object_index == obj_fire_walljump ||
				_inst.object_index == obj_lagacy_fire_walljump;
		
		if(_flag){
			fire_walljumping = true;
		}
		
		_flag = _inst.object_index == obj_white_walljump ||
				_inst.object_index == obj_lagacy_white_walljump ||
				_inst.object_index == obj_black_walljump ||
				_inst.object_index == obj_lagacy_black_walljump;
		
		if(_flag){
			with(_inst.object_index){
				deactivated = true;
			}
			
			var _obj = noone;
			switch(_inst.object_index){
				case obj_black_walljump:
					_obj = obj_white_walljump;
					break;
				case obj_white_walljump:
					_obj = obj_black_walljump;
					break;
				case obj_lagacy_black_walljump:
					_obj = obj_lagacy_white_walljump;
					break;
				case obj_lagacy_white_walljump:
					_obj = obj_lagacy_black_walljump;
					break;
			}
			
			with(_obj){
				deactivated = false;
			}
		}
		
		if(walljump_key == global.key_config.left){
			hspd = -15 * _xscale * _sign_adjust;
		}
		else if(walljump_key == global.key_config.right){
	  		hspd = 15 * _xscale * _sign_adjust;
		}
		
		vspd = -8.6 * _yscale;
		
		touching_walljump = false;
		walljump_key = undefined;
		// Refresh a walljump element
		
		if(global.player.kid_mode != "vkid"){
			play_sound(snd_wall_jump, 0);
		}
	}
	// If the player just pressed escaping key without jump key, the player falls down normally 
	else{
		if(walljump_key == global.key_config.left){
			hspd = -max_hspd * _xscale * _sign_adjust;
		}
		else if(walljump_key == global.key_config.right){
			hspd = max_hspd * _xscale * _sign_adjust;
		}

		touching_walljump = false;
		walljump_key = undefined;
		// Refresh a walljump element
	}
}

function handle_walljump(){
	if(purple_walljumping && global.other_player_data.time % 4 == 0){
		handle_purple_walljump_particle();
	}
	
	if(fire_walljumping && (global.other_player_data.time + 2) % 4 == 0){
		handle_fire_walljump_particle();
	}
	
	if(on_block || on_ladder || platform_id != noone || oak_cask_mode){
		return;
	} // In these cases, the player can't attach to the walljump instance

	var _offset = [90, -90]; // For checking if walljumps exist on the right side or the left side
		
	for(var _j = 0; _j < array_length(_offset); _j++){	
		var _horizontal_dx = lengthdir_x(1, global.player.gravity_dir + _offset[_j]);
		var _horizontal_dy = lengthdir_y(1, global.player.gravity_dir + _offset[_j]);
		
		var _inst = instance_place(x + _horizontal_dx, y + _horizontal_dy, obj_walljump);
		// If there is a walljump instance on the right side or the left side, take an id of it		
		
		var _flag = (_inst == noone) || (_inst != noone &&
					((_inst.object_index == obj_black_walljump && _inst.deactivated) ||
					(_inst.object_index == obj_white_walljump && _inst.deactivated) ||
					(_inst.object_index == obj_lagacy_black_walljump && _inst.deactivated) ||
					(_inst.object_index == obj_lagacy_white_walljump && _inst.deactivated)));
					
		if(_flag){
			touching_walljump = false;
			walljump_key = undefined;
			continue;
		} // If _inst is noone, refresh a walljump element and go to the next case	
			
		var _epsilon = 0.1; // For floating point comparison

		var _normal1 = {
			x : lengthdir_x(sign(global.player.xscale), global.player.gravity_dir + 90),
			y : lengthdir_y(sign(global.player.xscale), global.player.gravity_dir + 90)
		} // An unit vector indicating the right side or the left side
				
		var _normal2 = {
			x : lengthdir_x(1, _inst.image_angle),
			y : lengthdir_y(1, _inst.image_angle)
		} // An unit vector indicating the right side of the walljump
			
		if(dot(_normal1, _normal2) >= 1 - _epsilon){
		// If a dot product of normal1 and normal2 is one, it means they're directing a same direction.
			var _sign_adjust = floor(global.player.gravity_dir / 180) % 2 == 1 ? 1 : -1;
			_sign_adjust = global.player.gravity_dir == 0 ? 1 : _sign_adjust;
			
			touching_walljump = true;
			// touching_walljump will be used to set sprite_index and discriminate whether the player is on walljump in other gimmiks
			
			if(!global.player.screen_rotated){
				walljump_key = sign(global.player.xscale) * _sign_adjust == 1 ? global.key_config.left : global.key_config.right;
			}
			else{
				walljump_key = sign(global.player.xscale) * _sign_adjust == 1 ? global.key_config.right : global.key_config.left;
			}
			
			escape_from_walljump(_inst);
				
			return; 
			// Exit because we don't need to find more cases after we already handled one case
		}
		// Go to the next case since normal1 and normal2 don't have a same direction
	}
}

function handle_gimmiks(){
	handle_oak_cask();
	handle_screen_rotator();
	handle_panda_objects();
	handle_pastel_green_water();
	handle_ladder();
 	handle_gravity_changer();
	handle_speed_field();
	handle_water();
	handle_walljump();
}

function handle_dynamic_block(){
	var _list = ds_list_create(); // Make an empty list to add instance ids of dynamic blocks
	var _num = instance_place_list(x, y, obj_dynamic_block, _list, false);
	
	if(_num > 0){ // Check the player had collided any dynamic blocks
		for(var _i = 0; _i < _num; _i++){ 
			var _inst = _list[| _i]; 
			
			var _block_dx = _inst.x - _inst.old_x;
			if(_block_dx > 0){
				move_outside(180, _block_dx + 1, _inst);
			}
			else if(_block_dx < 0){
				move_outside(0, -_block_dx + 1, _inst);
			} // Let the player go outside from every dynamic block horizontally
		}
	}
	
	ds_list_destroy(_list);
	
	_list = ds_list_create();
	_num = instance_place_list(x, y, obj_dynamic_block, _list, false);
	
	if(_num > 0){
		for(var _i = 0; _i < _num; _i++){
			var _inst = _list[| _i];
			
			var _block_dy = _inst.y - _inst.old_y; 
			if(_block_dy > 0){
				move_outside(90, _block_dy + 1, _inst);
			}
			else if(_block_dy < 0){
				move_outside(270, -_block_dy + 1, _inst);
			} // Let the player go outside from every dynamic block vertically
		}
	}
	
	ds_list_destroy(_list);
	
	if(on_ladder){
		return;
	} // The next part should not be executed when the player is on the ladder
	
	if(dynamic_block_id == noone){
		return;
	} // Exit if there's no a dynamic block the player is on
			
	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir + 90),
		y : lengthdir_y(1, global.player.gravity_dir + 90)
	} // An unit vector indicating the right side of the player
	
	var _normal2 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	} // An unit vector indicating the bottom side of the player
	
	var _dp = {
		x : dynamic_block_id.x - dynamic_block_id.old_x,
		y : dynamic_block_id.y - dynamic_block_id.old_y
	} // Increment of the dynamic block's position 

	hspd += round(dot(_dp, _normal1)); 
	/* Add a dot product of dp and normal1 to hspd
	It means horizontal increment of the block in the player's perspective
	(We should consider that the direction of the player's gravity can be altered) */
	
	if(dot(_dp, _normal2) > 0){ 
		// We don't need to check when the block goes up because of move_outside in move_contact
		vspd += dot(_dp, _normal2);
		// Add dot product of dp and normal2(It means vertical increment of the block) to vspd
	}
}

function handle_push_block(){
	if(hspd == 0){
		return;
	}
	
	var _horizontal_dx = lengthdir_x(hspd, global.player.gravity_dir + 90);
	var _horizontal_dy = lengthdir_y(hspd, global.player.gravity_dir + 90);
	
	var _inst = instance_place(x + _horizontal_dx, y + _horizontal_dy, obj_push_block);
	var _below_inst = false;
	
	if(_inst == noone){
		if(on_block){
			var _vertical_dx = lengthdir_x(1, global.player.gravity_dir - 180);
			var _vertical_dy = lengthdir_y(1, global.player.gravity_dir - 180);
			var _dx = _horizontal_dx + _vertical_dx;
			var _dy = _horizontal_dy + _vertical_dy;
			_inst = instance_place(x + _dx, y + _dy, obj_push_block);
			if(_inst != noone){
				_below_inst = true;
			}
		}
		
		if(_inst == noone){
			return;
		}
	}
	
	var _epsilon = 0.01;
	
	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	}
	
	var _normal2 = {
		x : lengthdir_x(1, global.player.gravity_dir + 90),
		y : lengthdir_y(1, global.player.gravity_dir + 90)
	}
	
	var _inst_normal = {
		x : lengthdir_x(1, _inst.gravity_dir),
		y : lengthdir_y(1, _inst.gravity_dir)
	}
	
	var _dot1 = dot(_normal1, _inst_normal);
	var _dot2 = dot(_normal2, _inst_normal);
	
	if(_dot1 < 1 - _epsilon || abs(_dot2) > _epsilon){
		return;
	}
	
	var _saved_x = x;
	var _saved_y = y;
	
	var _contacting_distance = 0;
	var _dir = hspd > 0 ? 90 : -90;
	
	if(_inst.object_index == obj_heavy_push_block){
		if(!_below_inst){
			_contacting_distance = get_contacting_distance(global.player.gravity_dir + _dir, abs(hspd) + 1, _inst);
		}
		else{
			_contacting_distance = get_contacting_distance(global.player.gravity_dir - 180, abs(hspd) + 1, _inst);
		}
		_horizontal_dx = lengthdir_x(sign(hspd) * (_contacting_distance + 1), global.player.gravity_dir + 90);
		_horizontal_dy = lengthdir_y(sign(hspd) * (_contacting_distance + 1), global.player.gravity_dir + 90);
	}
	
	x += _horizontal_dx;
	y += _horizontal_dy;
	
	if(place_meeting(x, y, obj_slope)){
		var _list = ds_list_create();
		var _num = instance_place_list(x, y, obj_block, _list, false);
	
		if(_num > 0){
			for(var _i = 0; _i < _num; _i++){
				var _j = _list[| _i];
				move_outside(global.player.gravity_dir, abs(hspd) + 1, _j);
			}
		}
	
		ds_list_destroy(_list);
		
		
		if(place_meeting(x, y, _inst)){
			_dir = hspd > 0 ? 90 : -90;
			move_outside(global.player.gravity_dir + _dir, -1, _inst, true);
			
			x += _horizontal_dx;
			y += _horizontal_dy;
		}
	}
	
	with(_inst){
		be_pushed();
		if(place_meeting(x, y, obj_block)){
			_dir = other.hspd > 0 ? 90 : -90;
			move_outside(gravity_dir + _dir, abs(other.hspd), obj_block);
		}
	}
	
	x = _saved_x;
	y = _saved_y;
}

function handle_bunnyhop_pixel(_obj, _limit = 3){
	var _vertical_dx = lengthdir_x(gravity_pull, global.player.gravity_dir);
	var _vertical_dy = lengthdir_y(gravity_pull, global.player.gravity_dir);
	
	var _cnt = 0;
	while(_cnt <= _limit && !place_meeting(x + _vertical_dx, y + _vertical_dy, _obj)){
		x += _vertical_dx;
		y += _vertical_dy;
		_cnt++;
	}
	
	vspd = 0;
	jump_total = global.player.jump_total;
	can_coyote_jump = true;
	on_block = true;
	// If the player is on bunny-hop pixel, snap him to the ground
}

function handle_climbing_on_slope(){
	var _list = ds_list_create();
	var _num = instance_place_list(x, y, obj_block, _list, false);
	if(_num > 0){
		for(var _i = 0; _i < _num; _i++){
			var _inst = _list[| _i];
			move_outside(global.player.gravity_dir, abs(hspd) + 1, _inst);
		}
	}
	
	ds_list_destroy(_list);
	
	var _saved_x = x;
	var _saved_y = y;
	var _cur = 0;
	var _contact = false;
	
	while(place_meeting(x, y, obj_block)){
		x = _saved_x;
		y = _saved_y;
		x += lengthdir_x(_cur * -sign(hspd), global.player.gravity_dir + 90);
		y += lengthdir_y(_cur * -sign(hspd), global.player.gravity_dir + 90);
		move_outside(global.player.gravity_dir - 180, abs(hspd) + 1, obj_block);
		_cur++;
		_contact = true;
	}
	
	if(_contact){
		move_contact(global.player.gravity_dir, abs(hspd) + 1, obj_block);
	}
	
	handle_bunnyhop_pixel(obj_block);
	hspd = 0;
}

function handle_descending_on_slope(){
	var _sub_pixel = (global.player.gravity_dir % 90 == 0) ? 0 : 0.5;
	
	move_contact(global.player.gravity_dir, abs(hspd) * (1 + _sub_pixel) + 1, obj_block);
	
	if(place_meeting(x, y, obj_block)){
		var _dir = (hspd > 0) ? 90 : -90;
		move_outside(global.player.gravity_dir + _dir, abs(hspd) + 1, obj_block);
		move_contact(global.player.gravity_dir, abs(hspd) + 1, obj_block);
	}
	
	hspd = 0;
}

function handle_slope(){
	if(keyboard_check_pressed(global.key_config.jump)){
		return;
	}
	// Exit if the player tries to jump 
	// There's no need to ride on slopes when the player jumps
	
	var _horizontal_dx = lengthdir_x(hspd, global.player.gravity_dir + 90);
	var _horizontal_dy = lengthdir_y(hspd, global.player.gravity_dir + 90);
	// The horizontal component of the player's movement
	
	var _vertical_dx = lengthdir_x(vspd, global.player.gravity_dir);
	var _vertical_dy = lengthdir_y(vspd, global.player.gravity_dir);
	// The vertical component of the player's movement
	
	var _sub_pixel = (global.player.gravity_dir % 90 == 0) ? 0 : 0.5;

	if(on_block && place_meeting(x + _horizontal_dx, y + _horizontal_dy, obj_slope)){
		_horizontal_dx = lengthdir_x(sign(hspd), global.player.gravity_dir + 90);
		_horizontal_dy = lengthdir_y(sign(hspd), global.player.gravity_dir + 90);
		
		var _dx = _horizontal_dx + lengthdir_x(1 + _sub_pixel, global.player.gravity_dir - 180);
		var _dy = _horizontal_dy + lengthdir_y(1 + _sub_pixel, global.player.gravity_dir - 180);
		
		if(!place_meeting(x + _dx, y + _dy, obj_slope)){
			x += lengthdir_x(hspd, global.player.gravity_dir + 90);
			y += lengthdir_y(hspd, global.player.gravity_dir + 90);
			// Go horizontally if there's no block diagonally
			
			handle_climbing_on_slope();
		}
	}
	else if(vspd > 0 && place_meeting(x + _vertical_dx, y + _vertical_dy, obj_slope)){
		move_contact(global.player.gravity_dir, vspd + 1, obj_slope);
		
		_horizontal_dx = lengthdir_x(sign(hspd), global.player.gravity_dir + 90);
		_horizontal_dy = lengthdir_y(sign(hspd), global.player.gravity_dir + 90);
	
		_vertical_dx = lengthdir_x(abs(hspd) * (1 + _sub_pixel), global.player.gravity_dir);
		_vertical_dy = lengthdir_y(abs(hspd) * (1 + _sub_pixel), global.player.gravity_dir);
		
		var _dx = _horizontal_dx + _vertical_dx;
		var _dy = _horizontal_dy + _vertical_dy;
		
		if(place_meeting(x + _dx, y + _dy, obj_block)){
			x += lengthdir_x(hspd, global.player.gravity_dir + 90);
			y += lengthdir_y(hspd, global.player.gravity_dir + 90);
			
			handle_descending_on_slope();
		}
		
		handle_bunnyhop_pixel(obj_block);
	} 
}

function update_platform_top_left(_inst){
	// It updates the platform's top left point 
	// Points are different depending on the direction of the player's gravity

	var _angle = _inst.image_angle; 
	var _epsilon = 0.1; // For floating point comparision
	
	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	} // An unit vector indicating the bottom side of the player

	var _normal2 = {
		x : lengthdir_x(1, _angle),
		y : lengthdir_y(1, _angle)
	} // An unit vector indicating the right side of the platform
	
	var _top_detect = abs(dot(_normal1, _normal2)) < _epsilon && cross(_normal1, _normal2) < 0;
	var _left_detect = dot(_normal1, _normal2) >= 1 - _epsilon;
	var _bottom_detect = abs(dot(_normal1, _normal2)) < _epsilon && cross(_normal1, _normal2) > 0;
	var _right_detect = dot(_normal1, _normal2) <= -1 + _epsilon;
	// Check if the player is on the platform's top side or left side or bottom side or right side
	
	var _width = _inst.sprite_width;
	var _height = _inst.sprite_height;
	
	// Update platform infos depending on the player's state
	if(_left_detect){
		platform_top_left = {
			x : _inst.x + lengthdir_x(_height, _angle - 90),
			y : _inst.y + lengthdir_y(_height, _angle - 90)
		}
	}
	else if(_bottom_detect){
		platform_top_left = {
			x : _inst.x + lengthdir_x(_width, _angle) + lengthdir_x(_height, _angle - 90),
			y : _inst.y + lengthdir_y(_width, _angle) + lengthdir_y(_height, _angle - 90)
		}
	}
	else if(_right_detect){
		platform_top_left = {
			x : _inst.x + lengthdir_x(_width, _angle),
			y : _inst.y + lengthdir_y(_width, _angle)
		}
	}
	else if(_top_detect){
		platform_top_left = {
			x : _inst.x,
			y : _inst.y
		}
	}
	else{ // Refresh if nothing had been detected
		platform_top_left = undefined;
	}
}

function refresh_fall_from_platform(){
	var _flag = 
		keyboard_check_pressed(global.key_config.jump) ||
		on_block;
	
	if(_flag){
		fall_from_platform = false;
	}
}

function handle_moving_platform(){
	if(platform_id == noone || on_block){
		return;
	}
	
	var _dp = {
		x : platform_id.x - platform_id.old_x,
		y : platform_id.y - platform_id.old_y
	}

	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir + 90),
		y : lengthdir_y(1, global.player.gravity_dir + 90)
	} // An unit vector indicating the right side of the player

	var _normal2 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	} // An unit vector indicating the bottom side of the player
	
	hspd += dot(_dp, _normal1);
	
	var _dot = dot(_dp, _normal2);
	
	if(!keyboard_check_pressed(global.key_config.jump)){
		vspd += _dot;
		
		if(_dot > 0){
			platform_escaping_spd = _dot;
		}
		else{
			platform_escaping_spd = 0;
		}
	}
}

function settle_on_lagacy_platform(_inst){
	if(global.player.gravity_dir % 360 == 270){
		y = platform_top_left.y - 9 * global.player.yscale;
	}
	else if(global.player.gravity_dir % 360 == 90){
		y = platform_top_left.y + 9 * global.player.yscale;
	}
	else if(global.player.gravity_dir % 360 == 0){
		x = platform_top_left.x - 9 * abs(global.player.xscale);
	}
	else if(global.player.gravity_dir % 360 == 180){
		x = platform_top_left.x + 9 * abs(global.player.xscale);
	}
}

function settle_on_platform(_inst){
	if(vspd < 0){
		return;
	}
	
	if(fall_from_platform && _inst == previous_platform_id){
		return;
	}
	
	update_platform_top_left(_inst);
	
	if(platform_top_left == undefined){
		return;
	}
	
	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	} // An unit vector indicating the bottom side of the player
	
	var _bx = x + lengthdir_x(7 * global.player.yscale, global.player.gravity_dir);
	var _by = y + lengthdir_y(7 * global.player.yscale, global.player.gravity_dir);
		
	if(global.player.kid_mode == "dotkid"){
		_bx = x + lengthdir_x(1, global.player.gravity_dir);
		_by = y + lengthdir_y(1, global.player.gravity_dir);
	}
		
	var _dir = point_direction(platform_top_left.x, platform_top_left.y, _bx, _by);
	
	var _normal2 = {
		x : lengthdir_x(1, _dir),
		y : lengthdir_y(1, _dir)
	}
	
	if(dot(_normal1, _normal2) < 0 || platform_id != noone){
		
		var _flag = (_inst.object_index == obj_yuuutu_platform || object_is_ancestor(_inst.object_index, obj_yuuutu_platform) ||
					_inst.object_index == obj_verve_platform || object_is_ancestor(_inst.object_index, obj_verve_platform) ||
					_inst.object_index == obj_improved_yuuutu_platform || object_is_ancestor(_inst.object_index, obj_improved_yuuutu_platform))&& 
					global.player.gravity_dir % 90 == 0;
						
		if(!_flag){
			move_contact(global.player.gravity_dir, vspd + 1, _inst);
			// Use move_contact only if the player is above the platform
		
			var _dp = {
				x : _inst.x - _inst.old_x,
				y : _inst.y - _inst.old_y
			}
		
			if(dot(_normal1, _dp) != 0){
				handle_bunnyhop_pixel(_inst);
			}
		}
		else{
			settle_on_lagacy_platform(_inst);
				
			if(_inst.object_index == obj_improved_yuuutu_platform || object_is_ancestor(_inst.object_index, obj_improved_yuuutu_platform)){
				handle_bunnyhop_pixel(_inst);
			}
		}
		
		vspd = 0;
		can_coyote_jump = true;
		jump_total = global.player.jump_total;
		// Refresh vspd and jump
		
		platform_id = _inst; // Receive an id of the platform below the player
		fall_from_platform = false;
	}
}

function escape_from_platform(_inst){
	if(fall_from_platform && _inst == previous_platform_id){
		return;
	}
	
	update_platform_top_left(_inst);
	
	if(platform_top_left == undefined){
		return;	
	}

	var _normal1 = {
		x : lengthdir_x(1, global.player.gravity_dir),
		y : lengthdir_y(1, global.player.gravity_dir)
	} // An unit vector indicating the bottom side of the player
	
	var _dir
	
	if(!_inst.full){
		_dir = point_direction(platform_top_left.x, platform_top_left.y, x, y);
	}
	else{
		var _tx = x + lengthdir_x(13 * global.player.yscale, global.player.gravity_dir - 180);
		var _ty = y + lengthdir_y(13 * global.player.yscale, global.player.gravity_dir - 180);
		
		if(global.player.kid_mode == "dotkid"){
			_tx = x + lengthdir_x(1, global.player.gravity_dir - 180);
			_ty = y + lengthdir_y(1, global.player.gravity_dir - 180);
		}
		
		_dir = point_direction(platform_top_left.x, platform_top_left.y, _tx, _ty);
	}
	
	var _normal2 = {
		x : lengthdir_x(1, _dir),
		y : lengthdir_y(1, _dir)
	} // An unit vertor indicating a direction between the platform's top left and the player's center
	
	if(dot(_normal1, _normal2) <= 0){
		/* If the player's center point exceeds a top side of the platform while touching it,
		(In full platform, if the player's top point exceeds a top side of the platform while touching it)
		teleport the player onto the platform*/
		
		var _dp = {
			x : _inst.x - _inst.old_x,
			y : _inst.y - _inst.old_y
		}
		
		if(!(dot(_normal1, _dp) < 0 && keyboard_check_pressed(global.key_config.jump))){
			
			var _flag = (_inst.object_index == obj_yuuutu_platform || object_is_ancestor(_inst.object_index, obj_yuuutu_platform) ||
					_inst.object_index == obj_verve_platform || object_is_ancestor(_inst.object_index, obj_verve_platform) ||
					_inst.object_index == obj_improved_yuuutu_platform || object_is_ancestor(_inst.object_index, obj_improved_yuuutu_platform))&& 
					global.player.gravity_dir % 90 == 0;
					
			if(!_flag){
				move_outside(global.player.gravity_dir, -1, _inst, true);
				handle_bunnyhop_pixel(_inst);
			}
			else{
				settle_on_lagacy_platform(_inst);
				
				if(_inst.object_index == obj_improved_yuuutu_platform || object_is_ancestor(_inst.object_index, obj_improved_yuuutu_platform)){
					handle_bunnyhop_pixel(_inst);
				}
			}
			
			vspd = 0;
			can_coyote_jump = true;
			jump_total = global.player.jump_total;
			// Refresh vspd and jump
		
			platform_id = _inst; // Receive an id of the platform below the player
			oak_cask_mode = false;
		}
	}
	
}

function descend_from_platform(){
	if(platform_id == noone){
		return;
	}
				
	if(!platform_id.descendable){
		return;
	}
	
	if(!frozen && keyboard_check_pressed(global.key_config.down)){
		fall_from_platform = true;
		previous_platform_id = platform_id;
		platform_id = noone;
	}
}

function handle_platform(){
	refresh_fall_from_platform();
	handle_moving_platform();	
	
	var _inst = instance_place(x, y, obj_platform);
	
	if(_inst != noone && !_inst.bounce && _inst.standable){
		escape_from_platform(_inst);
	}
	
	var _vertical_dx = lengthdir_x(vspd, global.player.gravity_dir);
	var _vertical_dy = lengthdir_y(vspd, global.player.gravity_dir);
	
    _inst = instance_place(x + _vertical_dx, y + _vertical_dy, obj_platform);
	
	if(_inst != noone && _inst.standable){
		settle_on_platform(_inst);
	}
	
	descend_from_platform();
}

function handle_player_movement_and_collision(){
	if(global.game_over){
		return;
	}
	
	handle_old_variables();
	handle_jumping();
	handle_vjump();
	handle_hspd_and_vspd();
	handle_gimmiks();
	handle_dynamic_block();
	handle_push_block();
	handle_slope();
	handle_platform();
	
	var _dx, _dy;
	_dx = lengthdir_x(hspd, global.player.gravity_dir + 90) + lengthdir_x(vspd, global.player.gravity_dir);
	_dy = lengthdir_y(hspd, global.player.gravity_dir + 90) + lengthdir_y(vspd, global.player.gravity_dir);
	var _inst = instance_place(x + _dx, y + _dy, obj_block);
	
	// Check if there's a block on the player's next position
	if(!place_meeting(x + _dx, y + _dy, obj_block)){
		x += _dx;
		y += _dy;
		return;
	} // If there's no block, update the player's position depending on hspd and vspd and exit
	
	var _horizontal_dx = lengthdir_x(hspd, global.player.gravity_dir + 90);
	var _horizontal_dy = lengthdir_y(hspd, global.player.gravity_dir + 90);

	var _dir;
	
	if(place_meeting(x + _horizontal_dx, y + _horizontal_dy, obj_block)){
		// First, check if blocks exist beside the player 
		_dir = (hspd > 0) ? 90 : -90;
		move_contact(global.player.gravity_dir + _dir, abs(hspd), obj_block);
		// If blocks exist, use move_contact to let the player lean on the block
		hspd = 0;
	}
	
	var _vertical_dx = lengthdir_x(vspd, global.player.gravity_dir);
	var _vertical_dy = lengthdir_y(vspd, global.player.gravity_dir);

	if(place_meeting(x + _vertical_dx, y + _vertical_dy, obj_block)){
		// Check if blocks exist below the player or above the player
		_dir = (vspd > 0) ? 0 : -180;
		move_contact(global.player.gravity_dir + _dir, abs(vspd) + 1, obj_block);
		// If blocks exist, use move_contact to let the player settle on the ground or hit the ceiling
		
		if(vspd < 0){
			// When the player hits the ceiling
			oak_cask_mode = false;
			vspd = 0;
			// Refresh vspd
		}
		else{
			// When the player lands on the block
			vspd = 0;
			jump_total = global.player.jump_total;
			can_coyote_jump = true;
			// Refresh vspd and jump
			
			_dx = lengthdir_x(1, global.player.gravity_dir);
			_dy = lengthdir_y(1, global.player.gravity_dir);

			_inst = instance_place(x + _dx, y + _dy, obj_block);
			
			if(_inst != noone){
				if(_inst.object_index == obj_dynamic_block || object_is_ancestor(_inst.object_index, obj_dynamic_block)){
					dynamic_block_id = _inst;
				}
				else if(_inst.object_index == obj_slip_block || object_is_ancestor(_inst.object_index, obj_slip_block)){
					slip_block_id = _inst;
				}
				else if(_inst.object_index == obj_slide_block || object_is_ancestor(_inst.object_index, obj_slide_block)){
					slide_block_id = _inst;
				}
				else if(_inst.object_index == obj_panda_black_block || _inst.object_index == obj_panda_white_block){
					panda_block_id = _inst;
				}
			}
			// While settling on the block, get ids of specific block objects.
			
			purple_walljumping = false;
			fire_walljumping = false;

			on_block = true;
		}
	}
	
	_dx = lengthdir_x(hspd, global.player.gravity_dir + 90) + lengthdir_x(vspd, global.player.gravity_dir);
	_dy = lengthdir_y(hspd, global.player.gravity_dir + 90) + lengthdir_y(vspd, global.player.gravity_dir);

	if(place_meeting(x + _dx, y + _dy, obj_block)){
		// In this case, the player is going to the corner
		// Refresh hspd if there is still a collision
		hspd = 0;
	}
	
	// After refreshing hspd and vspd, add remaining values to the player
	x += lengthdir_x(hspd, global.player.gravity_dir + 90) + lengthdir_x(vspd, global.player.gravity_dir);
	y += lengthdir_y(hspd, global.player.gravity_dir + 90) + lengthdir_y(vspd, global.player.gravity_dir);
}

function handle_collision_variables(){
	//It literally handles all variables related to the player's collision
	
	water_id = get_id_in_collided_instances_ext(obj_water_parent);
	jump_refresher_id = get_id_in_collided_instances(obj_jump_refresher);
	jump_star_id = get_id_in_collided_instances(obj_jump_star);
	gravity_changer_id = get_id_in_collided_instances(obj_gravity_changer);
	
	var _dx = lengthdir_x(1, global.player.gravity_dir);
	var _dy = lengthdir_y(1, global.player.gravity_dir);
	
	if(on_block){
		if(!place_meeting(x + _dx, y + _dy, obj_block)){
			on_block = false;
			panda_block_id = noone;
			slip_block_id = noone;
			slide_block_id = noone;
		}
	}
	
	if(dynamic_block_id != noone){
		if(!place_meeting(x + _dx, y + _dy, dynamic_block_id)){
			dynamic_block_id = noone;
		}
	}
	
	if(on_ladder){
		var _flag = get_id_in_collided_instances(obj_ladder) == noone ||
					(on_block &&
					!keyboard_check_pressed(global.key_config.up));
					
		if(_flag){
			on_ladder = false;
			vspd = 0;
			fall_from_platform = false;
		}
	}
	
	if(platform_id != noone){
		if(!place_meeting(x + _dx, y + _dy, platform_id)){
			if(platform_id.snapless){
				fall_from_platform = true;
				previous_platform_id = platform_id;
			}
			
			platform_id = noone;
			
			if(!keyboard_check_pressed(global.key_config.jump)){
				vspd = platform_escaping_spd;
			}
		}
	}
	
	var _flag = 
		keyboard_check_pressed(global.key_config.jump) ||
		on_block;
	
	if(_flag){
		previous_platform_id = noone;
	}
	
	collided_instances = [];
}