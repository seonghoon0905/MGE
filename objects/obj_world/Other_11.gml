/// @description Settings UI
function handle_index_ui_str(){
	var _indexes = [
		"Player\n\n",
		"Achivement\n\n",
		"Display\n\n",
		"Audio\n\n",
		"Keyboard Controls\n\n",
		"Back To Title\n\n",
		"Quit Game"
	];
	
	var _str = "";
	
	for(var _i = 0; _i < array_length(settings_array_of_index); _i++){
		var _len = array_length(settings_array_of_index[_i]);
		
		if(_len < 1){
			continue;
		}
		
		_str += _indexes[_i];
	}
	
	return _str;
}

function handle_settings_pause_screen(){
	if(!(global.game_paused && on_setting && !simple_pause)){
		return;
	}
	
	draw_sprite(pause_sprite, 0, 0, 0);
}

function handle_settings_master_alpha(){
	var _transition_spd = 0.05; 
	var _master_alpha = settings_master_alpha;
	
	if(!on_setting){
		settings_master_alpha = max(0, _master_alpha - _transition_spd);
	}
	else{
		settings_master_alpha = min(1, _master_alpha + _transition_spd);
	}
}

function handle_settings_ui_background(){
	var _alpha = 0.75;
	draw_set_color(c_black);
	draw_set_alpha(_alpha * settings_master_alpha);
	draw_rectangle(0, 0, DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT, false);
	draw_set_alpha(1);
}

function handle_settings_index_ui(){
	var _arctan = animcurve_get_channel(ac_arctan, 0);
	var _amount = animcurve_channel_evaluate(_arctan, settings_master_alpha);
	var _h = lerp(0, DEFAULT_CAMERA_HEIGHT, _amount);
	
	draw_set_color(c_white);
	
	if(_h != 0){
		draw_rectangle(70, 0, 270, _h, false);
	}
	
	scribble("Settings")
		.starting_format("fnt_serif_bold_24", c_black)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(95, 70);
	
	scribble(index_ui_str)
		.starting_format("fnt_serif_bold_24", c_black)
		.transform(16 / 28, 16 / 28)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(95, 170);
}

function handle_settings_index_arrow_time(){
	var _transition_spd = 0.05;
	if(keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down)){
		settings_index_arrow_time = 0;
	}
	
	if(keyboard_check_pressed(vk_shift)){
		settings_index_arrow_time = 1;
	}
	
	if(settings_index_arrow_time < 1){
		settings_index_arrow_time += _transition_spd;
	}
}

function handle_settings_index_arrow1_ui(){
	var _start_y = 170;
	var _font_height = 15;
	var _line_space = 30;
	var _len = index_array_length;
	var _height = _len * _font_height + (_len - 1) * _line_space;
	var _gap = _font_height + _line_space;
	var _row_index = handle_index_arrow1_row_index(settings_row_index);
	var _to_y = lerp(0, _height, _gap * _row_index / _height);
	
	handle_settings_index_arrow_time();
	var _amount = min(1, settings_index_arrow_time);
	settings_index_arrow1_y = lerp(settings_index_arrow1_y, _start_y + _to_y, _amount);
	
	var _alpha = settings_master_alpha;
	draw_sprite_ext(spr_settings_index_arrow1, 0, 81, settings_index_arrow1_y + 6, 0.15, 0.15, 0, c_white, _alpha);  
}

function handle_settings_index_arrow2_ui(){
	if(!is_settings_row_index_selected){
		return;
	}
	if(array_length(settings_arrow2_to_y_list) == 0){
		return;
	}
	var _to_y = settings_arrow2_to_y_list[settings_column_index];
	
	handle_settings_index_arrow_time();
	
	var _amount = min(1, settings_index_arrow_time);

	settings_index_arrow2_y = lerp(settings_index_arrow2_y, _to_y, _amount);
	
	var _alpha = settings_master_alpha;
	draw_sprite_ext(spr_settings_index_arrow2, 0, 283, settings_index_arrow2_y + 13, 0.2, 0.2, 0, c_white, _alpha);  
}

function handle_arrow2_to_y_list_on_player_info(){
	if(ENABLE_SKIN && ENABLE_ITEM_AND_INVENTORY && ENABLE_PLAYER_BACKSTEP){
		array_push(settings_arrow2_to_y_list, 128);
		
		array_push(settings_arrow2_to_y_list, 226);
		array_push(settings_arrow2_to_y_list, 321);
		array_push(settings_arrow2_to_y_list, 374);
		
		array_push(settings_arrow2_to_y_list, 426);
	}
	else if(ENABLE_SKIN && ENABLE_PLAYER_BACKSTEP){
		array_push(settings_arrow2_to_y_list, 129);
		
		array_push(settings_arrow2_to_y_list, 189);
	}
	else if(ENABLE_ITEM_AND_INVENTORY && ENABLE_PLAYER_BACKSTEP){
		array_push(settings_arrow2_to_y_list, 129);
		
		array_push(settings_arrow2_to_y_list, 226);
	}
	else if(ENABLE_PLAYER_BACKSTEP){
		array_push(settings_arrow2_to_y_list, 96);
	}
}

