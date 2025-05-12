function Danmaku(_x, _y, _insts, _in_rotation_config = undefined) constructor{
	x = _x;
	y = _y;
	
	old_x = x;
	old_y = y;
	
	insts = variable_clone(_insts);
	obj = insts[0].object_index;
	
	in_rotation_config = variable_clone(_in_rotation_config);
	inside_rotation = 0;
	
	old_insts = [];
	far_dist = -infinity;
	size = 1;
	rotation = 0;
	
	for(var _i = 0; _i < array_length(insts); _i++){
		array_push(old_insts, {
			x : insts[_i].x,
			y : insts[_i].y
		});
		
		var _dist = point_distance(x, y, insts[_i].x, insts[_i].y);
		if(_dist > far_dist){
			far_dist = _dist;
		}
	}
	
	old_far_dist = far_dist;
	
	static destroy = function(){
		for(var _i = 0; _i < array_length(insts); _i++){
			instance_destroy(insts[_i]);
		}
	}
	
	static explode = function(_spd, _obj, _layer){
		for(var _i = 0; _i < array_length(insts); _i++){
			var _dist = point_distance(x, y, insts[_i].x, insts[_i].y);
			var _dir = point_direction(x, y, insts[_i].x, insts[_i].y);
			var _inst = instance_create_layer(insts[_i].x, insts[_i].y, _obj, _layer);
			_inst.speed = (_dist / far_dist) * _spd;
			_inst.direction = _dir;
		}	
	}
	
	static rotate_inside_circle = function(_rotation){
		var _n = in_rotation_config.n;
		var _dir_offset = in_rotation_config.dir_offset;
		var _start_dir = _dir_offset + rotation + _rotation;
		var _end_dir = _dir_offset + 360 + rotation + _rotation;
		var _cnt = 0;
		for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
			var _xx = x + lengthdir_x(far_dist, _dir);
			var _yy = y + lengthdir_y(far_dist, _dir);
			insts[_cnt].x = _xx;
			insts[_cnt].y = _yy;
			_cnt++;
		}
	}
		
	static rotate_inside_eclipse = function(_rotation){
		var _n = in_rotation_config.n;
		var _dir_offset = in_rotation_config.dir_offset;
		var _major_axis = in_rotation_config.major_axis * size;
		var _minor_axis = in_rotation_config.minor_axis * size;
		var _start_dir = _dir_offset + _rotation;
		var _end_dir = _dir_offset + 360 + _rotation;
		var _cnt = 0;
		for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
			var _xx = x + lengthdir_x(_major_axis, _dir);
			var _yy = y + lengthdir_y(_minor_axis, _dir);
			var _direction = point_direction(x, y, _xx, _yy) + rotation;
			var _distance = point_distance(x, y, _xx, _yy);
			insts[_cnt].x = x + lengthdir_x(_distance, _direction);
			insts[_cnt].y = y + lengthdir_y(_distance, _direction);	
			_cnt++;
		}
	}
	
	static rotate_inside_polygon = function(_rotation){
		var _n = in_rotation_config.n;
		var _bullets_per_line = in_rotation_config.bullets_per_line;
		var _dir_offset = in_rotation_config.dir_offset;
		var _start_dir = _dir_offset + rotation;
		var _end_dir = _dir_offset + 360 + rotation;
		var _cnt = 0;
		
		for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
			for(var _i = 0; _i < _bullets_per_line; _i++){
				var _start_x = x + lengthdir_x(far_dist, _dir);
				var _end_x = x + lengthdir_x(far_dist, _dir + 360 / _n);
				var _start_y = y + lengthdir_y(far_dist, _dir);
				var _end_y = y + lengthdir_y(far_dist, _dir + 360 / _n);
				var _amount = ((_i + _rotation / _bullets_per_line / _n) % _bullets_per_line) / _bullets_per_line;
				if(_amount < 0){
					_amount = 1 + _amount;
				}
				var _xx = lerp(_start_x, _end_x, _amount);
				var _yy = lerp(_start_y, _end_y, _amount);
				insts[_cnt].x = _xx;
				insts[_cnt].y = _yy;
				_cnt++;
			}
		}
	}
		
	static rotate_inside_star = function(_rotation){
		var _bullets_per_line = in_rotation_config.bullets_per_line;
		var _dir_offset = in_rotation_config.dir_offset;
		var _start_dir = _dir_offset + rotation;
		var _end_dir = _dir_offset + 720 + rotation;
		var _cnt = 0;
		
		for(var _dir = _start_dir; _dir < _end_dir; _dir += 720 / 5){
			var _start_x = x + lengthdir_x(far_dist, _dir);
			var _end_x = x + lengthdir_x(far_dist, _dir + 720 / 5);
			var _start_y = y + lengthdir_y(far_dist, _dir);
			var _end_y = y + lengthdir_y(far_dist, _dir + 720 / 5);
			for(var _i = 0; _i < _bullets_per_line; _i++){
				var _amount = ((_i + _rotation / _bullets_per_line / 5) % _bullets_per_line) / _bullets_per_line;
				if(_amount < 0){
					_amount = 1 + _amount;
				}
				var _xx = lerp(_start_x, _end_x, _amount);
				var _yy = lerp(_start_y, _end_y, _amount);
				insts[_cnt].x = _xx;
				insts[_cnt].y = _yy;
				_cnt++;
			}
		}
	}
		
	static rotate_inside_heart = function(_rotation){
		var _n = in_rotation_config.n;
		var _dir_offset = in_rotation_config.dir_offset;
		var _start_dir = _dir_offset + _rotation;
		var _end_dir = _dir_offset + 360 + _rotation;
		var _cnt = 0;
		for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
			var _xx = 16 * power(dsin(_dir), 3);
			var _yy = 13 * dcos(_dir) - 5 * dcos(2 * _dir) - 2 * dcos(3 * _dir) - dcos(4 * _dir);
			
			_xx *= size * in_rotation_config.size;
			_yy *= -size * in_rotation_config.size;
			_xx += x;
			_yy += y;
			
			var _direction = point_direction(x, y, _xx, _yy) + rotation;
			var _distance = point_distance(x, y, _xx, _yy);
			insts[_cnt].x = x + lengthdir_x(_distance, _direction);
			insts[_cnt].y = y + lengthdir_y(_distance, _direction);

			_cnt++;
		}
	}
	
	static rotate_inside = function(_rotation){
		switch(in_rotation_config.type){
			case "circle":
				rotate_inside_circle(_rotation);
				break;
			case "eclipse":
				rotate_inside_eclipse(_rotation);
				break;
			case "polygon":
				rotate_inside_polygon(_rotation);
				break;
			case "star":
				rotate_inside_star(_rotation);
				break;
			case "heart":
				rotate_inside_heart(_rotation);
				break;
		}
	}

	static transform = function(_x, _y, _rotation, _size, _inside_rotation = undefined){
		x = _x;
		y = _y;
		size = _size;
		far_dist = old_far_dist * size;
		rotation = _rotation;
		inside_rotation = _inside_rotation;
		
		for(var _i = 0; _i < array_length(old_insts); _i++){
			var _dist = point_distance(old_x, old_y, old_insts[_i].x, old_insts[_i].y) * size;
			var _dir = point_direction(old_x, old_y, old_insts[_i].x, old_insts[_i].y) + rotation;
			insts[_i].x = x + lengthdir_x(_dist, _dir);
			insts[_i].y = y + lengthdir_y(_dist, _dir);
		}
		
		if(inside_rotation != undefined){
			rotate_inside(inside_rotation);
		}
	}
	
	static transform_ext = function(_x, _y, _rotation, _size, _inside_rotation = undefined){
		x += _x;
		y += _y;
		size += _size;
		far_dist = old_far_dist * size;
		rotation += _rotation;
		inside_rotation += _inside_rotation;
		
		for(var _i = 0; _i < array_length(old_insts); _i++){
			var _dist = point_distance(old_x, old_y, old_insts[_i].x, old_insts[_i].y) * size;
			var _dir = point_direction(old_x, old_y, old_insts[_i].x, old_insts[_i].y) + rotation;
			insts[_i].x = x + lengthdir_x(_dist, _dir);
			insts[_i].y = y + lengthdir_y(_dist, _dir);
		}
		
		if(inside_rotation != undefined){
			rotate_inside(inside_rotation);
		}
	}
	
	static set_size = function(_size){
		size = _size;
		transform(x, y, rotation, size, inside_rotation);
	}
	
	static add_size = function(_size){
		size += _size;
		transform(x, y, rotation, size, inside_rotation);
	}
	
	static set_position = function(_x, _y){
		x = _x;
		y = _y;
		transform(x, y, rotation, size, inside_rotation);
	}
	
	static add_position = function(_x, _y){
		x += _x;
		y += _y;
		transform(x, y, rotation, size, inside_rotation);
	}
	
	static set_rotation = function(_rotation){
		rotation = _rotation;
		transform(x, y, rotation, size, inside_rotation);
	}
	
	static add_rotation = function(_rotation){
		rotation += _rotation;
		transform(x, y, rotation, size, inside_rotation);
	}

	static set_inside_rotation = function(_rotation){
		inside_rotation = _rotation;
		transform(x, y, rotation, size, inside_rotation);
	}
	
	static add_inside_rotation = function(_rotation){
		inside_rotation += _rotation;
		transform(x, y, rotation, size, inside_rotation);
	}
}