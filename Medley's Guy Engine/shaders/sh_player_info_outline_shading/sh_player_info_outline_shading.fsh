uniform vec2 iResolution; 
uniform float gap;
varying vec2 fragCoord;
varying vec2 v_vTexcoord;

#ifdef GL_ES
precision mediump float;
#endif

void main(void) {
	float plot = smoothstep(iResolution.x, iResolution.x - gap, fragCoord.x) - smoothstep(gap, 0., fragCoord.x);
	vec4 c = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(c.xyz, pow(plot * c.a, 0.33));
}