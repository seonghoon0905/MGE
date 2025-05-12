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

	x = (obj_player.x div DEFAULT_CAMERA_WIDTH) * DEFAULT_CAMERA_WIDTH;
	y = (obj_player.y div DEFAULT_CAMERA_HEIGHT) * DEFAULT_CAMERA_HEIGHT;

	camera_x = x;
	camera_y = y;
}

function set_fixed_camera_position(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(keyboard_check_pressed(global.key_config.load)){
		var _x = clamp(global.player_data.x, 0, room_width - 1);
		var _y = clamp(global.player_data.y, 0, room_height - 1);
		x = (_x div DEFAULT_CAMERA_WIDTH) * DEFAULT_CAMERA_WIDTH;
		y = (_y div DEFAULT_CAMERA_HEIGHT) * DEFAULT_CAMERA_HEIGHT;
	}
	else{
		var _x = clamp(obj_player.x, 0, room_width - 1);
		var _y = clamp(obj_player.y, 0, room_height - 1);
		x = (_x div DEFAULT_CAMERA_WIDTH) * DEFAULT_CAMERA_WIDTH;
		y = (_y div DEFAULT_CAMERA_HEIGHT) * DEFAULT_CAMERA_HEIGHT;
	}
}

function set_camera_position(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	set_fixed_camera_position();
	camera_x = x;
	camera_y = y;
	camera_set_view_pos(view_camera[0], camera_x, camera_y);
}