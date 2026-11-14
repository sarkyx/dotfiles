#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d) 1.-smoothstep(-1.3,1.3, (d)*iResolution.y )
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define PUV(p)vec2(log(length(p)),atan(p.y/p.x))

// thx iq! https://iquilezles.org/articles/distfunctions2d/
float dot2( in vec2 v ) { return dot(v,v); }
float sdTriangle( in vec2 p, in vec2 p0, in vec2 p1, in vec2 p2 )
{
	vec2 e0=p1-p0, v0=p-p0; float d0=dot2(v0-e0*clamp(dot(v0,e0)/dot(e0,e0),0.0,1.0));
	vec2 e1=p2-p1, v1=p-p1; float d1=dot2(v1-e1*clamp(dot(v1,e1)/dot(e1,e1),0.0,1.0));
	vec2 e2=p0-p2, v2=p-p2; float d2=dot2(v2-e2*clamp(dot(v2,e2)/dot(e2,e2),0.0,1.0));
    
    float o = e0.x*e2.y-e0.y*e2.x;
    vec2 d = min(min(vec2(d0,o*(v0.x*e0.y-v0.y*e0.x)),
                     vec2(d1,o*(v1.x*e1.y-v1.y*e1.x))),
                     vec2(d2,o*(v2.x*e2.y-v2.y*e2.x)));
	return -sqrt(d.x)*sign(d.y);
}

float SimpleVesicaDistanceX(vec2 p, float r, float d) {
    p.y = abs(p.y);
    p.y+=d;
    return length(p)-r;
}

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

float stripe(vec2 p, float n){
    p.y+=iTime*n*0.3;
    p*=Rot(radians(45.));

    p.x = mod(p.x,0.1)-0.05;
    float d = abs(p.x)-0.015;
    return d;
}

float bg(vec2 p){
    p*=Rot(radians(45.));
    vec2 prevP = p;
    p*=6.;
    
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    
    float n = Hash21(id);
    
    if(n<0.5){
        gr*=Rot(radians(-45.));
    } else {
        gr*=Rot(radians(45.));
    }
    
    vec2 prevGr = gr;
    gr.x = abs(gr.x)-0.353;
    float d = abs(gr.x)-0.02;
    
    if(n<0.5){
        float d2 = length(gr)-0.1;
        if(n<0.3){
            d = max(-d2,d);
            gr*=Rot(radians(30.*iTime*n*10.));
            d2 = abs(length(gr)-0.1)-0.02;
            d2 = max(-(abs(gr.y)-0.04),d2);
            d = min(d,d2);
        } else {
            gr = prevGr;
            d2 = abs(length(gr)-0.1)-0.02;
            d = min(d,d2);
        }
    } else {
        d = max(-(abs(gr.y)-0.15),d);
        gr = prevGr;
        float d2 = B(gr-vec2(0.22,0.17),vec2(0.15,0.02));
        d = min(d,d2);
        d2 = B(gr-vec2(-0.22,-0.17),vec2(0.15,0.02));
        d = min(d,d2);
        
        d2 = abs(length(gr-vec2(0.0,n<0.75 ? -0.17:0.17))-0.1)-0.02;
        d = min(d,d2);
        
        if(n>0.75){
            gr.y+=0.06;
            d2 = stripe(gr,n);
            d2 = max((abs(gr.y)-0.07),d2);
            d2 = max((abs(gr.x)-0.4),d2);
            d = min(d,d2);
        }
        
    }
    
    return d;
}


float cannabisLeafBase(vec2 p){
    p.x*=1.2;
    vec2 prevP = p;
    float d = B(p,vec2(0.1,0.3));
    float a = radians(11.);
    p.x = abs(p.x)-0.05;
    float slice = dot(p,vec2(cos(a),sin(a)));
    d = max(slice,d);
    
    p = prevP;
    a = radians(-12.);
    p.x = abs(p.x)-0.12;
    slice = dot(p,vec2(cos(a),sin(a)));
    d = max(slice,d);
    
    p = prevP;
    p.x = abs(p.x)+0.015;
    p.x*=-1.;
    
    float d2 = sdTriangle(p,vec2(-0.06,0.17),vec2(-0.05,0.05),vec2(-0.03,0.13));
    d = min(d,d2);
    
    d2 = sdTriangle(p,vec2(-0.08,0.1),vec2(-0.06,0.0),vec2(-0.03,0.05));
    d = min(d,d2);
    
    d2 = sdTriangle(p,vec2(-0.1,0.05),vec2(-0.07,-0.1),vec2(-0.05,0.0));
    d = min(d,d2);
    
    d2 = sdTriangle(p,vec2(-0.11,-0.03),vec2(-0.08,-0.15),vec2(-0.07,-0.07));
    d = min(d,d2);
    
    d2 = sdTriangle(p,vec2(-0.12,-0.11),vec2(-0.06,-0.3),vec2(-0.07,-0.15));
    d = min(d,d2);
    
    d2 = sdTriangle(p,vec2(-0.12,-0.2),vec2(-0.06,-0.3),vec2(-0.05,-0.25));
    d = min(d,d2);
    
    return d;
}

