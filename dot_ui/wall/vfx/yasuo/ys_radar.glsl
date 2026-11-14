#define MAX_STEPS 4
#define MAX_DIST 4.
#define SURF_DIST .0005
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b,kw) smoothstep(kw*antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define ZERO (min(iFrame,0))
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define SkewY(a) mat2(1.0,0.0,tan(a),1.0)
#define seg_0 0
#define seg_1 1
#define seg_2 2
#define seg_3 3
#define seg_4 4
#define seg_5 5
#define seg_6 6
#define seg_7 7
#define seg_8 8
#define seg_9 9
#define POST_EFFECT 0

float rand (vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float segBase(vec2 p){
    vec2 prevP = p;
    
    float size = 0.02;
    float padding = 0.05;

    float w = padding*3.0;
    float h = padding*5.0;

    p = mod(p,0.05)-0.025;
    float thickness = 0.005;
    float gridMask = min(abs(p.x)-thickness,abs(p.y)-thickness);
    
    p = prevP;
    float d = B(p,vec2(w*0.5,h*0.5));
    float a = radians(40.0);
    p.x = abs(p.x)-0.1;
    p.y = abs(p.y)-0.05;
    float d2 = dot(p,vec2(cos(a),sin(a)));
    //d = max(d2,d);
    //d = max(-gridMask,d);
    return d;
}

float seg0(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    float mask = B(p,vec2(size,size*2.7));
    d = max(-mask,d);
    return d;
}

float seg1(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x+=size;
    p.y+=size;
    float mask = B(p,vec2(size*2.,size*3.7));
    d = max(-mask,d);
    
    p = prevP;
    
    p.x+=size*1.9;
    p.y-=size*3.2;
    mask = B(p,vec2(size,size+0.01));
    d = max(-mask,d);
    
    return d;
}

float seg2(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x+=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.x-=size;
    p.y+=0.05;
    mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);
    
    return d;
}

float seg3(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.y = abs(p.y);
    p.x+=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.x+=0.06;
    mask = B(p,vec2(size,size+0.01));
    d = max(-mask,d);
    
    return d;
}

float seg4(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    
    p.x+=size;
    p.y+=0.08;
    float mask = B(p,vec2(size*2.,size*2.0));
    d = max(-mask,d);

    p = prevP;
    
    p.y-=0.08;
    mask = B(p,vec2(size,size*2.0));
    d = max(-mask,d);
    
    return d;
}

float seg5(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x-=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.x+=size;
    p.y+=0.05;
    mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);
    
    return d;
}

float seg6(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x-=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.y+=0.05;
    mask = B(p,vec2(size,size));
    d = max(-mask,d);
    
    return d;
}

float seg7(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x+=size;
    p.y+=size;
    float mask = B(p,vec2(size*2.,size*3.7));
    d = max(-mask,d);
    return d;
}

float seg8(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.y = abs(p.y);
    p.y-=0.05;
    float mask = B(p,vec2(size,size));
    d = max(-mask,d);
    
    return d;
}

float seg9(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.y-=0.05;
    float mask = B(p,vec2(size,size));
    d = max(-mask,d);

    p = prevP;
    p.x+=size;
    p.y+=0.05;
    mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);
    
    return d;
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float drawFont(vec2 p, int char){
    p.y*=-1.;
    float d = seg0(p)*checkChar(seg_0,char);
    d += seg1(p)*checkChar(seg_1,char);
    d += seg2(p)*checkChar(seg_2,char);
    d += seg3(p)*checkChar(seg_3,char);
    d += seg4(p)*checkChar(seg_4,char);
    d += seg5(p)*checkChar(seg_5,char);
    d += seg6(p)*checkChar(seg_6,char);
    d += seg7(p)*checkChar(seg_7,char);
    d += seg8(p)*checkChar(seg_8,char);
    d += seg9(p)*checkChar(seg_9,char);
    
    return d;
}

vec2 GetDist(vec3 p) {
    vec3 prevP = p;
    float d = length(p.xz)-1.;
    d = max((abs(p.y)-0.6),d);
    return vec2(d,0);
}

