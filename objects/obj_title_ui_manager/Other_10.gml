function handle_data_selection_screen(){
	scribble("Delete to erase a data \nShift & Arrow keys to select / Z to back")
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(0.5, 0.5)
		.align(fa_right, fa_bottom)
		.draw(DEFAULT_CAMERA_WIDTH - 16, DEFAULT_CAMERA_HEIGHT - 16);
}

function handle_difficulty_screen(){
    if(!difficulty_pause){
        return;
    }
    
    var _width = 400;
	var _height = 200;
	var _x = DEFAULT_CAMERA_WIDTH / 2;
	var _y = DEFAULT_CAMERA_HEIGHT / 2;
	
	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
    
    var _str = "";
    switch(difficulty_index){
        case 1:
            _str = "[[Medium]  Hard  VeryHard  Impossible";
            break;
        case 2:
            _str = "Medium  [[Hard]  VeryHard  Impossible";
            break;
        case 3:
            _str = "Medium  Hard  [[VeryHard]  Impossible";
            break;
        case 4:
            _str = "Medium  Hard  VeryHard  [[Impossible]";
            break;
    }

    scribble(string("Difficulty\n[scale, 0.5]{0}", _str))
        .starting_format("fnt_serif_bold_24", c_white)
        .align(fa_center, fa_middle)
        .draw(_x, _y);
}

function handle_save_deleting_screen(){
	if(!data_deleting_pause){
		return;
	}
	
	var _width = 400;
	var _height = 200;
	var _x = DEFAULT_CAMERA_WIDTH / 2;
	var _y = DEFAULT_CAMERA_HEIGHT / 2;
	
	draw_set_color(c_black);
	draw_set_alpha(0.8);
	draw_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	if(can_delete_data){
		scribble("Warning!\n[scale, 0.5]Data will be deleted.\nAre you Sure?\n\n[[Yes]      NO")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_center, fa_middle)
			.draw(_x, _y);
	}
	else if(!can_delete_data){
		scribble("Warning!\n[scale, 0.5]Data will be deleted.\nAre you Sure?\n\nYes      [[NO]")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_center, fa_middle)
			.draw(_x, _y);
	}
}