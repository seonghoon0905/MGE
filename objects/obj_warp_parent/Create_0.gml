warp_room = undefined;
warp_x = undefined;
warp_y = undefined;

name = undefined;
range = infinity;

amount1 = 0;
amount2 = 0;

alpha = 1;
text_alpha1 = 0;
text_alpha2 = 0;

warp_mode = 1;

/* 
	<warp modes>
	1 -> Teleport the player when he touches the warp
	2 -> Teleport the player when he's touching the warp and pressing "UP" key
*/

event_user(0); // local library

// event function
function step(){
	if(warp_room == undefined){
		return;
	}
	
	var _col = place_meeting(x, y, obj_player);
	
	if(_col){
		if((warp_mode == 1) || (warp_mode == 2 && keyboard_check_pressed(global.key_config.up))){
			global.warp.room = warp_room;
			global.warp.x = warp_x;
			global.warp.y = warp_y;
			room_goto(global.warp.room);
		}
	}
	
	var _latency = 6;
	if(warp_mode == 2){
		amount1 += (_col - amount1) / _latency;
		alpha = lerp(1, 0.7, amount1);
		text_alpha1 = lerp(0, 1, amount1);
	}
	
	var _in_range = true;
	if(range != infinity && instance_exists(obj_player)){
		_in_range = point_distance(x, y, obj_player.x, obj_player.y) < range;
		amount2 += ((!_col && _in_range) - amount2) / _latency;
		text_alpha2 = lerp(0, 1, amount2);
	}
	else{
		text_alpha2 = 1;
	}
}

function draw(){
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, alpha);
	handle_warp_text();
	handle_warp_name();
}