vec2 RayMarch(vec3 ro, vec3 rd, float side, int stepnum) {
    vec2 dO = vec2(0.0);
    
    for(int i=0; i<stepnum; i++) {
        vec3 p = ro + rd*dO.x;
        vec2 dS = GetDist(p);
        dO.x += dS.x*side;
        dO.y = dS.y;
        
        if(dO.x>MAX_DIST || abs(dS.x)<SURF_DIST) break;
    }
    
    return dO;
}

vec3 GetNormal(vec3 p) {
    float d = GetDist(p).x;
    vec2 e = vec2(.001, 0);
    
    vec3 n = d - vec3(
        GetDist(p-e.xyy).x,
        GetDist(p-e.yxy).x,
        GetDist(p-e.yyx).x);
    
    return normalize(n*-1.);
}

vec3 R(vec2 uv, vec3 p, vec3 l, float z) {
    vec3 f = normalize(l-p),
        r = normalize(cross(vec3(0,1,0), f)),
        u = cross(f,r),
        c = p+f*z,
        i = c + uv.x*r + uv.y*u,
        d = normalize(i-p);
    return d;
}

float bgItem0(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.05,0.005));
    
    float a = radians(-45.);
    p.x-=0.005;
    p.x = abs(p.x)-0.023;
    p.y-=0.012;
    float mask = B(p,vec2(0.02,0.01));
    p.x = abs(p.x)-0.01;
    p.y+=0.01;
    mask = max(dot(p,vec2(cos(a),sin(a))),mask);
    
    d = max(-mask,d);
    
    p = prevP;
    a = radians(45.);
    p.x+=0.005;
    p.x = abs(p.x)-0.023;
    p.y+=0.012;
    mask = B(p,vec2(0.02,0.01));
    p.x = abs(p.x)-0.01;
    p.y-=0.01;
    mask = max(dot(p,vec2(cos(a),sin(a))),mask);
    
    d = max(-mask,d);
    return d;
}

vec3 background(vec2 p, vec3 col, float w){
    vec2 prevP = p;

    p.x += mix(0.,-0.017,step(0.03,mod( p.y,0.06)));
    p.x += iTime*0.01*mix(1.,-1.,step(0.03,mod( p.y,0.06)));
    
    p.x = mod(p.x,0.034)-0.017;
    p.y = mod(p.y,0.03)-0.015;
    
    p*=Rot(radians(45.));
    p = DF(p,1.);
    p-=0.007;
    p*=Rot(radians(45.));
    float d = B(p,vec2(0.0001,0.007));
    
    p = prevP;
    p.y+=0.015;
    p.y = mod(p.y,0.03)-0.015;
    float d2 = abs(p.y)-0.0001;
    d = min(d,d2);
    
    col = mix(col,vec3(0.05),S(d,-0.0003,w));
    
    p = prevP;
    p.x += iTime*0.02*mix(1.,-1.,step(0.04,p.y));
    p.x = mod(p.x,0.1)-0.05;
    p.y =abs(p.y)-0.082;
    d = bgItem0(p);

    col += mix(col,vec3(0.1),S(d,0.0,w));
    
    return col;
}

float waveCircle(vec2 p, float s, float numW, float amp, float deg, float thickness){
    float r = s+amp*cos(atan(p.y,p.x)*numW);
    float d = abs(length(p)-r)-thickness;    
    p*=Rot(radians(deg));
    r = s+amp*cos(atan(p.y,p.x)*numW);
    float d2 = abs(length(p)-r)-thickness;  
    d = min(d,d2);    
    return d;
}

float grid(vec2 p){
    p = mod(p,0.004)-0.0002;
    float d = min(abs(p.x)-0.00001,abs(p.y)-0.00001);
    return d;
}

vec3 radar(vec2 p,vec3 col, float w){
    vec2 prevP = p;
    p*=Rot(radians(-25.0*iTime));
    float a = -atan(p.x,p.y);
    float d = length(p)-0.05;
    
    col = mix(col,vec3(1.)*a*0.01,S(d,0.0,w));
    
    d = length(p)-0.05;
    a = radians(2.);
    p.x = abs(p.x);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    p = prevP;
    p*=Rot(radians(-25.0*iTime));
    d = max(p.y,d);
    col = mix(col,vec3(0.2),S(d,0.0,w));
    
    return col;
}

