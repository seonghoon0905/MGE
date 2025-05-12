#macro HUB_MANAGER_FROZEN_TIME 10
frozen = false;
pos_x = 0;
pos_y = room_height / 2 - 100;
icon_width = 200;
icon_height = 200;
gap_between_icons = 50;
how_many_to_show = 3;
surf_x = 0;

graph = [
	[rm_total_test]
];
row1_names = [
	"[rainbow]test rooms",
];
row2_names = [
	["rm_total_test"]
];

recent_drawing = [];

go_next_key = vk_right;
go_previous_key = vk_left;

time = 0;
column_adjust = 1;

graph_surf = surface_create(1, 1);
final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);

event_user(0); // local library
level = 0;
column1 = 0;
column2 = 0;

create_default_graph_surf(level, column1);
surf_x = set_surf_x(level, column1, column2);
set_recent_drawing(level, column1, column2);

// event function 
function step(){
	select_room(level, column1, column2);
	make_graph_surf(level, column1, column2);
}
function draw(){
	if(surface_exists(final_surf)){
		draw_surface(final_surf, pos_x, pos_y);
	}
	draw_set_font(fnt_arial_11);
	draw_set_color(c_white);
	font_enable_effects(fnt_arial_11, true,{
		outlineEnable : true,
		outlineDistance : 0,
		outlineColor : c_black
	});
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_center);
	draw_text(room_width / 2, 576, 
	@"Press Shift to select
Press Z to go back");
}