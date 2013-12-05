/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.util;

/**
 *
 * @author rabasco
 */
public class JSONFormatter {
    
    public static String formatString(String varName, String varValue) {
    
        return "{\"" + varName + "\":\"" + varValue + "\"}";
    }
    
}
