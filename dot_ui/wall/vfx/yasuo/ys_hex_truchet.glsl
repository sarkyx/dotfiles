#define Rot(a)  mat2(cos(a - vec4(0,11,33,0)))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d) 1.-smoothstep(-1.2,1.2, (d)*iResolution.y )
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define PUV(p)vec2(log(length(p)),atan(p.y/p.x))

// thx, iq! https://iquilezles.org/articles/distfunctions2d/
float sdHexagon( in vec2 p, in float r )
{
    const vec3 k = vec3(-0.866025404,0.5,0.577350269);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
    return length(p)*sign(p.y);
}

float customHex(in vec2 p, in float r){
    vec2 prevP = p;
    float d = abs(sdHexagon(p,r))-0.02;
    d = max(-(abs(p.x)-0.08),d);
    p*=Rot(radians(30.));
    d = max(-(abs(p.y)-0.08),d);
    p = prevP;
    p*=Rot(radians(-30.));
    d = max(-(abs(p.y)-0.08),d);
    return d;
}

//thx Shane! getting the hex uv logic from the Shane's implementation here: https://www.shadertoy.com/view/Xljczw
const vec2 s = vec2(1.7320508, 1);
vec4 getHex(vec2 p){
    vec4 hC = floor(vec4(p, p - vec2(1, .5))/s.xyxy) + .5;
    vec4 h = vec4(p - hC.xy*s, p - (hC.zw + .5)*s);
    return dot(h.xy, h.xy)<dot(h.zw, h.zw) ? vec4(h.xy, hC.xy) : vec4(h.zw, hC.zw + .5);
}

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

float drawTruchetCIrcle(vec2 p){
    vec2 prevP = p;
    float s = 0.08;
    p-=vec2(0.29,-0.51);
    float d = abs(length(p)-0.29)-s;

    p = prevP;
    p-=vec2(0.30,0.51);
    float d2 = abs(length(p)-0.29)-s;
    d = min(d,d2);

    p = prevP;
    p-=vec2(-0.58,0.);
    d2 = abs(length(p)-0.29)-s;
    d = min(d,d2); 
    return abs(d)-0.02;
}

float arrows(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.15;
    p.y = mod(p.y,0.15)-0.075;
    p.y-=0.075;
    float d =Tri(p,vec2(0.05));
    p = prevP;
    d = max(abs(p.y)-0.2,d);
    return d;
}

float patterm1(vec2 p){
    float d = length(p)-0.05;
    p = DF(p,vec2(0.75));
    p-=0.2;
    p*=Rot(radians(45.));
    float d2 = arrows(p);
    d = min(d,d2);
    return d;
}

float circles(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.15;
    p.y = mod(p.y,0.15)-0.075;
    float d = abs(length(p)-0.03)-0.01;
    p = prevP;
    d = max(abs(p.y)-0.2,d);
    return d;
}

float patterm2(vec2 p){
    float d = length(p)-0.05;
    p = DF(p,vec2(0.75));
    p-=0.2;
    p*=Rot(radians(45.));
    float d2 = circles(p);
    d = min(d,d2);
    return d;
}

float rects(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.15;
    p.y = mod(p.y,0.15)-0.075;
    float d = abs(B(p,vec2(0.04)))-0.01;
    p = prevP;
    d = max(abs(p.y)-0.2,d);
    return d;
}

float patterm3(vec2 p){
    vec2 prevP = p;
    
    p*=Rot(radians(30.));
    p.y-=0.08;
    p.x*=1.5;
    float d = Tri(p,vec2(0.12));
    p = prevP;
    p = DF(p,vec2(0.75));
    p-=0.2;
    p*=Rot(radians(45.));
    float d2 = rects(p);
    d = min(d,d2);
    return d;
}

float plus(vec2 p){
    p*=Rot(radians(30.*iTime*2.));
    float d = B(p,vec2(0.01,0.05));
    float d2 = B(p,vec2(0.05,0.01));
    d = min(d,d2);
    return d;
}

float pluses(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.15;
    p.y = mod(p.y,0.15)-0.075;
    float d = plus(p);
    p = prevP;
    d = max(abs(p.y)-0.2,d);
    return d;
}

float patterm4(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(30.));
    float d = plus(p);
    p = prevP;
    p = DF(p,vec2(0.75));
    p-=0.2;
    p*=Rot(radians(45.));
    float d2 = pluses(p);
    d = min(d,d2);
    return d;
}

float drawHexTruchet(vec2 p){
    vec4 hgr = getHex(p);
    vec4 prevHgr = hgr;
    float n = Hash21(hgr.zw);
    
    float d = customHex(hgr.xy, 0.46);
    float d2 = 10.;
    
    if(n<0.5){
        d2 = drawTruchetCIrcle(hgr.xy);
        d = min(d,d2);
        
        if(n<0.25){
            d2 =patterm1(hgr.xy);
        } else {
            d2 =patterm2(hgr.xy);
        }
        
        d = min(d,d2);
    } else {
        hgr.x *= -1.;
        d2 = drawTruchetCIrcle(hgr.xy);
        d = min(d,d2);
        
        if(n<0.75){
            d2 =patterm3(hgr.xy);
        } else {
            d2 =patterm4(hgr.xy);
        }
        d = min(d,d2);
    }
    d2 = abs(sdHexagon(prevHgr.xy,0.5))-0.02;
    d = max(-d2,d);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5* iResolution.xy) / iResolution.y; 
    vec2 prevUV = uv;
    uv*=Rot(radians(3.*iTime));
    uv.x = abs(uv.x); // tweaked the shiffting issue
    uv = PUV(uv);
    uv.x+=iTime*0.2;
    uv*=2.54;
    vec3 col = vec3(0.);
    
    float d = drawHexTruchet(uv);
    col = mix(col,vec3(1.),S(d));
    col*=length(prevUV);

    fragColor = vec4(col, 1.0);
}
