public class Grid {
  Block[][] block;
  private final int COLS;
  private final int ROWS;
  private int score;
  
  public Grid(int cols, int rows) {
    COLS = cols;
    ROWS = rows;
    block = new Block[COLS][ROWS];
    initBlocks();  // initializes all blocks to empty blocks
  }
    
  public Block getBlock(int col, int row) {
    return block[col][row];
  }
  
  public void setBlock(int col, int row, int value, boolean changed) {
    block[col][row] = new Block(value, changed);
  }
  
  public void setBlock(int col, int row, int value) {
    setBlock(col, row, value, false);
  }
  
  public void setBlock(int col, int row) {
    setBlock(col, row, 0, false);
  }
  
  public void setBlock(int col, int row, Block b) {
    block[col][row] = b;
  }
  
  public void initBlocks() {
    // YOU WRITE THIS
    for(int row = 0; row < ROWS; row++){
      for(int col = 0; col < COLS; col++){
        block[col][row] = new Block();
      }
    }
  }
  
  public boolean isValid(int col, int row) {
    return((row < block[0].length && row >= 0) && (col < block.length && col >= 0));
  }
  
  public void swap(int col1, int row1, int col2, int row2) {
    if(isValid(col1, row1) && isValid(col2, row2)){
      Block temp = block[col1][row1];
      block[col1][row1] = block[col2][row2];
      block[col2][row2] = temp;
    }
  }
  
  public boolean canMerge(int col1, int row1, int col2, int row2) {
    // YOU WRITE THIS
    if(isValid(col1, row1) == false || isValid(col2, row2) == false){
      return false;
    }
    else if(block[col1][row1].getValue() == block[col2][row2].getValue()){
      return true;
    }
    else{
      return false;
    }
  }
  
  public void clearChangedFlags() {
    for(int col = 0; col < COLS; col++) {
      for(int row = 0; row < ROWS; row++) {
        block[col][row].setChanged(false);
      }
    }
  }
 
  // Is there an open space on the grid to place a new block?
  public boolean canPlaceBlock() {
    ArrayList<Location> empties = getEmptyLocations();
    if(empties.size() > 0){
      return true;
    }
    else{
    return false;
    }
  }
  
  public ArrayList<Location> getEmptyLocations() {
    // Put all locations that are currently empty into locs
    // YOU WRITE THIS
    ArrayList<Location> locs = new ArrayList<Location>();
    for(int row = 0; row < ROWS; row++){
      for(int col = 0; col < COLS; col++){
        if(block[col][row].getValue() == 0){
          locs.add(new Location(col, row));
        }
      }
    }
    return locs;
  }
  
  public Location selectLocation(ArrayList<Location> locs) {
    // YOU WRITE THIS
    int size = locs.size();
    int rand = (int) (Math.random() * size);
    return locs.get(rand);
  }
  
  // Randomly select an open location to place a block.
  public void placeBlock() {
    // YOU WRITE THIS
    double val = Math.random();
    if(val >= 0.875){
      val = 4;
    }
    else{
      val = 2;
    }
    ArrayList<Location> locs = getEmptyLocations();
    Location loc = selectLocation(locs);
    Block x = new Block((int) val, false);
    block[loc.getCol()][loc.getRow()] = x;
  }
  
  // Are there any adjacent blocks that contain the same value?
  public boolean hasCombinableNeighbors() {
    boolean ret = false;
    int row;
    int col;
    for(row = 0; row < ROWS; row++){
      for(col = 0; col < COLS; col++){
        if((canMerge(col, row, col, row + 1)) ||
          (canMerge(col, row, col, row - 1)) ||
          (canMerge(col, row, col + 1, row)) ||
          (canMerge(col, row, col - 1, row))){
            ret = true;
          }
      }
    }
    return ret;
  }
   
