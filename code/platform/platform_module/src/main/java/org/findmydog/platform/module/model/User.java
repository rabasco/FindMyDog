/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 *
 * @author rabasco
 */
@Document(collection = "users")
public class User {

    @Id
    private String id;
    @Indexed(unique = true)
    private String username;
    @Indexed(unique = true)
    private String email;
    private String apiKey;
    private String secret;    

    /**
     *
     * @param username
     * @param email
     * @param password
     */
    public User(String username, String email, String secret, String apiKey) {
        this.username = username;
        this.email = email;
        this.secret = secret;
        this.apiKey = apiKey;
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the secret
     */
    public String getSecret() {
        return secret;
    }

    /**
     * @param secret the secret to set
     */
    public void setSecret(String secret) {
        this.secret = secret;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the apikey
     */
    public String getApiKey() {
        return apiKey;
    }

    /**
     * @param apikey the apikey to set
     */
    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }
}
