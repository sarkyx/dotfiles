float sun(vec2 p, float t){
    float a = atan(p.x, p.y)-t/50.0;
    return 0.03/length(p*sin(a*11.0));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 tc = fragCoord/iResolution.xy;
    vec2 uv = fragCoord/iResolution.y;
    vec2 uvc = uv - vec2(iResolution.x/iResolution.y, 1.0)/2.0;
    vec2 nuv = vec2(iResolution.x/iResolution.y, 1.0) - uv;
    float t = iTime/3.0;
    vec2 gn = iResolution.xy/4.0;
    vec2 guv = fract(tc*gn);
    vec2 gid = floor(tc*gn);
    vec2 p1 = uvc + vec2(sin(t/3.0), cos(t/3.0+sin(t)))/3.0;
    vec2 p2 = uvc + vec2(cos(t/3.0), sin(-t/3.0+cos(t)))/3.0;
    float d = sin(uv.y*10.0+t)*sin(t)*0.1;
    nuv.x += d;
    float c = (2.0*mix(0.0, sun(p2, t)*mix(100.0, 300.0, smoothstep(-1.0, 1.0, sin(iTime))), fract(smoothstep(0.0, sun(p1, t), .5*sun(nuv, 0.0)))*(1.0/length(guv-0.5)/100.0)));
    fragColor = vec4(c);
}
