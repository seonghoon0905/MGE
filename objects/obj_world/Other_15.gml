/// @description Simple Pause

function handle_simple_pause(){
	if(global.no_pause){
		return;
	}
	
	if(!simple_pause){
		if(!global.in_game){
			return;
		}
	}
	
	if(!on_setting && keyboard_check_pressed(global.key_config.pause)){
		if(global.game_paused){
			sprite_delete(pause_sprite);
			
			instance_activate_all();
			
			simple_pause = false;
			global.game_paused = false;
		}
		else if(surface_exists(application_surface)){
			simple_pause = true;
			global.game_paused = true;
			
			var _w = surface_get_width(application_surface);
			var _h = surface_get_height(application_surface);
			var _pause_surf = surface_create(_w, _h);
			surface_set_target(_pause_surf);
			draw_clear_alpha(c_black, 0);
			var _res = shader_get_uniform(sh_snapshot, "iResolution");
			shader_set(sh_snapshot);
			shader_set_uniform_f(_res, _w, _h);
			draw_surface(application_surface, 0, 0);
			shader_reset();
			surface_reset_target();
			
			pause_sprite = sprite_create_from_surface(_pause_surf, 0, 0, DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_HEIGHT, false, true, 0, 0);
			surface_free(_pause_surf);
			instance_deactivate_all(true);
		}
	}
}

function handle_gameover_screen(){
    if(!global.in_game){
        return;
    }
    
    if(!global.game_over){
        return;
    }
    
    var _control = min(game_over_controller / 50, 1);
    
    draw_set_color(c_black);
    draw_set_alpha(_control * 0.7);
    draw_rectangle(0, 0, DEFAULT_CAMERA_WIDTH, DEFAULT_CAMERA_WIDTH, false);
    draw_set_alpha(1);
    
    scribble("Game Over\n[scale, 0.5]Press R To Restart")
		.starting_format("fnt_serif_bold_24", c_white)
		.align(fa_center, fa_middle)
        .blend(c_white, _control)
		.draw(DEFAULT_CAMERA_WIDTH / 2, DEFAULT_CAMERA_HEIGHT / 2);
    
    if(game_over_controller > 200){
        return;
    }
    
    game_over_controller++;
    var _pitch = audio_sound_get_pitch(global.settings.music_id);
    audio_sound_pitch(global.settings.music_id, lerp(_pitch, 0, game_over_controller / 200));
    
    if(audio_sound_get_pitch(global.settings.music_id) < 0.01){
        audio_sound_pitch(global.settings.music_id, 0);
    }
}

function handle_simple_pause_ui(){
	if(simple_pause){
		draw_sprite(pause_sprite, 0, 0, 0);
	}
	
	var _latency = 5;
	var _cam = cam_properties(0);
	pause_alpha += (simple_pause - pause_alpha) / _latency;
	
	if(pause_alpha != 0){
		draw_set_alpha(0.5 * pause_alpha);
		draw_set_color(c_black);
		draw_rectangle(0, 0, _cam.w, _cam.h, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		
		scribble("Pause")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_middle, fa_center)
			.blend(c_white, pause_alpha)
			.draw(400, 304);
			
		var _hour = global.other_player_data.time div (GAME_SPEED * 60 * 60);
		var _minute = global.other_player_data.time div (GAME_SPEED * 60);
		var _second = global.other_player_data.time div GAME_SPEED;
		
		_minute %= 60;
		_second %= 60;		
			
		scribble(
			string("Time | {0}:{1}:{2}\n", _hour, _minute, _second) +
			string("Deaths | {0}", global.other_player_data.death_count)
		)
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_left, fa_bottom)
			.blend(c_white, pause_alpha)
			.scale(0.5, 0.5)
			.draw(32, 608 - 32);
	}
}