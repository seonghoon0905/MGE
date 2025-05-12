/// @description local library
function refresh_supporter(){
	make_collidable(mom);
	mom.x = mom.xstart;
	mom.y = mom.ystart;
		
	mom.hspeed = 0;
	mom.vspeed = 0;
	mom.speed = 0;
	mom.gravity = 0;
	mom.gravity_direction = 0;
		
	mom.image_angle = mom_start_angle;
	mom.image_xscale = mom_start_xscale;
	mom.image_yscale = mom_start_yscale;
	mom.image_alpha = mom_start_alpha;
		
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
	is_offset_variables_initialized = false;
}

function refresh_moving(){
	mom.hspeed = 0;
	mom.vspeed = 0;
	mom.speed = 0;
	mom.gravity = 0;
	mom.gravity_direction = 0;
	
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
	
	stop_moving_mode = false;
	stop_all_mode = false;
}

function refresh_image_rotating(){
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
	
	stop_image_rotation_mode = false;
	stop_all_mode = false;
}

function refresh_scaling(){
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
	
	stop_scaling_mode = false;
	stop_all_mode = false;
}

function refresh_fading(){
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
	
	stop_fading_mode = false;
	stop_all_mode = false;
}

function initialize_offset_variables(){
	if(xoffset == undefined || yoffset == undefined){
		return;
	}
	
	if(!is_offset_variables_initialized){
		start_xpos = mom.x + xoffset;
		start_ypos = mom.y + yoffset;
		angle = point_direction(xoffset, yoffset, 0, 0);
		radius = point_distance(0, 0, xoffset, yoffset);
		is_offset_variables_initialized = true;
	}
}

function handle_speed_mode(){
	if(!speed_mode){
		return;
	}
	
	moving = true;
	
	mom.x += speed_mode_hspd;
	mom.y += speed_mode_vspd;
}

function handle_vector_mode(){
	if(!vector_mode){
		return;
	}
	
	moving = true;
	
	speed_mode_hspd = lengthdir_x(vector_mode_spd, vector_mode_dir);
	speed_mode_vspd = lengthdir_y(vector_mode_spd, vector_mode_dir);
	
	mom.x += speed_mode_hspd;
	mom.y += speed_mode_vspd;
}

function handle_projectile_mode(){
	if(!projectile_mode){
		return;
	}
	
	moving = true;
	
	speed_mode_hspd += lengthdir_x(projectile_gravity_pull, projectile_gravity_dir);
	speed_mode_vspd += lengthdir_y(projectile_gravity_pull, projectile_gravity_dir);
	
	mom.x += speed_mode_hspd;
	mom.y += speed_mode_vspd;
}

