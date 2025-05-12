/// @description local library
function initialize_chatbox_id(){
	chatbox_id.parent_id = id;

	chatbox_id.activate = function(){
		var _meeting = false;
		
		with(obj_player){
			_meeting = place_meeting(x, y, other.chatbox_id.parent_id);
		}
		
		if(keyboard_check_pressed(global.key_config.up) && _meeting){
			obj_player.frozen = true;
			return true;
		}
		else{
			return false;
		}
	}
	
	chatbox_id.deactivate = function(){
		if(!instance_exists(obj_player)){
			return;
		}
		
		if(keyboard_check_pressed(ord("S"))){
			return true;
		}
		
		if(!place_meeting(x, y, obj_player)){
			return true;
		}
	
		if(keyboard_check_pressed(global.key_config.load)){
			return true;
		}
	}
	
	chatbox_id.chatbox_x = x;
	chatbox_id.chatbox_y = y;
	chatbox_id.chatbox_dialogues = dialogues;
}

function handle_sign_alpha(){
	var _meet = place_meeting(x, y, obj_player);
	var _latency = 4;
	
	sign_alpha += (_meet - sign_alpha) / _latency;
	
	image_alpha = (1 - sign_alpha * 0.5);
}

function handle_sign_message(){
	var _meet = place_meeting(x, y, obj_player);
	var _dialogue_not_showing = chatbox_id.chatbox_clone == undefined;
	var _latency = 10;
	
	if(_dialogue_not_showing){
		message_alpha += (_meet - message_alpha) / _latency;
	}
	else{
		message_alpha += (_dialogue_not_showing - message_alpha) / _latency;
	}
	
	var _epsilon = 0.01;
	if(message_alpha < _epsilon){
		return;
	}
	
	scribble("Press up to read")
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(12 / 24, 12 / 24)
		.align(fa_center, fa_middle)
		.blend(c_white, message_alpha)
		.sdf_shadow(c_black, 1, 1, 1)
		.draw(x + sprite_width / 2, y - 10);
}

function handle_sign_position(){
	if(!is_initialized || chatbox_id.chatbox_clone == undefined){
		return;
	}
	
	var _offset = 8;
	
	_offset += chatbox_id.chatbox_clone.white_space_size;
	
	var _height = chatbox_id.chatbox_clone.chatbox_height;
	
	chatbox_id.chatbox_clone.x = x + sprite_width / 2;
	chatbox_id.chatbox_clone.y = y - _height / 2 - _offset;
}