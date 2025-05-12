pos_x = x;
pos_y = y;

alpha = 0;
icon_width = 25;
icon_height = 25;
gap_between_icons = 3;
how_many_to_show = 3;

draw_x = icon_width + gap_between_icons - global.other_player_data.inventory_index * (icon_width + gap_between_icons);
to_x = icon_width + gap_between_icons - global.other_player_data.inventory_index * (icon_width + gap_between_icons);

graph_surf = surface_create(array_length(global.other_player_data.inventory) * (icon_width + gap_between_icons), icon_height);
final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);

event_user(0); // local library
make_graph_surf();

// event function 
function step(){
	if(!instance_exists(obj_player)){
		return;
	}
	handle_animation_value();
	make_final_surf();
	handle_destroy();
}

function draw(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	handle_pos();
	handle_alpha();
	
	if(surface_exists(final_surf)){
		var _dir = global.player.gravity_dir - 270;
		draw_surface_ext(final_surf, pos_x, pos_y, 1, 1, _dir, c_white, alpha);
	}
}

function clean_up(){
	if(surface_exists(graph_surf)){
		surface_free(graph_surf);
	}

	if(surface_exists(final_surf)){
		surface_free(final_surf);
	}
}