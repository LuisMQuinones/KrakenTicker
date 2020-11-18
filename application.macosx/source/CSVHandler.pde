//Need to handle exception better

import java.io.FileReader;

class CSVHandler { 
  String pathToCSV;
  BufferedReader reader;
  FileReader fReader;
  public CSVHandler(String path) {
    pathToCSV = path;
    try {
      fReader = new FileReader(pathToCSV);
      reader = new BufferedReader(fReader);
    }
    catch(Exception e) {
      println("FileNotFound");
    }
  }

  //returns "" when last entry is empty
  String[] getLastRow() {
    // String [] lastRow = new String[9];

    String row="";
    String last="";
    try {    

      while ((row = reader.readLine()) != null)
      {
        last=row;
      }
      //lastRow = last.split(",");
    }  
    catch(Exception e) {
      println("Something went wrong"+e);
      println(pathToCSV);
    }
    return last.split(",");
  }
}
