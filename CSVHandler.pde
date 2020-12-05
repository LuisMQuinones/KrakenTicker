 /*
 * @author      LuisMQuinones
 * @modified    DEC 4, 2020
 *
 * Need to handle exception better
 */


import java.io.FileReader;
class CSVHandler{
  
  String path;
  Table table;
  
  public CSVHandler(String p){
    path = p;
  }
  
  String[] getLastRow() {

    table = loadTable(path);
    
    int index = table.lastRowIndex();
    int col = table.getColumnCount();
    String s = table.getString(index,0);
    
    
    for(int i=1 ;i<col; i++){
     s+=","+table.getString(index,i); 
    }
    

   return s.split(",");     
    }  
}
 
 
  
  

  
