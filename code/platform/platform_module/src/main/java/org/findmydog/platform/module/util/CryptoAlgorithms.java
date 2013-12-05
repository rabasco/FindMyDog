/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.util;

import java.security.MessageDigest;

/**
 *
 * @author rabasco
 */
public class CryptoAlgorithms {

    private static String encode(String input, String method) throws Exception {

        MessageDigest md = MessageDigest.getInstance(method);
        md.update(input.getBytes());

        byte byteData[] = md.digest();

        //convert the byte to hex format method 1
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }

        return sb.toString();
    }

    public static String sha256(String input) throws Exception {

        return encode(input, "SHA-256");
    }
    /*   public static String sha1(String input) throws Exception {

     return encode(input, "SHA-1");
     }*/
}
