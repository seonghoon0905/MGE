parent_id = noone;
time_list = [];
death_list = [];
difficulty_list = [];
secret_items_list = [];
snapshot = [];

pos_x = DEFAULT_CAMERA_WIDTH > 800 ? (DEFAULT_CAMERA_WIDTH - 800) / 2 : 0;
pos_x = round(pos_x);
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
    if(!obj_title_ui_manager.difficulty_pause && !obj_title_ui_manager.data_deleting_pause && keyboard_check_pressed(ord("Z"))){
        with(obj_world){
            global.savedata_index = 0;
        }
        with(obj_title_ui_manager){
            can_enter_data_selection_screen = false;
            data_selection_ui_manager_exist = false; 
        }
        instance_destroy();
    }
    
	handle_animation_value();
	make_graph_surf();
	make_final_surf();
}

function draw(){
    draw_set_alpha(0.9);
    draw_set_color(c_black);
    draw_rectangle(0, 0, DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT, false);
    draw_set_alpha(1);
    
    handle_secretitems();
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