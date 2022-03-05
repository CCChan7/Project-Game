class Enemy extends Entity
{
  int counter; // for animation

  private final PImage img1 = loadImage("enemy1.png");
  private final PImage img2 = loadImage("enemy2.png");
  private final PImage img3 = loadImage("enemy3.png");
  private final PImage img4 = loadImage("enemy4.png");

  Enemy(int x, int y) 
  {
    super(x, y);
  }

  void update()
  {
    move();
    render();
  }

  void move() 
  {
    x += random(0, 1);
    y -= random (2, 5);
  }

  void render() 
  {
    fill(0);
    if (counter < 10) 
    { 
      image(img1, x, y);
    } else if (counter < 20) 
    { 
      image(img2, x, y);
    } else if (counter < 30)
    { 
      image(img3, x, y);
    } else if (counter < 40)
    { 
      image(img4, x, y);
    } else
    { 
      image(img4, x, y); //resets animation
      counter=0;
    }
    counter++;
  }
}
