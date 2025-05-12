function refresh_global_player_data(){
	global.player_data = {
		x : undefined,
		y : undefined,
		room : undefined,
		jump_total : 2,
		xscale : 1,
		yscale : 1,
		gravity_dir : 270,
		kid_mode : "default",
		screen_rotated : false
	}
}

function refresh_global_other_player_data(){
	global.other_player_data = {
		time : 0,
		death_count : 0,
		item : ["pop_gun", "machine_gun", "shot_gun", "rocket_gun"],
		inventory : ["pop_gun"],
		skins : ["standard", "crimson", "round"],
		skin_index : 0,
		inventory_index : 0,
		achievements : array_create(ACHIEVEMENT_SLOT, false)
	}
}

function save_json(_data, _name){
    var _json_string = json_stringify(_data);
    var _buffer = buffer_create(string_byte_length(_json_string) + 1, buffer_fixed, 1);
    buffer_write(_buffer, buffer_string, _json_string);
    buffer_save(_buffer, _name);
    buffer_delete(_buffer);

}

function load_json(_name) {
    var _buffer = buffer_load(_name);
    if(_buffer != -1){
        var _json_string = buffer_read(_buffer, buffer_string);
        buffer_delete(_buffer);
        return json_parse(_json_string);
    }
    else{
        return undefined;
    }
}

function save_json_encrypted(_data, _name, _dict = undefined){
	var _json_string = base64_encode(json_stringify(_data));
	file_save_encrypted(_json_string, _name);
}

function load_json_decrypted(_name) {
	var _json_string = file_open_encrypted(_name);
	if(_json_string != undefined){
		return json_parse(base64_decode(_json_string));
	}
	else{
		return undefined;
	}
}

function save_player_data(_play_snd = true){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(!directory_exists("PlayerData")){
		directory_create("PlayerData");
	}
	
	if(_play_snd){
		play_sound(snd_save, 0);
	}
	
	var _player_x = PRESERVE_FLOATING_POINT ? obj_player.x : floor(obj_player.x);
	var _player_y = PRESERVE_FLOATING_POINT ? obj_player.y : floor(obj_player.y);
	
	global.player_data.x = _player_x;
	global.player_data.y = _player_y;
	global.player_data.jump_total = global.player.jump_total;
	global.player_data.xscale = global.player.xscale;
	global.player_data.yscale = global.player.yscale;
	global.player_data.gravity_dir = global.player.gravity_dir;
	global.player_data.room = room;
	global.player_data.kid_mode = global.player.kid_mode;
	global.player_data.screen_rotated = global.player.screen_rotated;
	save_json_encrypted(global.player_data, string("PlayerData\\PlayerData{0}.sav", global.savedata_index));
}

function apply_macros_to_datas(){
	if(!ENABLE_SKIN){
		global.other_player_data.skins = ["standard"];
		global.other_player_data.skin_index = 0;
	}
	
	if(!ENABLE_ITEM_AND_INVENTORY){
		global.other_player_data.item = ["pop_gun"];
		global.other_player_data.inventory = ["pop_gun"];
		global.other_player_data.inventory_index = 0;
	}
	
	if(!ENABLE_PLAYER_BACKSTEP){
		global.settings.backstep = false;
	}
}

function apply_player_data(_inst = noone){
	global.player.jump_total = global.player_data.jump_total;
	global.player.xscale = global.player_data.xscale;
	global.player.yscale = global.player_data.yscale;
	global.player.gravity_dir = global.player_data.gravity_dir;
	global.player.kid_mode = global.player_data.kid_mode;
	global.player.screen_rotated = global.player_data.screen_rotated;
	
	if(_inst != noone){
		_inst.backstep_sign = sign(global.player.xscale);
		_inst.jump_total = global.player.gravity_dir;
		_inst.image_speed = 1;
		_inst.draw_yscale = global.player.yscale;
		_inst.image_xscale = abs(global.player.xscale);
		_inst.image_yscale = global.player.yscale;
		_inst.draw_angle = global.player.gravity_dir - 270;
		_inst.image_angle = global.player.gravity_dir - 270;
		with(_inst){
			screen_rotate_anim_time = screen_rotate_anim_time_limit - 1;
			rotate_screen();
			update_panda_collision();
			handle_skin();
		}
	}
}

function save_other_player_data(){
	if(!global.in_game){
		return;
	}
	
	if(!directory_exists("OtherPlayerData")){
		directory_create("OtherPlayerData");
	}
	
	save_json_encrypted(global.other_player_data, string("OtherPlayerData\\OtherPlayerData{0}.sav", global.savedata_index));
}

function load_player_data(){
	return load_json_decrypted(string("PlayerData\\PlayerData{0}.sav", global.savedata_index));
}

function load_other_player_data(_index = undefined){
	if(_index == undefined){
		return load_json_decrypted(string("OtherPlayerData\\OtherPlayerData{0}.sav", global.savedata_index));
	}
	else{
		return load_json_decrypted(string("OtherPlayerData\\OtherPlayerData{0}.sav", _index));
	}
}