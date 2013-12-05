/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.exceptions;

/**
 *
 * @author rabasco
 */
public class FileNotFoundException extends BaseException {

    public FileNotFoundException() {
        this.errorString = "FILE_NOT_FOUND_EXCEPTION";
    }
}
