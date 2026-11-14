#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define Tri(p,s,a) max(-dot(p,vec2(cos(-a),sin(-a))),max(dot(p,vec2(cos(a),sin(a))),max(abs(p).x-s.x,abs(p).y-s.y)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define Slice(p,a) dot(p,vec2(cos(a),sin(a)))
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

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

float randomDotLine(vec2 p){
    vec2 prevP = p;
    p.x+=iTime*0.08;
    vec2 gv = fract(p*20.0)-0.5;
    vec2 id = floor(p*20.0);
    
    float n = Hash21(id);
    float d = B(gv,vec2(0.25*(n*2.0),0.2));
    p = prevP;
    p.y+= 0.012;
    d = max(abs(p.y)-0.01,max(abs(p.x)-0.08,d));
    return d;
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
    
    return abs(d)-0.004;
}

float dLine(vec2 p, vec2 a, vec2 b, float w){
    vec2 v = normalize(b-a);
    vec2 right = normalize(cross(vec3(v,0.0),vec3(0.0,0.0,1.0)).xy);
    vec2 newRightVec = right*(w*0.5);
    vec2 a1 = a+newRightVec, a2 = a-newRightVec, b1 = b+newRightVec, b2 = b-newRightVec;
    vec2 mida = vec2((a1.x + b1.x) * 0.5, (a1.y + b1.y) * 0.5);
    vec2 midb = vec2((a2.x + b2.x) * 0.5, (a2.y + b2.y) * 0.5);
    
    float rad1 = -atan(b1.x-a1.x,b1.y-a1.y);
    float rad2 = -atan(a2.x-a1.x,a2.y-a1.y);
    
    float mad = Slice(p-mida,rad1);
    float mbd = Slice(p-midb,rad1);
    
    float ad = Slice(p-a,rad2);
    float bd = Slice(p-b,rad2);
    float d = max(max(mad,-mbd),max(-ad,bd));
    return d;
}

float ringItem(vec2 p, float r, float r2, float deg){
    vec2 prevP = p;
    float thickness = 0.001;
    float d = abs(length(p)-r)-thickness;
    float rad = radians(deg*iTime);
    float x = r*cos(rad)+p.x;
    float y = r*sin(rad)+p.y;
    float d2 = length(vec2(x,y))-r2;
    d = max(-d2,d);
    d = min(d,abs(d2)-thickness);
    d2 = length(p)-0.005;
    d = min(d,d2);
    d2 = length(vec2(x,y))-0.005;
    d = min(d,d2);
    return d;
}

float smallCircle(vec2 p, float r){
    float thickness = 0.001;
    float d = abs(length(p)-r)-thickness;
    float d2 = length(p)-0.005;
    d = min(d,d2);
    return d;
}

