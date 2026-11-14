#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d) 1.-smoothstep(-1.3,1.3, (d)*iResolution.y )
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define PI 3.1415
#define FONT_H 0.017
#define FONT_THICK 0.005

vec2 layer1[] = vec2[](
    vec2(-0.1851,  0.0842),
    vec2(-0.2210,  0.1274),
    vec2(-0.0657,  0.1654),
    vec2(-0.2523, -0.0546),
    vec2(-0.0986, -0.0150),
    vec2(-0.1182,  0.0230),
    vec2(-0.1182,  0.0230)
);

vec2 layer2[] = vec2[](
    vec2(-0.0677,  0.0360),
    vec2(-0.0911,  0.0864),
    vec2(-0.0391,  0.1612),
    vec2(-0.0052,  0.0780),
    vec2(-0.0589, -0.0468),
    vec2(-0.1007,  0.0222),
    vec2(-0.0911,  0.0572)
);

vec2 layer3[] = vec2[](
    vec2( 0.0156,  0.0820),
    vec2(-0.0052,  0.1168),
    vec2( 0.1250,  0.1728),
    vec2(-0.0299, -0.0340),
    vec2( 0.0755, -0.0158),
    vec2( 0.0475,  0.0102),
    vec2( 0.0475,  0.0102)
);

vec2 layer4[] = vec2[](
    vec2( 0.1396,  0.0890),
    vec2( 0.1484,  0.1612),
    vec2( 0.0716,  0.0244),
    vec2( 0.1783, -0.0456),
    vec2( 0.2411,  0.0848),
    vec2( 0.1042,  0.0340),
    vec2( 0.1042,  0.0340)
);

vec2 star[] = vec2[](
    vec2( -0.18,-0.15),
    vec2( 0.0,0.2),
    vec2( 0.2,-0.2),
    vec2( -0.25,0.1),
    vec2( 0.25,0.0),
    vec2( -0.18,-0.15),
    vec2( -0.18,-0.15)
);

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float lineTo(vec2 p, vec2 a, vec2 b, float t){
    float k = dot(p-a,b-a)/dot(b-a,b-a);
    return mix(distance(p,mix(a,b,clamp(k,0.,t))),1e5, step(t,0.01));
}

// thx, iq! https://iquilezles.org/articles/distfunctions2d/
float dot2( vec2 v ) { return dot(v,v); }
float sdBezier( in vec2 pos, in vec2 A, in vec2 B, in vec2 C, float t )
{    
    vec2 a = B - A;
    vec2 b = A - 2.0*B + C;
    vec2 c = a * 2.0;
    vec2 d = A - pos;
    float kk = 1.0/dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);      
    float res = 0.0;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx-3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if( h >= 0.0) 
    { 
        h = sqrt(h);
        vec2 x = (vec2(h,-h)-q)/2.0;
        vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
        float t = clamp( uv.x+uv.y-kx, 0.0, t );
        res = dot2(d + (c + b*t)*t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        vec3  t = clamp(vec3(m+m,-n-m,n-m)*z-kx,0.0,t);
        res = min( dot2(d+(c+b*t.x)*t.x),
                   dot2(d+(c+b*t.y)*t.y) );
        // the third root cannot be the closest
        // res = min(res,dot2(d+(c+b*t.z)*t.z));
    }
    return mix(sqrt( res ),1e5, step(t,0.01));
}

