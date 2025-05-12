 /// @description local library
function handle_pos(){
	var _offset_x = -42 * abs(global.player.xscale);
	var _offset_y = -40 * global.player.yscale;
	var _len = point_distance(0, 0, _offset_x, _offset_y);
	var _dir = point_direction(0, 0, _offset_x, _offset_y);
	if(instance_exists(obj_player)){
		pos_x = obj_player.x + lengthdir_x(_len, _dir + global.player.gravity_dir - 270);
		pos_y = obj_player.y + lengthdir_y(_len, _dir + global.player.gravity_dir - 270);
	}
}

function handle_animation_value(){
	var _transition_spd = 0.05;
	var _value = obj_player.inventory_anmation_value;
	if(keyboard_check_pressed(global.key_config.item_swap)){
		obj_player.inventory_anmation_value = 0;
	}
	else if(_value < 1){
		obj_player.inventory_anmation_value = min(1, _value + _transition_spd);
	}
}

function handle_destroy(){
	if(obj_player.inventory_anmation_value >= 1){
		if(surface_exists(graph_surf)){
			surface_free(graph_surf);
		}

		if(surface_exists(final_surf)){
			surface_free(final_surf);
		}
		instance_destroy();
	}
}

function handle_alpha(){
	var _fade_in_out = animcurve_get_channel(ac_fade_out1, 0);
	alpha = animcurve_channel_evaluate(_fade_in_out, obj_player.inventory_anmation_value);
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
	graph_surf = surface_create(array_length(global.other_player_data.inventory) * (icon_width + gap_between_icons), icon_height);
	surface_set_target(graph_surf);
	var _pos_x = 0;
	for(var _index = 0; _index <= 2 * array_length(global.other_player_data.inventory); _index++){
		if(_index % 2 == 1){
			draw_sprite(spr_item_small_icon, find_inventory_icon_index((_index - 1) / 2), _pos_x, 0);
			_pos_x += icon_width;
		}
		else{
			_pos_x += gap_between_icons;
		}
	}
	surface_reset_target();
}

function make_final_surf(){
	if(!surface_exists(graph_surf)){
		make_graph_surf();
	}
	if(!surface_exists(final_surf)){
		final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);
	}
	
	to_x = icon_width + gap_between_icons - global.other_player_data.inventory_index * (icon_width + gap_between_icons);
	draw_x = lerp(draw_x, to_x, obj_player.inventory_anmation_value);
	
	surface_set_target(final_surf);
	draw_clear_alpha(c_black, 0);
	var _resolution = shader_get_uniform(sh_hub_outline_shading, "iResolution"); 
	var _icon_width = shader_get_uniform(sh_hub_outline_shading, "gap"); 
	shader_set(sh_player_inventory_outline_shading);
	draw_surface(graph_surf, draw_x, 0);
	shader_set_uniform_f(_resolution, surface_get_width(final_surf), surface_get_height(final_surf));
	shader_set_uniform_f(_icon_width, icon_width + gap_between_icons);
	shader_reset();
	surface_reset_target();
}