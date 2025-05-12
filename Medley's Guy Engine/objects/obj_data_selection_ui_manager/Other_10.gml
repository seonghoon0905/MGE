/// @description local library
function handle_animation_value(){
	var _transition_spd = 0.02;
	if(animation_value < 1){
		animation_value = min(1, animation_value + _transition_spd);
	}
}

function handle_snapshot(){
	if(snapshot[global.savedata_index] != undefined){
		draw_sprite_ext(snapshot[global.savedata_index], 0, 0, 0, 1, 1, 0, c_white, .5);
	}
	else{
		scribble("No data")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_middle, fa_top)
			.blend(c_white, 0.5)
			.draw(400, 314);
	}
}

function make_graph_surf(){ 
	if(parent_id == noone){
		return;
	}
	
	surface_free(graph_surf);
	graph_surf = surface_create(DATA_SLOT * (icon_width + gap_between_icons), icon_height);
	surface_set_target(graph_surf);
	
	var _pos_x = 0;
	for(var _index = 0; _index <= 2 * DATA_SLOT; _index++){
		if(_index % 2 == 1){
			draw_set_color(c_black);
			draw_set_alpha(0.5);
			draw_rectangle(_pos_x, 0, _pos_x + 180, 100, false);
			
			draw_set_color(c_white);
			draw_set_alpha(1);
			
			scribble("DATA " + string((_index - 1) / 2 + 1))
				.starting_format("fnt_serif_bold_24", c_white)
				.transform(0.6, 0.6)
				.align(fa_middle, fa_top)
				.draw(_pos_x + icon_width / 2, 10);
				
			var _hour = time_list[(_index - 1) / 2] div (GAME_SPEED * 60 * 60);
			var _minute = time_list[(_index - 1) / 2] div (GAME_SPEED * 60);
			var _second = time_list[(_index - 1) / 2] div GAME_SPEED;
	
			_minute %= 60;
			_second %= 60;
			
			scribble(
				string("Time / {0}:{1}:{2}\n", _hour, _minute, _second) +
				string("Death / {0}", death_list[(_index - 1) / 2])
			)
				.starting_format("fnt_serif_bold_24", c_white)
				.transform(0.5, 0.5)
				.align(fa_middle, fa_middle)
				.draw(_pos_x + icon_width / 2, 60);
		
			_pos_x += icon_width;
		}
		else{
			_pos_x += gap_between_icons;
		}
	}
	surface_reset_target();
}

function make_final_surf(){
	if(!surface_exists(final_surf)){
		final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);
	}
	
	to_x = icon_width + gap_between_icons - global.savedata_index * (icon_width + gap_between_icons);
	draw_x = lerp(draw_x, to_x, animation_value);
	
	surface_set_target(final_surf);
	draw_clear_alpha(c_black, 0);
	var _resolution = shader_get_uniform(sh_hub_outline_shading, "iResolution"); 
	var _icon_width = shader_get_uniform(sh_hub_outline_shading, "gap"); 
	shader_set(sh_title_ui_manager_outline_shading);
	draw_surface(graph_surf, draw_x, 0);
	shader_set_uniform_f(_resolution, surface_get_width(final_surf), surface_get_height(final_surf));
	shader_set_uniform_f(_icon_width, gap_between_icons);
	shader_reset();
	surface_reset_target();
}