float cL(vec2 p){
    vec2 prevP = p;
    float h = FONT_H;
    float d = lineTo(p,vec2(-h,h),vec2(-h,-h),1.)-FONT_THICK;
    float d2 = lineTo(p,vec2(-h,-h),vec2(h,-h),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float cP(vec2 p){
    float h = FONT_H;
    float d = lineTo(p,vec2(-h,0.0),vec2(-h,-h),1.)-FONT_THICK;
    float d2 = lineTo(p,vec2(-h,h),vec2(h,h),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(-h,0.),vec2(h,0.),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(h,h),vec2(h,0.),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float c0(vec2 p){
    vec2 prevP = p;
    float h = FONT_H;
    p.x = abs(p.x);
    float d = lineTo(p,vec2(h,h),vec2(h,-h),1.)-FONT_THICK;
    p = prevP;
    p.y = abs(p.y);
    float d2 = lineTo(p,vec2(h,h),vec2(-h,h),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float c1(vec2 p){
    vec2 prevP = p;
    float h = FONT_H;
    float d = lineTo(p,vec2(0.,h),vec2(0.,-h),1.)-FONT_THICK;
    return d;
}

float c2(vec2 p){
    vec2 prevP = p;
    float h = FONT_H;
    p.y = abs(p.y);
    float d = lineTo(p,vec2(h,h),vec2(-h,h),1.)-FONT_THICK;
    p = prevP;
    float d2 = lineTo(p,vec2(h,0.),vec2(-h,0.),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(h,h),vec2(h,0.),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(-h,0.),vec2(-h,-h),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float c3(vec2 p){
    vec2 prevP = p;
    float h = FONT_H;
    p.y = abs(p.y);
    float d = lineTo(p,vec2(h,h),vec2(-h,h),1.)-FONT_THICK;
    p = prevP;
    float d2 = lineTo(p,vec2(h*0.25,0.),vec2(-h,0.),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(h,h),vec2(h,-h),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float c4(vec2 p){
    float h = FONT_H;
    float d = lineTo(p,vec2(-h,h),vec2(-h,0.0),1.)-FONT_THICK;
    float d2 = lineTo(p,vec2(h,0.0),vec2(-h,0.0),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(h,0.0),vec2(h,-h),1.)-FONT_THICK;
    d = min(d,d2);
    d2 = lineTo(p,vec2(h,h),vec2(h,h*0.75),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float c5(vec2 p){
    vec2 prevP = p;
    p.y*=-1.;
    float d = c2(p);
    return d;
}

float c6(vec2 p){
    vec2 prevP = p;
    p.y*=-1.;
    float d = cP(p);
    return d;
}

float c7(vec2 p){
    vec2 prevP = p;
    p*=-1.;
    float d = cL(p);
    return d;
}

float c8(vec2 p){
    vec2 prevP = p;
    float h = FONT_H;
    float d = c0(p);
    float d2 = lineTo(p,vec2(-h,0.),vec2(h,0.0),1.)-FONT_THICK;
    d = min(d,d2);
    return d;
}

float c9(vec2 p){
    vec2 prevP = p;
    p.x*=-1.;
    float d = cP(p);
    return d;
}

float drawNumbers(vec2 p, int char){
    float d = 10.;
    if(char == 0) {
        d = c0(p);
    } else if(char == 1){
        d = c1(p);
    } else if(char == 2){
        d = c2(p);
    } else if(char == 3){
        d = c3(p);
    } else if(char == 4){
        d = c4(p);
    } else if(char == 5){
        d = c5(p);
    } else if(char == 6){
        d = c6(p);
    } else if(char == 7){
        d = c7(p);
    } else if(char == 8){
        d = c8(p);
    } else if(char == 9){
        d = c9(p);
    }
    
    return d;
}


float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float lines(vec2 p, vec2 layer[7], float anim, float speed, float thick){
    float num = float(layer.length());
    float t = mod(iTime*speed,num);
    if(t<num*0.3){
        t = cubicInOut(t);
    } else {
        t = (num-1.)-cubicInOut((t*0.7)-(num*0.3));
    }
    t = mix(num,t,anim);
    
    //float thick = 0.007;
    float d = lineTo(p,layer[0],layer[1],clamp(t,0.,1.))-thick;
    
    for(int i = 1; i<layer.length()-1; i++){
        float d2 = lineTo(p,layer[i],layer[i+1],clamp(t-float(i),0.,1.))-thick;
        d = min(d,d2);
    }
    
    return d;
}

float draw2026_items(vec2 p, float t, float thick){
    float d = sdBezier(p,vec2(0.15,-0.08),vec2(0.0,-0.035),vec2(-0.2,-0.09),t)-thick;
    float d2 = sdBezier(p,vec2(0.25,-0.13),vec2(0.0,-0.03),vec2(-0.25,-0.13),t)-thick;
    d = min(d,d2);
    d2 = lineTo(p,vec2(0.03,-0.11),vec2(-0.07,-0.12),t)-thick;
    d = min(d,d2);
    
    d2 = lineTo(p,vec2(0.2,0.18),vec2(0.17,0.12),t)-thick;
    d = min(d,d2);
    d2 = lineTo(p,vec2(0.1,0.19),vec2(0.0,0.14),t)-thick;
    d = min(d,d2);  
    d2 = lineTo(p,vec2(0.1,-0.03),vec2(0.21,-0.09),t)-thick;
    d = min(d,d2);      
    d2 = lineTo(p,vec2(-0.27,0.14),vec2(-0.21,0.08),t)-thick;
    d = min(d,d2);    
    d2 = lineTo(p,vec2(-0.3,-0.05),vec2(-0.21,0.03),t)-thick;
    d = min(d,d2); 
    return d;
}

float draw2026_bg(vec2 p){
    float d = lines(p,layer1,0.0,0.0,0.007);
    float d2 = lines(p,layer2,0.0,0.0,0.007);
    d = min(d,d2);
    d2 = lines(p,layer3,0.0,0.0,0.007);
    d = min(d,d2);
    d2 = lines(p,layer4,0.0,0.0,0.007);
    d = min(d,d2);
    
    float thick = 0.007;
    d2 = draw2026_items(p,1.0,thick);
    d = min(d,d2);      
    
    return d;
}

float draw2026(vec2 p, float speed){
    float d = lines(p,layer1,1.0,speed,0.007);
    float d2 = lines(p,layer2,1.0,speed,0.007);
    d = min(d,d2);
    d2 = lines(p,layer3,1.0,speed,0.007);
    d = min(d,d2);
    d2 = lines(p,layer4,1.0,speed,0.007);
    d = min(d,d2);
    
    float thick = 0.007;
    float num = 7.;
    float t = mod(iTime*speed,num);
    if(t<num*0.3){
        t = cubicInOut(t);
    } else {
        t = (num-1.)-cubicInOut((t*0.7)-(num*0.3));
    }
    
    d2 = draw2026_items(p,clamp(t,0.,1.0),thick);
    d = min(d,d2);     
    
    return d;
}

float drawStarBg(vec2 p){
    float d = lines(p,star,0.0,0.0,0.015);
    return d;
}

float drawStar(vec2 p, float speed){
    float d = lines(p,star,1.0,speed,0.015);
    return d;
}

float drawCircleBg(vec2 p){
    float thick = 0.01;
    float d = sdBezier(p,vec2(-0.07,0.05),vec2(-0.2,0.0),vec2(-0.08,-0.05),1.)-thick;
    float d2 = sdBezier(p,vec2(0.08,-0.05),vec2(0.2,0.0),vec2(-0.01,0.05),1.)-thick;
    d = min(d,d2);
    d2 = sdBezier(p,vec2(-0.08,-0.05),vec2(0.01,-0.07),vec2(0.08,-0.05),1.)-thick;
    d = min(d,d2);
    return d;
}

float drawCircle(vec2 p, float speed){
    float thick = 0.01;
    
    float num = 7.;
    float t = mod(iTime*speed,num);
    if(t<num*0.3){
        t = cubicInOut(t);
    } else {
        t = (num-1.)-cubicInOut((t*0.7)-(num*0.3));
    }    
    
    float d = sdBezier(p,vec2(-0.07,0.05),vec2(-0.2,0.0),vec2(-0.08,-0.05),clamp(t,0.,1.0))-thick;
    float d2 = sdBezier(p,vec2(0.08,-0.05),vec2(0.2,0.0),vec2(-0.01,0.05),clamp(t-2.,0.,1.0))-thick;
    d = min(d,d2);
    d2 = sdBezier(p,vec2(-0.08,-0.05),vec2(0.01,-0.07),vec2(0.08,-0.05),clamp(t-1.,0.,1.0))-thick;
    d = min(d,d2);
    return d;
}

float drawNumbers(vec2 p, float n){
    p-=vec2(0.42,-0.42);

    float d = drawNumbers(p,int(mod(10.*iTime+n,10.)));
    p.x-=-0.05;
    float d2 = drawNumbers(p,int(mod(5.*iTime+n,10.)));
    d = min(d,d2);
    p.x-=-0.05;
    d2 = drawNumbers(p,int(mod(3.*iTime+n,10.)));
    d = min(d,d2);
    return d;
}

vec3 quadTree(vec2 p, vec3 col){
    p.y-=iTime*0.1;
    p*=2.;
    vec2 id = floor(p);
    vec2 gr = (p-id)-0.5;
    
    float n = random(id);
    float n2 = random(id)*10.;
    int type = 0;
    vec2 cell = id;

    float thresholds[3] = float[](0.6, 0.6, 0.5);

    for (int i = 0; i < 3; i++)
    {
        n = random(cell + id + float(i) * 12.34);

        if (n < thresholds[i])
            break;

        type = i + 1;
        
        if(i<2){
            gr *= 2.0;
            cell = floor(gr);
            gr = fract(gr) - 0.5;
        }
    }

    float d;
    vec2 prevGr = gr;
    if (type <= 1)
    {
        gr*=0.65;
        gr.x -=0.03;
        gr.y +=0.03;
        d = draw2026_bg(gr);
        col = mix(col,vec3(0.4),S(d));
        d = draw2026(gr,((n*0.5)+0.5));
        col = mix(col,vec3(1.),S(d));
        gr = prevGr;
        
        d = abs(B(gr,vec2(0.47)))-0.002;
        d = max(-(abs(gr.x)-0.4),d);
        d = max(-(abs(gr.y)-0.4),d);
        col = mix(col,vec3(1.),S(d));        
        
        gr = prevGr;
        d = abs(B(gr,vec2(0.47)))-0.006;
        gr*=Rot(radians(30.*iTime+(n*10.0)));
        d = max(-(abs(gr.x)-0.2),d);
        d = max(-(abs(gr.y)-0.2),d);
        col = mix(col,vec3(0.5),S(d));
        
        gr = prevGr;
        d = drawNumbers(gr,n2);
        col = mix(col,vec3(0.8),S(d));
    }
    else if (type == 2)
    {
         gr*=0.7;
         d = drawStarBg(gr);
         col = mix(col,vec3(0.4),S(d));
         d = drawStar(gr,((n*0.5)+0.5));
         col = mix(col,vec3(1.),S(d));
    }
    else
    {
         gr*=0.35;
         d = drawCircleBg(gr);
         col = mix(col,vec3(0.4),S(d));
         d = drawCircle(gr,((n*0.5)+0.5));
         col = mix(col,vec3(1.),S(d)); 
    }
    
    if(type >= 2){
         gr = prevGr;
         d = abs(B(gr,vec2(0.44)))-0.005;
         d = max(-(abs(gr.x)-0.3),d);
         d = max(-(abs(gr.y)-0.3),d);
         col = mix(col,vec3(1.),S(d));  
         
         gr.x+=0.33;
         gr.y-=0.33;
         gr*=0.6;
         d = drawNumbers(gr,n2);
         col = mix(col,vec3(0.8),S(d));
    }
    
    return col;
}

vec3 bg(vec2 p, vec3 col){
    vec2 prevP = p;
    p.y-=iTime*0.12;
    
    p = mod(p,0.05)-0.025;
    float d = length(p)-0.001;
    col = mix(col,vec3(1.),S(d));
    
    p = prevP;
    p.y-=iTime*0.135;
    vec2 id = floor(p*70.);
    col = mix(col,vec3(0.25),step(0.98, random(id)));
    
    return col;
}

vec2 getSphereMap(vec2 p, float size){
    p*=size;
    float r = dot(p, p);
    float z = sqrt(1.0 - r);
    vec3 q = vec3(p, z);
    q.xz*=Rot(radians(53.+20.*iTime*0.5));
    vec3 normal = normalize(q);

    float longitude = atan(normal.x, normal.z);
    float latitude  = asin(normal.y);

    float u = longitude / (2. * PI) + 0.5;
    float v = latitude / (2.*PI) + 0.5;

    p = vec2(u,v);
    p -= 0.5;
    p*=size;
    return p;
}

float getTime(float t, float duration){
    return clamp(t,0.0,duration)/duration;
}

float getAnimationValue(){
    float easeValue = 0.;
    float frame = mod(iTime,12.0);
    float time = frame;
    
    float duration = 1.;
    if(frame>=5. && frame<6.){
        time = getTime(time-5.,duration);
        easeValue = cubicInOut(time);
    } else if(frame>=6. && frame<11.){
        easeValue = 1.;
    } else if(frame>=11. && frame<12.){
        time = getTime(time-11.,duration);
        easeValue = 1.0-cubicInOut(time);
    }
    
    return easeValue;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    uv*=1.-(getAnimationValue()*0.3);
    vec3 col = vec3(0.);
    
    col = bg(uv,col);
    col = quadTree(uv,col);

    fragColor = vec4(col,1.0);
}
