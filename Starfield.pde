Particle[] sparks = new Particle[250];
double originX, originY;
int burstHue;
double targetX, targetY;
int launchTime;
int flash = 0;
boolean flying = false;

void setup()
{
  size(500, 500);
  colorMode(HSB, 255);
  background(0);
  textAlign(CENTER);
  textSize(16);
}

void draw()
{
  noStroke();
  fill(0, 25);
  rect(0, 0, width, height);

  if (sparks[0] == null)
  {
    fill(255);
    text("click anywhere", width / 2, height / 2);
  }

  if (flying)
  {
    steerRocket();
  }

  if (flash > 0)
  {
    noStroke();
    fill(255, flash * 20);
    ellipse((float)originX, (float)originY, (8 - flash) * 30 + 20, (8 - flash) * 30 + 20);
    flash--;
  }

  for (int i = 0; i < sparks.length; i++)
  {
    if (sparks[i] != null)
    {
      sparks[i].move();
      sparks[i].show();
    }
  }

  drawCity();
}

void mousePressed()
{
  for (int i = 0; i < sparks.length; i++)
  {
    sparks[i] = null;
  }
  targetX = mouseX;
  targetY = constrain(mouseY, 40, height - 150);
  originX = Math.random() * width;
  originY = height;
  burstHue = 10;
  sparks[0] = new Particle();
  sparks[0].myAngle = Math.atan2(targetY - originY, targetX - originX) + (Math.random() - 0.5) * 0.8;
  sparks[0].mySpeed = 6;
  launchTime = frameCount;
  flying = true;
}

void steerRocket()
{
  double dx = targetX - sparks[0].myX;
  double dy = targetY - sparks[0].myY;
  if (Math.sqrt(dx * dx + dy * dy) < 10 || frameCount - launchTime > 120)
  {
    explode();
  }
  else
  {
    double diff = Math.atan2(dy, dx) - sparks[0].myAngle;
    while (diff > Math.PI)
    {
      diff -= 2 * Math.PI;
    }
    while (diff < -Math.PI)
    {
      diff += 2 * Math.PI;
    }
    sparks[0].myAngle += diff * 0.05;
  }
}

void explode()
{
  originX = sparks[0].myX;
  originY = sparks[0].myY;
  burstHue = (int)(Math.random() * 256);
  for (int i = 0; i < sparks.length; i++)
  {
    if (i < 12)
    {
      sparks[i] = new Oddball();
    }
    else
    {
      sparks[i] = new Particle();
      if (i < 156)
      {
        int ring = (i - 12) / 48;
        int k = (i - 12) % 48;
        sparks[i].myAngle = k * 2 * Math.PI / 48 + ring * 0.065;
        sparks[i].mySpeed = 2.5 + ring;
        sparks[i].myColor = color((burstHue + ring * 20) % 256, 200, 255);
      }
    }
  }
  flash = 8;
  flying = false;
}

void drawCity()
{
  noStroke();
  fill(150, 150, 30);
  for (int x = 0; x < width; x += 50)
  {
    rect(x, height - 40 - (x * 37) % 70, 50, 200);
  }
}

class Particle
{
  double myX, myY, myAngle, mySpeed;
  int myColor;

  Particle()
  {
    myX = originX;
    myY = originY;
    myAngle = Math.random() * 2 * Math.PI;
    mySpeed = Math.random() * 4 + 1;
    myColor = color((int)((burstHue + Math.random() * 40) % 256), 200, 255);
  }

  void move()
  {
    myX += Math.cos(myAngle) * mySpeed;
    myY += Math.sin(myAngle) * mySpeed;
    if (!flying)
    {
      mySpeed *= 0.975;
      myY += 0.3;
    }
  }

  void show()
  {
    float a = constrain((float)mySpeed * 60, 0, 255);
    noStroke();
    fill(myColor, a / 4);
    ellipse((float)myX, (float)myY, 10, 10);
    fill(myColor, a);
    ellipse((float)myX, (float)myY, (float)(Math.random() * 3 + 2), (float)(Math.random() * 3 + 2));
  }
}

class Oddball extends Particle
{
  Oddball()
  {
    mySpeed = Math.random() * 2 + 1;
    myColor = color(burstHue, 90, 255);
  }

  void move()
  {
    super.move();
    myY += 0.7;
  }

  void show()
  {
    float a = constrain((float)mySpeed * 100, 0, 255);
    float s = (float)(Math.random() * 4 + 4);
    stroke(myColor, a);
    strokeWeight(1);
    line((float)myX - s, (float)myY, (float)myX + s, (float)myY);
    line((float)myX, (float)myY - s, (float)myX, (float)myY + s);
    noStroke();
    fill(myColor, a);
    ellipse((float)myX, (float)myY, 3, 3);
  }
}
