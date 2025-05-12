/// @description Actions
function handle_inventory_ui(){
	if(instance_number(obj_player_inventory_ui) < 1){
		instance_create_depth(x, y, layer_get_depth(layer), obj_player_inventory_ui);
	}
}

function handle_inventory_index(){
	if(!ENABLE_ITEM_AND_INVENTORY){
		return;
	}
	
	if(keyboard_check_pressed(global.key_config.item_swap)){
		inventory_anmation_value = 0;
		handle_inventory_ui();
		var _index = global.other_player_data.inventory_index;
		var _len = array_length(global.other_player_data.inventory);
		global.other_player_data.inventory_index = _index < _len - 1 ? _index + 1 : 0;
		play_sound(snd_item_swap, 1, false);
	}
	
	if(!global.settings.swap_items_with_number_keys){
		return;
	}
	
	for(var _i = 1; _i <= array_length(global.other_player_data.inventory); _i++){
		if(keyboard_check_pressed(vk_anykey) && get_key_str(keyboard_key) == string(_i)){
			inventory_anmation_value = 0;
			handle_inventory_ui();
			global.other_player_data.inventory_index = _i - 1;
			play_sound(snd_item_swap, 1, false);
			return;
		}
	}
}

function shoot_telekid(){
	if(instance_number(obj_telekid_ghost) > 0){
		return;
	}
	
	var _dir = draw_angle + 270;
	var _xscale_sign = 1;
	
	if(touching_walljump){
		_dir = draw_angle + 90;
		_xscale_sign = -1;
	}
	
	if(keyboard_check_pressed(global.key_config.shoot)){
		play_sound(snd_telekid_shoot, 0);
		var _inst = instance_create_layer(x, y, layer_get_id("Player"), obj_telekid_ghost);
		_inst.sprite_index = sprite_index;
		_inst.hspd = 4;
		_inst.dir = global.player.xscale > 0 ? _dir - 270 : _dir - 90;
		_inst.image_angle = global.player.gravity_dir - 270;
		_inst.xscale = touching_walljump ? -global.player.xscale : global.player.xscale;
		_inst.xscale *= _xscale_sign;
		_inst.yscale = global.player.yscale;
		_inst.gravity_dir = global.player.gravity_dir;
		_inst.mom = id;
	}
}

function handle_enable_dotkid_indicator(){
	if(keyboard_check_pressed(global.key_config.shoot)){
		if(enable_dotkid_indicator){
			enable_dotkid_indicator = false;
		}
		else{
			enable_dotkid_indicator = true;
		}
	}
}

function handle_pop_gun(){
	var _dir = draw_angle + 270;
	
	if(touching_walljump){
		_dir = draw_angle + 90;
	}
	
	if(keyboard_check_pressed(global.key_config.shoot)){
		var _inst = instance_create_layer(x, y, layer_get_id("Player"), obj_bullet);
		with(_inst){
			x -= lengthdir_x(2, _dir);
			y -= lengthdir_y(2, _dir);
			speed = 12;
			direction = global.player.xscale > 0 ? _dir - 270 : _dir - 90;
		}
		play_sound(snd_shoot, 1, false);
	}
}

function handle_machine_gun(){
	var _dir = draw_angle + 270;
	
	if(touching_walljump){
		_dir = draw_angle + 90;
	}
	
	if(keyboard_check(global.key_config.shoot) && global.other_player_data.time % 5 == 0){
		var _inst = instance_create_layer(x, y, layer_get_id("Player"), obj_bullet);
		with(_inst){
			x -= lengthdir_x(2, _dir);
			y -= lengthdir_y(2, _dir);
			speed = 12;
			direction = global.player.xscale > 0 ? _dir - 270 : _dir - 90;
		}
		play_sound(snd_shoot, 1, false);
	}
}

function use_item(){
	if(global.player.kid_mode == "telekid"){
		shoot_telekid();
		return;
	}
	else if(global.player.kid_mode == "dotkid"){
		handle_enable_dotkid_indicator();
		return;
	}
	
	var _index = global.other_player_data.inventory_index;
	switch(global.other_player_data.inventory[_index]){
		case "pop_gun":
			handle_pop_gun();
			break;
		case "machine_gun":
			handle_machine_gun();
			break;
	}
}

function handle_actions(){
	if(global.game_over){
		return;
	}
	
	if(frozen){
		return;
	}

	handle_inventory_index();
	use_item();
}