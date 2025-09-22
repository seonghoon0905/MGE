function move_outside(_dir, _dist, _obj, _move_anyway = false){
    if(!place_meeting(x, y, _obj)){
        return;
    }
	var _cur = 1;
	while(_move_anyway ? true : _cur <= _dist){
		var _x = lengthdir_x(_cur, _dir + 180);
		var _y = lengthdir_y(_cur, _dir + 180);
		if(!place_meeting(x + _x, y + _y, _obj)){
			x += _x;
			y += _y;
			break;
		}
		_cur++;
	}
}

function move_contact(_dir, _dist, _obj){
	if(place_meeting(x, y, _obj)){
		move_outside(_dir, _dist, _obj);
		return;
	}
	
	var _cur = 1;
	while(_cur <= _dist){
		var _x = lengthdir_x(_cur, _dir);
		var _y = lengthdir_y(_cur, _dir);
		if(place_meeting(x + _x, y + _y, _obj)){
			_cur--;
			x = x + lengthdir_x(_cur, _dir);
			y = y + lengthdir_y(_cur, _dir);
			_cur = _dist;
		}
		_cur++;
	}
}

function get_contacting_distance(_dir, _dist, _obj){
	if(place_meeting(x, y, _obj)){
		return 0;
	}
	
	var _cur = 1;
	while(_cur <= _dist){
		var _x = lengthdir_x(_cur, _dir);
		var _y = lengthdir_y(_cur, _dir);
		if(place_meeting(x + _x, y + _y, _obj)){
			_cur--;
			return _cur;
		}
		_cur++;
	}
	
	return 0;
}

function make_incollidable(_obj){
	with(_obj){
        mask_index = spr_noone;
    }
}

function make_collidable(_obj){
	with(_obj){
        mask_index = sprite_index;
	}
}

/// @function		get_id_in_collided_instances(_object_index)
/// @description	It returns only one instance ID of _object_index in collided_instances.

function get_id_in_collided_instances(_object_index){
	for(var _i = 0; _i < array_length(collided_instances); _i++){
		var _inst = collided_instances[_i];
		if(_inst.object_index == _object_index){
			return _inst;
		}
	}
	
	return noone;
}

/// @function		get_id_in_collided_instances_ext(_object_index)
/// @description	It returns only one instance ID which is either a child of _object_index or the _object_index itself in collided_instances.

function get_id_in_collided_instances_ext(_object_index){
	for(var _i = 0; _i < array_length(collided_instances); _i++){
		var _inst = collided_instances[_i];
		if(_inst.object_index == _object_index || object_is_ancestor(_inst.object_index, _object_index)){
			return _inst;
		}
	}
	
	return noone;
}

/// @function		get_all_ids_in_collided_instances(_object_index)
/// @description	It returns an array of all instance IDs of _object_index in collided_instances.

function get_all_ids_in_collided_instances(_object_index){
	var _insts = [];
	var _is_insts_empty = true;
	
	for(var _i = 0; _i < array_length(collided_instances); _i++){
		var _inst = collided_instances[_i];
		if(_inst.object_index == _object_index){
			array_push(_insts, _inst);
			_is_insts_empty = false;
		}
	}

	if(_is_insts_empty){
		return noone;
	}
	else{
		return _insts;
	}
}

/// @function		get_all_ids_in_collided_instances_ext(_object_index)
/// @description	It returns an array of all instance IDs in collided_instances that are either children of _object_index or the _object_index itself.

function get_all_ids_in_collided_instances_ext(_object_index){
	var _insts = [];
	var _is_insts_empty = true;
	
	for(var _i = 0; _i < array_length(collided_instances); _i++){
		var _inst = collided_instances[_i];
		if(_inst.object_index == _object_index || object_is_ancestor(_inst.object_index, _object_index)){
			array_push(_insts, _inst);
			_is_insts_empty = false;
		}
	}

	if(_is_insts_empty){
		return noone;
	}
	else{
		return _insts;
	}
}


/// @function		move_bounce()
/// @description	If you place this in the Step Event of any instances with speed, hspeed, vspeed, etc., they will bounce off blocks.

function move_bounce(){
	if(place_meeting(x + hspeed, y, obj_block)){
		x -= hspeed;
	    hspeed *= -1;
	} 
	
	if(place_meeting(x, y + vspeed, obj_block)){
		y -= vspeed;
		vspeed *= -1;
	}
	
	if(place_meeting(x + hspeed, y + vspeed, obj_block)){
		x -= hspeed;
		hspeed *= -1;
			
		y -= vspeed;
		vspeed *= -1;
	}
}