package serverChristian;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

public class Writer {

	public Writer() {
		// TODO Auto-generated constructor stub
	}

	public void save(String ex) throws IOException{
		String[] split = ex.split(",");
		String end ="";
		if(ex.contains("SMARTCITY")){
			end = "SMARTCITY";
		}else if(ex.contains("Environment")){
			end = "Environment";
			}
		
		File log = new File("./log/log_"+end+".csv");

		String zeile= "";
	
		for(int i = 0; i < split.length; i++){
			if(i<10||i>12){
				if(i==1){
					zeile = zeile + (split[i].split(":")[1]+":"+split[i].split(":")[2]).replace("\"", "")+ ";";
				}else{
					zeile = zeile + split[i].split(":")[1].replace("\"", "").replace("}", "")+ ";";
				}
			}else{
				if(i==10){
					zeile = zeile + new Date().getTime()+ ";";
				}
			}
		}
		
		if(!log.exists()){
			log.createNewFile();
		}
		try {
			FileWriter writer = new FileWriter(log,true);
			BufferedWriter bufferWriter = new BufferedWriter(writer);
			bufferWriter.write(zeile + "\n");
			bufferWriter.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
