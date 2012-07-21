import processing.opengl.*;

import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;
import toxi.geom.*;
import toxi.math.*;

int DIM=14;
float angle = TWO_PI/DIM;
int REST_LENGTH=70;
float STRENGTH=0.0005;
float INNER_STRENGTH = 0.001;

VerletPhysics2D physics;
VerletPhysics2D chainWorld;
VerletParticle2D head;

ArrayList chains;

void setup() {
  size(800, 800, OPENGL);
  smooth();
  frameRate(30);
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.4)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  chainWorld=new VerletPhysics2D();
  chainWorld.addBehavior(new GravityBehavior(new Vec2D(0, 1.0)));
  chainWorld.setWorldBounds(new Rect(0, 0, width, height));

  chains = new ArrayList();
  for (int i = 0; i<DIM+1; i++) {
    chains.add (new Chain(16, 2.2, 0.089));
  }

  Vec2D center = new Vec2D (width/2, height/3);
  VerletParticle2D centerP = new VerletParticle2D(center.x, center.y);
  physics.addParticle(centerP);

  for (int i=0; i<DIM; i++) {

    VerletParticle2D p=new VerletParticle2D((center.x+REST_LENGTH*cos(i*angle)), (center.y-REST_LENGTH*sin(i*angle)));
    physics.addParticle(p);
     VerletSpring2D s=new VerletSpring2D(p, centerP, REST_LENGTH*1.2, INNER_STRENGTH);
    physics.addSpring(s);
  }
  
  for (int i=0; i<DIM; i++) {

    if (i>0) {
      VerletSpring2D sCircle=new VerletSpring2D(physics.particles.get(i), physics.particles.get(i-1), REST_LENGTH/2, STRENGTH);
      physics.addSpring(sCircle);
    }
    if (i>3) {
      VerletSpring2D sCircle=new VerletSpring2D(physics.particles.get(i), physics.particles.get(i-3), REST_LENGTH*1.5, STRENGTH);
      physics.addSpring(sCircle);
    }
    if (i>DIM/2) {
      VerletSpring2D sCircle1=new VerletSpring2D(physics.particles.get(i), physics.particles.get(DIM-i), REST_LENGTH*1.5, STRENGTH);
      physics.addSpring(sCircle1);
    }   
  }
  head=centerP;
  head.lock();
}

void draw() {

  background(0);
  stroke(255);
  
  head.x+=random(-3,3);
  head.y+=random(-3,3);
  
  if (head.x <0) head.x +=200;
  if (head.x >width) head.x -=200;
  if (head.y <0) head.y +=200;
  if (head.y >width) head.y -=200;

  //head.set(mouseX, mouseY);

  for (int i = 0; i<chains.size(); i++) {
    Chain c = (Chain) chains.get(i);
    c.chainHead.set(physics.particles.get(i));
    c.render();
  }

  physics.update();
  chainWorld.update();
  
   for (int i = 0; i<DIM*2-1; i++) {
    VerletSpring2D s=physics.springs.get(i);
    stroke(200);   
    strokeWeight(1);
    line(s.a.x, s.a.y, s.b.x, s.b.y);
  }
  
   for (int i = physics.springs.size()-1; i>(physics.springs.size()-DIM*2+1); i--) {
    VerletSpring2D s=physics.springs.get(i);
    stroke(50);   
    strokeWeight(1);
    line(s.a.x, s.a.y, s.b.x, s.b.y);
  }
  /*
  for (Iterator i=physics.springs.iterator(); i.hasNext();) {
    VerletSpring2D s=(VerletSpring2D)i.next();
    stroke(140);   
    strokeWeight(1);
    line(s.a.x, s.a.y, s.b.x, s.b.y);
  } */
 
}