float ringCircle(vec2 p){
    vec2 prevP = p;
    float thickness = 0.0005;
    float R = 0.41;
    float R2 = 0.29;
    float r = R;
    float r2 = R2;
    float r3 = 0.465;
    float d = abs(length(p)-r)-thickness;
    
    for(float i = 0.; i<4.; i++){
        float startAngle = i*25.;
        float rad = radians(startAngle+10.*-iTime);
        float x = r*cos(rad)+p.x;
        float y = r*sin(rad)+p.y;
        float dir = (mod(i,2.) == 0.)?-1.:1.;
        float d2 = ringItem(vec2(x,y),0.055-(i*0.005),0.02-(i*0.002), (30.+(i*5.))*dir);
        d = min(d,d2);
    }
    
    float d2 = abs(length(p)-r2)-thickness;
    d = min(d,d2);
    
    float rad = radians(((3.*25.)+10.*-iTime)+sin(iTime*1.2)*-10.);
    float x = r2*cos(rad)+p.x;
    float y = r2*sin(rad)+p.y;
    d2 = smallCircle(vec2(x,y),0.02);
    d = min(d,d2);
    
    x =  r2*cos(rad);
    y =  r2*sin(rad);
    
    rad = radians((2.*25.)+10.*-iTime);

    float deg =  (30.+(2.*5.));
    float rad2 = radians(deg*-iTime);
    
    r2 = 0.055-(2.*0.005);
    float x2 = (r*cos(rad))+(r2*cos(rad2));
    float y2 = (r*sin(rad))+(r2*sin(rad2));
    
    d2 = dLine(p,vec2(-x,-y),vec2(-x2,-y2),0.001);
    d = min(d,d2);
    
    r2 = R2;
    rad = radians((10.*-iTime)+sin(iTime*1.2)*10.);
    x = r2*cos(rad)+p.x;
    y = r2*sin(rad)+p.y;
    d2 = smallCircle(vec2(x,y),0.02);
    d = min(d,d2);
    
    x =  r2*cos(rad);
    y =  r2*sin(rad);
    
    rad = radians(25.+10.*-iTime);

    deg =  35.;
    rad2 = radians(deg*iTime);
    
    r2 = 0.055-(1.*0.005);
    x2 = (r*cos(rad))+(r2*cos(rad2));
    y2 = (r*sin(rad))+(r2*sin(rad2));    
    d2 = dLine(p,vec2(-x,-y),vec2(-x2,-y2),0.001);
    d = min(d,d2);
    
    
    for(float i = 0.; i<4.; i++){
        float startAngle = i*25.;
        float rad = radians(180.+startAngle+10.*-iTime);
        float x = r*cos(rad)+p.x;
        float y = r*sin(rad)+p.y;
        float dir = (mod(i,2.) == 0.)?-1.:1.;
        float d2 = ringItem(vec2(x,y),0.055-(i*0.005),0.02-(i*0.002), (30.+(i*5.))*dir);
        d = min(d,d2);
    }
    
    r2 = R2;
    rad = radians((180.+(3.*25.)+10.*-iTime)+sin(iTime*1.3)*10.);
    x = r2*cos(rad)+p.x;
    y = r2*sin(rad)+p.y;
    d2 = smallCircle(vec2(x,y),0.02);
    d = min(d,d2);
    
    x =  r2*cos(rad);
    y =  r2*sin(rad);
    
    rad = radians(180.+(3.*25.)+10.*-iTime);

    deg = -(30.+(3.*5.));
    rad2 = radians(deg*-iTime);
    
    r2 = 0.055-(3.*0.005);
    x2 = (r*cos(rad))+(r2*cos(rad2));
    y2 = (r*sin(rad))+(r2*sin(rad2));
    
    d2 = dLine(p,vec2(-x,-y),vec2(-x2,-y2),0.001);
    d = min(d,d2);
    
    
    
    r2 = R2;
    rad = radians(180.+(10.*-iTime)+sin(iTime*1.2)*-10.);
    x = r2*cos(rad)+p.x;
    y = r2*sin(rad)+p.y;
    d2 = smallCircle(vec2(x,y),0.02);
    d = min(d,d2);
    
    x =  r2*cos(rad);
    y =  r2*sin(rad);
    
    rad = radians(180.+10.*-iTime);

    deg = -30.;
    rad2 = radians(deg*iTime);
    
    r2 = 0.055;
    x2 = (r*cos(rad))+(r2*cos(rad2));
    y2 = (r*sin(rad))+(r2*sin(rad2));    
    d2 = dLine(p,vec2(-x,-y),vec2(-x2,-y2),0.001);
    d = min(d,d2);    
    
    
    p*=Rot(radians(sin(iTime*1.5)*120.));
    d2 = abs(length(p)-r3)-0.0001;
    d2 = max(abs(p.x)-0.3,d2);
    d = min(d,d2);
    
    return d;
}

float circleRuler(vec2 p){
    p*=Rot(radians(iTime*-25.));
    vec2 prevP = p;
    float r = 0.23;
    float d = abs(length(p)-r)-0.0001;
    
    p=DF(p,5.);
    p-=vec2(0.163);
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.001,0.02));
    d = min(d,d2);
    
    p = prevP;
    p=DF(p,20.);
    p-=vec2(0.163);
    p*=Rot(radians(45.));
    d2 = B(p,vec2(0.0005,0.01));
    d = min(d,d2);
    
    return d;
}

float circleRuler2(vec2 p){
    p*=Rot(radians(45.+iTime*20.));
    vec2 prevP = p;
    float r = 0.188;
    float d = abs(length(p)-r)-0.0001;
    
    p=DF(p,5.);
    p-=vec2(0.125);
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.001,0.012));
    d = min(d,d2);
    
    p = prevP;    
    p=DF(p,10.);
    p-=vec2(0.128);
    p*=Rot(radians(45.));
    d2 = B(p,vec2(0.001,0.006));
    d = min(d,d2);

    return d;
}

float circleItem0(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(10.+sin(iTime*0.5)*-150.));
    p=DF(p,2.);
    p-=vec2(0.24);
    p*=Rot(radians(225.));
    float d = abs(Tri(p,vec2(0.015,0.015),radians(45.)))-0.0005;
    return d;
}

