function Trigger(_arr, _direct = false) constructor{	
	direct = _direct;
	
	with(obj_world){
		handle_trigger_activator_ids();
	}
	
	mom = other;
	
	with(mom){
		trigger_id = other; // Store the struct's ID in the owner instance
	}
	
	supporter = instance_create_layer(0, 0, mom.layer, obj_trigger_supporter);
	supporter.mom = mom;
	supporter.mom_start_angle = mom.image_angle;
	supporter.mom_start_xscale = mom.image_xscale;
	supporter.mom_start_yscale = mom.image_yscale;
	supporter.mom_start_alpha = mom.image_alpha;	
	
	keys = variable_clone(_arr);
	order = 0;
	recent_key = 0;
	
	if(!direct){
		recent_key = keys[order];
	}
	
	is_all_triggered = false;
	
	nesting = false;
	no_order = false;
	is_recent_key_initialized = false;
	
	moving = false;
	image_rotating = false;
	scaling = false;
	fading = false;
	activated = false;
	activation_time_list = [];
	
	add_speed = function(_key, _hspeed, _vspeed, _delay){
		var _features = [_hspeed, _vspeed, _delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "speed", _features);
		}
	}
	
	activate_speed = function(_hspeed, _vspeed){
		with(supporter){
			refresh_moving();
		}
		
		supporter.speed_mode = true;
		supporter.speed_mode_hspd = _hspeed;
		supporter.speed_mode_vspd = _vspeed;
	}
	
	add_vector = function(_key, _spd, _dir, _delay){
		var _features = [_spd, _dir, _delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "vector", _features);
		}
	}
	
	activate_vector = function(_spd, _dir){
		with(supporter){
			refresh_moving();
		}
		
		supporter.vector_mode = true;
		supporter.vector_mode_spd = _spd;
		supporter.vector_mode_dir = _dir;
	}
	
	add_projectile = function(_key, _hspeed, _vspeed, _gravity_pull, _gravity_dir, _delay){
		var _features = [_hspeed, _vspeed, _gravity_pull, _gravity_dir, _delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "projectile", _features);
		}
	}
	
	activate_projectile = function(_hspeed, _vspeed, _gravity_pull, _gravity_dir){
		with(supporter){
			refresh_moving();
		}
		
		supporter.projectile_mode = true;
		supporter.speed_mode_hspd = _hspeed;
		supporter.speed_mode_vspd = _vspeed;
		supporter.projectile_gravity_pull = _gravity_pull;
		supporter.projectile_gravity_dir = _gravity_dir;
	}

	add_point = function(_key, _x, _y, _time, _delay, _anim_curve){
		var _features = [_x, _y, _time, _delay, _anim_curve];  
			
		with(obj_world){
			update_triggers_features(_key, other, "point", _features);
		}
	}
	
	activate_point = function(_x, _y, _time, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.point_mode = true;
		supporter.point_xstart = mom.x;
		supporter.point_ystart = mom.y;
		supporter.point_to_x = _x;
		supporter.point_to_y = _y;
		
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_loop_point = function(_key, _x, _y, _time, _count, _delay, _anim_curve){
		var _features = [_x, _y, _time, _count, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "loop_point", _features);
		}
	}
	
	activate_loop_point = function(_x, _y, _time, _count, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.loop_point_mode = true;
		supporter.loop_point_mode_reverse = false;
		supporter.point_xstart = mom.x;
		supporter.point_ystart = mom.y;
		supporter.point_to_x = _x;
		supporter.point_to_y = _y;
		
		supporter.loop_point_count = 0;
		supporter.loop_point_count_limit = _count;
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_dx_dy = function(_key, _dx, _dy, _time, _delay, _anim_curve){
		var _features = [_dx, _dy, _time, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "dx_dy", _features);
		}
	}
	
	activate_dx_dy = function(_dx, _dy, _time, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.dx_dy_mode = true;
		supporter.dx_dy_mode_dx = _dx;
		supporter.dx_dy_mode_dy = _dy;
		supporter.point_xstart = mom.x;
		supporter.point_ystart = mom.y;
		supporter.point_to_x = mom.x + _dx;
		supporter.point_to_y = mom.y + _dy;
		
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_loop_dx_dy = function(_key, _dx, _dy, _time, _count, _delay, _anim_curve){
		var _features = [_dx, _dy, _time, _count, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "loop_dx_dy", _features);
		}
	}
	
	activate_loop_dx_dy = function(_dx, _dy, _time, _count, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.loop_dx_dy_mode = true;
		supporter.loop_dx_dy_mode_reverse = false;
		supporter.dx_dy_mode_dx = _dx;
		supporter.dx_dy_mode_dy = _dy;
		supporter.point_xstart = mom.x;
		supporter.point_ystart = mom.y;
		supporter.point_to_x = mom.x + _dx;
		supporter.point_to_y = mom.y + _dy;
		
		supporter.loop_point_count = 0;
		supporter.loop_point_count_limit = _count;
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_rotation = function(_key, _center_x, _center_y, _angle, _time, _delay, _anim_curve){
		var _features = [_center_x, _center_y, _angle, _time, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "rotation", _features);
		}
	}
	
	activate_rotation = function(_center_x, _center_y, _angle, _time, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.rotation_mode = true;
		supporter.rotation_center_x = _center_x;
		supporter.rotation_center_y = _center_y;
		supporter.rotation_radius = point_distance(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_start_angle = point_direction(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_to_angle = supporter.rotation_start_angle + _angle;
		
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_loop_rotation = function(_key, _center_x, _center_y, _angle, _time, _count, _delay, _anim_curve){
		var _features = [_center_x, _center_y, _angle, _time, _count, _delay, _anim_curve];
		
		with(obj_world){
			update_triggers_features(_key, other, "loop_rotation", _features);
		}
	}
	
	activate_loop_rotation = function(_center_x, _center_y, _angle, _time, _count, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.loop_rotation_mode = true;
		supporter.loop_rotation_mode_reverse = false;
		supporter.rotation_center_x = _center_x;
		supporter.rotation_center_y = _center_y;
		supporter.rotation_radius = point_distance(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_start_angle = point_direction(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_to_angle = supporter.rotation_start_angle + _angle;
		
		supporter.loop_point_count = 0;
		supporter.loop_point_count_limit = _count;
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_endless_rotation = function(_key, _center_x, _center_y, _angular_speed, _delay){
		var _features = [_center_x, _center_y, _angular_speed, _delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "endless_rotation", _features);
		}
	}
	
	activate_endless_rotation = function(_center_x, _center_y, _angular_speed){
		with(supporter){
			refresh_moving();
		}
		
		supporter.endless_rotation_mode = true;
		supporter.endless_rotation_angle = point_direction(_center_x, _center_y, mom.x, mom.y);
		supporter.endless_rotation_angular_speed = _angular_speed;
		
		supporter.rotation_center_x = _center_x;
		supporter.rotation_center_y = _center_y;
		supporter.rotation_radius = point_distance(_center_x, _center_y, mom.x, mom.y);
	}
	
	add_rotation_in_eclipse = function(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay, _anim_curve){
		var _features = [_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "rotation_in_eclipse", _features);
		}
	}
	
	activate_rotation_in_eclipse = function(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.rotation_in_eclipse_mode = true;
		supporter.rotation_horizontal_ratio = _horizontal_ratio;
		supporter.rotation_vertical_ratio = _vertical_ratio;
		supporter.rotation_center_x = _center_x;
		supporter.rotation_center_y = _center_y;
		supporter.rotation_radius = point_distance(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_start_angle = point_direction(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_to_angle = supporter.rotation_start_angle + _angle;
		
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_loop_rotation_in_eclipse = function(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count, _delay, _anim_curve){
		var _features = [_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "loop_rotation_in_eclipse", _features);
		}
	}
	
	activate_loop_rotation_in_eclipse = function(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count, _anim_curve){
		with(supporter){
			refresh_moving();
		}
		
		supporter.loop_rotation_in_eclipse_mode = true;
		supporter.loop_rotation_in_eclipse_mode_reverse = false;
		
		supporter.rotation_horizontal_ratio = _horizontal_ratio;
		supporter.rotation_vertical_ratio = _vertical_ratio;
		supporter.rotation_center_x = _center_x;
		supporter.rotation_center_y = _center_y;
		supporter.rotation_radius = point_distance(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_start_angle = point_direction(_center_x, _center_y, mom.x, mom.y);
		supporter.rotation_to_angle = supporter.rotation_start_angle + _angle;
		
		supporter.loop_point_count = 0;
		supporter.loop_point_count_limit = _count;
		supporter.movement_anim_time = 0;
		supporter.movement_anim_time_limit = _time;
		supporter.movement_anim_curve = _anim_curve;
	}
	
	add_endless_rotation_in_eclipse = function(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay){
		var _features = [_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "endless_rotation_in_eclipse", _features);
		}
	}
	
	activate_endless_rotation_in_eclipse = function(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed){
		with(supporter){
			refresh_moving();
		}
		
		supporter.endless_rotation_in_eclipse_mode = true;
		supporter.endless_rotation_angle = point_direction(_center_x, _center_y, mom.x, mom.y);
		supporter.endless_rotation_angular_speed = _angular_speed;
		
		supporter.rotation_horizontal_ratio = _horizontal_ratio;
		supporter.rotation_vertical_ratio = _vertical_ratio;
		supporter.rotation_center_x = _center_x;
		supporter.rotation_center_y = _center_y;
		supporter.rotation_radius = point_distance(_center_x, _center_y, mom.x, mom.y);
	}
	
	add_image_rotation = function(_key, _angle, _time, _delay, _anim_curve){
		var _features = [_angle, _time, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "image_rotation", _features);
		}
	}
	
	activate_image_rotation = function(_angle, _time, _anim_curve){
		with(supporter){
			refresh_image_rotating();
		}
		
		supporter.image_rotation_mode = true;
		supporter.image_rotation_start_angle = mom.image_angle;
		supporter.image_rotation_end_angle = mom.image_angle + _angle;
		
		supporter.image_rotation_anim_time = 0;
		supporter.image_rotation_anim_time_limit = _time;
		supporter.image_rotation_anim_curve = _anim_curve;
	}
	
	add_loop_image_rotation = function(_key, _angle, _time, _count, _delay, _anim_curve){ 
		var _features = [_angle, _time, _count, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "loop_image_rotation", _features);
		}
	}
	
	activate_loop_image_rotation = function(_angle, _time, _count, _anim_curve){
		with(supporter){
			refresh_image_rotating();
		}
		
		supporter.loop_image_rotation_mode = true;
		supporter.loop_image_rotation_mode_reverse = false;
		
		supporter.image_rotation_start_angle = mom.image_angle;
		supporter.image_rotation_end_angle = mom.image_angle + _angle;

		supporter.loop_image_rotation_count = 0;
		supporter.loop_image_rotation_count_limit = _count
		supporter.image_rotation_anim_time = 0;
		supporter.image_rotation_anim_time_limit = _time;
		supporter.image_rotation_anim_curve = _anim_curve;
	}
	
	add_endless_image_rotation = function(_key, _angular_speed, _delay){
		var _features = [_angular_speed, _delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "endless_image_rotation", _features);
		}
	}
	
	activate_endless_image_rotation = function(_angular_speed){
		with(supporter){
			refresh_image_rotating();
		}
		
		supporter.endless_image_rotation_mode = true;
		supporter.endless_image_rotation_angular_speed = _angular_speed;
	}
	
	add_scale = function(_key, _xscale, _yscale, _time, _delay, _anim_curve){
		var _features = [_xscale, _yscale, _time, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "scale", _features);
		}
	}
	
	activate_scale = function(_xscale, _yscale, _time, _anim_curve){
		with(supporter){
			refresh_scaling();
		}
		
		supporter.scale_mode = true;
		supporter.scale_start_xscale = mom.image_xscale;
		supporter.scale_start_yscale = mom.image_yscale;
		supporter.scale_to_xscale = _xscale;
		supporter.scale_to_yscale = _yscale;
		
		supporter.scale_anim_time = 0;
		supporter.scale_anim_time_limit = _time;
		supporter.scale_anim_curve = _anim_curve;
	}
	
	add_loop_scale = function(_key, _xscale, _yscale, _time, _count, _delay, _anim_curve){
		var _features = [_xscale, _yscale, _time, _count, _delay, _anim_curve];
			
		with(obj_world){
			update_triggers_features(_key, other, "loop_scale", _features);
		}
	}
	
	activate_loop_scale = function(_xscale, _yscale, _time, _count, _anim_curve){
		with(supporter){
			refresh_scaling();
		}
		
		supporter.loop_scale_mode = true;
		supporter.loop_scale_mode_reverse = false;
		supporter.scale_start_xscale = mom.image_xscale;
		supporter.scale_start_yscale = mom.image_yscale;
		supporter.scale_to_xscale = _xscale;
		supporter.scale_to_yscale = _yscale;
		
		supporter.loop_scale_count = 0;
		supporter.loop_scale_count_limit = _count;
		supporter.scale_anim_time = 0;
		supporter.scale_anim_time_limit = _time;
		supporter.scale_anim_curve = _anim_curve;
	}
	
	add_alpha = function(_key, _alpha, _time, _delay, _anim_curve){
		var _features = [_alpha, _time, _delay, _anim_curve];
		
		with(obj_world){
			update_triggers_features(_key, other, "alpha", _features);
		}
	}
	
	activate_alpha = function(_alpha, _time, _anim_curve){
		with(supporter){
			refresh_fading();
		}
		
		supporter.alpha_mode = true;
		supporter.alpha_mode_start_alpha = mom.image_alpha;
		supporter.alpha_mode_to_alpha = _alpha;
		
		supporter.alpha_anim_time = 0;
		supporter.alpha_anim_time_limit = _time;
		supporter.alpha_anim_curve = _anim_curve;
	}
	
	add_loop_alpha = function(_key, _alpha, _time, _count, _delay, _anim_curve){
		var _features = [_alpha, _time, _count, _delay, _anim_curve];
		
		with(obj_world){
			update_triggers_features(_key, other, "loop_alpha", _features);
		}
	}
	
	activate_loop_alpha = function(_alpha, _time, _count, _anim_curve){
		with(supporter){
			refresh_fading();
		}
		
		supporter.loop_alpha_mode = true;
		supporter.loop_alpha_mode_reverse = false;
		supporter.alpha_mode_start_alpha = mom.image_alpha;
		supporter.alpha_mode_to_alpha = _alpha;
		
		supporter.loop_alpha_count = 0;
		supporter.loop_alpha_count_limit = _count;
		supporter.alpha_anim_time = 0;
		supporter.alpha_anim_time_limit = _time;
		supporter.alpha_anim_curve = _anim_curve;
	}
	
	add_scatter = function(_key, _delay){
		var _features = [_delay];
		
		with(obj_world){
			update_triggers_features(_key, other, "scatter", _features);
		}
	}
	
	activate_scatter = function(){
		supporter.scatter_mode = true;
	}
	
	add_stop_moving = function(_key, _delay){
		var _features = [_delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "stop_moving", _features);
		}
	}
	
	activate_stop_moving = function(){
		supporter.stop_moving_mode = true;
	}
	
	add_stop_image_rotation = function(_key, _delay){
		var _features = [_delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "stop_image_rotation", _features);
		}
	}
	
	activate_stop_image_rotation = function(){
		supporter.stop_image_rotation_mode = true;
	}
	
	add_stop_scaling = function(_key, _delay){
		var _features = [_delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "stop_scaling", _features);
		}
	}
	
	activate_stop_scaling = function(){
		supporter.stop_scaling_mode = true;
	}
	
	add_stop_fading = function(_key, _delay){
		var _features = [_delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "stop_fading", _features);
		}
	}
	
	activate_stop_fading = function(){
		supporter.stop_fading_mode = true;
	}
	
	add_stop_all = function(_key, _delay){		
		var _features = [_delay];
			
		with(obj_world){
			update_triggers_features(_key, other, "stop_all", _features);
		}
	}
	
	activate_stop_all = function(){
		supporter.stop_all_mode = true;
	}
}

