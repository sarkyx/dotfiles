#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
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

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
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
    p.x = abs(p.x)-0.11;
    p.y = abs(p.y)-0.06;
    float d2 = dot(p,vec2(cos(a),sin(a)));
    d = max(d2,d);
    d = max(-(abs(prevP.x)-0.01),d);
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
    p.y*=1.05;
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

float charX(vec2 p, float t){
    vec2 prevP = p;
    
    p = abs(p)-0.1;
    p.x*=-1.;
    float a = radians(45.);
    float thick = t;
    float d = dot(p-vec2(thick,0.0),vec2(cos(a),sin(a)));
    float d2 = dot(p-vec2(-thick,0.0),vec2(cos(a),sin(a)));
    d = max(-d2,d);
    
    d = max(abs(prevP.y)-0.1,d);
    return d;
}

float graphicItem0(vec2 p, int outline){
    vec2 prevP = p;
    p.y*=0.85;
    p.x+=iTime*0.2;
    p.x = mod(p.x,0.22)-0.11;
    float d = charX(p,0.04);
    
    if(outline == 1){
	d = abs(d)-0.002;
    }
    
    return d;
}

float graphicItem1_0(vec2 p){
    vec2 prevP = p;
    float d = charX(p,0.03);
    p.x = abs(p.x)-0.1;
    p.y = abs(p.y)-0.08;
    float d2 = B(p,vec2(0.03,0.02));
    d = min(d,d2);
    
    p = prevP;
    p.y = abs(p.y)-0.06;
    p.y*=-1.;
    d2 = Tri(p,vec2(0.04));
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.11;
    p.y-=0.02;
    p*=Rot(radians(45.));
    d2 = B(p,vec2(0.02,0.05));
    p = prevP;
    d2 = max(p.y-0.04,d2);
    d2 = max(abs(p.x)-0.13,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.105;
    p.y+=0.05;
    p*=Rot(radians(-90.));
    d2 = Tri(p,vec2(0.025));
    d = min(d,d2);
    
    return d;
}

float graphicItem1_1(vec2 p){
    vec2 prevP = p;
    p.x+=0.03;
    p*=Rot(radians(90.));
    float d = Tri(p,vec2(0.1));
    p.y+=0.05;
    float d2 = Tri(p,vec2(0.1));
    d = max(-d2,d);
    
    p = prevP;
    p.x+=0.11;
    p*=Rot(radians(90.));
    d2 = Tri(p,vec2(0.02));
    d = min(d,d2);
    
    p = prevP;
    p.y-=0.08;
    d2 = B(p,vec2(0.13,0.02));
    float a = radians(45.);
    p.x +=0.08;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.028;
    p*=Rot(radians(-45.));
    d2 = B(p,vec2(0.02,0.17));
    d2 = max(prevP.y-0.04,d2);
    d2 = max(-(prevP.y+0.1),d2);
    d2 = max(prevP.x-0.13,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y*=-1.;
    p.x-=0.13;
    p.y-=0.045;
    d2 = Tri(p,vec2(0.085));
    d2 = max(prevP.x-0.13,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.015;
    p.y+=0.015;
    d2 = Tri(p,vec2(0.085));
    p.y+=0.05;
    d2 = max(-Tri(p,vec2(0.085)),d2);
    d = min(d,d2);
    
    return d;
}

float graphicItem1_2(vec2 p){
    vec2 prevP = p;
    
    float a = radians(-45.);
    float thick = 0.03;
    float d = dot(p-vec2(thick,0.0),vec2(cos(a),sin(a)));
    float d2 = dot(p-vec2(-thick,0.0),vec2(cos(a),sin(a)));
    d = max(-d2,d);
    d = max(abs(prevP.y)-0.1,d);
    p = prevP;
    p.y-=0.08;
    d2 = B(p,vec2(0.13,0.02));
    d2 = max(dot(p-vec2(0.1,0.0),vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.1;
    p.y+=0.08;
    d2 = B(p,vec2(0.03,0.02));
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.09;
    d2 = dot(p-vec2(thick,0.0),vec2(cos(a),sin(a)));
    float d3 = dot(p-vec2(-thick,0.0),vec2(cos(a),sin(a)));
    d2 = max(-d3,d2);
    d2 = max(abs(prevP.y)-0.1,d2);
    d2 = max(prevP.x-0.13,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.13;
    p.y+=0.02;
    d2 = Tri(p,vec2(0.08));
    d2 = max(prevP.x-0.13,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = B(p,vec2(0.13,0.04));
    d2 = max(dot(p-vec2(-0.06,0.0),vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    
    return d;
}

float graphicItem1(vec2 p, int outline){
    vec2 prevP = p;
    p.x-=iTime*0.3+0.5;
    p*=3.;
    p.y+=0.5;
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);
    float n = random(id);
    
    float sc = 0.28;
    gv*=sc;
    vec2 prevGV = gv;
    float d = 10.;
    if(n<0.2){
	d = graphicItem1_1(gv);
    } else if(n>=0.2 && n<0.4){
	gv.x*=-1.;
	d = graphicItem1_1(gv);
    } else if(n>=0.4 && n<0.6){
	d = graphicItem1_0(gv);
    } else if(n>=0.6 && n<0.8){
	d = graphicItem1_2(gv);
    } else if(n>=0.8 && n<=1.0){
	gv.x*=-1.;
	d = graphicItem1_2(gv);
    }
    
    float a = radians(45.);
    gv = abs(gv)-vec2(0.15,0.06);
    d = max(dot(gv,vec2(cos(a),sin(a))),d);
    
    if(outline == 1){
	d = abs(d)-0.002;
    }
    gv = prevGV;
    d = max(abs(gv.x)-0.135,d);
    d = max(abs(prevP.y)-0.12,d);
    return d;
}

float graphicItem2_0(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.02,0.13));
    
    float a = radians(-50.);
    p.x -=0.02;
    p.y-=0.05;
    float d2 = B(p,vec2(0.02,0.04));
    p.y = abs(p.y)-0.04;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    
    a = radians(50.);
    p = prevP;
    p.x +=0.02;
    p.y+=0.05;
    d2 = B(p,vec2(0.02,0.04));
    p.y = abs(p.y)-0.04;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    p = prevP;
    d = max(-(length(p)-0.005),d);
    
    p = prevP;
    a = radians(-50.);
    p.y = abs(p.y)-0.12;
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float graphicItem2(vec2 p, float dir){
    vec2 prevP2 = p;

    p.x+=iTime*0.03*dir;
    p.x = mod(p.x,0.06)-0.03;
    p*=Rot(radians(20.));
    vec2 prevP = p;

    float d = graphicItem2_0(p);
    
    d = max(B(prevP2,vec2(0.15,0.105)),d);
    
    float d2 = abs(B(prevP2,vec2(0.16,0.12)))-0.002;
    d2 = max(-(abs(prevP2.x)-0.14),d2);
    d2 = max(-(abs(prevP2.y)-0.1),d2);
    
    d = min(d,d2);
    
    return d;
}

float graphicItem3(vec2 p){
    vec2 prevP = p;
    float d = abs(B(p,vec2(0.16,0.12)))-0.002;
    d = max(-(abs(p.x)-0.14),d);
    d = max(-(abs(p.y)-0.1),d);
    
    p = abs(p);
    p.x*=-1.;
    p*=Rot(radians(-55.));
    float d2 = B(p,vec2(0.002,0.15));
    
    d = min(d,d2);
    
    return d;
}

float graphicItem4(vec2 p, float dir){
    vec2 prevP = p;
    
    float d = 10.;
    for(float i = 0.; i<3.; i++){
	p*=Rot(radians(dir*iTime*i*20.0+sin(i)*110.));
	p = abs(p)-0.05;
	p.y+=0.05;
	p*=1.1;
	float d2 = graphicItem2_0(p);
	d = min(d,d2);
    }
    
    d = max(B(prevP,vec2(0.15,0.105)),d);
    
    float d2 = abs(B(prevP,vec2(0.16,0.12)))-0.002;
    d2 = max(-(abs(prevP.x)-0.14),d2);
    d2 = max(-(abs(prevP.y)-0.1),d2);
    
    d = min(d,d2);    
    
    return d;
}

float graphicItem5(vec2 p){
    vec2 prevP = p;
    
    p.x = abs(p.x);
    p.x*=-1.;
    p.x-=iTime*0.1;
    p.x = mod(p.x,0.12)-0.06;
    p*=Rot(radians(90.));
    p.y-=0.06;
    float d = Tri(p,vec2(0.12));
    p.y+=0.05;
    float d2 = Tri(p,vec2(0.12));
    d = max(-d2,d);
    
    p.x=abs(p.x);
    p*=Rot(radians(-45.));
    float a = radians(-50.);
    p.x -=0.04;
    p.y+=0.05;
    d2 = B(p,vec2(0.02,0.04));
    p.y = abs(p.y)-0.04;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    
    d = max(B(prevP,vec2(0.15,0.12)),d);
    
    return d;
}

float drawNumber(vec2 p, float n){
    float d = drawFont(p-vec2(-0.085,0.0),int(mod(9.+iTime*n,10.0)));
    float d2 = drawFont(p-vec2(0.085,0.0),int(mod(9.+iTime*2.*n,10.0)));
    d = min(d,d2);
    float numd = d;
    p*=Rot(radians(40.));
    p.x+=iTime*0.05;
    p.x = mod(p.x,0.02)-0.01;
    d2 = abs(p.x)-0.003;
    d = max(d2,d);
    
    return min(abs(numd)-0.002,d);
}

float randomDots(vec2 p, float n2, float dir){
    vec2 prevP = p;
    p.y-=iTime*0.05*dir;
    p*=35.;
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);
    float n = random(id)*n2;
    float d = 10.;
    if(n<0.2){
	d = length(gv)-(0.05+abs(sin(10.*iTime*n+5.))*0.15);
    }
    d = max(abs(prevP.y)-0.12,d);
    
    p = prevP;
    
    d = max(B(p,vec2(0.15,0.105)),d);
    
    float d2 = abs(B(p,vec2(0.16,0.12)))-0.002;
    d2 = max(-(abs(p.x)-0.14),d2);
    d2 = max(-(abs(p.y)-0.1),d2);
    
    d = min(d,d2);
    
    return d;
}

float drawAll(vec2 p){
    vec2 prevP = p;
    p.y+=iTime*0.1;
    p*=3.5;
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);
    float n = random(id);
    gv*=0.35;
    float d = 10.;

    if(n<0.17){
	d = graphicItem2(gv,(n>=0.085)?-1.:1.);
    } else if(n>=0.17 && n<0.34){
	d = randomDots(gv,n*1.9,(n>=0.255)?-1.:1.);
    } else if(n>=0.34 && n<0.51){
	d = graphicItem3(gv);
    } else if(n>=0.51 && n<0.68){
	d = drawNumber(gv,n*5.);
    } else if(n>=0.68 && n<0.85){
	d = graphicItem4(gv,(n>=0.765)?-1.:1.);
    } else if(n>=0.85){
	d = graphicItem5(gv);
    }
    
    return d;
}

float rulerItem0(vec2 p){
    p.y = abs(p.y)-0.28;
    float d = B(p,vec2(0.15,0.14));
    float a = radians(-45.);
    p.x = abs(p.x)-0.26;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    d = abs(d)-0.005;
    d = max(p.y+0.12,d);
    return d;
}

float arrow(vec2 p){
    p*=Rot(radians(-90.));
    vec2 prevP = p;
    float d = Tri(p,vec2(0.05));
    p.y+=0.025;
    float d2 = Tri(p,vec2(0.05));
    d = max(-d2,d);
    p = prevP;
    p.x = abs(p.x)-0.036;
    p.y+=0.056;
    float a = radians(45.);
    d2 = B(p,vec2(0.01));
    p.x = abs(p.x)-0.014;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    return d;
}

float plus(vec2 p){
    p.y+=iTime*0.1;
    p*=3.5;
    p.y+=0.5;
    
    vec2 gv = fract(p)-0.5;
    vec2 newGV = vec2(p.x,gv.y);
    vec2 id = floor(p);
    
    newGV.x = mod(newGV.x,0.5)-0.25;
    float d = min(B(newGV,vec2(0.003,0.03)),B(newGV,vec2(0.03,0.003)));
    return d;
}

float drawRulerVertical(vec2 p, int bg){
    vec2 prevP = p;
    p.y-=iTime*0.1;
    
    p*=Rot(radians(90.));
    float d = graphicItem0(p,bg);

    p = prevP;
    p.y += sin(iTime-10.)*0.4;
    p.x = abs(p.x)-0.13;
    float d2 = arrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.y -= sin(0.5*iTime-30.)*0.35;
    d = max(-B(p,vec2(0.135,0.14)),d);
    d2 = rulerItem0(p);
    
    d = min(d,d2);
    return d;
}

float drawRulerHolizontal(vec2 p, int bg){
    vec2 prevP = p;
    
    float d = graphicItem1(p,bg);
    return d;
}

float drawRuler(vec2 p, int bg){
    vec2 prevP = p;
    
    p.x+=sin(0.6*iTime-20.)*0.6;
    float d = drawRulerVertical(p,bg);
    
    p = prevP;
    p.y -= sin(0.5*iTime-30.)*0.35;
    float d2 = drawRulerHolizontal(p,bg);
    d = min(d,d2);
    
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    
    vec3 col = vec3(0.0);
    float d = drawAll(uv);
    
    col = mix(col,vec3(0.7),S(d,0.0));
    
    d = plus(uv);
    col = mix(col,vec3(0.5),S(d,0.0));
    
    d = drawRuler(uv,0);
    col = mix(col,vec3(1.0),S(d,0.0));
    
    d = drawRuler(uv,1);
    col = mix(col,vec3(1.),S(d,0.0));
    
    fragColor = vec4(col,1.0);
}
