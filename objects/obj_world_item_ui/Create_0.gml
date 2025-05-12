pos_x = 300;
pos_y = 225;

if(!ENABLE_SKIN){
	pos_y = 130;
}

icon_width = 32;
icon_height = 32;
gap_between_icons = 30;
how_many_to_show = 7;

to_x = (icon_width + gap_between_icons) * 3;
draw_x = to_x;
now_index = obj_world.settings_item_index;

graph_surf = surface_create(array_length(global.other_player_data.item) * (icon_width + gap_between_icons), icon_height);
final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);

event_user(0); // local library
make_final_surf();

// event function 
function step(){
	if(!instance_exists(obj_world)){
		return;
	}
	
	if(obj_world.settings_master_alpha == 0){
		return;
	}
	
	handle_animation_value();
	make_final_surf();
}

function draw_gui(){
	if(!instance_exists(obj_world)){
		return;
	}
	
	if(obj_world.settings_master_alpha == 0){
		return;
	}
	
	if(surface_exists(final_surf)){
		draw_surface_ext(final_surf, pos_x, pos_y, 1, 1, 0, c_white, obj_world.settings_master_alpha);
	}
	
	// Garbage Collecting
	surface_free(graph_surf);
	surface_free(final_surf);
	
	scribble("Item")
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_bottom)
		.blend(c_white, obj_world.settings_master_alpha)
		.draw(pos_x, pos_y - 5);
		
	scribble("Shift to add an item into the inventory")
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.5, 0.5)
		.align(fa_right, fa_bottom)
		.blend(c_white, obj_world.settings_master_alpha)
		.draw(pos_x + how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, pos_y - 5);
}

function clean_up(){
	if(surface_exists(graph_surf)){
		surface_free(graph_surf);
	}

	if(surface_exists(final_surf)){
		surface_free(final_surf);
	}
}