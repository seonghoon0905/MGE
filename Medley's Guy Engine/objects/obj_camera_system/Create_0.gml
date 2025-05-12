// This must be only placed in "rm_init"

event_user(0); // local library
event_user(1); // debug library

offset_x = DEFAULT_CAMERA_WIDTH / 2;
offset_y = DEFAULT_CAMERA_HEIGHT / 2;
debug_camera_mode = false;
debug_camera_zoom = 1;

if(instance_exists(obj_player)){
	debug_camera_moving_around_x = obj_player.x;
	debug_camera_moving_around_y = obj_player.y;
}

debug_zoom_bar_surf = surface_create(100, 30);

//event functions
function room_start(){
	set_default_view_and_camera();
}

function end_step(){
	toggle_debug_camera_mode();
	set_debug_camera_zoom();
	make_debug_zoom_bar_surf();
}

function draw_gui(){
	draw_debug_info();
}