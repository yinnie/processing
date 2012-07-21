import processing.opengl.*;

import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;

import toxi.geom.*;
import toxi.math.*;

int DIM=8;
float angle = TWO_PI/DIM;
int REST_LENGTH=70;
float STRENGTH=0.0025;
float INNER_STRENGTH = 0.006;

VerletPhysics2D physics;
VerletParticle2D head,tail;

void setup() {
  size(500,500,OPENGL);
  smooth();
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0,0.4)));
  physics.setWorldBounds(new Rect(0,0,width,height));
  
  Vec2D center = new Vec2D (width/2, height/2);
     VerletParticle2D centerP = new VerletParticle2D(center.x, center.y);
      physics.addParticle(centerP);
      
  for(int i=0; i<DIM; i++) {
    
      VerletParticle2D p=new VerletParticle2D((center.x+REST_LENGTH*cos(i*angle)),(center.y-REST_LENGTH*sin(i*angle)));
      physics.addParticle(p);
        
      if(i>0) {
      VerletSpring2D sCircle=new VerletSpring2D(p,physics.particles.get(i-1),REST_LENGTH/2,STRENGTH);
        physics.addSpring(sCircle);
      }
          if(i>3) {
      VerletSpring2D sCircle=new VerletSpring2D(p,physics.particles.get(i-3),REST_LENGTH*1.5,STRENGTH);
        physics.addSpring(sCircle);
      }
      if(i>DIM/2) {
        VerletSpring2D sCircle1=new VerletSpring2D(p,physics.particles.get(DIM-i),REST_LENGTH*1.5,STRENGTH);
        physics.addSpring(sCircle1);
      }
      
        VerletSpring2D s=new VerletSpring2D(p,centerP,REST_LENGTH,INNER_STRENGTH);
        physics.addSpring(s);        
  }
  head=centerP;
  head.lock();
}

void draw() {
  background(0);
  stroke(255);
  
  head.x+=random(-5, 5);
  head.y+=random(-5, 5);
  if(head.x <0) head.x +=200;
  if(head.x >width) head.x -=200;
  if(head.y <0) head.y +=200;
  if(head.y >width) head.y -=200;
  
  //head.set(mouseX, mouseY);
  physics.update();
  for(Iterator i=physics.springs.iterator(); i.hasNext();) {
    VerletSpring2D s=(VerletSpring2D)i.next();

    strokeWeight(0.001);
    line(s.a.x,s.a.y,s.b.x,s.b.y);
  }
}


