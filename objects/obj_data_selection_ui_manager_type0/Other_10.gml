/// @description local library
function handle_animation_value(){
	var _transition_spd = 0.02;
	if(animation_value < 1){
		animation_value = min(1, animation_value + _transition_spd);
	}
}

function handle_secretitems(){
    if(!ENABLE_SECRETITEMS_SYSTEM){
        return;
    }
    
    var _len = array_length(SECRETITEMS_SPRITES);
    var _x = DEFAULT_CAMERA_WIDTH / 2 - (array_length(SECRETITEMS_SPRITES) * 32 / 2);
    var _y = DEFAULT_CAMERA_HEIGHT / 2 + 75;
    for(var _i = 0; _i < _len; _i++){
        var _alpha = 0.1;
        if(secret_items_list[global.savedata_index][_i]){
            _alpha = 1;
        }
        
        var _spr = SECRETITEMS_SPRITES[_i];
        draw_sprite_ext(_spr, 0, _x + _i * 32, _y, 1, 1, 0, c_white, _alpha);
    }
}

function handle_snapshot(){
    var _scale = 1;
    var _x = (DEFAULT_CAMERA_WIDTH / 2) - (DEFAULT_CAMERA_WIDTH / 4 * _scale);
    var _y = (DEFAULT_CAMERA_HEIGHT / 2) - (DEFAULT_CAMERA_HEIGHT / 4 * _scale) - 100;
    
	if(snapshot[global.savedata_index] != undefined){
		draw_sprite_ext(snapshot[global.savedata_index], 0, _x, _y, _scale / 2, _scale / 2, 0, c_white, 1);
	}
    else{
        draw_sprite_ext(spr_title_no_data, 0, _x, _y, _scale, _scale, 0, c_white, 1);
    }
}

function make_graph_surf(){ 
	if(parent_id == noone){
		return;
	}
	
	surface_free(graph_surf);
	graph_surf = surface_create(DATA_SLOT * (icon_width + gap_between_icons), icon_height);
	surface_set_target(graph_surf);
	
	var _pos_x = 0;
	for(var _index = 0; _index <= 2 * DATA_SLOT; _index++){
		if(_index % 2 == 1){
			draw_set_color(c_black);
			draw_set_alpha(0.5);
			draw_rectangle(_pos_x, 0, _pos_x + icon_width, icon_height, false);
			
			draw_set_color(c_white);
			draw_set_alpha(1);
			
			scribble("DATA " + string((_index - 1) / 2 + 1))
				.starting_format("fnt_serif_bold_24", c_white)
				.transform(0.6, 0.6)
				.align(fa_middle, fa_top)
				.draw(_pos_x + icon_width / 2, 10);
            
            var _str = "";
            
            if(ENABLE_DIFFICULTY_MODE){
                if(snapshot[(_index - 1) / 2] == undefined){
                    _str = "NO DATA"; 
                } 
                switch(difficulty_list[(_index - 1) / 2]){
                    case 1:
                        _str = "Medium";
                        break;
                    case 2:
                        _str = "Hard";
                        break;
                    case 3:
                        _str = "Vert Hard";
                        break;
                    case 4:
                        _str = "Impossible";
                        break;
                }
            }
            
            scribble(_str)
    			.starting_format("fnt_serif_bold_24", c_white)
                .transform(0.4, 0.4)
    			.align(fa_middle, fa_top)
    			.blend(c_white, 1)
    			.draw(_pos_x + icon_width / 2, 30);
				
			var _hour = time_list[(_index - 1) / 2] div (GAME_SPEED * 60 * 60);
			var _minute = time_list[(_index - 1) / 2] div (GAME_SPEED * 60);
			var _second = time_list[(_index - 1) / 2] div GAME_SPEED;
	
			_minute %= 60;
			_second %= 60;
			
			scribble(
				string("Time / {0}:{1}:{2}\n", _hour, _minute, _second) +
				string("Death / {0}", death_list[(_index - 1) / 2])
			)
				.starting_format("fnt_serif_bold_24", c_white)
				.transform(0.5, 0.5)
				.align(fa_middle, fa_middle)
				.draw(_pos_x + icon_width / 2, 70);
		
			_pos_x += icon_width;
		}
		else{
			_pos_x += gap_between_icons;
		}
	}
	surface_reset_target();
}

function make_final_surf(){
	if(!surface_exists(final_surf)){
		final_surf = surface_create(how_many_to_show * (icon_width + gap_between_icons) + gap_between_icons, icon_height);
	}
	
	to_x = icon_width + gap_between_icons - global.savedata_index * (icon_width + gap_between_icons);
	draw_x = lerp(draw_x, to_x, animation_value);
	
	surface_set_target(final_surf);
	draw_clear_alpha(c_black, 0);
	var _resolution = shader_get_uniform(sh_hub_outline_shading, "iResolution"); 
	var _icon_width = shader_get_uniform(sh_hub_outline_shading, "gap"); 
	shader_set(sh_title_ui_manager_outline_shading);
	draw_surface(graph_surf, draw_x, 0);
	shader_set_uniform_f(_resolution, surface_get_width(final_surf), surface_get_height(final_surf));
	shader_set_uniform_f(_icon_width, gap_between_icons);
	shader_reset();
	surface_reset_target();
}