  // Notice how an enum can be used as a data type
  //
  // This is called ) method  the KeyEvents tab
  public boolean someBlockCanMoveInDirection(DIR dir) {
    // YOU WRITE THIS
    boolean ret = false;
    if(dir == DIR.NORTH){
      for(int row = 0; row < ROWS; row++){
        for(int col = 0; col < COLS; col++){
          if(isValid(col, row - 1) && block[col][row].getValue() != 0){
            if(block[col][row - 1].isEmpty() || canMerge(col, row, col, row - 1)){
              ret = true;
            }
          }
        }
      }
    }
    if(dir == DIR.EAST){
      for(int row = 0; row < ROWS; row++){
        for(int col = 0; col < COLS; col++){
          if(isValid(col + 1, row) && block[col][row].getValue() != 0){
            if(block[col + 1][row].isEmpty() || canMerge(col, row, col + 1, row)){
              ret = true;
            }
          }
        }
      }
    }
    if(dir == DIR.SOUTH){
      for(int row = 0; row < ROWS; row++){
        for(int col = 0; col < COLS; col++){
          if(isValid(col, row + 1) && block[col][row].getValue() != 0){
            if(block[col][row + 1].isEmpty() || canMerge(col, row, col, row + 1)){
              ret = true;
            }
          }
        }
      }
    }
    if(dir == DIR.WEST){
      for(int row = 0; row < ROWS; row++){
        for(int col = 0; col < COLS; col++){
          if(isValid(col - 1, row) && block[col][row].getValue() != 0){
            if(block[col - 1][row].isEmpty() || canMerge(col, row, col - 1, row)){
              ret = true;
            }
          }
        }
      }
    }
    return ret;
  }
  
  // Computes the number of points that the player has scored
  public void computeScore() {
    int sc = 0;
    for(int row = 0; row < ROWS; row++){
      for(int col = 0; col < COLS; col++){
        sc += block[col][row].getValue();
      }
    }
    score = sc;
  }
  
  public int getScore() {
    return score;
  }
  
  public void showScore() {
      textFont(scoreFont);
      fill(#000000);
      text("Score: " + getScore(), width/2, SCORE_Y_OFFSET);
      textFont(blockFont);
  }
  
  public void showBlocks() {
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        Block b = block[col][row];
        if (!b.isEmpty()) {
          float adjustment = (log(b.getValue()) / log(2)) - 1;
          fill(color(242 , 241 - 8*adjustment, 239 - 8*adjustment));
          rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
          fill(color(108, 122, 137));
          text(str(b.getValue()), GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col + BLOCK_SIZE/2, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row + BLOCK_SIZE/2 - Y_TEXT_OFFSET);
        } else {
          fill(BLANK_COLOR);
          rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
        }
      }
    }
  }
  
  // Copy the contents of another grid to this one
  public void gridCopy(Grid other) {
    // YOU WRITE THIS
    for(int row = 0; row < ROWS; row++){
      for(int col = 0; col < COLS; col++){
        block[row][col] = other.block[row][col];
      }
    }
  }
  
  public boolean isGameOver() {
    // YOU WRITE THIS
    boolean hasEmpty = false;
    ArrayList<Location> empties = getEmptyLocations();
    if(empties.size() != 0){
      hasEmpty = true;
    }
    boolean hasCombinable = hasCombinableNeighbors();
    if(hasEmpty == false && hasCombinable == false){
      return true;
    }
    else{
      return false;
    }
  }
  
  public void showGameOver() {
    fill(#0000BB);
    text("GAME OVER", GRID_X_OFFSET + 2*BLOCK_SIZE + 15, GRID_Y_OFFSET + 2*BLOCK_SIZE + 15);
  }
  
  //public String toString() {
  //  String str = "";
  //  for (int row = 0; row < ROWS; row++) {
  //    for (int col = 0; col < COLS; col++) {
  //      str += block[col][row].getValue() + " ";
  //    }
  //    str += "\n";   // "\n" is a newline character
  //  }
  //  return str;
  //}
}