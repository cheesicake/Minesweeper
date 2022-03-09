import de.bezier.guido.*;
private final static int NUM_ROWS = 20,
                         NUM_COLS = 20,
                         NUM_BOMBS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i=0; i<NUM_ROWS; i++){
      for (int j=0; j<NUM_COLS; j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }
    for (int k=0; k<NUM_BOMBS; k++)
      setMines(); 
}
public void setMines()
{
    //your code
    int r = (int)(random(NUM_ROWS));
    int c = (int)(random(NUM_COLS));
    if (!mines.contains(buttons[r][c])) mines.add(buttons[r][c]);
}

public void draw ()
{
    background( 0 );
    if (isWon() == true) 
      displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    //for (MSButton bomb: mines)
    //  if (!mines.contains(bomb) && !bomb.clicked) return false;
    //return true;
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int j=0; j<NUM_COLS; j++){
        String message = "      You lose   ";
        buttons[10][j].setLabel(message.charAt(j) + "");
        buttons[10][j].draw();
    }
    //noLoop();
}
public void displayWinningMessage()
{
    //your code here
    for(int j=0; j<NUM_COLS; j++){
        String message = "      You win    ";
        buttons[10][j].setLabel(message.charAt(j) + "");
        buttons[10][j].draw();
    }
}
public boolean isValid(int r, int c)
{
    //your code here
    return r>=0 && c>=0 && r<NUM_ROWS && c<NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int i=row-1; i<=row+1; i++){
      for (int j=col-1; j<=col+1; j++){
        if (isValid(i,j) && mines.contains(buttons[i][j])) numMines++;
      }
    }
    if (mines.contains(buttons[row][col])) numMines--;
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
      if (mouseButton == RIGHT){
          flagged = !flagged;
          if (!flagged) clicked = false;
        }
        else if (mines.contains(this)){
          clicked = true;
          for (MSButton bomb: mines)
              if (mines.contains(bomb)) bomb.clicked=true;
          displayLosingMessage();
        } 
        else if (countMines(myRow, myCol) > 0){
          clicked = true;
          setLabel("" + countMines(myRow, myCol));
        } else {
          clicked = true;
          for(int i = myRow-1; i<=myRow+1; i++){
            for(int j = myCol-1; j<=myCol+1; j++){
              if(isValid(i, j) && !buttons[i][j].clicked){
                buttons[i][j].mousePressed();
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(0,255,0);
        else if(clicked)
            fill( 255 );
        else 
            fill( 150 );

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