/// @function		set_trigger()
/// @description	Determine what trigger keys the instance will use.

function set_trigger(){
	var _arr = [];
	
	for(var _i = 0; _i <= argument_count; _i++){
		array_push(_arr, argument[_i]);
	}
	
	new Trigger(_arr);
}

/// @function		set_triggers_nesting()
/// @description	If you call it once, triggers don't wait until the previous trigger's done.

function set_triggers_nesting(){
	trigger_id.nesting = true;
}

/// @function		set_triggers_no_order()
/// @description	If you call it once, the player can activate triggers regardless of order.

function set_triggers_no_order(){
	trigger_id.no_order = true;
}

/// @function		set_trigger_offsets(_xoffset, _yoffset)
/// @description	Adjust the center point of a trigger instance for transforming its rotation and scaling along the x and y axes.

function set_trigger_offsets(_xoffset, _yoffset){
	trigger_id.supporter.xoffset = _xoffset;
	trigger_id.supporter.yoffset = _yoffset;
}

/// @function		add_trigger_speed(_key, _hspeed, _vspeed, _delay = 0)
/// @description	Determine the speed at which the trigger instance will move.

function add_trigger_speed(_key, _hspeed, _vspeed, _delay = 0){
	trigger_id.add_speed(_key, _hspeed, _vspeed, _delay);
}

