/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.urbanpulse.websockettest;

/**
 *
 * @author Christian Mueller <christian.mueller@the-urban-institute.de>
 */
import java.io.IOException;
import java.net.URI;
import java.util.concurrent.Future;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.WebSocketAdapter;
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest;
import org.eclipse.jetty.websocket.client.WebSocketClient;

public class WebSocketImpl {

    public void init() {

    }

    public static class ExampleSocket extends WebSocketAdapter {

        @Override
        public void onWebSocketText(String message) {
            System.out.println(message);
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
