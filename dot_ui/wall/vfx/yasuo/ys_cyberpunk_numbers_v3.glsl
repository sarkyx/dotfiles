#define R       iResolution.xy
#define Rot(a)  mat2(cos( radians(a) - vec4(0,11,33,0)))
#define S(d)    1.-smoothstep(-1.2,1.2, (d)*R.y )
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define SkewY(a) mat2(1.0,0.0,tan(a),1.0)
#define ch_0 0
#define ch_1 1
#define ch_2 2
#define ch_3 3
#define ch_4 4
#define ch_5 5
#define ch_6 6
#define ch_7 7
#define ch_8 8
#define ch_9 9

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

// thx iq! https://iquilezles.org/articles/distfunctions2d/
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec2 glitchEfect(vec2 uv, float shift, float b) {
    float glitchBlock = b;
    vec2 uv2 = fract(uv*glitchBlock)-0.5;
    vec2 id = floor(uv2);

    float n =Hash21(id);
    
    float glitchDist = 0.01;
    uv.x-=(fract(floor(uv.y+n*glitchBlock))*glitchDist);
    uv.x+=sin(n*3.0)*shift;
    return uv;
}

float grid(vec2 p, float size){
    vec2 prevP = p;
    float thickness = 0.001;
    p.x+=0.25;
    p = mod(p,size)-(size*0.5);
    
    float d = abs(p.x)-thickness;
    float d2 = abs(p.y)-thickness;
    d = min(d,d2);

    return d;
}

float dots(vec2 p){
    p = mod(p,0.1)-0.05;
    float d = length(p)-0.01;
    return d;
}

float stripes(vec2 p, float dir, float space, float s){
    vec2 prevP = p;
    
    p*=Rot(30.);
    p.x+=iTime*0.1*dir;
    p.x = mod(p.x,space)-(space*0.5);
    
    float d = sdBox(p,vec2(s,10.));
    return d;
}

float glitchBg(vec2 p){
    vec2 prevP = p;
    
    p*=6.;
    p.y-=iTime*0.5;
    
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);
    vec2 prevGv = gv;
    
    gv = glitchEfect(gv,0.3,5.);
    float n = clamp(Hash21(id)*0.4,0.1,0.4);
    
    float d = sdBox(gv,vec2(n));
    
    gv = prevGv;
    float d2 = stripes(gv,n<0.2?1.:-1.,0.1,0.02+n*0.05);
    if(n<0.15){
        if(n<0.1)d = max(-d2,d);
    } else {
        d = 10.;
    }
    
    p = prevP;
    p*=3.;
    p+=0.5;
    p.y-=iTime*0.25;
    gv = fract(p)-0.5;
    id = floor(p);
    prevGv = gv;
    
    gv = glitchEfect(gv,0.3,5.);
    n = clamp(Hash21(id)*0.4,0.1,0.4);
    
    d2 = sdBox(gv,vec2(n));
    
    gv = prevGv;
    float d3 = stripes(gv,n<0.2?1.:-1.,0.1,0.02+n*0.05);
    if(n<0.3){
        if(n<0.25)d2 = max(-d3,d2);
    } else {
        d2 = 10.;
    }
    d = min(d,d2);
    
    
    p = prevP;
    p*=3.;
    p-=0.5;
    p.y-=iTime*0.3;
    gv = fract(p)-0.5;
    id = floor(p);

    gv = glitchEfect(gv,0.3,5.);
    n = Hash21(id);
    
    d2 = dots(gv);
    if(n>0.3){
        d2 = 10.;
    }
    d = min(d,d2);
    
    
    p = prevP;
    p.y-=iTime*0.1;
    d2 = grid(p,0.05);
    d = min(d,d2);
    
    return d;
}

float char0(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.2,0.25));
    
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    p.y = abs(p.y);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    p = prevP;
    float d2 = sdBox(p,vec2(0.1,0.15));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(-0.1,0.125),vec2(0.11,0.025));
    d = max(-d2,d);
    
    return d;
}

float char1(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.05,0.25));
    float d2 = sdBox(p-vec2(-0.05,0.2),vec2(0.05,0.05));
    d = min(d,d2);
    
    d2 = sdBox(p-vec2(0.0,0.125),vec2(0.11,0.025));
    d = max(-d2,d);
    
    return d;
}

