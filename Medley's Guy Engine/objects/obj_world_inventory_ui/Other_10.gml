 /// @description local library
function handle_animation_value(){
	var _transition_spd = 0.1;
	var _value = obj_world.settings_inventory_ui_anim_time;
	if(_value < 1){
		obj_world.settings_inventory_ui_anim_time = min(1, _value + _transition_spd);
	}
}

function find_inventory_icon_index(_index){
	switch(global.other_player_data.inventory[_index]){
		case "pop_gun":
			return 0;
		case "machine_gun":
			return 1;
		case "shot_gun":
			return 2;
		case "rocket_gun":
			return 3;
	}
}

function make_graph_surf(){ 
	if(surface_exists(graph_surf)){
		surface_free(graph_surf);
	}
	
	graph_surf = surface_create(array_length(global.other_player_data.inventory) * (icon_width + gap_between_icons), icon_height);
	surface_set_target(graph_surf);
	var _pos_x = 0;
	for(var _index = 0; _index <= 2 * array_length(global.other_player_data.inventory); _index++){
		if(_index % 2 == 1){
			draw_sprite(spr_item_icon, find_inventory_icon_index((_index - 1) / 2), _pos_x, 0);
			_pos_x += icon_width;
		}
		else{
			_pos_x += gap_between_icons;
		}
	}
	surface_reset_target();
}

function make_final_surf(){
	make_graph_surf();
	
	if(surface_exists(final_surf)){
		surface_free(final_surf);
	}
	
	final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);
	
	if(!global.in_game){
		surface_set_target(final_surf);
		draw_clear(make_color_rgb(40, 40, 40));
		scribble("NO DATA")
			.starting_format("fnt_serif_bold_24", c_white)
			.scale(0.5, 0.5)
			.align(fa_center, fa_middle)
			.blend(c_white, obj_world.settings_master_alpha)
			.draw(mean(0, surface_get_width(final_surf)), mean(0, surface_get_height(final_surf)));
		surface_reset_target();
		return;
	}
	
	to_x = (icon_width + gap_between_icons) * 3 - obj_world.settings_inventory_index * (icon_width + gap_between_icons);
	draw_x = lerp(draw_x, to_x, obj_world.settings_inventory_ui_anim_time);
	
	surface_set_target(final_surf);
	draw_clear(make_color_rgb(40, 40, 40));
	var _resolution = shader_get_uniform(sh_hub_outline_shading, "iResolution"); 
	var _icon_width = shader_get_uniform(sh_hub_outline_shading, "gap"); 
	shader_set(sh_player_info_outline_shading);
	draw_surface(graph_surf, draw_x, 0);
	draw_sprite(spr_settings_select_icon, 0, (icon_width + gap_between_icons) * 3 + gap_between_icons, 0);
	shader_set_uniform_f(_resolution, surface_get_width(final_surf), surface_get_height(final_surf));
	shader_set_uniform_f(_icon_width, icon_width + gap_between_icons);
	shader_reset();
	surface_reset_target();
}