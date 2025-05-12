old_x = x;
old_y = y;

if(!is_start_value_saved){
	if(hspd != undefined){
		hspd_start = hspd;
	}
	
	if(vspd != undefined){
		vspd_start = vspd;
	}
	
	is_start_value_saved = true;
}

if(respawning_mode && keyboard_check_pressed(global.key_config.load)){
	x = xstart;
	y = ystart;
	real_x = x;
	real_y = y;
	
	if(hspd != undefined){
		hspd = hspd_start;
	}
	
	if(vspd != undefined){
		vspd = vspd_start;
	}
}

if(hspd != undefined || vspd != undefined){
	handle_movement_and_bounce();
}
