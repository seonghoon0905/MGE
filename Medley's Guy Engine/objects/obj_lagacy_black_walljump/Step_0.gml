if(keyboard_check_pressed(global.key_config.load)){
	deactivated = true;
}

if(deactivated){
	image_alpha = 0.5;
}
else{
	image_alpha = 1;
}