float circleItem1(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(-15.*iTime));
    float d = abs(length(p)-0.145)-0.007;
    float a = radians(45.);
    p.x = abs(p.x);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    p = prevP;
    float d2 = abs(length(p)-0.145)-0.0005;
    d2 = max(-d,d2);
    d = min(abs(d)-0.0005,d2);
    return d;
}

float centerNumber(vec2 p){
    vec2 prevP = p;
    p*=2.7;
    p*=SkewX(-0.4);
    float d = drawFont(p-vec2(-0.09,0.0),int(mod(iTime*4.,10.)));
    float d2 = drawFont(p-vec2(0.09,0.0),int(mod(iTime*8.,10.)));
    d = min(d,d2);
    p = prevP;
    d2 = abs(B(p,vec2(0.095,0.06)))-0.0005;
    d2 = max(-(abs(p.x)-0.085),d2);
    d2 = max(-(abs(p.y)-0.05),d2);
    d = min(d,d2);
    return d;
}

float centerCircleUI(vec2 p){
    vec2 prevP = p;
    float d = ringCircle(p);
    float d2 = circleRuler(p);
    d = min(d,d2);
    d2 = circleRuler2(p);
    d = min(d,d2);
    d2 = circleItem0(p);
    d = min(d,d2);
    d2 = circleItem1(p);
    d = min(d,d2);
    d2 = centerNumber(p);
    d = min(d,d2);
    return d;
}

float sideUIItem0Base(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.17,0.025));
    p.x-=0.01;
    p.y-=0.02;
    float d2 = B(p,vec2(0.08,0.02));
    float a = radians(-60.);
    p.x = abs(p.x)-0.07;
    d2 = max((dot(p,vec2(cos(a),sin(a)))),d2);
    d = max(-d2,d);
    
    p = prevP;
    a = radians(240.);
    p.x+=0.12;
    d = max((dot(p,vec2(cos(a),sin(a)))),d);
    return d;
}

float sideUIItem0(vec2 p){
    p*=1.1;
    p.x*=-1.;
    vec2 prevP = p;
    p.x+=0.08;
    p.y-=0.08;
    float d = sideUIItem0Base(p);
    p = prevP;
    p.x*=-1.;
    p.x+=0.08;
    p.y+=0.08;
    p*=Rot(radians(-90.));
    float d2= sideUIItem0Base(p);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(45.);
    p.x-=0.14;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    p = prevP;
    p-=vec2(0.05,0.05);
    p*=Rot(radians(-45.));
    d2 = B(p,vec2(0.02,0.04));
    d = abs(min(d,d2))-0.0005;
    
    p = prevP;
    p-=vec2(0.052,0.052);
    p*=Rot(radians(-45.));
    d2 = B(p,vec2(0.0005,0.04));
    d = min(d,d2);
    
    p = prevP;
    d2 = randomDotLine(p-vec2(-0.07,0.055));
    d = min(d,d2);
    d2 = B(p-vec2(-0.065,0.037),vec2(0.075,0.0001));
    d = min(d,d2);
    
    return d;
}

