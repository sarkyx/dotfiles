#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d) 1.-smoothstep(-1.3,1.3, (d)*iResolution.y )
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define SkewY(a) mat2(1.0,0.0,tan(a),1.0)

// thx, iq! https://iquilezles.org/articles/distfunctions2d/
float sdHexagon( in vec2 p, in float r )
{
    const vec3 k = vec3(-0.866025404,0.5,0.577350269);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
    return length(p)*sign(p.y);
}

// Getting the hex uv logic from the Shane's implementation here: https://www.shadertoy.com/view/Xljczw
const vec2 s = vec2(1.7320508, 1);
vec4 getHex(vec2 p){
    vec4 hC = floor(vec4(p, p - vec2(1, .5))/s.xyxy) + .5;
    vec4 h = vec4(p - hC.xy*s, p - (hC.zw + .5)*s);
    return dot(h.xy, h.xy)<dot(h.zw, h.zw) ? vec4(h.xy, hC.xy) : vec4(h.zw, hC.zw + .5);
}

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

// thx iq! https://iquilezles.org/articles/distfunctions2d/
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float diceDot(vec2 p){
    float d = length(p) - 0.055;
    float d2 = abs(length(p) - 0.09)-0.005;
    p*=Rot(radians(30.*iTime));
    d2 = max(-(abs(p.x)-0.02),d2);
    d = min(d,d2);
    return d;
}

float renderDice(vec2 p, int num){
    p*=2.;
    vec2 prevP = p;
    float d = 10.;
    if(num == 1){
        d = diceDot(p);
    } else if(num == 2){
        p*=Rot(radians(-45.));
        p.y = abs(p.y)-0.35;
        d = diceDot(p);
    } else if(num == 3){
        p*=Rot(radians(45.));
        p.y = abs(p.y)-0.175;
        p.y = abs(p.y)-0.175;
        d = diceDot(p);
    } else if(num == 4){
        p = abs(p)-0.247;
        d = diceDot(p);
    } else if(num == 5){
        p = abs(p)-0.247;
        d = diceDot(p);
        p = prevP;
        d = min(diceDot(p),d);
    } else if(num == 6){
        p.y = abs(p.y)-(0.247*0.5);
        p.y = abs(p.y)-(0.247*0.5);
        p.x = abs(p.x)-0.175;
        d = diceDot(p);
    }
    p = prevP;
    float d2 = abs(sdBox(p,vec2(0.48,0.4))-0.05)-0.01;
    d = min(d,d2);
    return d;
}

float faceTopBg(vec2 p){
    p*=SkewX(radians(-30.));
    float d = B(p,vec2(0.3,0.25));
    return d;
}

float faceLeftBg(vec2 p){
    p*=SkewX(radians(30.));
    float d = B(p,vec2(0.3,0.25));
    return d;
}

float faceRightBg(vec2 p){
    p*=Rot(radians(-60.));
    p*=SkewX(radians(-30.));
    float d = B(p,vec2(0.29,0.25));
    return d;
}

float faceTop(vec2 p, int num){
    p*=SkewX(radians(-30.));
    float d = renderDice(p,num);
    return d;
}

float faceLeft(vec2 p, int num){
    p*=SkewX(radians(30.));
    float d = renderDice(p,num);
    return d;
}

float faceRight(vec2 p, int num){
    p*=Rot(radians(-60.));
    p*=SkewX(radians(-30.));
    float d = renderDice(p,num);
    return d;
}

float stripe(vec2 p){
    p*=Rot(radians(-60.));
    p*=SkewX(radians(-30.));
    vec2 prevP = p;
    p*=Rot(radians(-45.));
    p-=iTime*0.05;
    p.x = mod(p.x,0.03)-0.015;
    float d = abs(p.x)-0.003;
    p = prevP;
    float d2 = sdBox(p,vec2(0.22,0.18))-0.05;
    d = max(d2,d);
    return d;
}

float dots(vec2 p){
    p*=SkewX(radians(30.));
    vec2 prevP = p;
    p-=iTime*0.03;
    p = mod(p,0.05)-0.025;
    float d = length(p)-0.005;
    p = prevP;
    float d2 = sdBox(p,vec2(0.22,0.18))-0.05;
    d = max(d2,d);
    return d;
}

vec3 drawDices(vec2 p, vec3 col){
    vec2 prevP = p;
    p*=3.+(1.-tanh(8. * cos(iTime / 3.)))*0.5;
    p.y-=iTime*0.5;
    vec4 hgr = getHex(p);
    vec4 prevHgr = hgr;
    float r = random(hgr.zw);
    float n = r*6.;
    
    vec2 gr = prevHgr.xy;

    float animate = (r<0.5) ? 1. : 0.;
    
    float d = faceTopBg(gr-vec2(-0.15,0.25));
    col = mix(col,vec3(0.3),S(d));
    d = faceLeftBg(gr-vec2(-0.15,-0.25));
    col = mix(col,vec3(0.15),S(d));
    d = faceRightBg(gr-vec2(0.29,0.));
    col = mix(col,vec3(0.0),S(d));
    
    d = faceTop(gr-vec2(-0.15,0.25),int(mod((animate*iTime)+n+1.,6.)+1.));
    col = mix(col,vec3(1.),S(d));
    
    if(r<0.5){
        d = dots(gr-vec2(-0.15,-0.25));
        col = mix(col,vec3(0.5),S(d));
        
        d = stripe(gr-vec2(0.29,0.));
        col = mix(col,vec3(0.3),S(d));
    }
    
    d = faceLeft(gr-vec2(-0.15,-0.25),int(mod((animate*iTime)+n+2.,6.)+1.));
    col = mix(col,vec3(0.8),S(d));
    d = faceRight(gr-vec2(0.29,0.),int(mod((animate*iTime)+n+3.,6.)+1.));
    col = mix(col,vec3(0.6),S(d));

    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec3 col = vec3(0.);
    col = drawDices(uv, col);
    fragColor = vec4(col,1.0);
}
