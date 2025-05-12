/// @description local library
function destroy_view_and_camera(){
	camera_destroy(view_camera[0]);
	
	if(view_enabled){
		view_visible[0] = false;
	    view_enabled = false;
	}
}

function set_default_view_and_camera(){
	destroy_view_and_camera();
	
	if(!view_enabled){
		view_visible[0] = true;
	    view_enabled = true;
	}
	
	view_set_xport(0, 0);
	view_set_yport(0, 0);
	view_set_wport(0, DEFAULT_CAMERA_WIDTH);
	view_set_hport(0, DEFAULT_CAMERA_HEIGHT);
	
	view_camera[0] = camera_create_view(0, 0, DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT);
	
	if(instance_exists(obj_player)){
		if(global.player.screen_rotated){
			camera_set_view_angle(view_camera[0], 180);
		}
		else{
			camera_set_view_angle(view_camera[0], 0);
		}
	}
}
