/// @description debug library
function toggle_debug_camera_mode(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(keyboard_check_pressed(global.debug_key_config.god_mode)){
		debug_camera_mode = false;
		debug_camera_zoom = 1;
		camera_set_view_size(view_camera[0], DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT);
		
		if(instance_exists(obj_smooth_camera)){
			camera_set_view_pos(view_camera[0], obj_smooth_camera.camera_x, obj_smooth_camera.camera_y);
		}
		else if(instance_exists(obj_fixed_camera)){
			camera_set_view_pos(view_camera[0], obj_fixed_camera.camera_x, obj_fixed_camera.camera_y);
		}
		else if(instance_exists(obj_smooth_fixed_camera)){
			camera_set_view_pos(view_camera[0], obj_smooth_fixed_camera.camera_x, obj_smooth_fixed_camera.camera_y);
		}
		else{
			camera_set_view_pos(view_camera[0], 0, 0);
		}
	}
	
	if(!global.debug_config.god_mode){
		return;
	}
	
	if(keyboard_check_pressed(global.debug_key_config.debug_camera)){
		if(!debug_camera_mode){
			debug_camera_mode = true;
		}
		else{
			debug_camera_mode = false;
			debug_camera_zoom = 1;
			camera_set_view_size(view_camera[0], DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT);
			
			if(instance_exists(obj_smooth_camera)){
				camera_set_view_pos(view_camera[0], obj_smooth_camera.camera_x, obj_smooth_camera.camera_y);
			}
			else if(instance_exists(obj_fixed_camera)){
				camera_set_view_pos(view_camera[0], obj_fixed_camera.camera_x, obj_fixed_camera.camera_y);
			}
			else if(instance_exists(obj_smooth_fixed_camera)){
				camera_set_view_pos(view_camera[0], obj_smooth_fixed_camera.camera_x, obj_smooth_fixed_camera.camera_y);
			}
			else{
				camera_set_view_pos(view_camera[0], 0, 0);
			}
		}
	}
}

function set_debug_camera_zoom(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(!debug_camera_mode){
		return;
	}
	
	if(mouse_wheel_up()){
		debug_camera_zoom = min(MAX_DEBUG_CAMERA_ZOOM, debug_camera_zoom + 0.1);
	}
	
	if(mouse_wheel_down()){
		debug_camera_zoom = max(MIN_DEBUG_CAMERA_ZOOM, debug_camera_zoom - 0.1);
	}
	
	if(keyboard_check(vk_space)){
		if(mouse_check_button(mb_left)){
			debug_camera_moving_around_x -= window_mouse_get_delta_x();
			debug_camera_moving_around_y -= window_mouse_get_delta_y();
		}
		camera_set_view_pos(view_camera[0], 
		debug_camera_moving_around_x - offset_x / debug_camera_zoom, 
		debug_camera_moving_around_y - offset_y / debug_camera_zoom);
	}
	else if(!keyboard_check(vk_space)){
		debug_camera_moving_around_x = obj_player.x;
		debug_camera_moving_around_y = obj_player.y;
		camera_set_view_pos(view_camera[0], obj_player.x - offset_x / debug_camera_zoom, obj_player.y - offset_y / debug_camera_zoom);
	}
	
	camera_set_view_size(view_camera[0], DEFAULT_CAMERA_WIDTH / debug_camera_zoom, DEFAULT_CAMERA_HEIGHT / debug_camera_zoom);
} 

function make_debug_zoom_bar_surf(){
	if(!debug_camera_mode){
		return;
	}
	
	if(!surface_exists(debug_zoom_bar_surf)){
		debug_zoom_bar_surf = surface_create(100, 30);
	}
	
	surface_set_target(debug_zoom_bar_surf);
	if(!debug_camera_mode){
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
		return;
	}
	draw_clear_alpha(c_black, 0);
	draw_set_color(c_white);
	draw_rectangle(13, 1, 98, 9, true);
	var _half_size = 5;
	var _x = lerp(_half_size + 2, 97 - _half_size, debug_camera_zoom / MAX_DEBUG_CAMERA_ZOOM);
	draw_set_color(c_red);
	draw_rectangle(_x - _half_size, 2, _x + _half_size, 8, true);
	surface_reset_target();
}

function draw_debug_info(){
	if(!instance_exists(obj_player)){
		return;
	}
	if(!debug_camera_mode){
		return;
	}
	draw_set_font(fnt_arial_11);
	draw_set_color(c_white);
	font_enable_effects(fnt_arial_11, true,{
		outlineEnable : true,
		outlineDistance : 0,
		outlineColor : c_black
	});
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_left);
	draw_text(32, 576, 
	string("Mouse wheel up / down to zoom in / out : {0}\nSpace + L mouse button to move around", debug_camera_zoom));

	if(surface_exists(debug_zoom_bar_surf)){
		draw_surface(debug_zoom_bar_surf, 21, 532);
	}
}