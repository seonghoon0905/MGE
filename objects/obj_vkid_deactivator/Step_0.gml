image_alpha = 1;
if(instance_exists(obj_player)){
	if(global.player.kid_mode == "vkid"){
		image_alpha = 1;
	}
	else{
		image_alpha = 0.2;
	}
}