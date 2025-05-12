var _flag = global.game_over ||
			keyboard_check_pressed(global.key_config.load) ||
			(instance_exists(obj_player) && global.player.kid_mode != "telekid");

if(_flag){
	instance_destroy();
}

var _dx = lengthdir_x(hspd, dir);
var _dy = lengthdir_y(hspd, dir);

if(place_meeting(x + _dx, y + _dy, obj_block)){
	move_contact(dir, abs(hspd) + 1, obj_block);
	
	if(place_meeting(x, y, obj_block)){
		instance_destroy();
	}
	
	with(mom){
		x = other.x;
		y = other.y;
		
		draw_xscale = global.player.xscale;
		global.player.yscale = other.yscale;
		vspd = 0;
		jump_total = global.player.jump_total;
		can_coyote_jump = true;
	}
	instance_destroy();
}
else{
	x += _dx;
	y += _dy;
}