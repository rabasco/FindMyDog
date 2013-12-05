/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.util;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 *
 * @author rabasco
 */
public class JSONFormatterTest {

    @Test
    public void testFormatString() throws Exception {

        String result = "{\"TEST\":\"TEST_STRING\"}";

        String response = JSONFormatter.formatString("TEST", "TEST_STRING");

        assertEquals("Response should be " + result + " but is " + response, result, response);
    }
}