vec3 centerUiItem(vec2 p, vec3 col, float w){
    vec2 prevP = p;
    p*=Rot(radians(20.*iTime*0.3));
    float d = waveCircle(p,0.082,12.,0.003,16.,0.00001);
    col = mix(col,vec3(1.),S(d,-0.0002,w));
    
    p = prevP;
    p*=Rot(radians(-20.*iTime*0.4));
    d = abs(length(p)-0.0645)-0.00001;
    p = DF(p,30.);
    p-=0.047;
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.0001,0.0017)); 
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(-20.*iTime*0.4));
    d2 = abs(length(p)-0.0665)-0.00001;
    d = min(d,d2);

    p = DF(p,10.);
    p-=0.048;
    p*=Rot(radians(45.));    
    d2 = B(p,vec2(0.0001,0.0027)); 
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(-20.*iTime*0.4));
    p = DF(p,5.);
    p-=0.045;
    p*=Rot(radians(45.)); 
    d2 = B(p,vec2(0.0025,0.001)); 
    d = min(d,d2);    
    
    p = prevP;
    p*=Rot(radians(30.*iTime*0.5));
    d2 = abs(length(p)-0.05)-0.00001;
    d = min(d,d2);  
    p = DF(p,5.);
    p-=0.037;
    p*=Rot(radians(45.)); 
    d2 = B(p,vec2(0.0002,0.0023)); 
    d = min(d,d2);   
    
    p = prevP;
    p*=Rot(radians(30.*iTime*0.5));
    p = DF(p,20.);
    p-=0.0365;
    p*=Rot(radians(45.)); 
    d2 = B(p,vec2(0.0002,0.0013)); 
    d = min(d,d2);       
    
    col = mix(col,vec3(1.),S(d,-0.0002,w));
    
    
    p = prevP;
    d = max(length(p)-0.048,grid(p));
    col = mix(col,vec3(0.05),S(d,0.0,w));    
    
    
    p = prevP;
    d = abs(length(p)-0.01)-0.00001;
    d2 = abs(length(p)-0.023)-0.00001;
    d = min(d,d2);  
    d2 = abs(length(p)-0.035)-0.00001;
    d = min(d,d2); 
    
    p = DF(p,2.);
    p-=0.021;
    p*=Rot(radians(45.)); 
    d2 = B(p,vec2(0.0001,0.0195)); 
    d = min(d,d2);   
    
    col = mix(col,vec3(0.7),S(d,-0.0005,w));
    
    p = prevP;
    p.y-= iTime*0.01;
    p*=60.;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    vec2 prevGr = gr;
    float r = rand(id);
    
    d = length(gr-vec2(sin(r*5.)*0.25))-0.15*sin(r*(iTime+1.)*1.5);
    d = max(length(prevP)-0.05,d);
    col = mix(col,vec3(0.5),S(d,0.0,w));
    
    p = prevP;
    p*=Rot(radians(45.+sin(iTime*0.3)*270.));
    p.y = abs(p.y)-0.057;
    p.y*=-1.;
    d = Tri(p,vec2(0.002));
    col = mix(col,vec3(0.5),S(d,0.0,w));
    
    p = prevP;
    p = DF(p,30.);
    p-=0.053;
    d = length(p)-0.0003;
    col = mix(col,vec3(0.2),S(d,0.0,w));    
    
    p = prevP;
    p*=Rot(radians(-45.-sin(iTime*0.2)*180.));
    p.y = abs(p.y)-0.073;
    p.y*=-1.;
    d = Tri(p,vec2(0.002));
    col = mix(col,vec3(0.5),S(d,0.0,w));    

    return col;
}

