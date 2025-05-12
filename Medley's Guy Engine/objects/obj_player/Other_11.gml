/// @description Kidmodes
function handle_dotkid_mask(){
	if(global.player.kid_mode == "dotkid"){
		mask_index = spr_dotkid;	
	}
}

function enable_dotkid(){
	if(abs(global.player.xscale) != 1 || global.player.yscale != 1){
		return;
	}
	
	var _inst = get_id_in_collided_instances(obj_dotkid_activator);
	var _epsilon = 0.01;
	
	if(global.player.kid_mode != "dotkid" && _inst != noone){
		var _normal1 = {
			x : lengthdir_x(1, global.player.gravity_dir),
			y : lengthdir_y(1, global.player.gravity_dir)
		}
	
		var _normal2 = {
			x : lengthdir_x(1, _inst.image_angle + 270),
			y : lengthdir_y(1, _inst.image_angle + 270)
		}
	
		var _dot = dot(_normal1, _normal2);
		
		if(_dot > 1 - _epsilon){
			enable_dotkid_indicator = true;
			global.player.kid_mode = "dotkid";
			handle_skin();
		
			mask_index = spr_dotkid;
			x = _inst.x + lengthdir_x(17, global.player.gravity_dir + 90) + lengthdir_x(23, global.player.gravity_dir);
			y = _inst.y + lengthdir_y(17, global.player.gravity_dir + 90) + lengthdir_y(23, global.player.gravity_dir);
		
			play_sound(snd_skin_change, 0);
		}
	}
}


function disable_dotkid(_deactivator, _play_snd = true){
	if(global.player.kid_mode != "dotkid"){
		return false;
	}
	
	if(abs(global.player.xscale) != 1 || global.player.yscale != 1){
		return false;
	}
	
	var _inst = get_id_in_collided_instances(_deactivator);
	var _epsilon = 0.01;
	
	if(_inst != noone){
		var _normal1 = {
			x : lengthdir_x(1, global.player.gravity_dir),
			y : lengthdir_y(1, global.player.gravity_dir)
		}
	
		var _normal2 = {
			x : lengthdir_x(1, _inst.image_angle + 270),
			y : lengthdir_y(1, _inst.image_angle + 270)
		}

		var _dot = dot(_normal1, _normal2);
		
		if(_dot > 1 - _epsilon){
			global.player.kid_mode = "default";
			handle_skin();
		
			mask_index = spr_player_mask;
			x = _inst.x + lengthdir_x(17, global.player.gravity_dir + 90) + lengthdir_x(23, global.player.gravity_dir);
			y = _inst.y + lengthdir_y(17, global.player.gravity_dir + 90) + lengthdir_y(23, global.player.gravity_dir);
			global.player.xscale = 1;
			
			if(_play_snd){
				play_sound(snd_skin_back, 0);
			}
			
			return true;
		}
	}
	
	return false;
}

function enable_telekid(){
	var _changable = true;
	
	if(global.player.kid_mode != "telekid" && get_id_in_collided_instances(obj_telekid_activator) != noone){
		if(global.player.kid_mode == "dotkid"){
			_changable = disable_dotkid(obj_telekid_activator, false);
		}
		
		if(_changable){
			global.player.kid_mode = "telekid";
			handle_skin();
		
			skin_changing_sfx_start = true;
			skin_changing_sfx_value = 0;
			play_sound(snd_skin_change, 0);
		}
	}
}

function disable_telekid(){
	if(global.player.kid_mode != "telekid"){
		return;
	}
	
	if(get_id_in_collided_instances(obj_telekid_deactivator) != noone){
		global.player.kid_mode = "default";
		handle_skin();
		
		play_sound(snd_skin_back, 0);
	}
}

function enable_vkid(){
	var _chagable = true;
	
	if(global.player.kid_mode != "vkid" && get_id_in_collided_instances(obj_vkid_activator) != noone){
		if(global.player.kid_mode == "dotkid"){
			_chagable = disable_dotkid(obj_vkid_activator, false);
		}
		
		if(_chagable){
			global.player.kid_mode = "vkid";
			handle_skin();
		
			jump_total = 0;
		
			skin_changing_sfx_start = true;
			skin_changing_sfx_value = 0;
			play_sound(snd_skin_change, 0);
		}
	}
}

function disable_vkid(){
	if(global.player.kid_mode != "vkid"){
		return;
	}
	
	if(get_id_in_collided_instances(obj_vkid_deactivator) != noone){
		global.player.kid_mode = "default";
		handle_skin();
		
		play_sound(snd_skin_back, 0);
	}
}

function handle_kid_mode(){
	handle_dotkid_mask();
	
	enable_telekid();
	enable_dotkid();
	enable_vkid();

	disable_telekid();
	disable_dotkid(obj_dotkid_deactivator);
	disable_vkid();
}