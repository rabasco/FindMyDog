/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.util;

import static org.junit.Assert.*;
import org.junit.Test;

/**
 *
 * @author rabasco
 */
public class CryptoAlgorithmsTest {

    //==========================================================================
    // SHA256 method
    //==========================================================================
    @Test
    public void testSHA256() throws Exception {

        String testString = "12345";
        String testStringResult = "5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5";

        String result = CryptoAlgorithms.sha256(testString);

        assertEquals("SHA256 result should be " + testStringResult + " but is " + result, testStringResult, result);
    }
}
