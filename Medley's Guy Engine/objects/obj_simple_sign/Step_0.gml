if(instance_exists(obj_player)){
	if(place_meeting(x, y, obj_player)){
		if(keyboard_check_pressed(global.key_config.up)){
			touch = true;
		}
	}
	else{
		touch = false;
	}
}