vec3 arrowItem(vec2 p, vec3 col, float w){
    vec2 prevP = p;
    
    p.x = abs(p.x);
    p.x+=0.0035;
    p.x+=iTime*0.02;
    p.x = mod(p.x,0.018)-0.009;
    p.x+=0.008;
    p*=Rot(radians(-90.));
    p.y*=0.75;
    float d = Tri(p,vec2(0.01));
    p.y+=0.005;
    d = abs(max(-Tri(p,vec2(0.01)),d))-0.00005;

    p = prevP;
    d = max(abs(p.x)-0.138,d);
    d = max(-(length(p)-0.085),d);

    col = mix(col,vec3(0.5),S(d,0.0,w));  
    return col;
}

vec3 rightTopItem(vec2 p, vec3 col, float w){
    vec2 prevP = p;
    p = DF(p,2.);
    p-=0.01;
    float d = B(p,vec2(0.001)); 
    
    p = prevP;
    
    p*=Rot(radians(20.));
    p = DF(p,2.);
    p-=0.005+sin(iTime)*0.002+0.001;
    
    float d2 = B(p,vec2(0.001)); 
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(45.+230.*sin(iTime*1.2)));
    d2 = abs(length(p)-0.02)-0.00001;
    d2 = max(abs(p.x)-0.01,d2);       
    d = min(d,d2);
    
    col = mix(col,vec3(0.5),S(d,0.0,w));
    
    return col;
}

vec3 rightBottomItem(vec2 p, vec3 col, float w){
    vec2 prevP = p;
    p*=20.;
    p*=SkewX(0.4);
    float d = drawFont(p-vec2(-0.09,0.0),int(mod(iTime*4.,10.)));
    float d2 = drawFont(p-vec2(0.09,0.0),int(mod(iTime*8.,10.)));
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(45.)+radians(-30.*iTime*0.5));
    p = DF(p,4.);
    p-=0.015;
    p*=Rot(radians(45.)); 
    d2 =abs( length(prevP)-0.021)-0.003;
    d2 = max(-B(p,vec2(0.0015,0.01)),d2);
   
    p = prevP;
    p*=Rot(radians(45.)+radians(-30.*iTime*0.5));
    float a = radians(70.);
    p.x = abs(p.x);
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);   
    
    p = prevP;
    p*=Rot(radians(20.*iTime*1.2));
    d2 = abs(length(p)-0.015)-0.00001;
    p = DF(p,0.75);
    p-=0.015;
    p*=Rot(radians(45.)); 
    d2 = max(-B(p,vec2(0.003,0.01)),d2);
    
    d = min(d,d2); 
    col = mix(col,vec3(0.5),S(d,0.0,w));  
    return col;
}

