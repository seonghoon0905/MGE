function explode_circle_danmaku(_x, _y, _spd, _n, _dir_offset, _layer, _obj){
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _inst = instance_create_layer(_x, _y, _layer, _obj);
		_inst.direction = _dir;
		_inst.speed = _spd;
	}
}

function explode_eclipse_danmaku(_x, _y, _spd, _n, _dir_offset, _layer, _major_axis, _minor_axis, _obj){
	var _insts = [];
	for(var _dir = 0; _dir < 360; _dir += 360 / _n){
		var _inst = instance_create_layer(_x, _y, _layer, _obj);
		var _xx = _x + lengthdir_x(1, _dir);
		var _yy = _y + lengthdir_y(_minor_axis / _major_axis, _dir);
		_inst.speed = point_distance(_x, _y, _xx, _yy) * _spd;
		_inst.direction = point_direction(_x, _y, _xx, _yy) + _dir_offset;
	}
}

function explode_polygon_danmaku(_x, _y, _spd, _n, _bullets_per_line, _dir_offset, _layer, _obj){
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _start_x = _x + lengthdir_x(1, _dir);
		var _end_x = _x + lengthdir_x(1, _dir + 360 / _n);
		var _start_y = _y + lengthdir_y(1, _dir);
		var _end_y = _y + lengthdir_y(1, _dir + 360 / _n);
		for(var _i = 0; _i < _bullets_per_line; _i++){
			var _xx = lerp(_start_x, _end_x, _i / _bullets_per_line);
			var _yy = lerp(_start_y, _end_y, _i / _bullets_per_line);
			var _inst = instance_create_layer(_x, _y, _layer, _obj);
			_inst.speed = point_distance(_x, _y, _xx, _yy) * _spd;
			_inst.direction = point_direction(_x, _y, _xx, _yy);
		}
	}
}

function explode_star_danmaku(_x, _y, _spd, _bullets_per_line, _dir_offset, _layer, _obj){
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 720;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 720 / 5){
		var _start_x = _x + lengthdir_x(1, _dir);
		var _end_x = _x + lengthdir_x(1, _dir + 720 / 5);
		var _start_y = _y + lengthdir_y(1, _dir);
		var _end_y = _y + lengthdir_y(1, _dir + 720 / 5);
		for(var _i = 0; _i < _bullets_per_line; _i++){
			var _xx = lerp(_start_x, _end_x, _i / _bullets_per_line);
			var _yy = lerp(_start_y, _end_y, _i / _bullets_per_line);
			var _inst = instance_create_layer(_x, _y, _layer, _obj);
			_inst.speed = point_distance(_x, _y, _xx, _yy) * _spd;
			_inst.direction = point_direction(_x, _y, _xx, _yy);
		}
	}
}

function explode_heart_danmaku(_x, _y, _spd, _n, _dir_offset, _layer, _obj){
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _xx = 16 * power(dsin(_dir), 3);
		var _yy = 13 * dcos(_dir) - 5 * dcos(2 * _dir) - 2 * dcos(3 * _dir) - dcos(4 * _dir);
		_yy *= -1;
		_xx += _x;
		_yy += _y;
		var _inst = instance_create_layer(_x, _y, layer, _obj);
		_inst.speed = point_distance(_x, _y, _xx, _yy) * _spd / 5;
		_inst.direction = point_direction(_x, _y, _xx, _yy);
	}
}

