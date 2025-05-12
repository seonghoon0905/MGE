uniform vec2 iResolution; 
varying vec2 fragCoord;
varying vec2 v_vTexcoord;

void main(void) {
    gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).xyz, 1);
}