function handle_settings_skin_ui(){
	if(!ENABLE_SKIN){
		return;
	}
	
	if(settings_row_index == 0){
		if(instance_number(obj_world_skin_ui) < 1){
			instance_create_depth(x, y, layer_get_depth(layer) - 1, obj_world_skin_ui);
		}
	}
}

function handle_settings_item_ui(){
	if(!ENABLE_ITEM_AND_INVENTORY){
		return;
	}
	
	if(settings_row_index == 0){
		if(instance_number(obj_world_item_ui) < 1){
			instance_create_depth(x, y, layer_get_depth(layer) - 1, obj_world_item_ui);
		}
	}
}

function handle_settings_inventory_ui(){
	if(!ENABLE_ITEM_AND_INVENTORY){
		return;
	}
	
	if(settings_row_index == 0){
		if(instance_number(obj_world_inventory_ui) < 1){
			instance_create_depth(x, y, layer_get_depth(layer) - 1, obj_world_inventory_ui);
		}
	}
}

function handle_settings_swap_items_with_number_keys_ui(){
	if(!ENABLE_ITEM_AND_INVENTORY){
		return;
	}
	
	var _y = 0;
	
	if(ENABLE_SKIN){
		_y = 378;
	}
	else{
		_y = 290;
	}
	
	var _str;
	if(global.settings.swap_items_with_number_keys){
		_str = "Swap items with number keys : [[ON] / OFF"
	}
	else{
		_str = "Swap items with number keys : ON / [[OFF]"
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, _y);
}

function handle_settings_backstep_ui(){
	if(!ENABLE_PLAYER_BACKSTEP){
		return;
	}
	
	var _y = 0;

	if(ENABLE_SKIN && ENABLE_ITEM_AND_INVENTORY){
		_y = 430;
	}
	else if(ENABLE_SKIN){
		_y = 193;
	}
	else if(ENABLE_ITEM_AND_INVENTORY){
		_y = 337;
	}
	else{
		_y = 100;
	}
	
	var _str;
	if(global.settings.backstep){
		_str = "Backstep : [[ON] / OFF"
	}
	else{
		_str = "Backstep : ON / [[OFF]"
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, _y);
}

function handle_settings_achivement_ui(){
	if(!ENABLE_ACHIEVEMENT){
		return;
	}
	
	if(settings_row_index == 1){
		if(instance_number(obj_world_achievement_ui) < 1){
			instance_create_depth(x, y, layer_get_depth(layer) - 1, obj_world_achievement_ui);
		}
	}
}

function handle_settings_fullscreen_ui(){
	var _str;
	if(global.settings.fullscreen){
		_str = "Fullscreen : [[ON] / OFF"
	}
	else{
		_str = "Fullscreen : ON / [[OFF]"
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 100);
		
	array_push(settings_arrow2_to_y_list, 96);
}

function handle_settings_window_size_ui(){
    var _str;
    
    switch(global.settings.window_size){
        case 0:
		    _str = "Window Size : [[100%] / 120% / 150% / 200%";
            break;
        case 1:
            _str = "Window Size : 100% / [[120%] / 150% / 200%";
            break;
        case 2:
            _str = "Window Size : 100% / 120% / [[150%] / 200%";
            break;
        case 3:
            _str = "Window Size : 100% / 120% / 150% / [[200%]";
            break;
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 145);
		
	array_push(settings_arrow2_to_y_list, 141);
}

function handle_settings_smoothing_mode_ui(){
	var _str;
	
	if(global.settings.smoothing_mode){
		_str = "Smoothing Mode : [[ON] / OFF"
	}
	else{
		_str = "Smoothing Mode : ON / [[OFF]"
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 190);
		
	array_push(settings_arrow2_to_y_list, 186);
}

function handle_settings_vsync_ui(){
	var _str;
	
	if(global.settings.vsync){
		_str = "Vsync : [[ON] / OFF"
	}
	else{
		_str = "Vsync : ON / [[OFF]"
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 235);
		
	array_push(settings_arrow2_to_y_list, 231);
}

function handle_settings_master_volume_ui(){
	scribble("Master volume | " + string(global.settings.master_volume))
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 100);
	
	draw_set_color(c_white);
	draw_set_alpha(settings_master_alpha);
	var _x2 = lerp(300, 760, global.settings.master_volume / 100);
	draw_rectangle(300, 145, _x2, 175, false);
	draw_set_alpha(1);
	
	array_push(settings_arrow2_to_y_list, 96);
}