float cannabisLeafItem0(vec2 p){
    vec2 prevP = p;
    p.y+=0.01;
    p.y-= iTime*0.02;
    p.y = mod(p.y,0.03)-0.015;
    p.x*=3.;
    p.y-=0.005;
    float d = Tri(p,vec2(0.02));
    p = prevP;
    d = max(abs(p.y)-0.04,d);
    return d;
}

float cannabisLeafInside(vec2 p){
     vec2 prevP = p;
     float d = B(p-vec2(0.0,-0.05),vec2(0.003,0.22));
     
     p.x += 0.013;
     p.y -= 0.03;
     p*=Rot(radians(-25.));
     
     float d2 = B(p,vec2(0.003,0.03));
     d = min(d,d2);
     
     p = prevP;
     
     p.x += 0.013;
     p.y -= 0.03;
     p*=Rot(radians(-25.));     
     
     d2 = B(p,vec2(0.003,0.03));
     d = min(d,d2);
     
     p = prevP;
     p.x -= 0.012;
     p.y -= 0.05;
     p*=Rot(radians(25.));     
     
     d2 = B(p,vec2(0.003,0.025));
     d = min(d,d2);
     
     p = prevP;
     
     p.x += 0.015;
     p.y += 0.04;
     p*=Rot(radians(-25.));     
     
     d2 = B(p,vec2(0.003,0.035));
     d = min(d,d2);     
     
     p = prevP;
     
     p.x -= 0.015;
     p.y += 0.02;
     p*=Rot(radians(25.));     
     
     d2 = B(p,vec2(0.003,0.035));
     d = min(d,d2);         
     
     p = prevP;
     
     p.x += 0.02;
     p.y += 0.15;
     p*=Rot(radians(-25.));     
     
     d2 = B(p,vec2(0.003,0.05));
     d = min(d,d2);        
     
     p = prevP;
     
     p.x -= 0.02;
     p.y += 0.1;
     p*=Rot(radians(25.));     
     
     d2 = B(p,vec2(0.003,0.05));
     d = min(d,d2);  
     
     p = prevP;
     
     p.x -= 0.013;
     p.y += 0.18;
     p*=Rot(radians(-45.));     
     
     d2 = B(p,vec2(0.003,0.02));
     d = min(d,d2);  
     
     p = prevP;
     p.x -= 0.025;
     p.y += 0.22;
     d2 = B(p,vec2(0.003,0.03));
     d = min(d,d2);  
     
     p = prevP;
     
     p.x += 0.013;
     p.y += 0.22;
     p*=Rot(radians(45.));     
     
     d2 = B(p,vec2(0.003,0.02));
     d = min(d,d2);  
     
     p = prevP;
     p.x += 0.025;
     p.y += 0.255;
     d2 = B(p,vec2(0.003,0.025));
     d = min(d,d2);  
     
     p = prevP;
     p.x -= 0.02;
     p.y += 0.055;
     p*=Rot(radians(25.));    
     d2 = cannabisLeafItem0(p);
     d = min(d,d2); 
     
     p = prevP;
     p.x += 0.025;
     p.y += 0.08;
     p*=Rot(radians(-25.));    
     d2 = cannabisLeafItem0(p);
     d = min(d,d2);      
     
     p = prevP;
     p.x -= 0.035;
     p.y += 0.13;
     p*=Rot(radians(25.));    
     d2 = cannabisLeafItem0(p);
     d = min(d,d2);      
     
     p = prevP;
     p.x += 0.035;
     p.y += 0.17;
     p*=Rot(radians(-25.));    
     d2 = cannabisLeafItem0(p);
     d = min(d,d2);       
     
     return d;
}

float cannabisLeaf(vec2 p, float size){
    vec2 prevP = p;
    float d = abs(cannabisLeafBase(p))-size;
    float d2 = cannabisLeafInside(p);
    
    d = max(-(p.y+0.28),d);
    d = min(d,d2);
    
    return d;
}

float cannabisStem(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.035,0.06));
    
    p.x +=0.03;
    p.y -=0.015;
    float d2 = B(p,vec2(0.013,0.03));
    float a = radians(50.);
    p.y = abs(p.y)-0.025;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    d = max(-d2,d);
    
    p = prevP;
    p.y+=0.015;
    p.x -=0.03;
    d2 = B(p,vec2(0.013,0.03));
    a = radians(-50.);
    p.y = abs(p.y)-0.025;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    
    d = max(-d2,d);
    
    return d;
}

