event_user(0); // constructor

parent_id = noone;

chatbox = undefined;
chatbox_clone = undefined;
typist = scribble_typist();

activate = undefined;

destroy = function(){
	if(instance_exists(obj_player)){
		obj_player.frozen = false;
	}
	return;
}

deactivate = function(){
	if(!instance_exists(obj_player)){
		return;
	}
	
	if(keyboard_check_pressed(ord("S"))){
		return true;
	}
	
	if(keyboard_check_pressed(global.key_config.load)){
		return true;
	}
}

chatbox_x = undefined;
chatbox_y = undefined;
chatbox_dialogues = undefined;
chatbox_delay = undefined;
chatbox_font_scale = undefined;
chatbox_text_color = undefined;
chatbox_align = undefined;
chatbox_sound_array = undefined;
chatbox_font = undefined;

//event function
function end_step(){
	var _check_list = [activate, deactivate, destroy, chatbox_x, chatbox_y, chatbox_dialogues];
	//Check every element of an array is not undefined
	for(var _i = 0; _i < array_length(_check_list); _i++){
		if(_check_list[_i] == undefined){
			return;
		}
	}
	
	if(chatbox == undefined){
		var _delay = (chatbox_delay == undefined) ? 0.3 : chatbox_delay;
		var _font_scale = (chatbox_font_scale == undefined) ? 12 / 24 : chatbox_font_scale;
		var _text_color = (chatbox_text_color == undefined) ? c_white : chatbox_text_color;
		var _align = (chatbox_align == undefined) ? "middle" : chatbox_align;
		var _sound_array = (chatbox_sound_array == undefined) ? [snd_dialogue1] : chatbox_sound_array;
		var _font = (chatbox_font == undefined) ? "fnt_serif_bold_24" : chatbox_font;
        var _parent = id;
		chatbox = new chatbox_class(chatbox_x, chatbox_y, chatbox_dialogues, _delay, _font_scale, _text_color, _align, _sound_array, _font, _parent);
	}
	
	if(activate() && chatbox != undefined && chatbox_clone == undefined){
		chatbox_clone = variable_clone(chatbox);
		play_sound(snd_chatbox_popup1, 0);
	}
	
	if(chatbox_clone == undefined){
		return;
	}
	
	if(instance_exists(obj_player) && !obj_player.frozen){
		obj_player.frozen = true;
	}
	
	chatbox_clone.update_typist();
	chatbox_clone.update_chatbox_bbox();
	chatbox_clone.update_scribble_object();
}

function draw(){
	if(chatbox_clone == undefined){
		return;
	}
	
	chatbox_clone.draw_chatbox();
	chatbox_clone.draw_scribble_object();
}