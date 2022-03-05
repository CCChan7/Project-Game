Character player;
PImage backGround;
Mode gamemode;
int bgY = 0;
PVector playerSpeed;
float maxSpeed = 3; //speed of player
int spawntimer = 0; // counts up as soon as the program runs
int lives = 3; //start amount of lives
int score = 0; //start score
int time;
int wait = 1000; // 1 second in milliseconds
int ingametimer = 60;
int difficultymodifier = 0;

ArrayList<Enemy> enemylist = new ArrayList(); //list containing enemies
ArrayList <Bullet> bulletlist = new ArrayList(); //list containing bullets
ArrayList<Coins> coinlist = new ArrayList(); //list containing coin collectables
ArrayList<TimeBoost> timelist = new ArrayList(); //list containing time boosters
ArrayList<Life> lifelist = new ArrayList(); //list containing life up boosters

public enum ChangeMode //contains game modes
{
  START, PLAY, END;
}

void setup() 
{
  fill(0);
  size(600, 600); //size of window screen
  time = millis(); //ellapsed time in milliseconds
  backGround = loadImage("background.png");
  backGround.resize(width, height);
  gamemode = new Mode();
  player = new Character(width/2, 60);
  player.position = new PVector(width/2, 60);
  playerSpeed = new PVector();
  noCursor(); //used for smooth mouse movement
  noStroke();
  smooth();
} 

void modes()
{
  splashscreen(); //always starts game at the splash screen
  if (keyCode == ENTER) //changes game mode to play when the user presses enter key
  {
    gamemode.currentmode =  ChangeMode.PLAY;
  } 

  if (gamemode.currentmode == ChangeMode.PLAY)
  {
    playinggame();
  }

  if (lives == 0 || ingametimer == 0 || score < 0) //game ends when there are no more lives or the player runs out of time
  {
    gamemode.currentmode = ChangeMode.END;
  }
  if (gamemode.currentmode == ChangeMode.END)
  {
    gameover();
  }
}

void draw()
{   
  modes();
}

void splashscreen() //shows splash screen with instructions on how to play the game
{  
  background(200);
  fill(0);
  textSize(15);
  text("The main goal of the game is to get as high score as you can before time runs", 5, 50);
  text("out whilest avoiding enemies.", 5, 70);
  text("You have 3 lives to begin with, if you touch an enemy you lose lifes and score", 5, 90);
  text("but you can more lives through the life collectable.", 5, 110);
  text("You can extend the time you have by collecting time boosts.", 5, 130);
  text("You can shoot enemies by clicking where your mouse is hovering.", 5, 150);
  text("Use the arrow keys to move around.", 5, 170);
  text("The game will get harder the more time has passed.", 5, 190);
  text("Press Enter to start playing.", 5, 210);
}

void gameover()
{
  background(200);
  fill(0);
  text("Game Over", width/2, height/2); //shows game over
  if (score > 0)
  {
    text("Score: " + score, width/2, height/2 + 20); //shows score at end of game
  } else
  {
    text("Score: 0", width/2, height/2 + 20); //shows score at end of game
  }
}

void playinggame()
{
  drawBackground();
  update();
  starttimer();
  difficulty();
  player.position.add(playerSpeed);
  fill(200, 200, 200);
  ellipse(player.position.x, player.position.y, 25, 25); //draws player model
  fill(0, 0, 255);
  ellipse(player.position.x, player.position.y, 10, 10);
  PVector mouse = new PVector(mouseX, mouseY);
  fill(255);
  ellipse(mouse.x, mouse.y, 5, 5); //draws mouse cursor
  if (frameCount%5==0 && mousePressed)
  {
    PVector direction = PVector.sub(mouse, player.position);
    direction.normalize();
    direction.mult(maxSpeed*3); //projectile speed based off of how fast the player can move
    Bullet fire = new Bullet(player.position, direction); //fires from where the player is and where the player is pointing
    bulletlist.add(fire);
  }

  for (Bullet fire : bulletlist)
  {
    fire.update();
    fire.display();
  }
  fill(200); //displays lives, score, difficulty level and time left
  text("Lives: " + lives, 50, 50);
  text("Score: " + score, 50, 65);
  text("Time Left:  " + ingametimer, 50, 80);
  if (difficultymodifier == 0)
  {
    text("Difficulty: EASY", 50, 95);
  } else if (difficultymodifier == 1)
  {
    text("Difficulty: NORMAL", 50, 95);
  } else if (difficultymodifier <= 2)
  {
    text("Difficulty: HARD", 50, 95);
  }
}

void update()
{
  spawntimer++; // increments every second
  spawn(); //spawns in enemies and boosts
  for (int i = 0; i < enemylist.size(); i++)
  {
    Enemy currentenemy = enemylist.get(i);
    currentenemy.update(); 
    if (enemycollision(currentenemy) || currentenemy.y > 600) //removes at top of screen or when the player collides
    {
      enemylist.remove(i);
      lives -= 1; 
      //when the player gets hit by an enemylives so dont get hit
    }
    for (Bullet fire : bulletlist) 
    {
      //finds whether the distance between the bullets in the bulletlist are 75 pixels (enemy width and height) close to each other
      if (dist(currentenemy.x, currentenemy.y, fire.x, fire.y) < 75)
      {
        //removes the enemy
        enemylist.remove(currentenemy);
        score += 1; //when enemy is shot score goes up by 1
      }
    }
  }
  for (int j = 0; j < coinlist.size(); j++)
  {
    Coins currentcoin = coinlist.get(j);
    currentcoin.update(); 
    if (coincollision(currentcoin) || currentcoin.y > 600) //removes at top of screen or when the player collides
    {
      coinlist.remove(j);
      score += 10; //when collected coin adds to score
    }
  }
  for (int k = 0; k < timelist.size(); k++)
  {
    TimeBoost currentTB= timelist.get(k);
    currentTB.update(); 
    if (TBcollision(currentTB) || currentTB.y > 600) //removes at top of screen or when the player collides
    {
      timelist.remove(k);
      ingametimer += 10; //when collected adds 10 seconds to countdown
    }
  }
  for (int l = 0; l < lifelist.size(); l++)
  {
    Life currentlife= lifelist.get(l);
    currentlife.update(); 
    if (lifecollision(currentlife) || currentlife.y > 600) //removes at top of screen or when the player collides
    {
      lifelist.remove(l);
      lives += 1; //when collected adds one more life
    }
  }
}

