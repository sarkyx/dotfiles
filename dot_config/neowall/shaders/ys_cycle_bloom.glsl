#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define ZERO (min(iFrame,0))
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define SkewY(a) mat2(1.0,0.0,tan(a),1.0)

vec2 twist(vec2 p, float k){
    float c = cos(k*p.y);
    float s = sin(k*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec2  q = m*p;    
    return q;
}

float graphicItem0(vec2 p){
    p*=SkewY(radians(45.));
    vec2 prevP = p;
    
    p.x*=3.;
    float d = length(p)-0.3;
    p = prevP;
    
    p.y-=0.07;
    p.x*=2.7;
    p.y = abs(p.y)-0.22;
    float d2 = length(p)-0.2;
    
    d = max(-d2,d);
    
    p = prevP;
    p.y-=iTime*0.05;
    p = mod(p,0.02)-0.01;
    d = max(-(abs(p.x)-0.002),d);
    d = max(-(abs(p.y)-0.002),d);
    
    return d;
}

float graphicItem1(vec2 p){
    vec2 prevP = p;
    p.y*=0.5;
    float d = B(p,vec2(0.1));
    
    p = abs(p)-0.095;
    p.y+=0.01;
    d = max(-(length(p)-0.1),d);
    d = abs(d)-0.004;
    p = prevP;
    d = max(abs(p.y)-0.17,d);
    return d;
}

float graphicItem2(vec2 p){
    vec2 prevP = p;
    p.x*=2.2;
    p.y-=iTime*0.3;
    
    p.y = mod(p.y,0.12)-0.06;
    p.y-=0.05;

    float d = Tri(p,vec2(0.09));
    p.y+=0.06;
    p.x*=0.3;
    d = max(-Tri(p,vec2(0.09)),d);
    return d;
}

float graphicItem3_1(vec2 p){
    p.y*=0.9;
    p*=SkewY(radians(-50.));
    vec2 prevP = p;
    p.x-=0.006;
    p.y+=0.035;
    float d = B(p,vec2(0.011,0.09));
    float a = radians(25.);
    p.y = abs(p.y)-0.06;
    p.x+=0.005;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    p = prevP;
    p.x+=0.006;
    p.y-=0.035;
    float d2 = B(p,vec2(0.011,0.09));
    a = radians(-25.);
    p.y = abs(p.y)-0.06;
    p.x-=0.005;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    return d;
}

float graphicItem3(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.3;
    p.y = mod(p.y,0.3)-0.15;
    float d = graphicItem3_1(p);
    
    return d;
}

float graphicItem4(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.3;
    p.y = mod(p.y,0.24)-0.12;
    float d = B(p,vec2(0.05,0.1));
    float d2 = B(p-vec2(0.,0.045),vec2(0.05,0.1));
    float a = radians(-5.);
    p.x = abs(p.x)-0.04;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    a = radians(-15.);
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    d = max(-d2,d);
    
    a = radians(-12.);
    p.x-=0.02;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}


float graphicItem5(vec2 p){
    p.y-=iTime*0.3;
    p.y = mod(p.y,0.42)-0.21;
    p.y+=0.01;
    vec2 prevP = p;
    p.x-=0.01;
    p.x*=2.;
    p.y*=0.7;
    p.y-=0.09;
    p *= SkewY(radians(-10.));
    float d = max(p.x,Tri(p,vec2(0.1)));
    
    p =prevP;
    p.x+=0.01;
    p.x*=2.;
    p.y*=-1.0;
    p.y*=0.7;
    p.y-=0.09;
    p *= SkewY(radians(10.));
    float d2 = max(-p.x,Tri(p,vec2(0.1)));
    d = min(d,d2);
    
    p =prevP;
    p.x-=0.03;
    p.y-=0.08;
    p*=Rot(radians(-5.));
    p.x*=1.2;
    p.y*=0.7;
    p.y-=0.095;
    p *= SkewY(radians(-20.));
    d2 = max(p.x,Tri(p,vec2(0.1)));
    d = min(d,d2);

    return d;
}

float pattern0(vec2 p){
    vec2 prevP = p;
    
    p = DF(p,3.);
    p-=0.2;
    p*=Rot(radians(45.));
    
    vec2  q = twist(p,-0.3);    
    
    float d = graphicItem2(p);
    return d;
}

float pattern1(vec2 p){
    vec2 prevP = p;
    
    p = DF(p,3.);
    p-=0.2;
    p*=Rot(radians(45.));
    
    float d = graphicItem3(p);
    return d;
}


float pattern2(vec2 p){
    vec2 prevP = p;
    
    p = DF(p,3.);
    p-=0.4;
    p*=Rot(radians(45.));
    
    float d = graphicItem4(p);
    return d;
}


float pattern3(vec2 p){
    vec2 prevP = p;
    
    p = DF(p,3.);
    p-=0.2;
    p*=Rot(radians(45.));
    
    float d = graphicItem5(p);
    return d;
}

float centerItem0(vec2 p){
    vec2 prevP = p;
    
    p*=Rot(radians(-45.*iTime));
    
    float d = length(p)-0.17;
    
    p = DF(p,0.75);
    p-=0.11;
    p.y+=0.02;
    p.x*=0.75;
    p.y*=1.2;
    d = max(-(length(p)-0.1),d);
    
    return d;
}

float centerItem_line(vec2 p, float dir){
    vec2 prevP = p;
    p.x+=iTime*0.1*dir;
    p.x = mod(p.x,0.12)-0.06;
    p*=SkewX(radians(-60.));
    float d = B(p,vec2(0.05,0.01));
    p = prevP;
    
    p*=SkewX(radians(-60.));
    d = max((abs(p.x)-0.17),d);
    return d;
}

float centerItem1(vec2 p){
    p*=1.2;
    vec2 prevP = p;
    
    float size = 0.17;
    p.x*=1.5;
    p.y*=-1.;
    p.y-=size*0.5;
    float d = abs(Tri(p,vec2(size)))-0.01;
    p = prevP;
    p*=Rot(radians(30.*iTime+15.));
    d = max(-(abs(p.x)-0.03),d);
    
    p = prevP;
    p.x-=0.055;
    p.y-=size*0.5+0.03;
    float d2 = centerItem_line(p,1.);
    d = min(d,d2);
    p = prevP;
    
    p.x+=0.115;
    p.y-=0.035;
    p*=Rot(radians(57.));
    d2 = centerItem_line(p,-1.);
    d = min(d,d2);
    p = prevP;

    p.x-=0.05;
    p.y+=0.07;
    p*=Rot(radians(-57.));
    d2 = centerItem_line(p,-1.);
    d = min(d,d2);
    
    return d;
}

float centerItem2(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(-35.*iTime));
    p = DF(p,3.);
    p-=0.08; 
    
    float d = centerItem_line(p,0.5);
    return d;
}

