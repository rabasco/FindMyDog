/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.exceptions;

/**
 *
 * @author rabasco
 */
public class UserNotFoundException extends BaseException {

    public UserNotFoundException() {
        this.errorString = "USER_NOT_FOUND_EXCEPTION";
    }
}
