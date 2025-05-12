draw_sprite_ext(sprite_index, 1, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);

if(!surface_exists(surf)){
	surf = surface_create(sprite_width, sprite_height);
}

draw_x += move_speed;
draw_x = draw_x % sprite_width;

surface_set_target(surf);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(sprite_index, 2, draw_x, 0, image_xscale, image_yscale, 0, c_white, image_alpha);
draw_sprite_ext(sprite_index, 2, draw_x - sprite_width, 0, image_xscale, image_yscale, 0, c_white, image_alpha);
surface_reset_target();

draw_surface_ext(surf, x, y, 1, 1, image_angle, c_white, image_alpha);