float sideUIItem1(vec2 p){
    p*=1.1;
    vec2 prevP = p;
    float d = B(p,vec2(0.003,0.36));
    p.x+=0.027;
    p.y = abs(p.y)-0.36;
    float d2 = B(p,vec2(0.03,0.003));
    d = min(d,d2);
    
    float speed = -0.1;
    
    p = prevP;
    p.y += iTime*speed;
    p.x+=0.015;
    p.y = mod(p.y,0.02)-0.01;
    d2 = B(p,vec2(0.01,0.0005));
    p = prevP;
    d2 = max(abs(p.y)-0.36,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y += iTime*speed;
    p.x+=0.025;
    p.y = mod(p.y,0.06)-0.03;
    d2 = B(p,vec2(0.015,0.001));
    p = prevP;
    d2 = max(abs(p.y)-0.36,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.06;
    p.y+=sin(iTime*0.5)*0.3;
    p*=Rot(radians(90.));
    d2 = abs(Tri(p,vec2(0.015),radians(45.)))-0.0005;
    d = min(d,d2);
    return d;
}

float graphItem(vec2 p, float speed, float start, float h){
    vec2 prevP;
    float endTime = 5.;
    float dist = h-start;
    float t = mod(iTime*speed,endTime);
    float animVal = endTime*0.5;
    float val = t/animVal;
    if(t<endTime*0.5){
        val=(t/animVal)*dist;
    } else {
        val=(1.-((t-animVal)/animVal))*dist;
    }
    
    float w = 0.013;
    float h2 = start+val;
    float d = B(p-vec2(0.,val),vec2(w,h2));
    float d2 = abs(B(p-vec2(0.,dist),vec2(0.022,h+start+0.005)))-0.0001;
    d2 = max(-(abs(p.x)-(w-0.002)),d2);
    d2 = max(-(abs(p.y-dist)-h),d2);
    d = min(d,d2);
    return d;
}

float graphUI(vec2 p){
    float d = graphItem(p,2.5,0.01,0.1);
    float d2 = graphItem(p-vec2(0.055,0.),2.,0.01,0.1);
    d = min(d,d2);
    d2 = graphItem(p-vec2(-0.055,0.),2.7,0.01,0.1);
    d = min(d,d2);
    return d;
}

float meterUI(vec2 p){
    vec2 prevP = p;
    float d = abs(length(p)-0.06)-0.0001;
    
    p=DF(p,4.);
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.005,0.2));
    d = max(-d2,d);
    
    p = prevP;
    p*=Rot(radians(sin(iTime*0.5)*190.));
    p.x = abs(p.x)-0.085;
    p*=Rot(radians(90.));
    
    d2 = abs(Tri(p,vec2(0.015,0.015),radians(45.)))-0.0005;
    d = min(d,d2);
    
    p = prevP;
    d2 = B(p,vec2(0.0002,0.04));
    d = min(d,d2);
    d2 = B(p,vec2(0.04,0.0002));
    d = min(d,d2);
    
    p*=Rot(radians(45.));
    d =max(-B(p,vec2(0.02)),d);
    d2 = abs(B(p,vec2(0.01)))-0.00001;
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(iTime*-30.));
    d2 = B(p-vec2(0,0.025),vec2(0.0002,0.025));
    d = min(d,d2);
    
    return d;
}

float sideUIItem2(vec2 p){
    p*= Rot(radians(45.));
    vec2 prevP = p;
    float d = abs(B(p,vec2(0.06)))-0.0001;
    float d2 = abs(B(p,vec2(0.06)))-0.002;
    p*=Rot(radians(20.*iTime));
    float mask = min(abs(p.x)-0.03,abs(p.y)-0.03);
    d2 = max(-mask,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(B(p,vec2(0.04)))-0.0001;
    d = min(d,d2);
    d2 = abs(B(p,vec2(0.04)))-0.002;
    p*=Rot(radians(-25.*iTime));
    mask = min(abs(p.x)-0.015,abs(p.y)-0.015);
    d2 = max(-mask,d2);
    d = min(d,d2);
    
    p = prevP;
    p*=1.+sin(iTime*5.)*0.1;
    d2 = abs(B(p,vec2(0.015)))-0.0001;
    mask = min(abs(p.x)-0.005,abs(p.y)-0.005);
    d2 = max(-mask,d2);
    d = min(d,d2);
    
    return d;
}

float sliderItem(vec2 p, float speed){
    vec2 prevP = p;
    float d = abs(B(p,vec2(0.02,0.1)))-0.0001;
    d = max(-(abs(p.y)-0.09),d);
    float d2 = B(p,vec2(0.0001,0.09));
    d = min(d,d2);
    p.y = mod(p.y,0.02)-0.01;
    d2 = B(p,vec2(0.005,0.001));
    p = prevP;
    d2 = max((abs(p.y)-0.08),d2);
    d = min(d,d2);
    p.y+=sin(iTime*speed)*0.08;
    d2 = B(p,vec2(0.018,0.005));
    d = min(d,d2);
    
    p.x = abs(p.x)-0.025;
    p*=Rot(radians(-90.));
    d2 = abs(Tri(p,vec2(0.013,0.013),radians(45.)))-0.0005;
    d = min(d,d2);        
    
    return d;
}

float sideUIItem3(vec2 p){
    vec2 prevP = p;
    float d = sliderItem(p-vec2(-0.045,0.),1.);
    float d2 = sliderItem(p-vec2(0.045,0.),1.5);
    d = min(d,d2);
    return d;
}

float smallCircleItem(vec2 p, float speed){
    vec2 prevP = p;
    p*=Rot(radians(20.*iTime*speed));
    float d = abs(length(p)-0.029)-0.01;
    p=DF(p,2.);
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.005,0.2));
    d = max(-d2,d);
    d2 = length(p)-0.005;
    d = min(d,d2);
    return d;
}

