/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import org.findmydog.platform.module.exceptions.EmailExistsException;
import org.findmydog.platform.module.exceptions.UserNotFoundException;
import org.findmydog.platform.module.exceptions.UsernameExistsException;
import static org.junit.Assert.*;

import org.findmydog.platform.module.model.User;
import org.junit.Test;

/**
 *
 * @author rabasco
 */
public class UserRepositoryMongoImplTest extends MongoEnvironmentTest {

    //==========================================================================
    // getApikey
    //==========================================================================
    @Test
    public void testGetApikey() throws Exception {

        String email = "email@email.com";
        String secret = "1234";
        User user = new User("username", email, secret, "apikey");
        userRepository.save(user);

        String apiKey = userRepository.getApikey(email, secret);

        assertEquals(apiKey, "apikey");
    }

    @Test
    public void testGetApikeyUserNotFound() throws Exception {

        thrown.expect(UserNotFoundException.class);

        userRepository.getApikey("email@email.coom", "1234");
    }

    //==========================================================================
    // getUserByApikey
    //==========================================================================
    @Test
    public void testGetUserByApikey() throws Exception {

        User user = new User("username", "email@email.com", "1234", "apikey");
        user = userRepository.save(user);

        User savedUser = userRepository.getUserByApikey("apikey");

        assertEquals(user.getId(), savedUser.getId());
    }

    @Test
    public void testGetUserByApikeyNotFound() throws Exception {

        thrown.expect(UserNotFoundException.class);

        userRepository.getUserByApikey("apikey");
    }

    //==========================================================================
    // getUserByEmail
    //==========================================================================
    @Test
    public void testGetUserByEmail() throws Exception {

        User user = new User("username", "email@email.com", "1234", "apikey");
        user = userRepository.save(user);

        User savedUser = userRepository.getUserByEmail("email@email.com");

        assertEquals(user.getId(), savedUser.getId());
    }

    @Test
    public void testGetUserByEmailNotFound() throws Exception {

        thrown.expect(UserNotFoundException.class);

        userRepository.getUserByEmail("email@email.com");
    }

    //==========================================================================
    // save
    //==========================================================================
    @Test
    public void testSave() throws Exception {

        User user = new User("username", "email@email.com", "1234", "apikey");
        userRepository.save(user);

        int usersInCollection = template.findAll(User.class).size();

        assertEquals("Only 1 Sample should exist in collection, but there are "
                + usersInCollection, 1, usersInCollection);
    }

    @Test
    public void testSaveUsernameExists() throws Exception {

        thrown.expect(UsernameExistsException.class);

        userRepository.save(new User("username", "email2@email.com", "1234", "apikey"));
        userRepository.save(new User("username", "email@email.com", "1234", "apikey2"));
    }

    @Test
    public void testSaveEmailExists() throws Exception {

        thrown.expect(EmailExistsException.class);

        userRepository.save(new User("username", "email@email.com", "1234", "apikey"));
        userRepository.save(new User("username2", "email@email.com", "1234", "apikey2"));
    }
}