float centerItem3(vec2 p){
    p*=Rot(radians(-35.*iTime));
    vec2 prevP = p;

    float d = abs(B(p,vec2(0.1)))-0.01;
    p*=Rot(radians(-25.*iTime+45.));
    d = max(-(abs(p.x)-0.03),d);
    
    p = prevP;
    p*=Rot(radians(-45.));
    float d2 = abs(B(p,vec2(0.1)))-0.01;
    p = prevP;
    p*=Rot(radians(25.*iTime+45.));
    d2 = max(-(abs(p.x)-0.03),d2);
    
    d = min(d,d2);
    
    return d;
}

float centerItem4(vec2 p){
    p.x*=0.8;
    p.y*=1.2;
    vec2 prevP = p;
    
    p*=SkewY(radians(-40.));
    float d = abs(length(p)-0.1)-0.01;
    p*=Rot(radians(-55.*iTime-45.));
    d = max(-(abs(p.x)-0.03),d);
    
    p = prevP;
    p*=SkewY(radians(40.));
    float d2 = abs(length(p)-0.1)-0.01;
    p*=Rot(radians(55.*iTime+45.));
    d2 = max(-(abs(p.y)-0.03),d2);    
    d = min(d,d2);
    
    return d;
}

float mainGraphic(vec2 p){
    vec2 prevP = p;
    float d  = pattern0(p);
    float t = mod(iTime*1.,4.);
    if(t<1.){
        d  = pattern3(p);
    } else if (t>=1. && t<2.){
        d  = pattern1(p);
    } else if (t>=2. && t<3.){
        d  = pattern2(p);
    } else if (t>=3. && t<4.){
        d  = pattern0(p);
    }
    
    p*=Rot(radians(45.));
    p = DF(p,3.);
    p-=0.3;
    p*=Rot(radians(45.));
    
    vec2 prevP2 = p;
    
    p.y-=iTime*0.3;
    p.y = mod(p.y,0.2)-0.1;
    float d2 = length(p)-0.01;
    d = min(d,d2);
    
    p = prevP2;
    p.y-=iTime*0.3;
    p.y-=0.11;
    p.y = mod(p.y,0.2)-0.1;
    p.x*=1.5;
    d2 = Tri(p,vec2(0.02));
    d = min(d,d2);
    
    return d;
}

float centerGraphic(vec2 p){
    vec2 prevP = p;
    float d = centerItem4(p);
    
    float t = mod(iTime*3.,5.);
    if(t<1.){
        d  = centerItem0(p);
    } else if (t>=1. && t<2.){
        d  = centerItem1(p);
    } else if (t>=2. && t<3.){
        d  = centerItem2(p);
    } else if (t>=3. && t<4.){
        d  = centerItem3(p);
    } else if (t>=4. && t<5.){
        d  = centerItem4(p);
    }

    return d;
}

float otherGraphicElements(vec2 p){
    vec2 prevP = p;
    p.x = abs(p.x)-0.55;
    p.y = abs(p.y)-0.35;
    p*=Rot(radians(-105.));
    float d = graphicItem0(p);
    p = prevP;
    
    p.x = abs(p.x)-0.7;
    float d2 = graphicItem1(p);
    d = min(d,d2);
    p = prevP;
    p.x = abs(p.x)-0.3;
    p.y = abs(p.y)-0.4;
    p*=Rot(radians(40.));
    p*=2.;
    d2 = graphicItem1(p);
    d = min(d,d2);
    return d;
}

float bg(vec2 p){
    p = mod(p,0.05)-0.025;
    float d = length(p)-0.0015;
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    
    vec3 col = vec3(0.);

    float d = bg(p);
    col = mix(col,vec3(1.),S(d,0.0));
    d = mainGraphic(p);
    col = mix(col,vec3(1.),S(d,0.001));
    col*=length(p)-0.1;
    col*= 0.6-(length(p)-0.3);

    d = centerGraphic(p);    
    col = mix(col,vec3(1.),S(d,0.0));
    
    d = otherGraphicElements(p);
    col = mix(col,vec3(1.),S(d,0.0));
    
    fragColor = vec4(sqrt(col),1.0);
}
