full = false
snapless = true;
standable = true;
bounce = false;
descendable = false;
help_message = true;

/*
	full : If it's true, the player can be snapped to the platform when the player's top point exceeds the top side of it
	
	snapless : If it's true, the player can't snap on platform if he falls down from the platform directly
	
	standable : If it's true, the player can stand on the platform
	
	bounce : If it's true, the player can preserve his vertical speed when he jumps out of the platform
	
	descendable : If it's true, the player can descend from the platform directly with the down key
	
	help_message : If it's true, "Press down to descend" appears when descendable is true
*/


respawning_mode = true;

hspd = undefined;
vspd = undefined;

gravity_dir = image_angle + 270;

hspd_start = 0;
vspd_start = 0;

is_start_value_saved = false;

old_x = x;
old_y = y;

real_x = x;
real_y = y;

event_user(0); // Movement & Collision
