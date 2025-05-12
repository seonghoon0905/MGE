function dot(_v1, _v2){
	return _v1.x * _v2.x + _v1.y * _v2.y;
}

function cross(_v1, _v2){
	return _v1.x * _v2.y - _v1.y * _v2.x;
}

function rotate2d(_v, _dir){
	return {
		x : _v.x * lengthdir_x(1, _dir) - _v.y * lengthdir_y(1, _dir),
		y : _v.x * lengthdir_y(1, _dir) + _v.y * lengthdir_x(1, _dir)
	}
}

function cross3d(_v1, _v2){
	return{
		x : _v1.y * _v2.z - _v2.y * _v1.z,
		y : _v1.z * _v2.x - _v2.z * _v1.x,
		z : _v1.x * _v2.y - _v2.x * _v1.y
	}
}

function triple_product(_v1, _v2, _v3){
	return cross3d(cross3d(_v1, _v2), _v3);
}

