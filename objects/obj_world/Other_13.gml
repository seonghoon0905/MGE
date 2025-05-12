/// @description Trigger
function handle_trigger_activator_ids(){
	if(is_trigger_activator_ids_initialized){
		return;
	}
	
	var _num, _obj = obj_trigger_activator_parent;
	
	if(instance_exists(_obj)){
		_num = instance_number(_obj);
		
		for(var _i = 0; _i < _num; _i++){
			var _inst = instance_find(_obj, _i);
			array_push(trigger_activator_ids, _inst);
		}
		
		is_trigger_activator_ids_initialized = true;
	}
}

function update_triggers_features(_key, _trigger_id, _type, _features){
	array_push(triggers_features, [_key, _trigger_id, _type, _features]);
}

function update_trigger_activator_triggers(){
	if(!enable_update_trigger_activator_triggers){
		return;
	}
	
	for(var _i = 0; _i < array_length(triggers_features); _i++){
		var _arr = triggers_features[_i];
		
		var _len = array_length(trigger_activator_ids);
	
		if(_len < 1){
			continue;
		}
	
		for(var _j = 0; _j < _len; _j++){
			if(trigger_activator_ids[_j].key == _arr[0]){
				array_push(trigger_activator_ids[_j].triggers, {
					trigger_id : _arr[1],
					type : _arr[2],
					features : _arr[3]
				});
			}
		}
	}
	
	enable_update_trigger_activator_triggers = false;
}