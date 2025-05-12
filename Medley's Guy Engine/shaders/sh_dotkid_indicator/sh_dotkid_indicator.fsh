uniform vec3 iResolution; 
uniform vec2 pos;
varying vec2 fragCoord; 

float plot(float x, float gap, float a){
    return smoothstep(x + gap, x, a) - smoothstep(x, x - gap, a);
}

void main(void){
    vec2 uv = ((fragCoord.xy - pos) - .5*iResolution.xy) / iResolution.y;
    vec4 col = vec4(0.);
    vec2 center = vec2(0.);
    float radius = 0.49;
    float sdf = radius - length(uv);
    sdf = plot(0., 2./iResolution.y, sdf);
    col = mix(col, vec4(1., 0., 0., 1.), sdf);
    gl_FragColor = col;
}