/// @function		add_trigger_vector(_key, _speed, _direction, _delay = 0)
/// @description	Determine the speed and direction at which the trigger instance will move.

function add_trigger_vector(_key, _speed, _direction, _delay = 0){
	trigger_id.add_vector(_key, _speed, _direction, _delay);
}

/// @function		add_trigger_projectile(_key, _hspeed, _vspeed, _garvity_pull, _gravity_dir, _delay = 0)
/// @description	Determine the values at which the trigger instance will launch a projectile.

function add_trigger_projectile(_key, _hspeed, _vspeed, _garvity_pull, _gravity_dir, _delay = 0){
	trigger_id.add_projectile(_key, _hspeed, _vspeed, _garvity_pull, _gravity_dir, _delay);
}

/// @function		add_trigger_point(_key, _x, _y, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the point where the trigger instance will move to.

function add_trigger_point(_key, _x, _y, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_point(_key, _x, _y, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_point(_key, _x, _y, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the point where the trigger instance will loop to. (_count can set how many times the trigger instance will loop)

function add_trigger_loop_point(_key, _x, _y, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_point(_key, _x, _y, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_dx_dy(_key, _dx, _dy, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine increment of x and y how the trigger instance will move.

function add_trigger_dx_dy(_key, _dx, _dy, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_dx_dy(_key, _dx, _dy, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_dx_dy(_key, _dx, _dy, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine increment of x and y how the trigger instance will loop to. (_count can set how many times the trigger instance will loop)

function add_trigger_loop_dx_dy(_key, _dx, _dy, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_dx_dy(_key, _dx, _dy, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_rotation(_key, _center_x, _center_y, _angle, _time, _delay = 0, _anim_curve = ac_linear)

function add_trigger_rotation(_key, _center_x, _center_y, _angle, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_rotation(_key, _center_x, _center_y, _angle, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_rotation(_key, _center_x, _center_y, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)

function add_trigger_loop_rotation(_key, _center_x, _center_y, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_rotation(_key, _center_x, _center_y, _angle, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_endless_rotation(_key, _center_x, _center_y, _angular_speed, _delay = 0)

function add_trigger_endless_rotation(_key, _center_x, _center_y, _angular_speed, _delay = 0){
	trigger_id.add_endless_rotation(_key, _center_x, _center_y, _angular_speed, _delay);
}

/// @function		add_trigger_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay = 0, _anim_curve = ac_linear)

function add_trigger_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)

function add_trigger_loop_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_endless_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay = 0)

function add_trigger_endless_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay = 0){
	trigger_id.add_endless_rotation_in_eclipse(_key, _center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay);
}

/// @function		add_trigger_image_rotation(_key, _angle, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the angle how the trigger instance's sprite will spin. 

function add_trigger_image_rotation(_key, _angle, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_image_rotation(_key, _angle, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_image_rotation(_key, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the angle how the trigger instance's sprite will spin. (_count can set how many times the trigger instance will loop)
function add_trigger_loop_image_rotation(_key, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_image_rotation(_key, _angle, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_endless_image_rotation(_key, _angular_speed, _delay = 0)
/// @description	Determine the angular speed how the trigger instance's sprite will spin.

function add_trigger_endless_image_rotation(_key, _angular_speed, _delay = 0){
	trigger_id.add_endless_image_rotation(_key, _angular_speed, _delay);
}

/// @function		add_trigger_scale(_key, _xscale, _yscale, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the scale to which a trigger instance will be resized.

function add_trigger_scale(_key, _xscale, _yscale, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_scale(_key, _xscale, _yscale, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_scale(_key, _xscale, _yscale, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the scale to which a trigger instance will be resized. (_count can set how many times the trigger instance will loop).

function add_trigger_loop_scale(_key, _xscale, _yscale, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_scale(_key, _xscale, _yscale, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_alpha(_key, _alpha, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the image_alpha to which a trigger instance will be faded.

function add_trigger_alpha(_key, _alpha, _time, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_alpha(_key, _alpha, _time, _delay, _anim_curve);
}

/// @function		add_trigger_loop_alpha(_key, _alpha, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the image_alpha to which a trigger instance will be faded. (_count can set how many times the trigger instance will loop).

function add_trigger_loop_alpha(_key, _alpha, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	trigger_id.add_loop_alpha(_key, _alpha, _time, _count, _delay, _anim_curve);
}

/// @function		add_trigger_scatter(_key, _delay)
/// @description	Break a trigger instance into four pieces.

function add_trigger_scatter(_key, _delay = 0){
	trigger_id.add_scatter(_key, _delay);
}

/// @function		add_trigger_stop_moving(_key, _delay = 0)
/// @description	Stop the trigger instance's movement action (Regardless of a nesting option).

function add_trigger_stop_moving(_key, _delay = 0){
	trigger_id.add_stop_moving(_key, _delay);
}

/// @function		add_trigger_stop_image_rotating(_key, _delay = 0)
/// @description	Stop the trigger instance's image rotation action (Regardless of a nesting option).

function add_trigger_stop_image_rotation(_key, _delay = 0){
	trigger_id.add_stop_image_rotation(_key, _delay);
}

/// @function		add_trigger_stop_scaling(_key, _delay = 0)
/// @description	Stop the trigger instance's scaling action (Regardless of a nesting option).

function add_trigger_stop_scaling(_key, _delay = 0){
	trigger_id.add_stop_scaling(_key, _delay);
}

/// @function		add_trigger_stop_fading(_key, _delay = 0)
/// @description	Stop the trigger instance's fading action (Regardless of a nesting option).

function add_trigger_stop_fading(_key, _delay = 0){
	trigger_id.add_stop_fading(_key, _delay);
}

/// @function		add_trigger_stop_all(_key, _delay = 0)
/// @description	Stop every trigger action (Regardless of a nesting option).

function add_trigger_stop_all(_key, _delay = 0){
	trigger_id.add_stop_all(_key, _delay);
}


/*							  *\
	Direct Trigger Functions
\*							  */

/// @function		set_direct_trigger()
/// @description	Allow the instance to directly use trigger actions without trigger keys.

function set_direct_trigger(){
	new Trigger([], true);
}

function handle_direct_trigger_function(_method, _ft, _delay, _trigger_id){
	var _inst = instance_create_layer(x, y, layer, obj_trigger_call_later);
	_inst.mom = id;
	_inst.trigger_method = _method;
	_inst.args = variable_clone(_ft);
	_inst.delay_limit = _delay;
	_inst.trigger_id = _trigger_id;
	_inst.direct = true;
}

/// @function		add_direct_trigger_speed(_hspeed, _vspeed, _delay = 0)
/// @description	Determine the speed at which the trigger instance will move.

function add_direct_trigger_speed(_hspeed, _vspeed, _delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_speed, [_hspeed, _vspeed], _delay, trigger_id);
}

/// @function		add_direct_trigger_vector(_speed, _direction, _delay = 0)
/// @description	Determine the speed and direction at which the trigger instance will move.

function add_direct_trigger_vector(_speed, _direction, _delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_vector, [_speed, _direction], _delay, trigger_id);
}

/// @function		add_direct_trigger_projectile(_hspeed, _vspeed, _garvity_pull, _gravity_dir, _delay = 0)
/// @description	Determine the values at which the trigger instance will launch a projectile.

function add_direct_trigger_projectile(_hspeed, _vspeed, _garvity_pull, _gravity_dir, _delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_projectile, [_hspeed, _vspeed, _garvity_pull, _gravity_dir], _delay, trigger_id);
}

/// @function		add_direct_trigger_point(_x, _y, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the point where the trigger instance will move to.

function add_direct_trigger_point(_x, _y, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_point, [_x, _y, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_point(_x, _y, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the point where the trigger instance will loop to. (_count can set how many times the trigger instance will loop)

function add_direct_trigger_loop_point(_x, _y, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_loop_point, [_x, _y, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_dx_dy(_dx, _dy, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine increment of x and y how the trigger instance will move.

function add_direct_trigger_dx_dy(_dx, _dy, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_dx_dy, [_dx, _dy, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_dx_dy(_dx, _dy, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine increment of x and y how the trigger instance will loop to. (_count can set how many times the trigger instance will loop)

function add_direct_trigger_loop_dx_dy(_dx, _dy, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}

	handle_direct_trigger_function(trigger_id.activate_loop_point, [_dx, _dy, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_rotation(_center_x, _center_y, _angle, _time, _delay = 0, _anim_curve = ac_linear)

function add_direct_trigger_rotation(_center_x, _center_y, _angle, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_rotation, [_center_x, _center_y, _angle, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_rotation(_center_x, _center_y, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)

function add_direct_trigger_loop_rotation(_center_x, _center_y, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_loop_rotation, [_center_x, _center_y, _angle, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_endless_rotation(_center_x, _center_y, _angular_speed, _delay = 0)

function add_direct_trigger_endless_rotation(_center_x, _center_y, _angular_speed, _delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_endless_rotation, [_center_x, _center_y, _angular_speed], _delay, trigger_id);
}

/// @function		add_direct_trigger_rotation_in_eclipse(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay = 0, _anim_curve = ac_linear)

function add_direct_trigger_rotation_in_eclipse(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_rotation_in_eclipse, [_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_rotation_in_eclipse(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)

function add_direct_trigger_loop_rotation_in_eclipse(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_loop_rotation_in_eclipse, [_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angle, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_endless_rotation_in_eclipse(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay = 0)

function add_direct_trigger_endless_rotation_in_eclipse(_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed, _delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_endless_rotation_in_eclipse, [_center_x, _center_y, _horizontal_ratio, _vertical_ratio, _angular_speed], _delay, trigger_id);
}

/// @function		add_direct_trigger_image_rotation(_angle, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the angle how the trigger instance's sprite will spin. 

function add_direct_trigger_image_rotation(_angle, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_image_rotation, [_angle, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_image_rotation(_angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the angle how the trigger instance's sprite will spin. (_count can set how many times the trigger instance will loop)
function add_direct_trigger_loop_image_rotation(_angle, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_loop_image_rotation, [_angle, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_endless_image_rotation(_angular_speed, _delay = 0)
/// @description	Determine the angular speed how the trigger instance's sprite will spin.

function add_direct_trigger_endless_image_rotation(_angular_speed, _delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_endless_image_rotation, [_angular_speed], _delay, trigger_id);
}

/// @function		add_direct_trigger_scale(_xscale, _yscale, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the scale to which a trigger instance will be resized.

function add_direct_trigger_scale(_xscale, _yscale, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_scale, [_xscale, _yscale, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_scale(_xscale, _yscale, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the scale to which a trigger instance will be resized. (_count can set how many times the trigger instance will loop).

function add_direct_trigger_loop_scale(_xscale, _yscale, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_loop_scale, [_xscale, _yscale, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_alpha(_alpha, _time, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the image_alpha to which a trigger instance will be faded.

function add_direct_trigger_alpha(_alpha, _time, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_alpha, [_alpha, _time, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_loop_alpha(_alpha, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear)
/// @description	Determine the image_alpha to which a trigger instance will be faded. (_count can set how many times the trigger instance will loop).

function add_direct_trigger_loop_alpha(_alpha, _time, _count = infinity, _delay = 0, _anim_curve = ac_linear){
	if(!trigger_id.direct){
		return;
	}

	handle_direct_trigger_function(trigger_id.activate_loop_alpha, [_alpha, _time, _count, _anim_curve], _delay, trigger_id);
}

/// @function		add_direct_trigger_scatter(_delay)
/// @description	Break a trigger instance into four pieces.

function add_direct_trigger_scatter(_delay = 0){
	if(!trigger_id.direct){
		return;
	}
	
	handle_direct_trigger_function(trigger_id.activate_scatter, [], _delay, trigger_id);
}
