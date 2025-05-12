if(other.activated){
	play_sound(snd_shoot_refresher, 0);

	if(global.player.jump_total > 1){
		with(obj_player){
			if(jump_total - 1 == 0 || jump_total == 0){
				jump_total = 1;
			}
		}
	}
	
	other.activated = false;
}