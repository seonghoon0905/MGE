draw_self();

if(touch && dialogues != ""){
	scribble(dialogues)
		.starting_format("fnt_serif_bold_24", c_white)
		.transform(12 / 24, 12 / 24)
		.align(fa_center, fa_middle)
		.sdf_shadow(c_black, 1, 1, 1)
		.draw(x + sprite_width / 2, y - 10);
}