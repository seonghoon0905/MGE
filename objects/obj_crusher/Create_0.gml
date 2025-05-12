image_speed = 0;
hspd = 0;
vspd = 0;
max_spd = 5;
is_crusher_moving = false;
frozen_time_limit = 30;
frozen_time = frozen_time_limit;

event_user(0); // local library

// event functions
function begin_step(){
	old_x = x;
	old_y = y;
	
	handle_respawning_mode();
	find_player();
	go_to_player();

	x = round(x);
	y = round(y);
}