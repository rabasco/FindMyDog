/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.exceptions;

/**
 *
 * @author rabasco
 */
public class UsernameExistsException extends BaseException {

    public UsernameExistsException() {
        this.errorString = "USERNAME_EXISTS_EXCEPTION";
    }
}
