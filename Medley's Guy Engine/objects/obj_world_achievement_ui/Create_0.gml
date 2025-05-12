event_user(0); // local library

ach_width = 480;
ach_height = 160;
gap = 32;
icon_size = 140;

now_index = obj_world.achievement_index;
anim_time_limit = 8;
anim_time = anim_time_limit;
go_up = false;
go_down = false;

surf_dy = 0;

var _completed_ach = 0;
for(var _i = 0; _i < ACHIEVEMENT_SLOT; _i++){
	if(global.other_player_data.achievements[_i]){
		_completed_ach++;
	}
}

progress = _completed_ach / ACHIEVEMENT_SLOT * 100;
	

// event functions
function step(){
	if(!instance_exists(obj_world)){
		return;
	}
	
	if(obj_world.settings_master_alpha == 0){
		return;
	}
	
	update_achievement_index();
	handle_achievement_surf_dy();
}

function draw_gui(){
	if(!global.in_game){
		scribble("NO DATA")
			.starting_format("fnt_serif_bold_24", c_white)
			.align(fa_center, fa_middle)
			.blend(c_white, obj_world.settings_master_alpha)
			.scale(1, 1)
			.draw(300 + 240, 304);
			
		return;
	}
	draw_achievements();
}