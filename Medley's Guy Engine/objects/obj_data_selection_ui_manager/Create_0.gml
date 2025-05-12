parent_id = noone;
time_list = [];
death_list = [];
snapshot = [];

pos_x = 0;
pos_y = 426;

icon_width = 180;
icon_height = 100;

gap_between_icons = 65;

how_many_to_show = 3;
animation_value = 0;

draw_x = icon_width + gap_between_icons;
to_x = icon_width + gap_between_icons;

graph_surf = surface_create(DATA_SLOT * (icon_width + gap_between_icons), icon_height);
final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);

event_user(0); // local library
make_graph_surf();
make_final_surf();

// event function 
function step(){
	handle_animation_value();
	make_graph_surf();
	make_final_surf();
}

function draw(){
	handle_snapshot();
	if(surface_exists(final_surf)){
		draw_surface_ext(final_surf, pos_x, pos_y, 1, 1, 0, c_white, 1);
	}
} 

function clean_up(){
	for(var _i = 0; _i < DATA_SLOT; _i++){
		if(snapshot[_i] != undefined){
			sprite_delete(snapshot[_i]);
			snapshot[_i] = undefined;
		}
	}
	
	if(surface_exists(graph_surf)){
		surface_free(graph_surf);
	}

	if(surface_exists(final_surf)){
		surface_free(final_surf);
	}
}