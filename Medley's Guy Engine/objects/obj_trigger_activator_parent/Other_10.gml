/// @description local library
function handle_respawning_mode(){
	if(keyboard_check_pressed(global.key_config.load)){
		for(var _i = 0; _i < array_length(triggers); _i++){
			var _trigger_id = triggers[_i].trigger_id;
			_trigger_id.activated = false;
			_trigger_id.order = 0;
			_trigger_id.recent_key = _trigger_id.keys[_trigger_id.order];
			_trigger_id.is_all_triggered = false;
			
			_trigger_id.supporter.activation_time = 0;
			_trigger_id.supporter.activation_time_limit = 0;
		}
		
		respawned = true;
		is_recent_key_initialized = false;
		
		for(var _j = 0; _j < array_length(call_later_insts); _j++){
			instance_destroy(call_later_insts[_j]);
		}
		
		call_later_insts = [];
	}
}

function handle_trigger_function(_method, _ft, _delay, _trigger_id, _activation_time){
	if(_delay == 0){
		method_call(_method, _ft);
	}
	else{
		var _inst = instance_create_layer(x, y, layer, obj_trigger_call_later);
		_inst.mom = id;
		_inst.trigger_method = _method;
		_inst.args = variable_clone(_ft);
		_inst.delay_limit = _delay;
		_inst.trigger_id = _trigger_id;
		
		array_push(call_later_insts, _inst);
	}
	
	array_push(_trigger_id.activation_time_list, _activation_time);
}

