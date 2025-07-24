function initialize_room_music(){
	// It's called at room start event of obj_world
	audio_master_gain(global.settings.master_volume / 100); // First, control master volume of audio
	
	var _room_music;
	
	switch(room){
		case rm_total_test:
			_room_music = snd_test_room;
			break;
		default:
			_room_music = snd_no_music;
			break;
	}
	// Set the main music of the room. 
	
	// If the currently playing music is same as the _room_music, just skip.
	if(audio_get_name(global.settings.music_id) != audio_get_name(_room_music)){
		
		audio_stop_sound(global.settings.music_id);
		// If the currently playing music is different from the _room_music, stop the previous track.
		
		global.settings.music_id = audio_play_sound(_room_music, 0, true, global.settings.music_volume / 100);
		// Update the currently playing music.
	}
}

function play_sound(_snd, _priority, _loop = false){
	audio_play_sound(_snd, _priority, false, global.settings.effect_volume / 100);
}