mom = noone;
mom_start_angle = 0;
mom_start_xscale = 0;
mom_start_yscale = 0;
mom_start_alpha = 0;


speed_mode = false;
speed_mode_hspd = 0;
speed_mode_vspd = 0;

vector_mode = false;
vector_mode_spd = 0;
vector_mode_dir = 0;

projectile_mode = false;
projectile_gravity_pull = 0;
projectile_gravity_dir = 0;

point_mode = false;
point_xstart = 0;
point_ystart = 0;
point_to_x = 0;
point_to_y = 0;

loop_point_mode = false;
loop_point_mode_reverse = false;
loop_point_xstart = 0;
loop_point_ystart = 0;
loop_point_to_x = 0;
loop_point_to_y = 0;
loop_point_count = 0;
loop_point_count_limit = infinity;

dx_dy_mode = false;
dx_dy_mode_dx = 0;
dx_dy_mode_dy = 0;

loop_dx_dy_mode = false;
loop_dx_dy_mode_reverse = false;

rotation_mode = false;
rotation_center_x = 0;
rotation_center_y = 0;
rotation_radius = 0;
rotation_start_angle = 0;
rotation_to_angle = 0;

loop_rotation_mode = false;
loop_rotation_mode_reverse = false;
loop_rotation_start_angle = 0;
loop_rotation_to_angle = 0;

endless_rotation_mode = false;
endless_rotation_angle = 0;
endless_rotation_angular_speed = 0;

rotation_in_eclipse_mode = false;
rotation_horizontal_ratio = 1;
rotation_vertical_ratio = 1;

loop_rotation_in_eclipse_mode = false;
loop_rotation_in_eclipse_mode_reverse = false;

endless_rotation_in_eclipse_mode = false;

movement_anim_time = 0;
movement_anim_time_limit = 0;
movement_anim_curve = ac_linear;


image_rotation_mode = false;
image_rotation_start_angle = 0;
image_rotation_end_angle = 0;

loop_image_rotation_mode = false;
loop_image_rotation_mode_reverse = false;
loop_image_rotation_start_angle = 0;
loop_image_rotation_end_angle = 0;
loop_image_rotation_count = 0;
loop_image_rotation_count_limit = 0;

endless_image_rotation_mode = false;
endless_image_rotation_angular_speed = 0;

image_rotation_anim_time = 0;
image_rotation_anim_time_limit = 0;
image_rotation_anim_curve = ac_linear;


scale_mode = false;
scale_start_xscale = 0;
scale_start_yscale = 0;
scale_to_xscale = 0;
scale_to_yscale = 0;

loop_scale_mode = false;
loop_scale_mode_reverse = false;
loop_scale_start_xscale = 0;
loop_scale_start_yscale = 0;
loop_scale_to_xscale = 0;
loop_scale_to_yscale = 0;
loop_scale_count = 0;
loop_scale_count_limit = infinity;

scale_anim_time = 0;
scale_anim_time_limit = 0;
scale_anim_curve = ac_linear;


alpha_mode = false;
alpha_mode_start_alpha = 0;
alpha_mode_to_alpha = 0;

loop_alpha_mode = false;
loop_alpha_mode_reverse = false;
loop_alpha_start_alpha = 0;
loop_alpha_to_alpha = 0;
loop_alpha_count = 0;
loop_alpha_count_limit = 0;

alpha_anim_time = 0;
alpha_anim_time_limit = 0;
alpha_anim_curve = ac_linear;


scatter_mode = false;
scatter_initialized = false;
scatter_surf_list = [];
scatter_surf_pos_list = [];
scatter_surf_spd_list = [];
scatter_surf_anim_time = 0;
scatter_surf_start_xscale = 0;
scatter_surf_start_yscale = 0;
scatter_surf_start_angle = 0;
scatter_surf_start_alpha = 0;
scatter_surf_alpha = 0;
scatter_surf_vspd = 0;


stop_moving_mode = false;
stop_image_rotation_mode = false;
stop_scaling_mode = false;
stop_fading_mode = false;
stop_all_mode = false;


xoffset = undefined;
yoffset = undefined;
start_xpos = 0;
start_ypos = 0;
angle = 0;
radius = 0;
is_offset_variables_initialized = false;


moving = false;
image_rotating = false;
scaling = false;
fading = false;
activated = false;

activation_time = 0;
activation_time_limit = 0;

event_user(0); // local library

// event functions 
function begin_step(){
	moving = false;
	image_rotating = false;
	scaling = false;
	fading = false;
	activated = false;
	
	initialize_offset_variables();
	
	// Moving
	handle_speed_mode();
	handle_vector_mode();
	handle_projectile_mode();
	handle_point_mode();
	handle_loop_point_mode();
	handle_dx_dy_mode();
	handle_loop_dx_dy_mode();
	handle_rotation_mode();
	handle_loop_rotation_mode();
	handle_endless_rotation_mode();
	handle_rotation_in_eclipse_mode();
	handle_loop_rotation_in_eclipse_mode();
	handle_endless_rotation_in_eclipse_mode();
	
	// Image Rotation
	handle_image_rotation_mode();
	handle_loop_image_rotation_mode();
	handle_endless_image_rotation_mode();
	
	// Scaling
	handle_scale_mode();
	handle_loop_scale_mode();
	
	// Fading
	handle_alpha_mode();
	handle_loop_alpha_mode();
	
	
	adjust_position_with_offset();
	
	handle_activation_time();
	
	mom.trigger_id.moving = moving;
	mom.trigger_id.image_rotating = image_rotating;
	mom.trigger_id_scaling = scaling;
	mom.trigger_id.fading = fading;
	mom.trigger_id.activated = activated;
	
	handle_stop_moving_mode();
	handle_stop_image_rotation_mode();
	handle_stop_scaling_mode();
	handle_stop_fading_mode();
	handle_stop_all_mode();
}

function step(){
	if(keyboard_check_pressed(global.key_config.load)){
		refresh_supporter();
	}
}

function draw(){
	handle_scatter_mode();
}