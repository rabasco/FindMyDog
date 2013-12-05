/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.exceptions;

/**
 *
 * @author rabasco
 */
public class BaseException extends Exception {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected String error = "";
    
    @Override
    public String getMessage() {
        
        if (error.length() > 0)
            return "{\"error\":\"" + error + "\"}";
        else 
            return "";
        
    }
    
    @Override
    public String getLocalizedMessage() {
        return getMessage();
    }
    
}