function send_signal_to_triggers(){
	var _len = array_length(triggers);
	
	if(_len < 1){
		return;
	}
	
	var _is_anything_triggered = false;
	
	for(var _i = 0; _i < _len; _i++){
		var _trigger_id = triggers[_i].trigger_id;
		
		if(_trigger_id.is_all_triggered || _trigger_id.direct){
			continue;
		}
		
		if(!_trigger_id.nesting && _trigger_id.activated){
			continue;
		}
		
		var _ft = triggers[_i].features;
		
		if(key == _trigger_id.recent_key || _trigger_id.no_order){
			
			if(_trigger_id.is_recent_key_initialized && key == _trigger_id.recent_key){
				// Only for no_order mode
				continue;
			}
			
			switch(triggers[_i].type){
				case "scatter":
					handle_trigger_function(_trigger_id.activate_scatter, [], _ft[0], _trigger_id, 0);
					_is_anything_triggered = true;
					continue;
					
				case "stop_moving":
					handle_trigger_function(_trigger_id.activate_stop_moving, [], _ft[0], _trigger_id, 0);
					_is_anything_triggered = true;
					continue;
					
				case "stop_all":
					handle_trigger_function(_trigger_id.activate_stop_all, [], _ft[0], _trigger_id, 0);
					_is_anything_triggered = true;
					continue;
			}
			
			var _activation_time = 0;
			
			if(!_trigger_id.moving || _trigger_id.nesting){
				switch(triggers[_i].type){
					case "speed":
						handle_trigger_function(_trigger_id.activate_speed, [_ft[0], _ft[1]], _ft[2], _trigger_id, 0);
						_is_anything_triggered = true;
						continue;
				
					case "vector":
						handle_trigger_function(_trigger_id.activate_vector, [_ft[0], _ft[1]], _ft[2], _trigger_id, 0);
						_is_anything_triggered = true;
						continue;
						
					case "projectile":
						handle_trigger_function(_trigger_id.activate_projectile, [_ft[0], _ft[1], _ft[2], _ft[3]], _ft[4], _trigger_id, 0);
						_is_anything_triggered = true;
						continue;
									
					case "point":
						handle_trigger_function(_trigger_id.activate_point, [_ft[0], _ft[1], _ft[2], _ft[4]], _ft[3], _trigger_id, _ft[2] + _ft[3]);
						_is_anything_triggered = true;
						continue;
			
					case "loop_point":
						_activation_time = 0;
						
						if(_ft[3] != infinity){
							_activation_time = _ft[2] * _ft[3] + _ft[4];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_point, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[5]], _ft[4], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
				
					case "dx_dy":
						handle_trigger_function(_trigger_id.activate_dx_dy, [_ft[0], _ft[1], _ft[2], _ft[4]], _ft[3], _trigger_id, _ft[2] + _ft[3]);
						_is_anything_triggered = true;
						continue;
						
					case "loop_dx_dy":
						_activation_time = 0;
						
						if(_ft[3] != infinity){
							_activation_time = _ft[2] * _ft[3] + _ft[4];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_dx_dy, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[5]], _ft[4], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
						
					case "rotation":
						handle_trigger_function(_trigger_id.activate_rotation, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[5]], _ft[4], _trigger_id, _ft[3] + _ft[4]);
						_is_anything_triggered = true;
						continue;
					
					case "loop_rotation":
						_activation_time = 0;
						
						if(_ft[4] != infinity){
							_activation_time = _ft[3] * _ft[4] + _ft[5];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_rotation, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[4], _ft[6]], _ft[5], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
						
					case "endless_rotation":
						handle_trigger_function(_trigger_id.activate_endless_rotation, [_ft[0], _ft[1], _ft[2]], _ft[3], _trigger_id, 0);
						_is_anything_triggered = true;
						continue;
						
					case "rotation_in_eclipse":
						handle_trigger_function(_trigger_id.activate_rotation_in_eclipse, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[4], _ft[5], _ft[7]], _ft[6], _trigger_id, _ft[5] + _ft[6]);
						_is_anything_triggered = true;
						continue;
						
					case "loop_rotation_in_eclipse":
						_activation_time = 0;
						
						if(_ft[6] != infinity){
							_activation_time = _ft[5] * _ft[6] + _ft[7];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_rotation_in_eclipse, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[4], _ft[5], _ft[6], _ft[8]], _ft[7], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
						
					case "endless_rotation_in_eclipse":
						handle_trigger_function(_trigger_id.activate_endless_rotation_in_eclipse, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[4]], _ft[5], _trigger_id, 0);
						_is_anything_triggered = true;
						continue;
				}
			}
			
			if(!_trigger_id.image_rotating || _trigger_id.nesting){
				switch(triggers[_i].type){
					case "image_rotation":
						handle_trigger_function(_trigger_id.activate_image_rotation, [_ft[0], _ft[1], _ft[3]], _ft[2], _trigger_id, _ft[1] + _ft[2]);
						_is_anything_triggered = true;
						continue;
				
					case "loop_image_rotation":
						_activation_time = 0;
						
						if(_ft[2] != infinity){
							_activation_time = _ft[1] * _ft[2] + _ft[3];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_image_rotation, [_ft[0], _ft[1], _ft[2], _ft[4]], _ft[3], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
			
					case "endless_image_rotation":
						handle_trigger_function(_trigger_id.activate_endless_image_rotation, [_ft[0]], _ft[1], _trigger_id, 0);
						_is_anything_triggered = true;
						continue;
				}
			}
			
			if(!_trigger_id.scaling || _trigger_id.nesting){
				switch(triggers[_i].type){
					case "scale":
						handle_trigger_function(_trigger_id.activate_scale, [_ft[0], _ft[1], _ft[2], _ft[4]], _ft[3], _trigger_id, _ft[2] + _ft[3]);
						_is_anything_triggered = true;
						continue;
					
					case "loop_scale":
						_activation_time = 0;
						
						if(_ft[3] != infinity){
							_activation_time = _ft[2] * _ft[3] + _ft[4];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_scale, [_ft[0], _ft[1], _ft[2], _ft[3], _ft[5]], _ft[4], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
				}
			}
			
			if(!_trigger_id.fading || _trigger_id.nesting){
				switch(triggers[_i].type){
					case "alpha":
						handle_trigger_function(_trigger_id.activate_alpha, [_ft[0], _ft[1], _ft[3]], _ft[2], _trigger_id, _ft[1] + _ft[2]);
						_is_anything_triggered = true;
						continue;
					case "loop_alpha":
						_activation_time = 0;
						
						if(_ft[2] != infinity){
							_activation_time = _ft[1] * _ft[2] + _ft[3];
						}
						
						handle_trigger_function(_trigger_id.activate_loop_alpha, [_ft[0], _ft[1], _ft[2], _ft[4]], _ft[3], _trigger_id, _activation_time);
						_is_anything_triggered = true;
						continue;
				}
			}
			
			if(_is_anything_triggered && _trigger_id.no_order){
				_trigger_id.is_recent_key_initialized = true;
			}
		}
	}
		
	if(!_is_anything_triggered){
		return;
	}

	play_sound(snd, 0);
	
	for(var _i = 0; _i < _len; _i++){
		var _trigger_id = triggers[_i].trigger_id;
		
		for(var _j = 0; _j < array_length(_trigger_id.activation_time_list); _j++){
			if(_trigger_id.supporter.activation_time_limit < _trigger_id.activation_time_list[_j]){
				_trigger_id.supporter.activation_time_limit = _trigger_id.activation_time_list[_j];
			} 
		}
		
		_trigger_id.activation_time_list = [];
		
		if(_trigger_id.no_order && _trigger_id.is_recent_key_initialized){
			_trigger_id.recent_key = key;
			continue;
		}

		if(key == _trigger_id.recent_key){
			_trigger_id.order++;
			
			if(_trigger_id.order >= array_length(_trigger_id.keys)){
				_trigger_id.is_all_triggered = true;
				continue;
			}
			
			_trigger_id.recent_key = _trigger_id.keys[_trigger_id.order];
		}
	}
}