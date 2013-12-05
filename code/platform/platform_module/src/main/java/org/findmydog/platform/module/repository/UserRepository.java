/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import org.findmydog.platform.module.model.User;

/**
 *
 * @author rabasco
 */
public interface UserRepository {

    public String getApikey(String email, String secret) throws Exception;

    public User getUserByApikey(String apikey) throws Exception;

    public User getUserByEmail(String email) throws Exception;

    public User save(User user) throws Exception;
}
