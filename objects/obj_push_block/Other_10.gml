/// @description Movement & Collision
function handle_respawning_mode(){
	if(!respawning_mode){
		return;
	}
	
	if(keyboard_check_pressed(global.key_config.load)){
		x = xstart;
		y = ystart;
		
		hspd = 0;
		vspd = 0;
		
		sprite_index = surf_sprite;
		visible = true;
		
		on_block = false;
		
		platform_top_left = undefined;
		platform_id = noone;
		platform_escaping_spd = 0;
		
		dynamic_block_id = noone;
		slide_block_id = noone;
		
		box_kill = false;
		box_kill_initialized = false;
	}
}

function handle_old_variables(){
	old_x = x;
	old_y = y;
	old_hspd = hspd;
	old_vspd = vspd;
}

function handle_hspd_on_slide_block(){
	if(slide_block_id == noone){
		return;
	}
	
	var _normal1 = {
		x : lengthdir_x(1, gravity_dir),
		y : lengthdir_y(1, gravity_dir)
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
	handle_hspd_on_slide_block();
	
	// Accelerate vspd with grav
	vspd += gravity_pull;
	
	if(vspd > max_vspd){
		vspd = max_vspd;
	}
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
	
	if(dynamic_block_id == noone){
		return;
	} // Exit if there's no a dynamic block the player is on
	
	var _normal1 = {
		x : lengthdir_x(1, gravity_dir + 90),
		y : lengthdir_y(1, gravity_dir + 90)
	} // An unit vector indicating the right side of the player
	
	var _normal2 = {
		x : lengthdir_x(1, gravity_dir),
		y : lengthdir_y(1, gravity_dir)
	} // An unit vector indicating the bottom side of the player
	
	var _dp = {
		x : dynamic_block_id.x - dynamic_block_id.old_x,
		y : dynamic_block_id.y - dynamic_block_id.old_y
	} // Increment of the dynamic block's position 

	hspd += dot(_dp, _normal1); 
	/* Add a dot product of dp and normal1 to hspd
	It means horizontal increment of the block in the player's perspective
	(We should consider that the direction of the player's gravity can be altered) */
	
	if(dot(_dp, _normal2) > 0){ 
		// We don't need to check when the block goes up because of move_outside in move_contact's guard clause
		vspd += dot(_dp, _normal2);
		// Add dot product of dp and normal2(It means vertical increment of the block) to vspd
	}
}

function update_platform_top_left(_inst){
	// It updates the platform's top left / top right / bottom left point 
	// Points are different depending on the direction of the block's gravity

	var _angle = _inst.image_angle; 
	var _epsilon = 0.1; // For floating point comparision
	
	var _normal1 = {
		x : lengthdir_x(1, gravity_dir),
		y : lengthdir_y(1, gravity_dir)
	}

	var _normal2 = {
		x : lengthdir_x(1, _angle),
		y : lengthdir_y(1, _angle)
	}
	
	var _top_detect = abs(dot(_normal1, _normal2)) < _epsilon && cross(_normal1, _normal2) < 0;
	var _left_detect = dot(_normal1, _normal2) >= 1 - _epsilon;
	var _bottom_detect = abs(dot(_normal1, _normal2)) < _epsilon && cross(_normal1, _normal2) > 0;
	var _right_detect = dot(_normal1, _normal2) <= -1 + _epsilon;

	var _width = _inst.sprite_width;
	var _height = _inst.sprite_height;
	
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
	else{
		platform_top_left = undefined;
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
		x : lengthdir_x(1, gravity_dir + 90),
		y : lengthdir_y(1, gravity_dir + 90)
	}

	var _normal2 = {
		x : lengthdir_x(1, gravity_dir),
		y : lengthdir_y(1, gravity_dir)
	}
	
	hspd += dot(_dp, _normal1);
	
	var _dot = dot(_dp, _normal2);
	
	vspd += _dot;
		
	if(_dot > 0){
		platform_escaping_spd = _dot;
	}
	else{
		platform_escaping_spd = 0;
	}
}

function handle_bunnyhop_pixel(_obj, _limit = 3){
	var _vertical_dx = lengthdir_x(gravity_pull, gravity_dir);
	var _vertical_dy = lengthdir_y(gravity_pull, gravity_dir);
	
	var _cnt = 0;
	while(_cnt <= _limit && !place_meeting(x + _vertical_dx, y + _vertical_dy, _obj)){
		x += _vertical_dx;
		y += _vertical_dy;
		_cnt++;
	}
	
	vspd = 0;
	on_block = true;
}

function settle_on_platform(_inst){
	if(vspd < 0){
		return;
	}
	
	update_platform_top_left(_inst);
	
	if(platform_top_left == undefined){
		return;
	}
	
	var _bx = x + lengthdir_x(14 * image_yscale, gravity_dir);
	var _by = y + lengthdir_y(14 * image_yscale, gravity_dir);
	
	var _normal1 = {
		x : lengthdir_x(1, gravity_dir),
		y : lengthdir_y(1, gravity_dir)
	} // An unit vector indicating the bottom side of the player
	
	var _normal2 = {
		x : lengthdir_x(1, point_direction(platform_top_left.x, platform_top_left.y, _bx, _by)),
		y : lengthdir_y(1, point_direction(platform_top_left.x, platform_top_left.y, _bx, _by))
	}

	if(dot(_normal1, _normal2) < 0){
		move_contact(gravity_dir, vspd + 1, _inst);
		// Use move_contact only if the player is above the platform
		
		var _dp = {
			x : _inst.x - _inst.old_x,
			y : _inst.y - _inst.old_y
		}
		
		if(dot(_normal1, _dp) != 0){
			handle_bunnyhop_pixel(_inst);
		}
		
		vspd = 0;
		platform_id = _inst; // Receive an id of the platform below the player
	}
}

function escape_from_platform(_inst){
	update_platform_top_left(_inst);
	
	if(platform_top_left == undefined){
		return;	
	}

	var _normal1 = {
		x : lengthdir_x(1, gravity_dir),
		y : lengthdir_y(1, gravity_dir)
	} // An unit vector indicating the bottom side of the player

	var _normal2 = {
		x : lengthdir_x(1, point_direction(platform_top_left.x, platform_top_left.y, x, y)),
		y : lengthdir_y(1, point_direction(platform_top_left.x, platform_top_left.y, x, y))
	} // An unit vertor indicating a direction between the platform's top left and the player's center
	
	if(dot(_normal1, _normal2) <= 0){
		move_outside(gravity_dir, -1, _inst, true);
		/* If the player's center point exceeds a top side of the platform while touching it,
		teleport the player onto the platform*/
		
		vspd = 0;
		platform_id = _inst; // Receive an id of the platform below the player
	}
}

function handle_platform(){
	handle_moving_platform();	
	
	var _inst = instance_place(x, y, obj_platform);
	
	if(_inst != noone){
		escape_from_platform(_inst);
	}
	
	var _vertical_dx = lengthdir_x(vspd, gravity_dir);
	var _vertical_dy = lengthdir_y(vspd, gravity_dir);
	
	_inst = instance_place(x + _vertical_dx, y + _vertical_dy, obj_platform);
	
	if(_inst != noone){
		settle_on_platform(_inst);
	}
}

function handle_push_block_movement_and_collision(){
	handle_old_variables();
	handle_hspd_and_vspd();
	handle_dynamic_block();
	handle_platform();
	
	var _dx, _dy;
	_dx = lengthdir_x(hspd, gravity_dir + 90) + lengthdir_x(vspd, gravity_dir);
	_dy = lengthdir_y(hspd, gravity_dir + 90) + lengthdir_y(vspd, gravity_dir);
	
	if(!place_meeting(x + _dx, y + _dy, obj_block)){
		x += _dx;
		y += _dy;
		return;
	}
	
	var _horizontal_dx = lengthdir_x(hspd, gravity_dir + 90);
	var _horizontal_dy = lengthdir_y(hspd, gravity_dir + 90);
	
	var _dir;
	if(place_meeting(x + _horizontal_dx, y + _horizontal_dy, obj_block)){
		_dir = (hspd > 0) ? 90 : -90;
		move_contact(gravity_dir + _dir, abs(hspd), obj_block);
		hspd = 0;
	}
	
	var _vertical_dx = lengthdir_x(vspd, gravity_dir);
	var _vertical_dy = lengthdir_y(vspd, gravity_dir);
	
	if(place_meeting(x + _vertical_dx, y + _vertical_dy, obj_block)){
		_dir = (vspd > 0) ? 0 : -180;
		move_contact(gravity_dir + _dir, abs(vspd) + 1, obj_block);
		
		if(vspd < 0){
			vspd = 0;
		}
		else{
			vspd = 0;
			
			_dx = lengthdir_x(1, gravity_dir);
			_dy = lengthdir_y(1, gravity_dir);
			var _inst = instance_place(x + _dx, y + _dy, obj_block);
			
			if(_inst != noone){
				if(_inst.object_index == obj_slide_block || object_is_ancestor(_inst.object_index, obj_slide_block)){
					slide_block_id = _inst;
				}
				else if(_inst.object_index == obj_dynamic_block || object_is_ancestor(_inst.object_index, obj_dynamic_block)){
					dynamic_block_id = _inst;
				}
			}
			
			on_block = true;
		}
	}
	
	_dx = lengthdir_x(hspd, gravity_dir + 90) + lengthdir_x(vspd, gravity_dir);
	_dy = lengthdir_y(hspd, gravity_dir + 90) + lengthdir_y(vspd, gravity_dir);
	
	if(place_meeting(x + _dx, y + _dy, obj_block)){
		hspd = 0;
	}
	
	x += lengthdir_x(hspd, gravity_dir + 90) + lengthdir_x(vspd, gravity_dir);
	y += lengthdir_y(hspd, gravity_dir + 90) + lengthdir_y(vspd, gravity_dir);
}

function handle_collision_variables(){
	var _dx = lengthdir_x(1, gravity_dir);
	var _dy = lengthdir_y(1, gravity_dir);
	
	if(on_block){
		if(!place_meeting(x + _dx, y + _dy, obj_block)){
			on_block = false;
			slide_block_id = noone;
		}
	}
	
	if(dynamic_block_id != noone){
		if(!place_meeting(x + _dx, y + _dy, dynamic_block_id)){
			dynamic_block_id = noone;
		}
	}

	if(platform_id != noone){
		if(!place_meeting(x + _dx, y + _dy, platform_id)){
			platform_id = noone;
			vspd = platform_escaping_spd;
		}
	}
}

function be_pushed(){
	var _dir = other.hspd > 0 ? -90 : 90;
	move_outside(gravity_dir + _dir, abs(other.hspd) + 1, other.id);
	
	if(place_meeting(x, y, obj_slope)){
		move_outside(gravity_dir, abs(other.hspd) + 1, obj_block);
		
		var _saved_x = x;
		var _saved_y = y;
		var _cur = 0;
		var _contact = false;
	
		while(place_meeting(x, y, obj_block)){
			x = _saved_x;
			y = _saved_y;
			x += lengthdir_x(_cur * -sign(other.hspd), global.player.gravity_dir + 90);
			y += lengthdir_y(_cur * -sign(other.hspd), global.player.gravity_dir + 90);
			move_outside(global.player.gravity_dir - 180, abs(other.hspd) + 1, obj_block);
			_cur++;
			_contact = true;
		}
		
		if(_contact){
			move_contact(global.player.gravity_dir, abs(hspd) + 1, obj_block);
		}
	
		handle_bunnyhop_pixel(obj_block);
	}
	
	if(!place_meeting(x, y, obj_block)){
		var _vertical_dx = lengthdir_x(abs(other.hspd) + 1, gravity_dir);
		var _vertical_dy = lengthdir_y(abs(other.hspd) + 1, gravity_dir);
	
		if(place_meeting(x + _vertical_dx, y + _vertical_dy, obj_slope)){
			move_contact(gravity_dir, abs(other.hspd) + 1, obj_block);
		}
	}
}