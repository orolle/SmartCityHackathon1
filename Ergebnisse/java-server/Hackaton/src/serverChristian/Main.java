package serverChristian;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Main {

	public Main() {
		// TODO Auto-generated constructor stub
	}
	public static void main(String[] args) throws IOException {
		
        try {
            new WebSocketImpl().startClient();
        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            
        }
    }
}
