/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.exceptions;

/**
 *
 * @author rabasco
 */
public class UnauthorizedUserException extends BaseException {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public UnauthorizedUserException() {
        this.error = "UNAUTHORIZED_USER_EXCEPTION";
    }
}
