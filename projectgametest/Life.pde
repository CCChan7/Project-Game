class Life extends Objects
{
  PImage img = loadImage ("life.png");

  Life(int x, int y)
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
    image(img, x, y);
  }
}
