varying vec2 fragCoord;
varying vec2 v_vTexcoord;

#ifdef GL_ES
precision mediump float;
#endif

void main(void) {
	float plot = smoothstep(1., 0., length(vec2(96.) - fragCoord) / 160.);
	vec4 c = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(c.xyz, c.w * plot);
}