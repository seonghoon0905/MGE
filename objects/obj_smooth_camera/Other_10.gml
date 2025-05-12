/// @description local library

function set_camera_position_within_room(){
	if(x < offset_x){
		x = offset_x;
	}
	else if(x > room_width - offset_x){
		x = room_width - offset_x;
	}
	if(y < offset_y){
		y = offset_y;
	}
	else if(y > room_height - offset_y){
		y = room_height - offset_y;
	}
}
function initialize_camera_position(){
	if(!instance_exists(obj_player)){
		return;
	}

	x = obj_player.x;
	y = obj_player.y;
	set_camera_position_within_room();
	
	camera_x = x;
	camera_y = y;
}

function smooth_camera_follow_player(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(keyboard_check_pressed(global.key_config.load)){
		x = global.player_data.x;
		y = global.player_data.y;
	}
	else{
		x += (obj_player.x - x) / follow_latency;
		y += (obj_player.y - y) / follow_latency;
	}
}

function set_camera_position(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	smooth_camera_follow_player();
	set_camera_position_within_room();
	camera_x = x - offset_x;
	camera_y = y - offset_y;
	camera_set_view_pos(view_camera[0], camera_x, camera_y);
}