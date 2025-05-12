/// @description Movement & Collision
function handle_movement_and_bounce(){
	var _check = [obj_block, obj_platform_fence];

	array_push(_check, obj_platform_fence);
	
	var _horizontal_dx = 0, _horizontal_dy = 0;
	_horizontal_dx = (hspd != undefined) ? lengthdir_x(hspd, gravity_dir + 90) : 0;
	_horizontal_dy = (hspd != undefined) ? lengthdir_y(hspd, gravity_dir + 90) : 0;
	
	var _vertical_dx = 0, _vertical_dy = 0;
	_vertical_dx = (vspd != undefined) ? lengthdir_x(vspd, gravity_dir) : 0;
	_vertical_dy = (vspd != undefined) ? lengthdir_y(vspd, gravity_dir) : 0;
	
	var _dx = _horizontal_dx + _vertical_dx;
	var _dy = _horizontal_dy + _vertical_dy;
	
	if(!place_meeting(real_x + _dx, real_y + _dy, _check)){
		real_x += _dx;
		real_y += _dy;
		x = round(real_x);
		y = round(real_y);
		return;
	}
	
	var _dir, _change_hspd = false, _change_vspd = false;
	
	if(hspd != undefined){
		_horizontal_dx = lengthdir_x(hspd, gravity_dir + 90);
		_horizontal_dy = lengthdir_y(hspd, gravity_dir + 90);
	
		if(place_meeting(real_x + _horizontal_dx, real_y + _horizontal_dy, _check)){
			_dir = (hspd > 0) ? 90 : -90;
			move_contact(gravity_dir + 90, abs(hspd) + 1, _check);
			hspd *= -1;
			_change_hspd = true;
		}
	}
	
	if(vspd != undefined){
		_vertical_dx = lengthdir_x(vspd, gravity_dir);
		_vertical_dy = lengthdir_y(vspd, gravity_dir);
	
		if(place_meeting(real_x + _vertical_dx, real_y + _vertical_dy, _check)){
			_dir = (vspd > 0) ? 0 : -180;
			move_contact(gravity_dir + _dir, abs(vspd) + 1, _check);
			vspd *= -1;
			_change_vspd = true;
		}
	}
	
	_horizontal_dx = (hspd != undefined) ? lengthdir_x(hspd, gravity_dir + 90) : 0;
	_horizontal_dy = (hspd != undefined) ? lengthdir_y(hspd, gravity_dir + 90) : 0;
	
	_vertical_dx = (vspd != undefined) ? lengthdir_x(vspd, gravity_dir) : 0;
	_vertical_dy = (vspd != undefined) ? lengthdir_y(vspd, gravity_dir) : 0;
	
	_dx = _horizontal_dx + _vertical_dx;
	_dy = _horizontal_dy + _vertical_dy;
	
	if(place_meeting(real_x + _dx, real_y + _dy, _check)){
		hspd *= -1;
		_change_hspd = true;
	}
	
	_horizontal_dx = (hspd != undefined) ? lengthdir_x(hspd, gravity_dir + 90) : 0;
	_horizontal_dy = (hspd != undefined) ? lengthdir_y(hspd, gravity_dir + 90) : 0;
	
	_vertical_dx = (vspd != undefined) ? lengthdir_x(vspd, gravity_dir) : 0;
	_vertical_dy = (vspd != undefined) ? lengthdir_y(vspd, gravity_dir) : 0;
	
	real_x += _horizontal_dx + _vertical_dx;
	real_y += _horizontal_dy + _vertical_dy;
	
	x = round(real_x);
	y = round(real_y);
}