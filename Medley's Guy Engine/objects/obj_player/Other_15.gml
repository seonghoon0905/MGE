/// @description ETC
function handle_time(){
	if(global.game_over){
		return;
	}
	
	global.other_player_data.time++;
}

function handle_jump_star_particle(_col){
	if(_col == undefined){
		return;
	}
	
	var _ps = part_system_create();
	part_system_depth(_ps, layer_get_depth("Player"));
	part_system_draw_order(_ps, true);

	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_star);
	part_type_size(_ptype1, 0.05, 0.1, 0, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 0.1, 1, 0, 0);
	part_type_direction(_ptype1, global.player.gravity_dir - 90, global.player.gravity_dir + 90, 0, 0);
	part_type_gravity(_ptype1, 0.2, global.player.gravity_dir);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, _col, _col, _col);
	part_type_alpha3(_ptype1, 1, 0.5, 0);
	part_type_blend(_ptype1, false);
	part_type_life(_ptype1, 5, 15);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -0.5, 0.5, -0.5, 0.5, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 20);

	part_system_position(_ps, x, y);
}

function handle_oak_cask_particle(){
	var _ps = part_system_create();
	part_system_depth(_ps, layer_get_depth("Player"));
	part_system_draw_order(_ps, true);
	
	var _scale = global.player.kid_mode == "dotkid" ? 0.1 : 0.35;

	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_smoke);
	part_type_size(_ptype1, 0.8, 1, -0.075, 0);
	part_type_scale(_ptype1, _scale, _scale);
	part_type_speed(_ptype1, -5, -6, 0, 0);
	part_type_direction(_ptype1, global.player.gravity_dir - 70, global.player.gravity_dir + 70, 0, 0);
	part_type_gravity(_ptype1, 0.3, global.player.gravity_dir);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, c_red, c_yellow, c_black);
	part_type_alpha3(_ptype1, 1, 1, 1);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 20, 30);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, -0.5, 0.5, -0.5, 0.5, ps_shape_rectangle, ps_distr_linear);
	part_emitter_burst(_ps, _pemit1, _ptype1, 1);

	part_system_position(_ps, x, y);
}

function handle_purple_walljump_particle(){
	var _ps = part_system_create();
	part_system_depth(_ps, layer_get_depth("Player") + 100);
	part_system_draw_order(_ps, true);

	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_flare);
	part_type_size(_ptype1, 0.25, 0.5, -0.02, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 2, -2, 0, 0);
	part_type_direction(_ptype1, 0, 360, 0, 0);
	part_type_gravity(_ptype1, 0, 0);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour1(_ptype1, $660066);
	part_type_alpha1(_ptype1, 0.7);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 25, 50);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_ellipse, ps_distr_invgaussian);
	part_emitter_burst(_ps, _pemit1, _ptype1, 1);

	part_system_position(_ps, x, y);
}

function handle_fire_walljump_particle(){
	var _ps = part_system_create();
	part_system_depth(_ps, layer_get_depth("Player") + 100);
	part_system_draw_order(_ps, true);

	var _ptype1 = part_type_create();
	part_type_shape(_ptype1, pt_shape_spark);
	part_type_size(_ptype1, 0.25, 0.35, -0.02, 0);
	part_type_scale(_ptype1, 1, 1);
	part_type_speed(_ptype1, 2, -2, 0, 0);
	part_type_direction(_ptype1, 0, 360, 0, 0);
	part_type_gravity(_ptype1, 0.2, global.player.gravity_dir - 180);
	part_type_orientation(_ptype1, 0, 0, 0, 0, false);
	part_type_colour3(_ptype1, c_red, c_orange, c_yellow);
	part_type_alpha3(_ptype1, 0.7, 0.7, 0.7);
	part_type_blend(_ptype1, true);
	part_type_life(_ptype1, 25, 50);

	var _pemit1 = part_emitter_create(_ps);
	part_emitter_region(_ps, _pemit1, 0, 0, 0, 0, ps_shape_ellipse, ps_distr_invgaussian);
	part_emitter_burst(_ps, _pemit1, _ptype1, 1);

	part_system_position(_ps, x, y);

}