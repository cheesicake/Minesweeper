import de.bezier.guido.*;
public final static int NUM_ROWS = 10;//Declared and initialized constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_COLS = 10;
public final static int NUM_BOMBS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int n = 0; n < NUM_COLS; n++){
        buttons[i][n] = new MSButton(i, n);
      }
    }
    
    setMines();
}
public void setMines()
{
  while(mines.size()<NUM_BOMBS){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
        System.out.println(r+", "+c);
      }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int i = 0; i<NUM_ROWS; i++){
      for(int n = 0; n<NUM_COLS; n++){
        if(mines.contains(buttons[i][n]))
        return true;
      }
    }
    return false;
}
public void displayLosingMessage()
{
    textSize(15);
    buttons[NUM_ROWS/2][NUM_COLS/2].myLabel = "LOST";
    noLoop();
}
public void displayWinningMessage()
{
    if(isWon())
    text("you win", 100, 100);
}
public boolean isValid(int r, int c)
{
    if(r>=0 && r<NUM_ROWS && c >=0 && c < NUM_COLS){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i<=row+1; i++){
      for(int n = col-1; n<=col+1; n++){
        if(isValid(i, n)&&mines.contains(buttons[i][n]))
        numMines++;
      }
    }
    if(mines.contains(buttons[row][col])){
      numMines--;
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT&&!buttons[myRow][myCol].clicked){
          flagged = !flagged;
        }
        if(flagged == true){
          clicked = false;
        }else if(mines.contains(this)){
          displayLosingMessage();
          
        }else if(countMines(myRow, myCol)>0){
          myLabel = countMines(myRow, myCol)+"";
        }else{
          if (isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].clicked)
            buttons[myRow-1][myCol].mousePressed();
          if (isValid(myRow-1,myCol-1) && !buttons[myRow-1][myCol-1].clicked)
            buttons[myRow-1][myCol-1].mousePressed();
          if (isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].clicked)
            buttons[myRow-1][myCol+1].mousePressed();
          if (isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].clicked)
            buttons[myRow][myCol-1].mousePressed();
          if (isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].clicked)
            buttons[myRow+1][myCol-1].mousePressed();
          if (isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].clicked)
            buttons[myRow+1][myCol].mousePressed();
          if (isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].clicked)
            buttons[myRow+1][myCol+1].mousePressed();
          if (isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].clicked)
            buttons[myRow][myCol+1].mousePressed();
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(127, 224, 85);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
