saved = false; 
frozen_time = 0;
time_limit = 30;
gravity_dir = image_angle + 270;

image_speed = 0;
image_index = 0;
image_xscale = floor(gravity_dir / 180) % 2 == 1 ? 1 : -1;

// event function 
function step(){
	if(saved){
		frozen_time++;
		if(frozen_time > time_limit){
			saved = false;
			image_index = 0;
		}
	}
	
	var _epsilon = 0.01;
	if(abs(global.player.gravity_dir - gravity_dir) > _epsilon){
		return;
	}
	
	if(!place_meeting(x, y, obj_player)){
		return;
	}
	
	if(!saved && keyboard_check_pressed(global.key_config.save)){
		saved = true;
		frozen_time = 0;
		save_player_data();
		image_index = 1;
	}
}