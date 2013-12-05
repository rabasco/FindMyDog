/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import org.findmydog.platform.services.security.SecurityPolicy;
import org.findmydog.platform.services.util.JSONFormatter;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 *
 * @author rabasco
 */
@RunWith(SpringJUnit4ClassRunner.class)
public class UserControllerTest extends MongoControllerTest {

    //==========================================================================
    // getAPIkey
    //==========================================================================
    @Test
    public void testGetAPIkey() throws Exception {

        String url = "/users/apikey/?email=" + signedUser.getEmail();
        String response = JSONFormatter.formatString("apikey", signedUser.getApiKey());

        mockMvc.perform(
                get(getSignedUrl(url))
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(response));
    }

    @Test
    public void testGetAPIKeyUserNotFound() throws Exception {

        String url = "/users/apikey/?email=notexists@findmydog.org";
        String response = JSONFormatter.formatString("error", "USER_NOT_FOUND_EXCEPTION");

        mockMvc.perform(
                get(getSignedUrl(url))
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(response));
    }

    //==========================================================================
    // register
    //==========================================================================
    @Test
    public void testRegister() throws Exception {

        String email = "new@findmydog.org";
        String secret = "12345";

        String response = JSONFormatter.formatString("apikey", SecurityPolicy.generateAPIkey(email, secret));

        mockMvc.perform(
                post("/users/")
                .accept(MediaType.APPLICATION_JSON)
                .param("username", "new")
                .param("email", email)
                .param("secret", secret))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(response));
    }

    @Test
    public void testRegisterUsernameExists() throws Exception {

        String response = JSONFormatter.formatString("error", "USERNAME_EXISTS_EXCEPTION");

        mockMvc.perform(
                post("/users/")
                .accept(MediaType.APPLICATION_JSON)
                .param("username", signedUser.getUsername())
                .param("email", "test2@findmydog.org")
                .param("secret", "12345"))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(response));
    }

    @Test
    public void testEmailExists() throws Exception {

        String response = JSONFormatter.formatString("error", "EMAIL_EXISTS_EXCEPTION");

        mockMvc.perform(
                post("/users/")
                .accept(MediaType.APPLICATION_JSON)
                .param("username", "test2")
                .param("email", signedUser.getEmail())
                .param("secret", "12345"))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(response));
    }
}
