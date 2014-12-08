package serverChristian;

import java.io.IOException;
import java.net.URI;
import java.util.concurrent.Future;

import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.WebSocketAdapter;
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest;
import org.eclipse.jetty.websocket.client.WebSocketClient;

public class WebSocketImpl {
	static Writer writer = new Writer();
	public void init() {

    }

    public static class ExampleSocket extends WebSocketAdapter {

        @Override
        public void onWebSocketText(String message) {
            System.out.println(message);
           // System.out.println("logger war aktiv");
            try {
				writer.save(message);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
    }

  

    public void startClient() throws Exception {
    	
        WebSocketClient client = new WebSocketClient();
        try {
            client.start();
            ClientUpgradeRequest request = new ClientUpgradeRequest();
            request.setSubProtocols("xsCrossfire");
            
            

            URI wsUri = URI.create("ws://192.168.0.101:8282");

            ExampleSocket socket = new ExampleSocket();
            
            Future<Session> future = client.connect(socket, wsUri, request);

            future.get(); // wait for conn
            while(true) {
                
            }
           
        } finally {
            client.stop();
        }
    }

}