function handle_settings_music_volume_ui(){
	scribble("Music volume | " + string(global.settings.music_volume))
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 205);
	
	draw_set_color(c_white);
	draw_set_alpha(settings_master_alpha);
	var _x2 = lerp(300, 760, global.settings.music_volume / 100);
	draw_rectangle(300, 250, _x2, 280, false);
	draw_set_alpha(1);
	
	array_push(settings_arrow2_to_y_list, 201);
}

function handle_settings_effect_volume_ui(){
	scribble("Effect volume | " + string(global.settings.effect_volume))
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 310);
	
	draw_set_color(c_white);
	draw_set_alpha(settings_master_alpha);
	var _x2 = lerp(300, 760, global.settings.effect_volume / 100);
	draw_rectangle(300, 355, _x2, 385, false);
	draw_set_alpha(1);
	
	array_push(settings_arrow2_to_y_list, 306);
}

function handle_settings_fps_sync_ui(){
	var _str;
	
	if(global.settings.fps_sync){
		_str = "FPS Sync : [[ON] / OFF"
	}
	else{
		_str = "FPS Sync : ON / [[OFF]"
	}
	
	scribble(_str)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.7, 0.7)
		.align(fa_left, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(300, 415);
		
	array_push(settings_arrow2_to_y_list, 411);
}

function handle_settings_keyboard_controls_ui(){	
	var _y = 100;
	var _row = settings_row_index;
	
	var _name_list = handle_name_list_on_keyboard_control();
	var _index = 0;
	
	repeat(array_length(_name_list)){
		scribble(settings_array_of_index[_row][_index])
			.starting_format("fnt_serif_bold_24", c_white)
			.transform(0.7, 0.7)
			.align(fa_left, fa_top)
			.blend(c_white, settings_master_alpha)
			.draw(300, _y);
			
		var _str = 
		settings_is_key_selected && (_index == settings_column_index) ? 
		"Select a key" : 
		get_key_str(global.key_config[$ _name_list[_index]]);
		
		scribble(_str)
			.starting_format("fnt_serif_bold_24", c_white)
			.transform(0.7, 0.7)
			.align(fa_right, fa_top)
			.blend(c_white, settings_master_alpha)
			.draw(760, _y);
			
		array_push(settings_arrow2_to_y_list, _y - 4);
		
		_y += 40;
		_index++;
	}
}

function handle_settings_extra_info(){
	var _hour = global.other_player_data.time div (GAME_SPEED * 60 * 60);
	var _minute = global.other_player_data.time div (GAME_SPEED * 60);
	var _second = global.other_player_data.time div GAME_SPEED;
	
	_minute %= 60;
	_second %= 60;
	
	scribble(
		string(
		"[scale, 0.45]Time : {0}:{1}:{2} | Death : {3}\n[scale, 0.35]Shift & Arrow Keys to select | Z to back | ESC to exit"
		, _hour, _minute, _second, global.other_player_data.death_count)
	)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(1 , 1)
		.align(fa_right, fa_top)
		.blend(c_white, settings_master_alpha)
		.draw(DEFAULT_CAMERA_WIDTH - 16, 16);
}

function draw_settings_ui(){
	handle_settings_pause_screen();
	handle_settings_master_alpha();
	
	if(settings_master_alpha == 0){
		if(instance_exists(obj_world_skin_ui)){
			instance_destroy(obj_world_skin_ui);
		}
		
		if(instance_exists(obj_world_item_ui)){
			instance_destroy(obj_world_item_ui);
			settings_item_index = 0;
		}
		
		if(instance_exists(obj_world_inventory_ui)){
			instance_destroy(obj_world_inventory_ui);
			settings_inventory_index = 0;
		}
		
		if(instance_exists(obj_world_achievement_ui)){
			instance_destroy(obj_world_achievement_ui);
		}
		return;
	}
	
	handle_settings_ui_background();
	handle_settings_index_ui();
	handle_settings_index_arrow1_ui();
	handle_settings_skin_ui();
	handle_settings_item_ui();
	handle_settings_inventory_ui();
	handle_settings_achivement_ui();
	
	settings_arrow2_to_y_list = [];
	
	switch(settings_row_index){
		case 0:
			handle_arrow2_to_y_list_on_player_info();
			handle_settings_swap_items_with_number_keys_ui();
			handle_settings_backstep_ui();
			break;
		case 1:
			array_push(settings_arrow2_to_y_list, 287);
			break;
		case 2:
			handle_settings_fullscreen_ui();
            handle_settings_window_size_ui();
			handle_settings_smoothing_mode_ui();
            handle_settings_vsync_ui();
			break;
		case 3:
			handle_settings_master_volume_ui();
			handle_settings_music_volume_ui();
			handle_settings_effect_volume_ui();
			handle_settings_fps_sync_ui();
			break;
		case 4:
			handle_settings_keyboard_controls_ui();
			break;
	}
	handle_settings_index_arrow2_ui();
	handle_settings_extra_info();
}