float cannabisEyeBall(vec2 p){
    p.x += sin(iTime*0.5)*0.03;
    float d = abs(length(p)-0.06)-0.003;
    float d2= abs(length(p)-0.05)-0.003;
    d = min(d,d2);
    d2= abs(length(p)-0.04)-0.003;
    d = min(d,d2);
    d2= abs(length(p)-0.03)-0.003;
    d = min(d,d2);
    d2= length(p-vec2(0.01,0.01))-0.01;
    d = min(d,d2);
    
    return d;
}

float cannabisEye(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(sin(iTime*0.5)*130.));
    p = DF(p,4.0);
    p-= 0.095;
    
    p*=Rot(radians(45.));
    p.x*=1.8;
    float d = Tri(p,vec2(0.02));
    
    p = prevP;
    float e = cannabisEyeBall(p);
    
    p = prevP;
    p.y *= 0.4+sin(iTime)*0.6+1.0;
    float d2 = abs(SimpleVesicaDistanceX(p,0.11,0.05))-0.003;
    
    d = min(d,d2);
    float d3 = SimpleVesicaDistanceX(p,0.11,0.05);
    d2 = max(d3,d2);
    
    d = min(max(d3,e),d);
    
    p = prevP;
    d2 = abs(length(p)-0.1)-0.003;
    d2 = max(-(abs(p.y)-0.02),d2);
    d = min(d,d2);
    
    d2 = abs(length(p)-0.085)-0.003;
    d2 = max(-(abs(p.y)-0.07),d2);
    d = min(d,d2);    
    
    d2 = abs(length(p)-0.14)-0.003;
    d = min(d,d2);
    
    return d;
}

float cannabisMask(vec2 p){
    vec2 prevP = p;
    float d = cannabisLeafBase(p-vec2(0.0,0.2));
    p.x = abs(p.x)-0.27;
    p.y-=0.12;
    p*=Rot(radians(30.));
    float d2 = cannabisLeafBase(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.35;
    p.y+=0.13;
    p*=1.3;
    p*=Rot(radians(70.));
    d2 = cannabisLeafBase(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.25;
    p.y+=0.32;
    p*=1.5;
    p*=Rot(radians(108.));
    d2 = cannabisLeafBase(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.15;
    p.y+=0.4;
    p*=2.;
    p*=Rot(radians(125.));
    d2 = cannabisLeafBase(p);
    d = min(d,d2);    
    
    p = prevP;
    d2 = cannabisStem(p-vec2(0.,-0.42));
    d = min(d,d2);    
    
    d2 = length(p-vec2(0.,-0.22))-0.18;
    d = min(d,d2);  
    return d;
}

float cannabis(vec2 p){
    vec2 prevP = p;
    float d = cannabisLeaf(p-vec2(0.0,0.2),0.003);
    p.x = abs(p.x)-0.27;
    p.y-=0.12;
    p*=Rot(radians(30.));
    float d2 = cannabisLeaf(p,0.003);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.35;
    p.y+=0.13;
    p*=1.3;
    p*=Rot(radians(70.));
    d2 = cannabisLeaf(p,0.0037);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.25;
    p.y+=0.32;
    p*=1.8;
    p*=Rot(radians(108.));
    d2 = cannabisLeaf(p,0.005);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.15;
    p.y+=0.4;
    p*=2.5;
    p*=Rot(radians(125.));
    d2 = cannabisLeaf(p,0.008);
    d = min(d,d2);    
    
    p = prevP;
    d2 = abs(cannabisStem(p-vec2(0.,-0.42)))-0.003;
    d = min(d,d2);    
    p = prevP;
    d2 = B(p-vec2(0.,-0.42),vec2(0.003,0.035));
    
    d = min(d,d2);
    
    d2 = length(p-vec2(0.,-0.22))-0.135;
    d = max(-d2,d);  
    
    d2 = cannabisEye(p-vec2(0.,-0.215));
    d = min(d,d2);
     
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec3 col = vec3(0.0);
    uv*=Rot(radians(3.*iTime));
    uv.x = abs(uv.x);
    uv = PUV(uv);
    uv.x+=iTime*0.2;
    
    float d = bg(uv);
    uv = prevUV;
    float m = cannabisMask(uv);
    d = max(-m,d);
    m = abs(cannabisMask(uv))-0.02;
    d = max(-m,d);
    col = mix(col,vec3(0.8),S(d));
    col*=length(prevUV);
    d = cannabis(uv);
    col = mix(col,vec3(1.),S(d));

    fragColor = vec4(col,1.0);
}
