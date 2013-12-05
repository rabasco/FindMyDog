/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.exceptions;

/**
 *
 * @author rabasco
 */
public class SignNotFoundException extends BaseException {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public SignNotFoundException() {
        this.error = "SIGN_NOT_FOUND_EXCEPTION";
    }
}