void spawn()
{
  //spawntimer for enemies and objects ingame
  //spawn rates are based on difficulty modifier
  if (difficultymodifier == 0)
  {
    if (spawntimer % 40 == 0) 
    {
      enemylist.add(new Enemy((int)random(600), height )); //randomly generates enemies by adding to list from bottom of screen
    }
    if (spawntimer % 200 == 0) 
    {
      timelist.add(new TimeBoost((int)random(600), height )); //randomly generates time boosts by adding to list from bottom of screen
      lifelist.add(new Life((int)random(600), height )); //randomly generates life up boosts by adding to list from bottom of screen
    }
    if (spawntimer % 100 == 0)
    {
      coinlist.add(new Coins((int)random(600), height )); //randomly generates coin collectables by adding to list from bottom of screen
    }
  } else if (difficultymodifier == 1)
  {
    if (spawntimer % 30 == 0) 
    {
      enemylist.add(new Enemy((int)random(600), height )); //randomly generates enemies by adding to list from bottom of screen
    }
    if (spawntimer % 400 == 0) 
    {
      timelist.add(new TimeBoost((int)random(600), height )); //randomly generates time boosts by adding to list from bottom of screen
      lifelist.add(new Life((int)random(600), height )); //randomly generates life up boosts by adding to list from bottom of screen
    }
    if (spawntimer % 200 == 0)
    {
      coinlist.add(new Coins((int)random(600), height )); //randomly generates coin collectables by adding to list from bottom of screen
    }
  } else if (difficultymodifier == 2)
  {
    if (spawntimer % 20 == 0) 
    {
      enemylist.add(new Enemy((int)random(600), height )); //randomly generates enemies by adding to list from bottom of screen
    }
    if (spawntimer % 600 == 0) 
    {
      timelist.add(new TimeBoost((int)random(600), height )); //randomly generates time boosts by adding to list from bottom of screen
      lifelist.add(new Life((int)random(600), height )); //randomly generates life up boosts by adding to list from bottom of screen
    }
    if (spawntimer % 300 == 0)
    {
      coinlist.add(new Coins((int)random(600), height )); //randomly generates coin collectables by adding to list from bottom of screen
    }
  }
}

void drawBackground()
{
  image(backGround, 0, bgY); //draws background twice
  image(backGround, 0, bgY+backGround.height);
  bgY -=4; //move background 4 pixels downwards
  if (bgY == -backGround.height) 
  {
    bgY= 0; //resets the background
  }
}

void difficulty()
{
  if (spawntimer == 3000)
  {
    difficultymodifier += 1; //if 30 seconds pass difficulty increases
  }
  if (spawntimer == 6000)
  {
    difficultymodifier += 1; //if 60 seconds pass difficulty increases
  }
  if (spawntimer == 12000)
  {
    difficultymodifier += 1; //if 120 seconds pass difficulty increases
  }
}

void starttimer()
{
  if (millis() - time >= wait) //detects whenever a second passes and increments the gametime value by 1
  {
    ingametimer--; //subtracks from countdown timer
    time = millis(); //resets the loop so it will always run
  }
}

boolean enemycollision(Enemy enemy) //returns value when player model collides with enemy model
{
  return abs(player.position.x-enemy.x) < 66 && abs(player.position.y - enemy.y) < 66;
}

boolean coincollision(Coins coins)  //returns value when player model collides with coin model
{
  return abs(player.position.x-coins.x) < 50 && abs(player.position.y - coins.y) < 50;
}

boolean TBcollision(TimeBoost time)  //returns value when player model collides with time boost model
{
  return abs(player.position.x-time.x) < 32 && abs(player.position.y - time.y) < 32;
}

boolean lifecollision(Life life)  //returns value when player model collides with life UP model
{
  return abs(player.position.x-life.x) < 20 && abs(player.position.y - life.y) < 20;
}

void keyPressed() 
{
  if (keyCode == UP)    
  {
    playerSpeed.y = -maxSpeed; //moves player up
  }
  if (keyCode == DOWN) 
  { 
    playerSpeed.y = maxSpeed; //moves player down
  }
  if (keyCode == LEFT) 
  { 
    playerSpeed.x = -maxSpeed; //moves player left
  }
  if (keyCode == RIGHT)
  { 
    playerSpeed.x = maxSpeed; //moves player right
  }
}

void keyReleased()
{
  if (keyCode == UP || keyCode == DOWN)  
  {
    playerSpeed.y = 0; //stops the player moving vertically as soon as up or down has been released
  }
  if (keyCode == LEFT || keyCode == RIGHT) 
  { 
    playerSpeed.x = 0; //stops the player moving horizontally as soon as the left or right key has been released
  }
}
