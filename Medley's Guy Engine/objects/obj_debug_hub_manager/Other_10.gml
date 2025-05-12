 /// @description local library
function create_default_graph_surf(_level, _column1){
	switch(_level){
		case 0:
			graph_surf = surface_create(array_length(graph) * (icon_width + gap_between_icons), icon_height);
			break;
		case 1:
			graph_surf = surface_create(array_length(graph[_column1]) * (icon_width + gap_between_icons), icon_height);
			break;
	}
}

function set_surf_x(_level, _column1, _column2){
	switch(_level){
		case 0:
			return -_column1 * (icon_width + gap_between_icons);
		case 1:
			return -_column2 * (icon_width + gap_between_icons);
	}
}

function find_name(_level, _column1, _column2){
	switch(_level){
		case 0:
			return row1_names[_column1];
		case 1:
			return row2_names[_column1][_column2];
	}
}

function set_recent_drawing(_level, _column1, _column2){
	recent_drawing = [];
	switch(_level){
		case 0:
			for(var _index = 0; _index < array_length(graph); _index++){
				array_push(recent_drawing, find_name(_level, _index, _column2));
			}
			break;
		case 1:
			for(var _index = 0; _index < array_length(graph[_column1]); _index++){
				array_push(recent_drawing, find_name(_level, _column1, _index));
			}
			break;
	}
}

function column_change(_column, _array){
	if(_column < array_length(_array) - 1 && !frozen && keyboard_check_pressed(vk_right)){
		_column++;
		frozen = true;
		time = 0;
		column_adjust = -1;
	}
	else if(_column > 0 && !frozen && keyboard_check_pressed(vk_left)){
		_column--;
		frozen = true;
		time = 0;
		column_adjust = 1;
	}
	return _column;
}

function select_room(_level, _column1, _column2){
	switch(_level){
		case 0:
			column1 = column_change(_column1, graph);
			break;
		case 1:
			column2 = column_change(_column2, graph[_column1]);
			break;
	}
	
	if(!frozen && keyboard_check_pressed(vk_shift)){
		switch(_level){
			case 0:
				level++;
				set_recent_drawing(level, column1, column2);
				create_default_graph_surf(level, column1);
				surf_x = set_surf_x(level, column1, column2);
				break;
			case 1:
				global.warp.room = graph[column1][column2];
				room_goto(global.warp.room);
				break;
		}
	}
	else if(!frozen && keyboard_check_pressed(ord("Z"))){
		if(_level == 1){
			level--;
			column2 = 0;
			set_recent_drawing(level, column1, column2);
			create_default_graph_surf(level, column1);
			surf_x = set_surf_x(level, column1, column2);
		}
	}
}

function make_graph_surf(_level, _column1, _column2){ 
	if(!surface_exists(graph_surf)){
		create_default_graph_surf(_level, _column1);
	};	
	if(!surface_exists(final_surf)){
		final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons + 1), icon_height);
	}
	if(frozen){
		time = min(time + 1, HUB_MANAGER_FROZEN_TIME);
		var _channel = animcurve_get_channel(ac_ease, 0);
		surf_x = set_surf_x(_level, column_adjust + _column1, column_adjust + _column2) 
		+ lerp(0, column_adjust * (icon_width + gap_between_icons), animcurve_channel_evaluate(_channel, time / HUB_MANAGER_FROZEN_TIME));
		
		if(time == HUB_MANAGER_FROZEN_TIME){
			frozen = false;
		}
	}
	var _draw_surf = function(_array){
		var _pos_x = 0;
		for(var _index = 0; _index <= 2 * array_length(_array); _index++){
			if(_index % 2 == 1){
				draw_set_color(c_white);
				draw_rectangle(_pos_x, 0, _pos_x + icon_width - 1, icon_height, false);
				var _text = scribble(recent_drawing[(_index - 1) / 2])
					.wrap(icon_width - 10)
					.starting_format("fnt_arial_11", c_black)
					.align(fa_left, fa_top);
				_text.draw(_pos_x + 1, 1);
					
				_pos_x += icon_width;
			}
			else{
				_pos_x += gap_between_icons;
			}
		}
	}
	
	surface_set_target(graph_surf);
	switch(_level){
		case 0:
			_draw_surf(graph);
			break;
		case 1:
			_draw_surf(graph[_column1]);
			break;
	}
	surface_reset_target();
	
	surface_set_target(final_surf);
	draw_clear_alpha(c_black, 0);
	var _resolution = shader_get_uniform(sh_hub_outline_shading, "iResolution"); 
	var _gap = shader_get_uniform(sh_hub_outline_shading, "gap"); 
	shader_set(sh_hub_outline_shading);
	draw_surface(graph_surf, icon_width + gap_between_icons + surf_x, 0);
	shader_set_uniform_f(_resolution, how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);
	shader_set_uniform_f(_gap, gap_between_icons + icon_width);
	shader_reset();
	surface_reset_target();
}