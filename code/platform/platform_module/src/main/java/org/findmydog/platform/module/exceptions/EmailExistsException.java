/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.exceptions;

/**
 *
 * @author rabasco
 */
public class EmailExistsException extends BaseException {

    public EmailExistsException() {
        this.errorString = "EMAIL_EXISTS_EXCEPTION";
    }
}