float char2(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.2,0.25));
    
    p = prevP;
    float d2 = sdBox(p-vec2(0.,0.1),vec2(0.3,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(0.1,-0.1),vec2(0.2,0.05));
    d = max(-d2,d);

    p-=vec2(-0.2,0.025);
    p*=Rot(-45.);
    
    d2 = sdBox(p,vec2(0.1,0.025));
    d = max(-d2,d);
    
    p = prevP;
    
    d2 = sdBox(p-vec2(0.15,0.05),vec2(0.05));
    d = min(d,d2);        
    
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    p.y = abs(p.y);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float char3(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.2,0.25));
    
    p = prevP;
    float d2 = sdBox(p-vec2(0.,0.1),vec2(0.3,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(-0.1,-0.1),vec2(0.2,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(-0.16,0.0),vec2(0.06,0.06));
    d = max(-d2,d);
    
    p = prevP;
    
    d2 = sdBox(p-vec2(0.15,0.05),vec2(0.05));
    d = min(d,d2);    
    
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    p.y = abs(p.y);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float char4(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p-vec2(0.05,-0.075),vec2(0.05,0.175));
    float d2 = sdBox(p-vec2(0.0,-0.1),vec2(0.2,0.05));
    d = min(d,d2);
    
    p*=Rot(18.);
    d2 = sdBox(p-vec2(-0.125,0.05),vec2(0.05,0.2));
    d = min(d,d2);
    
    p = prevP;
    p-=vec2(0.1,0.08);
    p*=Rot(45.);
    
    d2 = sdBox(p,vec2(0.07,0.025));
    d = max(-d2,d);
    
    p = prevP;
    d = max(-p.x-0.2,d);
    d = max(p.y-0.25,d);
    
    return d;
}

float char5(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.2,0.25));
    
    p = prevP;
    float d2 = sdBox(p-vec2(0.,0.1),vec2(0.3,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(-0.1,-0.1),vec2(0.2,0.05));
    d = max(-d2,d);

    p-=vec2(0.2,0.025);
    p*=Rot(45.);
    d2 = sdBox(p,vec2(0.1,0.025));
    d = max(-d2,d);
    
    p = prevP;
    
    d2 = sdBox(p-vec2(-0.15,0.05),vec2(0.05));
    d = min(d,d2);    
    
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    p.y = abs(p.y);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float char6(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.2,0.25));
    
    p = prevP;
    float d2 = sdBox(p-vec2(0.,0.1),vec2(0.3,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(0.,-0.1),vec2(0.1,0.05));
    d = max(-d2,d);

    p-=vec2(0.2,0.025);
    p*=Rot(45.);
    d2 = sdBox(p,vec2(0.1,0.025));
    d = max(-d2,d);
    
    p = prevP;
    
    d2 = sdBox(p-vec2(-0.15,0.05),vec2(0.05));
    d = min(d,d2);    
    
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    p.y = abs(p.y);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float char7(vec2 p){
    vec2 prevP = p;
    p*=Rot(38.);
    float d = sdBox(p-vec2(0.045,-0.05),vec2(0.05,0.35));
    p = prevP;
    float d2 = sdBox(p-vec2(0.0,0.2),vec2(0.2,0.05));
    d = min(d,d2);
    
    d2 = sdBox(p-vec2(0.0,0.125),vec2(0.3,0.025));
    d = max(-d2,d);
    
    d = max(p.x-0.2,d);
    d = max(-p.y-0.25,d);
    
    p = prevP;
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float char8(vec2 p){
    vec2 prevP = p;
    float d = sdBox(p,vec2(0.2,0.25));
    
    p = prevP;
    float d2 = sdBox(p-vec2(-0.11,0.1),vec2(0.21,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(0.,-0.1),vec2(0.1,0.05));
    d = max(-d2,d);
    
    d2 = sdBox(p-vec2(-0.15,0.05),vec2(0.05));
    d = min(d,d2);
    
    p = prevP;
    float a = radians(45.);
    p.x = abs(p.x)-0.4;
    p.y = abs(p.y);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float char9(vec2 p){
    vec2 prevP = p;
    p*=-1.0;
    float d = char6(p);
    
    return d;
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float drawFont(vec2 p, int char){
    p*=0.6;
    //p*=Rot(90.);
    p*=SkewX(radians(-20.));
    p = glitchEfect(p,0.035,5.0);
    vec2 prevP = p;
    float d = char0(p)*checkChar(ch_0,char);
    d += char1(p)*checkChar(ch_1,char);
    d += char2(p)*checkChar(ch_2,char);
    d += char3(p)*checkChar(ch_3,char);
    d += char4(p)*checkChar(ch_4,char);
    d += char5(p)*checkChar(ch_5,char);
    d += char6(p)*checkChar(ch_6,char);
    d += char7(p)*checkChar(ch_7,char);
    d += char8(p)*checkChar(ch_8,char);
    d += char9(p)*checkChar(ch_9,char);
    
    return d;
}

float render(vec2 p){
    //p*=Rot(30.*iTime);

    float t = iTime;
    p*=4.;
    p.y-=t*0.5;
    
    if(mod(p.y,2.)>1.){
        p.x+=t*0.5;
    } else {
        p.x-=t*0.5;
    }
    
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);

    float n = Hash21(id)*10.0;
    int char = int(n);
    int frame = int(mod(iTime*1.2+float(n),10.0));
    float d = drawFont(gv,frame);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    
    vec3 col = vec3(0.);

    // shane's 2d flat bumpmap reference: https://www.shadertoy.com/view/4ftBzS
    float px = 1e-2/iResolution.y;
    float d3X = render(p + vec2(px, 0));
    float d3Y = render(p + vec2(0, px));
    float dB = d3Y;

    float d = glitchBg(p);
    col = mix(col,vec3(0.35),S(d));
    
    d = render(p);
    float depth =  -.03;
    float b = (max(dB, depth) - max(d, depth))/px;
    b = max(.5 + b, 0.);
    col = mix(col,vec3(1.)*.5 + b,S(d));

    // Output to screen
    fragColor = vec4(col,1.0);
}