vec3 leftTopItem(vec2 p, vec3 col, float w){
    vec2 prevP = p;
    p.x+=iTime*0.01;
    p.y-=0.0002;
    p*=144.;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    vec2 prevGr = gr;
    float r = rand(id);

    float d = B(gr,vec2(sin(r+3.*iTime*r)*r*0.4));
    float mask = B(prevP,vec2(0.023,0.014));
    d = max(mask,d);

    gr-=0.5;
    float d2 = min(abs(gr.x)-0.06,abs(gr.y)-0.06);
    d2 = max(mask,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = abs( B(p,vec2(0.025,0.016)))-0.00001;
    d2 = max(-(abs(p.x)-0.023),d2);
    d2 = max(-(abs(p.y)-0.012),d2);
    d = min(d,d2);
    
    col = mix(col,vec3(0.5),S(d,0.0,w));  
    return col;
}

vec3 graphBar(vec2 p, vec3 col, float w, float speed, float start){
    vec2 prevP = p;
    float endTime = 5.;
    float dist = 0.02;
    float t = mod(start+iTime*speed,endTime);
    float animVal = endTime*0.5;
    float val = t/animVal;
    if(t<endTime*0.5){
        val=(t/animVal)*dist;
    } else {
        val=(1.-((t-animVal)/animVal))*dist;
    }
    
    p.x+=0.021;
    float d = B(p-vec2(dist,0.0),vec2(dist,0.002));
    
    col = mix(col,vec3(0.25),S(d,0.0,w));  
    d = B(p-vec2(dist-val,0.0),vec2(dist-val,0.002));
    
    p = prevP;
    p.x+=0.001;
    float d2 = abs(B(p,vec2(dist+0.002,0.004)))-0.00001;
    d2 = max(-(abs(p.x)-dist-0.001),d2);
    d2 = max(-(abs(p.y)-0.003),d2);
    d = min(d,d2);
    col = mix(col,vec3(0.5),S(d,0.0,w));
    return col;
}

vec3 leftBottomItem(vec2 p, vec3 col, float w){
    vec2 prevP = p;

    col = graphBar(p,col,w,2.,1.);
    col = graphBar(p-vec2(0.,0.012),col,w,2.1,1.5);
    col = graphBar(p-vec2(0.,-0.012),col,w,2.2,2.);
    
    return col;
}

vec3 graphic1(vec2 p, vec3 col, float w){
    vec2 prevP = p;
    p.x = abs(p.x)-0.11;
    p.y = abs(p.y)-0.08;
    float d = B(p,vec2(0.0205,0.00001));
    p.x+=0.031;
    p.y+=0.006;
    p*=Rot(radians(-30.));
    float d2 = B(p,vec2(0.012,0.00001));
    d = min(d,d2);
    
    p.x+=0.012;
    p.y+=0.06;
    p*=Rot(radians(25.));
    d2 = B(p,vec2(0.012,0.00001));
    p.x-=0.007;
    d2 = max(-(abs(p.x)-0.002),d2);
    d = min(d,d2);    
    
    p = prevP;
    p.x = abs(p.x)-0.13;
    p.y = abs(p.y)-0.02;
    p.y = abs(p.y)-0.003;
    d2 = B(p,vec2(0.0001));
    d = min(d,d2);  
    
    p = prevP;
    p.x = abs(p.x)-0.06;
    p.y = abs(p.y)-0.077;
    p*=Rot(radians(45.));
    d2 = B(p,vec2(0.0008));
    d = min(d,d2);  
    d2 = abs(B(p,vec2(0.0026)))-0.0001;
    d = min(d,d2);  
    
    col = mix(col,vec3(1.1),S(d,0.0,w));
    
    
    return col;
}

vec3 mainUi(vec2 p, vec3 col, float w){
    vec2 prevP = p;
   
    float d = B(p,vec2(0.14,0.09));
    col = mix(col,vec3(0.02),S(d,0.0,w));
    
    col = graphic1(p,col,w);
    col = arrowItem(p,col,w);
    col = radar(p,col,w);
    col = centerUiItem(p,col,w);
    col = leftTopItem(p-vec2(-0.108,-0.053),col,w);
    col = leftBottomItem(p-vec2(-0.108,0.049),col,w);
    col = rightTopItem(p-vec2(0.105,-0.049),col,w);
    col = rightBottomItem(p-vec2(0.105,0.049),col,w);
    
    return col;
}

vec3 materials(int mat, vec3 n, vec3 rd, vec3 p, vec3 col, float w){
    col = vec3(0.);
    vec2 uv = vec2(1.572*atan(p.x,p.z)/6.2832,p.y/4.);
    col = background(uv,col,w);
    col += mainUi(uv,col,w);
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec2 m =  iMouse.xy/iResolution.xy;
    
    vec3 ro = vec3(0, 0, -0.01);
    ro.xz *= Rot(radians(180.0));
    
    vec3 rd = R(uv, ro, vec3(0,0.0,0), 1.3);
    vec2 d = RayMarch(ro, rd, 1.,MAX_STEPS);
    vec3 col = vec3(.0);
    
    if(d.x<MAX_DIST) {
        vec3 p = ro + rd * d.x;
        vec3 n = GetNormal(p);
        int mat = int(d.y);
        col = materials(mat,n,rd,p,col,0.5/abs(dot(rd,p)) );
    } else {
        col = vec3(0.0);
    }
    
    #if POST_EFFECT
    // grabbed the Shane's effect from comment. Thank you so much! Much improved!
    float falloff = smoothstep(.35, .85, length(fragCoord/iResolution.xy - .5));
    col *= mix(vec3(1, 2, 4), vec3(1, 4, 2), falloff);
    #endif
    
    fragColor = vec4(sqrt(col),1.0);
}
