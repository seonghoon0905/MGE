offset_x = DEFAULT_CAMERA_WIDTH / 2;
offset_y = DEFAULT_CAMERA_HEIGHT / 2;
follow_latency = 7;
camera_x = 0;
camera_y = 0;

event_user(0); // local library

//event functions
function step(){
	set_camera_position();
}

function room_start(){
	initialize_camera_position();
}