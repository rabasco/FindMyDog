/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.security;

import org.findmydog.platform.module.model.User;

/**
 *
 * @author rabasco
 */
public interface SecurityContext {

    public User getAutenticatedUser() throws Exception;
}
