/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.security;

import org.findmydog.platform.module.util.CryptoAlgorithms;

/**
 *
 * @author rabasco
 */
public class SecurityPolicy {

    private static final String APPSECRET = "UoI";

    public static String generateAPIkey(String email, String secret) throws Exception {

        String stringToEncode = email + APPSECRET + secret;

        String apikey = CryptoAlgorithms.sha256(stringToEncode);

        return apikey;
    }
}
