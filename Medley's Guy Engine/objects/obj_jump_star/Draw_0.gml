draw_sprite_ext(sprite_index, index, x, y, image_xscale, image_yscale, 0, c_white, 1);

if(animation_start){
	var _amount = animation_value / animation_value_limit;
	var _size = lerp(1, 2, _amount);
	var _alpha = lerp(1, 0, _amount);
	var _x = sprite_get_width(sprite_index) * image_xscale * (_size - 1) / 2;
	var _y = sprite_get_height(sprite_index) * image_yscale *  (_size - 1) / 2;
	draw_sprite_ext(
		sprite_index, index, 
		x - _x, 
		y - _y, 
		_size * image_xscale, 
		_size * image_yscale, 0, c_white, _alpha
	);
	if(animation_value < animation_value_limit){
		animation_value++;
	}
	else{
		animation_start = false;
	}
}