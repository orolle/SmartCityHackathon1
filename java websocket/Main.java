/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.urbanpulse.websockettest;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Christian Mueller <christian.mueller@the-urban-institute.de>
 */
public class Main {

    public static void main(String[] args) {
        try {
            new WebSocketImpl().startClient();
        } catch (Exception ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