float sideUIItem4(vec2 p){
    vec2 prevP = p;
    float d = smallCircleItem(p-vec2(-0.045,0.),1.);
    float d2 = smallCircleItem(p-vec2(0.045,0.),-2.);
    d = min(d,d2);
    return d;
}

float sideUIItem5(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(-25.*iTime));
    p=DF(p,5.);
    p-=vec2(0.04);
    p*=Rot(radians(45.));
    
    float d = B(p,vec2(0.001,0.01));
    
    float speed = 2.;
    p = prevP;
    p*=Rot(radians(25.*iTime*speed));
    float d2 = abs(length(p)-0.08)-0.005;
    
    float a = radians(45.);
    p.x = abs(p.x);
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(25.*iTime*speed));
    d2 = abs(length(p)-0.08)-0.005;
    
    a = radians(-45.);
    p.x = abs(p.x);
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(sin(iTime*2.)*45.));
    d2 = B(p,vec2(0.03,0.001));
    d = min(d,d2);
    d2 = B(p,vec2(0.001,0.03));
    d = min(d,d2);
    d = max(-B(p,vec2(0.015)),d);
    d2 = length(p)-0.005;
    d = min(d,d2);
    
    return d;
}

float triangle2(vec2 p, vec2 s, float thick){
    float d = B(p, s);
    float a = radians(225.);
    d = abs(max(dot(p,vec2(cos(a),sin(a))),d))-thick;
    return d;
}

float sideUIItem6(vec2 p){
    vec2 prevP = p;
    float d = triangle2(p,vec2(0.08),0.0005);
    float d2 = triangle2(p,vec2(0.08),0.003);
    p*=Rot(radians(-25.*iTime));
    d2 = max(-min(abs(p.x)-0.03,abs(p.y)-0.03),d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = triangle2(p-vec2(0.018),vec2(0.035),0.0005);
    d = min(d,d2);
    d2 = triangle2(p-vec2(0.018),vec2(0.035),0.003);
    p-=vec2(0.018);
    p*=Rot(radians(25.*iTime));
    d2 = max(-min(abs(p.x)-0.015,abs(p.y)-0.015),d2);
    d = min(d,d2);
    
    return d;
}

float plus(vec2 p, float speed){
    p*=Rot(radians(10.*iTime*speed));
    float d = B(p,vec2(0.0001,0.01));
    float d2 = B(p,vec2(0.01,0.0001));
    d = min(d,d2);
    return d;
}

float sideAreaUI(vec2 p){
    vec2 prevP = p;
    p.x = abs(p.x)-0.57;
    p.y = abs(p.y)-0.35;
    float d = sideUIItem0(p);
    p = prevP;
    p.x = abs(p.x)-0.79;
    float d2 = sideUIItem1(p);
    d = min(d,d2);
    p = prevP;
    d2 = graphUI(p-vec2(0.625,0.125));
    d = min(d,d2);
    d2 = meterUI(p-vec2(-0.62,0.23));
    d = min(d,d2);
    d2 = sideUIItem2(p-vec2(-0.62,0.));
    d = min(d,d2);
    d2 = sideUIItem3(p-vec2(-0.62,-0.25));
    d = min(d,d2);
    d2 = sideUIItem4(p-vec2(0.62,0.));
    d = min(d,d2);
    d2 = sideUIItem5(p-vec2(0.62,-0.22));
    d = min(d,d2);
    
    p.x = abs(p.x)-0.37;
    p.y = abs(p.y)-0.36;
    d2 = sideUIItem6(p);
    d = min(d,d2);
    
    p = prevP;
    p-=vec2(-0.62,0.);
    p.x = abs(p.x)-0.08;
    p.y = abs(p.y)-0.1;
    d2 = plus(p,5.);
    d = min(d,d2);
    
    p = prevP;
    p-=vec2(0.62,-0.22);
    p.x = abs(p.x)-0.07;
    p.y = abs(p.y)-0.11;
    d2 = plus(p,-8.);
    d = min(d,d2);
    
    return d;
}

float bg(vec2 p){
    p = mod(p,0.04)-0.02;
    float d = abs(p.x)-0.0001;
    float d2 = abs(p.y)-0.0001;
    d = min(d,d2);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;

    vec3 col = vec3(0.);
    float d = centerCircleUI(p);
    float d2 = sideAreaUI(p);
    d = min(d,d2);
    
    float bgd = bg(p);
    col = mix(col,vec3(0.03),S(bgd,0.0));
    col = mix(col,vec3(1.),S(d,0.0));

    fragColor = vec4(sqrt(col),1.0);
}
