event_inherited();

hspd = 0; // Added to "x" on every frame
vspd = 0; // Added to "y" on every frame

old_hspd = hspd; // Value that hspd had one frame before 
old_vspd = vspd; // Value that vspd had one frame before 

gravity_dir = image_angle + 270;
gravity_pull = 0.4; // Added to vspd on every frame
max_vspd = 9.4; // Limits max value of vspd

on_block = false;

dynamic_block_id = noone;
slide_block_id = noone;

platform_top_left = undefined;
platform_id = noone;
platform_escaping_spd = 0;

respawning_mode = true;

box_kill = false;
box_kill_initialized = false;

surf_sprite = sprite_index
surf_pos_list = [];
surf_spd_list = [];
surf_start_xscale = 1;
surf_start_yscale = 1;
surf_start_angle = 0;
surf_start_alpha = 1;
surf_alpha = 1;
surf_anim_time = 0;
surf_vspd = 0;

event_user(0); // Movement & Collision
event_user(1); // BoxKill

//event functions
function step(){
	if(!box_kill){
		handle_push_block_movement_and_collision();
		handle_collision_variables();
		handle_stucking_in_block();
		hspd = 0;
	}
}

function end_step(){
	handle_respawning_mode();
}


function draw(){
	if(!box_kill){
		draw_self();
	}
	else{
		initialize_box_kill_effect();
		handle_box_kill_effect();
	}
}