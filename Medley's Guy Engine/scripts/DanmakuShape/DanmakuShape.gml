function make_circle_danmaku(_x, _y, _n, _dir_offset, _radius, _layer, _obj){
	var _insts = [];
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _xx = _x + lengthdir_x(_radius, _dir);
		var _yy = _y + lengthdir_y(_radius, _dir);
		var _inst = instance_create_layer(_xx, _yy, _layer, _obj);
		array_push(_insts, _inst);
	}
	return new Danmaku(_x, _y, _insts, {
		type : "circle",
		n : _n,
		dir_offset : _dir_offset
	});
}

function make_eclipse_danmaku(_x, _y, _n, _dir_offset, _major_axis, _minor_axis, _layer, _obj){
	var _insts = [];
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _xx = _x + lengthdir_x(_major_axis, _dir);
		var _yy = _y + lengthdir_y(_minor_axis, _dir);
		var _inst = instance_create_layer(_xx, _yy, _layer, _obj);
		array_push(_insts, _inst);
	}
	return new Danmaku(_x, _y, _insts, {
		type : "eclipse",
		n : _n,
		dir_offset : _dir_offset,
		major_axis : _major_axis,
		minor_axis : _minor_axis
	});
}

function make_polygon_danmaku(_x, _y, _n, _bullets_per_line, _dir_offset, _size, _layer, _obj){
	var _insts = [];
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _start_x = _x + lengthdir_x(_size, _dir);
		var _end_x = _x + lengthdir_x(_size, _dir + 360 / _n);
		var _start_y = _y + lengthdir_y(_size, _dir);
		var _end_y = _y + lengthdir_y(_size, _dir + 360 / _n);
		for(var _i = 0; _i < _bullets_per_line; _i++){
			var _xx = lerp(_start_x, _end_x, _i / _bullets_per_line);
			var _yy = lerp(_start_y, _end_y, _i / _bullets_per_line);
			var _inst = instance_create_layer(_xx, _yy, _layer, _obj);
			array_push(_insts, _inst);
		}
	}
	return new Danmaku(_x, _y, _insts, {
		type : "polygon",
		n : _n,
		bullets_per_line : _bullets_per_line,
		dir_offset : _dir_offset
	});
}

function make_star_danmaku(_x, _y, _bullets_per_line, _dir_offset, _size, _layer, _obj){
	var _insts = [];
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 720;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 720 / 5){
		var _start_x = _x + lengthdir_x(_size, _dir);
		var _end_x = _x + lengthdir_x(_size, _dir + 720 / 5);
		var _start_y = _y + lengthdir_y(_size, _dir);
		var _end_y = _y + lengthdir_y(_size, _dir + 720 / 5);
		for(var _i = 0; _i < _bullets_per_line; _i++){
			var _xx = lerp(_start_x, _end_x, _i / _bullets_per_line);
			var _yy = lerp(_start_y, _end_y, _i / _bullets_per_line);
			var _inst = instance_create_layer(_xx, _yy, _layer, _obj);
			array_push(_insts, _inst);
		}
	}
	return new Danmaku(_x, _y, _insts, {
		type : "star",
		bullets_per_line : _bullets_per_line,
		dir_offset : _dir_offset
	});
}

function make_heart_danmaku(_x, _y, _n, _dir_offset, _size, _layer, _obj){
	var _insts = [];
	var _start_dir = _dir_offset;
	var _end_dir = _dir_offset + 360;
	for(var _dir = _start_dir; _dir < _end_dir; _dir += 360 / _n){
		var _xx = 16 * power(dsin(_dir), 3);
		var _yy = 13 * dcos(_dir) - 5 * dcos(2 * _dir) - 2 * dcos(3 * _dir) - dcos(4 * _dir);
		_xx *= _size;
		_yy *= -_size;
		_xx += _x;
		_yy += _y;
		var _inst = instance_create_layer(_xx, _yy, _layer, _obj);
		array_push(_insts, _inst);
	}
	return new Danmaku(_x, _y, _insts, {
		type : "heart",
		n : _n,
		dir_offset : _dir_offset,
		size : _size
	});
}