function get_achievement_icon(_index){
	switch(_index){
		case 0:
			return spr_oak_cask;
		case 1:
			return spr_rotate_screen_down;
		case 2:
			return spr_telekid_deactivator;
		case 3:
			return spr_warp;
	}
}

function get_achivement_name(_index){
	switch(_index){
		case 0:
			return "EXAMPLE 1";
		case 1:
			return "EXAMPLE 2";
		case 2:
			return "EXAMPLE 3";
		case 3: 
			return "EXAMPLE 4";
	}
}

function get_achivement_explanation(_index){
	switch(_index){
		case 0:
			return "This is an example. You must change this\nwhen you using the achievement system.";
		case 1:
			return "This is an example. You must change this\nwhen you using the achievement system.";
		case 2:
			return "This is an example. You must change this\nwhen you using the achievement system.";
		case 3:
			return "This is an example. You must change this\nwhen you using the achievement system.";
	}
}

function activate_achievement(_index){
	if(!ENABLE_ACHIEVEMENT){
		return;	
	}
	
	if(global.other_player_data.achievements[_index]){
		return;
	}
	
	global.other_player_data.achievements[_index] = true;
	
	var _inst = instance_create_depth(0, 0, 0, obj_achievement_effect_ui);
	_inst.index = _index;
}