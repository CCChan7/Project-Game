class Bullet extends PVector //inherits from premade PVector function
{
  PVector velocity;

  Bullet(PVector location, PVector velocity) 
  {
    super(location.x, location.y);
    this.velocity = velocity.get();
  }

  void update()
  {
    add(velocity); //updates based on velocity of bullet based off where the player shoots the bullet
  }

  void display() 
  {
    fill(255, 0, 0);
    ellipse(x, y, 5, 5);
  }
}
