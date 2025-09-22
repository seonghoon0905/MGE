can_enter_data_selection_screen = false;
data_selection_ui_manager_exist = false; 
data_deleting_pause = false;
difficulty_pause = false;
difficulty_init = false;
difficulty_index = 1;
can_delete_data = false;



event_user(0);

//event function
function step(){
	if(!can_enter_data_selection_screen){
		if(keyboard_check_pressed(vk_shift)){
			can_enter_data_selection_screen = true;
		}
		return;
	}
	
	if(!data_selection_ui_manager_exist){
        var _ui_manager = undefined;
        
        with(obj_world){
            _ui_manager = data_selection_ui_manager;
        }
        
		var _inst = instance_create_layer(x, y, layer, _ui_manager);
        
		_inst.parent_id = id;
		for(var _i = 0; _i < DATA_SLOT; _i++){
			var _other_data = load_other_player_data(_i);
            
			if(file_exists("SnapShot\\SnapShot" + string(_i) + ".png")){
				array_push(_inst.snapshot, sprite_add("SnapShot\\SnapShot" + string(_i) + ".png", 0, false, true, 0, 0));
			}
			else{
				array_push(_inst.snapshot, undefined);
			}
			
            if(ENABLE_DIFFICULTY_MODE){
                var _diff = _other_data == undefined ? 0 : _other_data.difficulty;
                array_push(_inst.difficulty_list, _diff);
            }
            
            var _time = _other_data == undefined ? 0 : _other_data.time;
			var _death = _other_data == undefined ? 0 : _other_data.death_count;
            
            array_push(_inst.time_list, _time);
			array_push(_inst.death_list, _death);
            
            if(ENABLE_SECRETITEMS_SYSTEM){
                var _secrets = _other_data == undefined ? array_create(array_length(SECRETITEMS_SPRITES), false) : _other_data.secret_items;
                array_push(_inst.secret_items_list, _secrets);
            }
		}
        
		data_selection_ui_manager_exist = true;
	}
}

function draw(){
	if(data_selection_ui_manager_exist){
		handle_data_selection_screen();
        handle_difficulty_screen();
		handle_save_deleting_screen();
	}
}