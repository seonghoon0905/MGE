/// @description local library
function handle_warp_text(){
	if(warp_mode != 2){
		return;
	}

	if(text_alpha1 > 0){
		scribble("Press up to enter")
			.starting_format("fnt_serif_bold_24", c_white)
			.transform(12 / 24, 12 / 24)
			.align(fa_center, fa_middle)
			.blend(c_white, text_alpha1)
			.sdf_shadow(c_dkgray, 0.8, 2, 2)
			.draw(x + sprite_width / 2, y - 10);
	}
}

function handle_warp_name(){
	if(name == undefined){
		return;
	}
	
	if(text_alpha2 > 0){
		scribble(name)
			.starting_format("fnt_serif_bold_24", c_white)
			.transform(12 / 24, 12 / 24)
			.align(fa_center, fa_middle)
			.blend(c_white, text_alpha2)
			.sdf_shadow(c_black, 1, 1, 1)
			.draw(x + sprite_width / 2, y - 10);
	}
}