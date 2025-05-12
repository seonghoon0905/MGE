/// @description constructor
function chatbox_class(_x, _y, _dialogues, _delay, _font_scale, _text_color, _align, _sound_array, _font) constructor{
	x = _x;
	y = _y;
	
	dialogues = array_create(array_length(_dialogues), "");
	delay = _delay;
	font_scale = _font_scale;
	text_color = _text_color;
	align = _align;
	sound_array = _sound_array;
	font = _font;
	
	white_space_size = 16;
	
	select_section = [];
	select_section_index = 0;
	select_section_started = false;
	
	function handle_number_of_choices(_str){
		var _number = 1;
		var _number_of_choices = 0;
		while(string_count(string(_number), _str) > 0){
			_number++;
			_number_of_choices++;
		}
		return _number_of_choices;
	}
	
	function handle_select_section(_page){
		while(string_count("%select%", dialogues[_page]) > 0){
			var _start_pos = string_pos("%select%", scribble(dialogues[_page]).get_text());
			
			var _src_start_pos = string_pos("%select%", dialogues[_page]);
			var _text = string_replace(dialogues[_page], "%select%", _src_start_pos != 1 ? "[pause]" : "");
			var _src_end_pos = string_pos("%/select%", _text);
			
			var _select_section_string = string_copy(_text, _src_start_pos, _src_end_pos - _src_start_pos);
			var _number_of_choices = handle_number_of_choices(_select_section_string);
			
			var _dest_end_pos = string_pos("%/select%", string_replace_all(_text, "[pause]", ""));
			
			dialogues[_page] = string_replace(dialogues[_page], "%select%", _src_start_pos != 1 ? "[pause]" : "");
			dialogues[_page] = string_replace(dialogues[_page], "%/select%", "[pause]");
			
			array_push(select_section, {
				page : _page,
				start_pos : _start_pos,
				chosen_number : 0,
				number_of_choices : _number_of_choices,
				src_start_pos : _src_start_pos,
				src_end_pos : _src_end_pos,
				dest_end_pos : _dest_end_pos,
			});
		}
	}
	
	var _page = 0;
	offset = 0;
	old_offset = offset;
	
	while(array_length(_dialogues) > 0){
		var _dialogue = array_shift(_dialogues);
		while(array_length(_dialogue) > 0){
			dialogues[_page] += array_shift(_dialogue);
			handle_select_section(_page);
			if(array_length(_dialogue) > 0){
				dialogues[_page] += "[pause]";
			}
		}
		_page++;
	}
	
	array_push(select_section, {page : undefined});
	
	function refresh_scribble_object(){
		var _halign, _valign;
		switch(align){
			case "middle":
				_halign = fa_center;
				_valign = fa_middle;
				break;
			case "top_left":
				_halign = fa_left;
				_valign = fa_top;
				break;
		}
	
		scribble_object
			.starting_format(font, text_color)
			.transform(font_scale, font_scale)
			.align(_halign, _valign);
	}
	
	page = 0;
	scribble_object = scribble(dialogues[page]);
	refresh_scribble_object();
	
	chatbox_top_left_x = x;
	chatbox_top_left_y = y;
	chatbox_bottom_right_x = x;
	chatbox_bottom_right_y = y;
	chatbox_width = 0;
	chatbox_height = 0;
	
	function refresh_typist(){
		other.typist.in(delay, 5);
		other.typist.ease(SCRIBBLE_EASE.CIRC, 0, -5, 1, 1, 45, 0.1);	
		other.typist.sound_per_char(sound_array, 0.85, 1, " ", global.settings.effect_volume / 100);
	}
	
	refresh_typist();
	
	function handle_standard_key_action(){
		if(keyboard_check_pressed(global.key_config.jump)){
			if(other.typist.get_paused()){
				other.typist.unpause();
			}
			else{
				other.typist.skip_to_pause();
			}
		}
		
		if(keyboard_check_pressed(vk_control)){
			other.typist.unpause();
			other.typist.skip();
		}
	}
	
	function handle_pause_tag_before_select_section(){
		var _previous_dialogue = dialogues[page];
		
		var _src = string_copy(dialogues[page], 1, select_section[select_section_index].src_end_pos - 1 + offset);
		var _text = string_replace_all(dialogues[page], "[pause]", "");
		var _dest = string_copy(_text, 1, select_section[select_section_index].dest_end_pos - 1 + offset);
		
		dialogues[page] = string_replace(dialogues[page], _src, _dest);
		
		scribble_object = scribble(dialogues[page]);
		refresh_scribble_object();
		
		dialogues[page] = _previous_dialogue;
	}
	
	function update_select_section_string(_old_chosen_number = undefined){
		var _chosen_number = select_section[select_section_index].chosen_number;
		var _src_start_pos = select_section[select_section_index].src_start_pos + old_offset;
		var _src_end_pos = select_section[select_section_index].src_end_pos + offset;
		var _len = string_length(dialogues[page]);
		
		var _str1 = string_copy(dialogues[page], 1, _src_start_pos - 1);
		var _str2 = string_copy(dialogues[page], _src_end_pos, _len - _src_end_pos + 1);
		var _src = string_copy(dialogues[page], _src_start_pos, _src_end_pos - _src_start_pos);
		
		var _macro1 = "[rainbow][wave]";
		var _macro2 = "[/wave][/rainbow]";
		
		if(_old_chosen_number != undefined){
			var _dest = string_replace(_src, string(_macro1 + "{0}" + _macro2 + ".", _old_chosen_number + 1), string("{0}.", _old_chosen_number + 1));
			dialogues[page] = _str1 + _dest + _str2;
			_src = _dest;
		}
		
		var _dest = string_replace(_src, string("{0}.", _chosen_number + 1), string(_macro1 + "{0}" + _macro2 + ".", _chosen_number + 1));
		
		dialogues[page] = _str1 + _dest + _str2;
		offset = (offset == old_offset) ? offset + string_length(_macro1 + _macro2) : offset;
		
		handle_pause_tag_before_select_section();
		other.typist.skip_to_pause();
	}
	
	skip_when_select_command_is_on_last = false;
	
	function handle_select_section_key_action(){
		if(other.typist.get_position() < select_section[select_section_index].start_pos + old_offset){
			if(keyboard_check_pressed(vk_control)){
				handle_pause_tag_before_select_section();
				other.typist.skip_to_pause();
			}
			else{
				handle_standard_key_action();
			}
			return;
		}
		
		if(!select_section_started){
			update_select_section_string();
			
			other.typist.sound_per_char(sound_array, 0.5, 1, " ", 0);
			other.typist.skip_to_pause();
			
			select_section_started = true;
		}
		
		if(keyboard_check_pressed(global.key_config.right) ^^ keyboard_check_pressed(global.key_config.down)){
			var _cn = select_section[select_section_index].chosen_number;
			var _noc = select_section[select_section_index].number_of_choices;
			select_section[select_section_index].chosen_number = _cn + 1 < _noc ? _cn + 1 : 0;
			update_select_section_string(_cn);
		}
		else if(keyboard_check_pressed(global.key_config.left) ^^ keyboard_check_pressed(global.key_config.up)){
			var _cn = select_section[select_section_index].chosen_number;
			var _noc = select_section[select_section_index].number_of_choices;
			select_section[select_section_index].chosen_number = _cn - 1 < 0 ? _noc - 1 : _cn - 1;
			update_select_section_string(_cn);
		}
		else if(keyboard_check_pressed(global.key_config.jump)){
			old_offset = offset;
			
			if(select_section_index < array_length(select_section) - 1){
				select_section_index++;
			}
			
			select_section_started = false;
			
			refresh_typist();
			other.typist.unpause();
			
			if(other.typist.get_position() >= string_length(scribble_object.get_text()) - 1){
				skip_when_select_command_is_on_last = true;
			}
		}
	}
	
	function update_typist(){
		if(other.typist.get_state() == 1){
			return;
		}
		
		if(select_section[select_section_index].page == page){
			handle_select_section_key_action();
		}
		else{
			handle_standard_key_action();
		}
	}
	
	function fit_in_room(){
		var _width = chatbox_width;
		var _height = chatbox_height;
		var _offset = 16;
		_offset += white_space_size;
		
		var _left = _width / 2 + _offset;
		var _right = room_width - (_width / 2 + _offset);
		var _top = _height / 2 + _offset;
		var _bottom = room_height - (_height / 2 + _offset);
		
		x = clamp(x, _left, _right);
		y = clamp(y, _top, _bottom);
	}
	
	function fit_in_camera(){
		var _cam = cam_properties(0);
		
		var _width = chatbox_width;
		var _height = chatbox_height;
		var _offset = 16;
		_offset += white_space_size;
		
		var _left = _cam.x + _width / 2 + _offset;
		var _right = (_cam.x + _cam.w) - (_width / 2 + _offset);
		var _top = _cam.y + _height / 2 + _offset;
		var _bottom = (_cam.y + _cam.h) - (_height / 2 + _offset);
		
		x = clamp(x, _left, _right);
		y = clamp(y, _top, _bottom);
	}
	
	function update_chatbox_bbox(){
		var _bbox = scribble_object.get_bbox();
	
		chatbox_width = _bbox.width;
		chatbox_height = _bbox.height;
		
		if(!view_enabled){
			fit_in_room();
		}
		else{
			fit_in_camera();
		}
		
		var _following_latency = 3;
		var _top_left_x, _top_left_y, _bottom_right_x, _bottom_right_y;
		
		switch(align){
			case "middle":
				_top_left_x = x - _bbox.width / 2 - white_space_size;
				_top_left_y = y - _bbox.height / 2 - white_space_size;
				_bottom_right_x = x + _bbox.width / 2 + white_space_size;
				_bottom_right_y = y + _bbox.height / 2 + white_space_size;
				break;
			case "top_left":
				_top_left_x = x;
				_top_left_y = y;
				_bottom_right_x = x + _bbox.width + white_space_size * 2;
				_bottom_right_y = y + _bbox.height + white_space_size * 2;
				break;
		}
		
		chatbox_top_left_x += (_top_left_x - chatbox_top_left_x) / _following_latency;
		chatbox_top_left_y += (_top_left_y - chatbox_top_left_y) / _following_latency;
		chatbox_bottom_right_x += (_bottom_right_x - chatbox_bottom_right_x) / _following_latency;
		chatbox_bottom_right_y += (_bottom_right_y - chatbox_bottom_right_y) / _following_latency;
	}
	
	function update_scribble_object(){
		if(other.deactivate()){
			refresh_typist();
			delete other.chatbox_clone;
			other.chatbox_clone = undefined;
			call_later(1, time_source_units_frames, other.destroy);
			return;
		}
		
		var _flag1 = other.typist.get_state() == 1 && keyboard_check_pressed(global.key_config.jump);
		var _flag2 = skip_when_select_command_is_on_last;
		
		if(_flag1 || _flag2){
			if(page >= array_length(dialogues) - 1){
				refresh_typist();
				delete other.chatbox_clone;
				other.chatbox_clone = undefined;
				call_later(1, time_source_units_frames, other.destroy);
				return;
			}
			
			page++;
			offset = 0;
			old_offset = offset;
			skip_when_select_command_is_on_last = false;
			
			scribble_object = scribble(dialogues[page]);
			refresh_scribble_object();
		}
	}
		
	function draw_scribble_object(){
		var _offset;
		switch(align){
			case "top_left":
				_offset = white_space_size;
				break;
			default:
				_offset = 0;
		}
		scribble_object
			.draw(x + _offset, y + _offset, other.typist);
		
	}
	
	function draw_chatbox(){
		draw_set_color(c_black);
		draw_set_alpha(0.8);
		draw_rectangle(
			chatbox_top_left_x, 
			chatbox_top_left_y, 
			chatbox_bottom_right_x, 
			chatbox_bottom_right_y, false
		);
		draw_set_alpha(1);
	}
}