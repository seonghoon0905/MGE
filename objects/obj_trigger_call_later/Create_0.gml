mom = noone;
trigger_method = undefined;
args = [];
delay = 0;
delay_limit = 0;
trigger_id = noone;

direct = false;
finished = false;


// event functions
function end_step(){
	if(direct){
		if(keyboard_check_pressed(global.key_config.load)){
			delay = 0;
			finished = false;
		}
		
		if(finished){
			return;
		}
	}
	
	
	if(delay < delay_limit){
		delay++;
		return;
	}	
	
	with(trigger_id){
		method_call(other.trigger_method, other.args);
	}
	
	if(direct){
		finished = true;
		return;
	}
	
	for(var _i = 0; _i < array_length(mom.call_later_insts); _i++){
		if(id == mom.call_later_insts[_i]){
			array_delete(mom.call_later_insts, _i, 1);
			break;
		}
	}

	instance_destroy();
}
