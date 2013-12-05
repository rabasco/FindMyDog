/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.exceptions;

/**
 *
 * @author rabasco
 */
public class APIKeyNotFoundException extends BaseException {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public APIKeyNotFoundException() {
        this.error = "APIKEY_NOT_FOUND_EXCEPTION";
    }
}
