/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.findmydog.platform.module.model.User;
import org.findmydog.platform.module.repository.UserRepository;
import org.findmydog.platform.services.security.SecurityPolicy;
import org.findmydog.platform.services.util.JSONFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author rabasco
 */
@Controller
@RequestMapping(value = "/users")
public class UserController extends SecureController {

    @Autowired
    private UserRepository userRepository;

    @RequestMapping(value = "/apikey/", method = RequestMethod.GET, produces = "application/json")
    public @ResponseBody
    String getAPIkey(@RequestParam("email") String email) throws JsonProcessingException {

        try {
            User user = userRepository.getUserByEmail(email);

            checkSign(user);

            return JSONFormatter.formatString("apikey", user.getApiKey());

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    String register(@RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("secret") String secret) {

        try {

            String apikey = SecurityPolicy.generateAPIkey(email, secret);

            User user = new User(username, email, secret, apikey);

            user = userRepository.save(user);

            return JSONFormatter.formatString("apikey", user.getApiKey());

        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
