class Manager{
  String file_name;
  String file_extension;
  String root_directory;
  String[] filenames;
  
  Manager(String in_root_directory, String in_file_name, String in_file_extension){
    file_name = in_file_name;
    file_extension = in_file_extension;
    root_directory = in_root_directory;
    filenames = listFileNames(root_directory);
  }
  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
  
  String currentCounter(){
    int counter = 0;
    String expression = file_name+"(.*?)"+file_extension;
    
    for(int i = 0; i < filenames.length; i++){
      String[] matches = match(filenames[i], expression);
      if (matches != null){
        counter = max(counter,parseInt(matches[1]));
      }
    }
    String return_counter = nf(counter+1, 5);
    return return_counter;
  }
  
}