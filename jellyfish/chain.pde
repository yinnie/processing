
class Chain {

  VerletSpring2D[] springs;
  VerletParticle2D[] particles;
  VerletParticle2D chainHead;
  int numParticles;
  float springLength;
  float springStrength;
  int radius;

  Chain(int x, float y, float z) {
    numParticles = x;
    springLength = y;
    springStrength = z;
    particles = new VerletParticle2D[x];
    springs = new VerletSpring2D[x-1];
    radius = 2;

    for (int i = 0; i<numParticles; i++) {
      particles[i] = new VerletParticle2D (width/2, height/3);
      chainWorld.addParticle(particles[i]);
    } 

    for (int i = 0; i<numParticles-1; i++) {
      springs[i] = new VerletSpring2D (particles[i], particles[i+1], springLength, springStrength);
      chainWorld.addSpring(springs[i]);
    }

    chainHead = particles[0];
    chainHead.lock();  
  }

  void render() {   
    
    for ( int i = 0; i<numParticles-1; i++) {
      stroke(255-i*20);
      line(particles[i].x, particles[i].y, particles[i+1].x, particles[i+1].y);
    }
    /*
     for ( int i = 0; i<numParticles; i++) {
       color(255);
    stroke(0.001);
    ellipse(particles[i].x, particles[i].y, radius*2, radius*2);
     }
     */
    
  }

}




