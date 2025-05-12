/// @description Window Caption

function handle_window_caption(){
	var _caption = "";
	if(!global.in_game){
		_caption = GAME_NAME;
	}
	else{
		var _hour = global.other_player_data.time div (GAME_SPEED * 60 * 60);
		var _minute = global.other_player_data.time div (GAME_SPEED * 60);
		var _second = global.other_player_data.time div GAME_SPEED;
	
		_minute %= 60;
		_second %= 60;
	
		_caption = string(
			GAME_NAME + " [SaveData{0}] | Time : {1}:{2}:{3} | Death : {4}",
			global.savedata_index + 1,
			_hour, _minute, _second,
			global.other_player_data.death_count,
		);
	}
	
	if(_caption != last_window_caption){
		window_set_caption(_caption);
		last_window_caption = _caption;
	}
}