if(instance_exists(obj_player)){
	var _inst = instance_create_depth(x, y, layer_get_depth(obj_player.layer) - 100, obj_pastel_water3);
	_inst.image_angle = image_angle;
	_inst.speed = 2;
	_inst.direction = image_angle + 90;
	_inst.image_xscale = image_xscale;
	_inst.image_yscale = image_yscale;
	
	with(other){
		instance_destroy();
	}
}