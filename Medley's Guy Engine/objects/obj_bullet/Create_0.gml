//event functions 
function end_step(){
	if(place_meeting(x, y, [obj_block, obj_death_block])){
		instance_destroy();
	}
	
	if(keyboard_check_pressed(global.key_config.load)){
		instance_destroy();
	}
}

function outside_room(){
	instance_destroy();
}