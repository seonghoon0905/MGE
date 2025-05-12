attribute vec3 in_Position; 
varying vec2 fragCoord; 
attribute vec2 in_TextureCoord;
varying vec2 v_vTexcoord;


void main() {
	vec4 Position = vec4( in_Position, 1); 
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * Position; 
	fragCoord = in_Position.xy; 
    v_vTexcoord = in_TextureCoord;
}