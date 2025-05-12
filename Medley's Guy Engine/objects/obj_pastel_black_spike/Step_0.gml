if(keyboard_check_pressed(global.key_config.load)){
	x = xstart;
	y = ystart;
	hspd = 0;
	vspd = 0;
}

var _collision_response = false;
if(hspd != 0 || vspd != 0){
	if(!place_meeting(x + hspd, y + vspd, obj_block)){
		x += hspd;
		y += vspd;
	}
	else{
		_collision_response = true;
	}
}

if(_collision_response){
	if(place_meeting(x + hspd, y, obj_block)){
		var _dir = hspd > 0 ? 0 : 180;
		move_contact(_dir, abs(hspd) + 1, obj_block);
	}
	
	if(place_meeting(x, y + vspd, obj_block)){
		var _dir = vspd > 0 ? 270 : 90;
		move_contact(_dir, abs(vspd) + 1, obj_block);
	}
	
	hspd = 0;
	vspd = 0;
}