function handle_point_mode(){
	if(!point_mode){
		return;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;	
	}
	else{
		point_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	mom.x = round(lerp(point_xstart, point_to_x, _amount));
	mom.y = round(lerp(point_ystart, point_to_y, _amount));
}

function handle_loop_point_mode(){
	if(!loop_point_mode){
		return;
	}
	
	if(loop_point_count_limit == infinity){
		moving = true;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		movement_anim_time = 1;
		loop_point_mode_reverse = loop_point_mode_reverse ? false : true;
		
		loop_point_count++;
		if(loop_point_count == loop_point_count_limit){
			loop_point_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_point_xstart = loop_point_mode_reverse ? point_to_x : point_xstart;
	loop_point_ystart = loop_point_mode_reverse ? point_to_y : point_ystart;
	loop_point_to_x = loop_point_mode_reverse ? point_xstart : point_to_x;
	loop_point_to_y = loop_point_mode_reverse ? point_ystart : point_to_y;
	
	mom.x = round(lerp(loop_point_xstart, loop_point_to_x, _amount));
	mom.y = round(lerp(loop_point_ystart, loop_point_to_y, _amount));
}

function handle_dx_dy_mode(){
	if(!dx_dy_mode){
		return;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		dx_dy_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	mom.x = round(lerp(point_xstart, point_to_x, _amount));
	mom.y = round(lerp(point_ystart, point_to_y, _amount));
}

function handle_loop_dx_dy_mode(){
	if(!loop_dx_dy_mode){
		return;
	}
	
	if(loop_point_count_limit == infinity){
		moving = true;
	}

	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		movement_anim_time = 1;
		loop_dx_dy_mode_reverse = loop_dx_dy_mode_reverse ? false : true;
		
		loop_point_count++;
		if(loop_point_count == loop_point_count_limit){
			loop_point_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_point_xstart = loop_dx_dy_mode_reverse ? point_to_x : point_xstart;
	loop_point_ystart = loop_dx_dy_mode_reverse ? point_to_y : point_ystart;
	loop_point_to_x = loop_dx_dy_mode_reverse ? point_xstart : point_to_x;
	loop_point_to_y = loop_dx_dy_mode_reverse ? point_ystart : point_to_y;
	
	mom.x = round(lerp(loop_point_xstart, loop_point_to_x, _amount));
	mom.y = round(lerp(loop_point_ystart, loop_point_to_y, _amount));
}

function handle_rotation_mode(){
	if(!rotation_mode){
		return;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		rotation_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	var _angle = lerp(rotation_start_angle, rotation_to_angle, _amount);
	
	mom.x = rotation_center_x + lengthdir_x(rotation_radius, _angle);
	mom.y = rotation_center_y + lengthdir_y(rotation_radius, _angle);
	mom.x = round(mom.x);
	mom.y = round(mom.y);
}

function handle_loop_rotation_mode(){
	if(!loop_rotation_mode){
		return;
	}
	
	if(loop_point_count_limit == infinity){
		moving = true;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		movement_anim_time = 1;
		loop_rotation_mode_reverse = loop_rotation_mode_reverse ? false : true;
		
		loop_point_count++;
		if(loop_point_count == loop_point_count_limit){
			loop_point_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_rotation_start_angle = loop_rotation_mode_reverse ? rotation_to_angle : rotation_start_angle;
	loop_rotation_to_angle = loop_rotation_mode_reverse ? rotation_start_angle : rotation_to_angle;
	
	var _angle = lerp(loop_rotation_start_angle, loop_rotation_to_angle, _amount);
	
	mom.x = rotation_center_x + lengthdir_x(rotation_radius, _angle);
	mom.y = rotation_center_y + lengthdir_y(rotation_radius, _angle);
	mom.x = round(mom.x);
	mom.y = round(mom.y);
}

function handle_endless_rotation_mode(){
	if(!endless_rotation_mode){
		return;
	}
	
	moving = true;
	
	endless_rotation_angle += endless_rotation_angular_speed;

	mom.x = rotation_center_x + lengthdir_x(rotation_radius, endless_rotation_angle);
	mom.y = rotation_center_y + lengthdir_y(rotation_radius, endless_rotation_angle);
	mom.x = round(mom.x);
	mom.y = round(mom.y);
}

function handle_rotation_in_eclipse_mode(){
	if(!rotation_in_eclipse_mode){
		return;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		rotation_in_eclipse_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	
	var _old_pos_x = (movement_anim_time - 1) / movement_anim_time_limit;
	var _old_amount = animcurve_channel_evaluate(_channel, _old_pos_x);
	
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	var _old_angle = lerp(rotation_start_angle, rotation_to_angle, _old_amount);
	var _angle = lerp(rotation_start_angle, rotation_to_angle, _amount);
	
	mom.x += lengthdir_x(rotation_radius * rotation_horizontal_ratio, _angle) - lengthdir_x(rotation_radius * rotation_horizontal_ratio, _old_angle);
	mom.y += lengthdir_y(rotation_radius * rotation_vertical_ratio, _angle) - lengthdir_y(rotation_radius * rotation_vertical_ratio, _old_angle);
	mom.x = round(mom.x);
	mom.y = round(mom.y);
}

function handle_loop_rotation_in_eclipse_mode(){
	if(!loop_rotation_in_eclipse_mode){
		return;
	}
	
	if(loop_point_count_limit == infinity){
		moving = true;
	}
	
	if(movement_anim_time < movement_anim_time_limit){
		movement_anim_time++;
	}
	else{
		movement_anim_time = 1;
		loop_rotation_in_eclipse_mode_reverse = loop_rotation_in_eclipse_mode_reverse ? false : true;
		
		loop_point_count++;
		if(loop_point_count == loop_point_count_limit){
			loop_rotation_in_eclipse_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	
	var _old_pos_x = (movement_anim_time - 1) / movement_anim_time_limit;
	var _old_amount = animcurve_channel_evaluate(_channel, _old_pos_x);
	
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_rotation_start_angle = loop_rotation_in_eclipse_mode_reverse ? rotation_to_angle : rotation_start_angle;
	loop_rotation_to_angle = loop_rotation_in_eclipse_mode_reverse ? rotation_start_angle : rotation_to_angle;
	
	var _old_angle = lerp(loop_rotation_start_angle, loop_rotation_to_angle, _old_amount);
	var _angle = lerp(loop_rotation_start_angle, loop_rotation_to_angle, _amount);
	
	mom.x += lengthdir_x(rotation_radius * rotation_horizontal_ratio, _angle) - lengthdir_x(rotation_radius * rotation_horizontal_ratio, _old_angle);
	mom.y += lengthdir_y(rotation_radius * rotation_vertical_ratio, _angle) - lengthdir_y(rotation_radius * rotation_vertical_ratio, _old_angle);
	mom.x = round(mom.x);
	mom.y = round(mom.y);
}

function handle_endless_rotation_in_eclipse_mode(){
	if(!endless_rotation_in_eclipse_mode){
		return;
	}
	
	moving = true;
	
	endless_rotation_angle += endless_rotation_angular_speed;

	mom.x += lengthdir_x(rotation_radius * rotation_horizontal_ratio, endless_rotation_angle) - lengthdir_x(rotation_radius * rotation_horizontal_ratio, endless_rotation_angle - endless_rotation_angular_speed);
	mom.y += lengthdir_y(rotation_radius * rotation_vertical_ratio, endless_rotation_angle) - lengthdir_y(rotation_radius * rotation_vertical_ratio, endless_rotation_angle - endless_rotation_angular_speed);
	mom.x = round(mom.x);
	mom.y = round(mom.y);
}

function handle_image_rotation_mode(){
	if(!image_rotation_mode){
		return;
	}
	
	if(image_rotation_anim_time < image_rotation_anim_time_limit){
		image_rotation_anim_time++;
	}
	else{
		image_rotation_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(image_rotation_anim_curve, 0);
	var _pos_x = image_rotation_anim_time / image_rotation_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	if(xoffset != undefined && yoffset != undefined){
		angle += (image_rotation_end_angle - image_rotation_start_angle) / image_rotation_anim_time_limit;
	}
	
	mom.image_angle = lerp(image_rotation_start_angle, image_rotation_end_angle, _amount);
}

function handle_loop_image_rotation_mode(){
	if(!loop_image_rotation_mode){
		return;
	}
	
	if(loop_image_rotation_count_limit == infinity){
		rotating = true;
	}
	
	if(image_rotation_anim_time < image_rotation_anim_time_limit){
		image_rotation_anim_time++;
	}
	else{
		image_rotation_anim_time = 1;
		loop_image_rotation_mode_reverse = loop_image_rotation_mode_reverse ? false : true;
		
		loop_image_rotation_count++;
		if(loop_image_rotation_count == loop_image_rotation_count_limit){
			loop_image_rotation_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(image_rotation_anim_curve, 0);
	var _pos_x = image_rotation_anim_time / image_rotation_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_image_rotation_start_angle = loop_image_rotation_mode_reverse ? image_rotation_end_angle : image_rotation_start_angle;
	loop_image_rotation_end_angle = loop_image_rotation_mode_reverse ? image_rotation_start_angle : image_rotation_end_angle;
	
	if(xoffset != undefined && yoffset != undefined){
		angle += (loop_image_rotation_end_angle - loop_image_rotation_start_angle) / image_rotation_anim_time_limit;
	}
	
	mom.image_angle = lerp(loop_image_rotation_start_angle, loop_image_rotation_end_angle, _amount);
}

function handle_endless_image_rotation_mode(){
	if(!endless_image_rotation_mode){
		return;
	}
	
	rotating = true;
		
	if(xoffset != undefined && yoffset != undefined){
		angle += endless_image_rotation_angular_speed;
	}
	
	mom.image_angle += endless_image_rotation_angular_speed;
}

function handle_scale_mode(){
	if(!scale_mode){
		return;
	}
	
	if(scale_anim_time < scale_anim_time_limit){
		scale_anim_time++;
	}
	else{
		scale_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(scale_anim_curve, 0);
	var _pos_x = scale_anim_time / scale_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);

	mom.image_xscale = lerp(scale_start_xscale, scale_to_xscale, _amount);
	mom.image_yscale = lerp(scale_start_xscale, scale_to_yscale, _amount);
}

function handle_loop_scale_mode(){
	if(!loop_scale_mode){
		return;
	}
	
	if(loop_scale_count_limit == infinity){
		scaling = true;
	}
	
	if(scale_anim_time < scale_anim_time_limit){
		scale_anim_time++;
	}
	else{
		scale_anim_time = 1;
		loop_scale_mode_reverse = loop_scale_mode_reverse ? false : true;
		
		loop_scale_count++;
		if(loop_scale_count == loop_scale_count_limit){
			loop_scale_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(scale_anim_curve, 0);
	var _pos_x = scale_anim_time / scale_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_scale_start_xscale = loop_scale_mode_reverse ? scale_to_xscale : scale_start_xscale;
	loop_scale_start_yscale = loop_scale_mode_reverse ? scale_to_yscale : scale_start_yscale;
	
	loop_scale_to_xscale = loop_scale_mode_reverse ? scale_start_xscale : scale_to_xscale;
	loop_scale_to_yscale = loop_scale_mode_reverse ? scale_start_yscale : scale_to_yscale;

	mom.image_xscale = lerp(loop_scale_start_xscale, loop_scale_to_xscale, _amount);
	mom.image_yscale = lerp(loop_scale_start_yscale, loop_scale_to_yscale, _amount);
}

function handle_alpha_mode(){
	if(!alpha_mode){
		return;
	}
	
	if(mom.image_alpha == 0){
		make_incollidable(mom);
	}
	else{
		make_collidable(mom);
	}
	
	var _epsilon = 0.01;

	if(alpha_anim_time < alpha_anim_time_limit){
		alpha_anim_time++;
	}
	else{
		alpha_mode = false;
		return;
	}
	
	var _channel = animcurve_get_channel(alpha_anim_curve, 0);
	var _pos_x = alpha_anim_time / alpha_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	mom.image_alpha = lerp(alpha_mode_start_alpha, alpha_mode_to_alpha, _amount);
}

function handle_loop_alpha_mode(){
	if(!loop_alpha_mode){
		return;
	}
	
	if(loop_alpha_count_limit == infinity){
		fading = true;
	}
	
	if(alpha_anim_time < alpha_anim_time_limit){
		alpha_anim_time++;
	}
	else{
		alpha_anim_time = 1;
		loop_alpha_mode_reverse = loop_alpha_mode_reverse ? false : true;
		
		loop_alpha_count++;
		if(loop_alpha_count == loop_alpha_count_limit){
			loop_alpha_mode = false;
			return;
		}
	}
	
	var _channel = animcurve_get_channel(alpha_anim_curve, 0);
	var _pos_x = alpha_anim_time / alpha_anim_time_limit;
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	loop_alpha_start_alpha = loop_alpha_mode_reverse ? alpha_mode_to_alpha : alpha_mode_start_alpha;
	loop_alpha_to_alpha = loop_alpha_mode_reverse ? alpha_mode_start_alpha : alpha_mode_to_alpha;

	mom.image_alpha = lerp(loop_alpha_start_alpha, loop_alpha_to_alpha, _amount);
}

function initialize_scatter_mode(){
	if(scatter_initialized){
		return;	
	}
	
	scatter_surf_list = [];
	
	repeat(4){
		array_push(scatter_surf_list, surface_create(mom.sprite_width / 2, mom.sprite_height / 2));
	}

	scatter_surf_pos_list = [];
	scatter_surf_spd_list = [];
	scatter_surf_start_xscale = mom.image_xscale;
	scatter_surf_start_yscale = mom.image_yscale;
	scatter_surf_start_angle = mom.image_angle;
	scatter_surf_start_alpha = mom.image_alpha;
	scatter_surf_alpha = scatter_surf_start_alpha;
	scatter_surf_anim_time = 0;

	var _index = 0;
	
	randomize();
	
	var _xoffset = sprite_get_xoffset(mom.sprite_index) * mom.image_xscale;
	var _yoffset = sprite_get_yoffset(mom.sprite_index) * mom.image_yscale;
	var _horizontal_xoffset = lengthdir_x(_xoffset, mom.image_angle);
	var _vertical_xoffset = lengthdir_y(_xoffset, mom.image_angle);
	var _horizontal_yoffset = lengthdir_x(_yoffset, mom.image_angle - 90);
	var _vertical_yoffset = lengthdir_y(_yoffset, mom.image_angle - 90);
			
	var _width = mom.sprite_width / 2;
	var _height = mom.sprite_height / 2; 
	var _horizontal_width = lengthdir_x(_width, mom.image_angle);
	var _vertical_width = lengthdir_y(_width, mom.image_angle);
	var _horizontal_height = lengthdir_x(_height, mom.image_angle - 90);
	var _vertical_height = lengthdir_y(_height, mom.image_angle - 90);

	for(var _i = 0; _i < 2; _i++){
		for(var _j = 0; _j < 2; _j++){
			array_push(scatter_surf_pos_list, {
				x : mom.x - _horizontal_xoffset - _horizontal_yoffset + _i * _horizontal_width + _j * _horizontal_height, 
				y : mom.y - _vertical_xoffset - _vertical_yoffset + _i * _vertical_width + _j * _vertical_height
			});
		
			var _hspd = _i > 0 ? random_range(2, 1) : random_range(-1, -2);
			var _vspd = _j > 0 ? random_range(1, 2) : random_range(-1, -2);
		
			array_push(scatter_surf_spd_list, {
				hspd : _hspd,
				vspd : _vspd,
			});
		
			surface_set_target(scatter_surf_list[_index]);
			
			var _left = _i * sprite_get_width(mom.sprite_index) / 2;
			var _top = _j * sprite_get_height(mom.sprite_index) / 2;
			
			draw_sprite_part_ext(mom.sprite_index, mom.image_index, _left, _top, sprite_get_width(mom.sprite_index) / 2, sprite_get_height(mom.sprite_index) / 2, 0, 0, mom.image_xscale, mom.image_yscale, c_white, 1);
			
			surface_reset_target();
			
			_index++;
		}
	}
	
	scatter_initialized = true;
}

function handle_scatter_mode(){
	if(!scatter_mode){
		return;
	}

	initialize_scatter_mode();
	make_incollidable(mom);
	mom.image_alpha = 0;
	
	if(scatter_surf_anim_time > 1){
		for(var _i = 0; _i < 4; _i++){
			if(surface_exists(scatter_surf_list[_i])){
				surface_free(scatter_surf_list[_i]);
			}
		}
		return;
	}
	
	for(var _i = 0; _i < array_length(scatter_surf_list); _i++){
		if(!surface_exists(scatter_surf_list[_i])){
			scatter_initialized = false;
			initialize_scatter_mode();
		}
	}
	
	if(scatter_surf_anim_time < 1){
		scatter_surf_anim_time += 0.03;
	}
	
	var _channel = animcurve_get_channel(ac_fade_out2, 0);
	var _amount = animcurve_channel_evaluate(_channel, scatter_surf_anim_time);
	
	scatter_surf_alpha = _amount * scatter_surf_start_alpha;
	
	for(var _i = 0; _i < 4; _i++){
		if(scatter_surf_pos_list[_i].x < 0 || 
		   scatter_surf_pos_list[_i].x > room_width || 
		   scatter_surf_pos_list[_i].y < 0 || 
		   scatter_surf_pos_list[_i].y > room_height){
			continue;
		}

		draw_surface_ext(scatter_surf_list[_i], scatter_surf_pos_list[_i].x, scatter_surf_pos_list[_i].y, _amount, _amount, scatter_surf_start_angle, c_white, scatter_surf_alpha);
		
		scatter_surf_vspd += 0.1;
		
		var _horizontal_hspd = lengthdir_x(scatter_surf_spd_list[_i].hspd, scatter_surf_start_angle);
		var _vertical_hspd = lengthdir_y(scatter_surf_spd_list[_i].hspd, scatter_surf_start_angle);
		var _horizontal_vspd = lengthdir_x(scatter_surf_spd_list[_i].vspd, scatter_surf_start_angle - 90);
		var _vertical_vspd = lengthdir_y(scatter_surf_spd_list[_i].vspd, scatter_surf_start_angle - 90);
		
		scatter_surf_pos_list[_i].x += _horizontal_hspd + _horizontal_vspd;
		scatter_surf_pos_list[_i].y += _vertical_hspd + _vertical_vspd + scatter_surf_vspd;
	}
}

function adjust_position_with_offset(){
	if(xoffset == undefined || yoffset == undefined){
		return;
	}
	
	if(speed_mode || vector_mode || projectile_mode){
		start_xpos += speed_mode_hspd;
		start_ypos += speed_mode_vspd;
	}
	
	var _channel = animcurve_get_channel(movement_anim_curve, 0);
	var _pos_old_x = (movement_anim_time - 1) / movement_anim_time_limit;
	var _pos_x = movement_anim_time / movement_anim_time_limit;
	var _old_amount = animcurve_channel_evaluate(_channel, _pos_old_x);
	var _amount = animcurve_channel_evaluate(_channel, _pos_x);
	
	if(point_mode || loop_point_mode){		
		var _old_x, _x, _old_y, _y;
		
		if(point_mode){
			_old_x = lerp(point_xstart, point_to_x, _old_amount);
			_x = lerp(point_xstart, point_to_x, _amount);
		
			_old_y = lerp(point_ystart, point_to_y, _old_amount);
			_y = lerp(point_ystart, point_to_y, _amount);
		}
		else if(loop_point_mode){
			_old_x = lerp(loop_point_xstart, loop_point_to_x, _old_amount);
			_x = lerp(loop_point_xstart, loop_point_to_x, _amount);
		
			_old_y = lerp(loop_point_ystart, loop_point_to_y, _old_amount);
			_y = lerp(loop_point_ystart, loop_point_to_y, _amount);
		}
		
		start_xpos += _x - _old_x;
		start_ypos += _y - _old_y;
	}
	else if(dx_dy_mode){
		start_xpos += lerp(0, dx_dy_mode_dx, _amount) - lerp(0, dx_dy_mode_dx, _old_amount);
		start_ypos += lerp(0, dx_dy_mode_dy, _amount) - lerp(0, dx_dy_mode_dy, _old_amount);
	}
	else if(loop_dx_dy_mode){
		if(!loop_dx_dy_mode_reverse){
			start_xpos += lerp(0, dx_dy_mode_dx, _amount) - lerp(0, dx_dy_mode_dx, _old_amount);
			start_ypos += lerp(0, dx_dy_mode_dy, _amount) - lerp(0, dx_dy_mode_dy, _old_amount);
		}
		else{
			start_xpos -= lerp(0, dx_dy_mode_dx, _amount) - lerp(0, dx_dy_mode_dx, _old_amount);
			start_ypos -= lerp(0, dx_dy_mode_dy, _amount) - lerp(0, dx_dy_mode_dy, _old_amount);
		}
	}
	else if(rotation_mode || loop_rotation_mode || rotation_in_eclipse_mode || loop_rotation_in_eclipse_mode){
		var _angle, _old_angle;
		
		if(rotation_mode || rotation_in_eclipse_mode){
			_angle = lerp(rotation_start_angle, rotation_to_angle, _amount);
			_old_angle = lerp(rotation_start_angle, rotation_to_angle, _old_amount);
		}
		else if(loop_rotation_mode || loop_rotation_in_eclipse_mode){
			_angle = lerp(loop_rotation_start_angle, loop_rotation_to_angle, _amount);
			_old_angle = lerp(loop_rotation_start_angle, loop_rotation_to_angle, _old_amount);
		}		
		
		if(rotation_mode || loop_rotation_mode){
			start_xpos += lengthdir_x(rotation_radius, _angle) - lengthdir_x(rotation_radius, _old_angle);
			start_ypos += lengthdir_y(rotation_radius, _angle) - lengthdir_y(rotation_radius, _old_angle);
		}
		else if(rotation_in_eclipse_mode || loop_rotation_in_eclipse_mode){
			start_xpos += lengthdir_x(rotation_radius * rotation_horizontal_ratio, _angle) - lengthdir_x(rotation_radius * rotation_horizontal_ratio, _old_angle);
			start_ypos += lengthdir_y(rotation_radius * rotation_vertical_ratio, _angle) - lengthdir_y(rotation_radius * rotation_vertical_ratio, _old_angle);
		}
	}
	else if(endless_rotation_mode || endless_rotation_in_eclipse_mode){
		if(endless_rotation_mode){
			start_xpos += lengthdir_x(rotation_radius, endless_rotation_angle) - lengthdir_x(rotation_radius, endless_rotation_angle - endless_rotation_angular_speed);
			start_ypos += lengthdir_y(rotation_radius, endless_rotation_angle) - lengthdir_y(rotation_radius, endless_rotation_angle - endless_rotation_angular_speed);
		}
		else if(endless_rotation_in_eclipse_mode){
			start_xpos += lengthdir_x(rotation_radius * rotation_horizontal_ratio, endless_rotation_angle) - lengthdir_x(rotation_radius * rotation_horizontal_ratio, endless_rotation_angle - endless_rotation_angular_speed);
			start_ypos += lengthdir_y(rotation_radius * rotation_vertical_ratio, endless_rotation_angle) - lengthdir_y(rotation_radius * rotation_vertical_ratio, endless_rotation_angle - endless_rotation_angular_speed);
		}
	}
	
	mom.x = start_xpos + lengthdir_x(radius, angle) * mom.image_xscale;
	mom.y = start_ypos + lengthdir_y(radius, angle) * mom.image_yscale;
}

function handle_activation_time(){
	if(activation_time < activation_time_limit){
		activated = true;
		activation_time++;
	}
	else{
		activation_time = 0;
		activation_time_limit = 0;
	}
}

function handle_stop_moving_mode(){
	if(!stop_moving_mode){
		return;
	}
	
	refresh_moving();
}

function handle_stop_image_rotation_mode(){
	if(!stop_image_rotation_mode){
		return;
	}
	
	refresh_image_rotating();
}

function handle_stop_scaling_mode(){
	if(!stop_scaling_mode){
		return;
	}
	
	refresh_scaling();
}

function handle_stop_fading_mode(){
	if(!stop_fading_mode){
		return;
	}
	
	refresh_fading();
}

function handle_stop_all_mode(){
	if(!stop_all_mode){
		return;
	}
	
	refresh_moving();
	refresh_image_rotating();
	refresh_scaling();
	refresh_fading();
}
