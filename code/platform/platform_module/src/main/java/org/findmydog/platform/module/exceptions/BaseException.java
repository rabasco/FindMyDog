/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.exceptions;

/**
 *
 * @author rabasco
 */
public class BaseException extends Exception {
    
    protected String errorString = "";
    
    @Override
    public String getMessage() {
        
        if (errorString.length() > 0)
            return "{\"error\":\"" + errorString + "\"}";
        else 
            return "";
        
    }
    
    @Override
    public String getLocalizedMessage() {
        return getMessage();
    }
    
}
