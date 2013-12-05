/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.exceptions;

/**
 *
 * @author rabasco
 */
public class PetNotFoundException extends BaseException {

    public PetNotFoundException() {
        this.errorString = "PET_NOT_FOUND_EXCEPTION";
    }
}
