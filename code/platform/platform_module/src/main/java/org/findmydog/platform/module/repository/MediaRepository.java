/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.io.InputStream;
import org.findmydog.platform.module.exceptions.FileNotFoundException;

/**
 *
 * @author rabasco
 */
public interface MediaRepository {

    public InputStream getImagePet(String filename) throws FileNotFoundException;

    public InputStream getImageReport(String filename) throws FileNotFoundException;

    public void saveImagePet(String filename, byte[] bytes);

    public void saveImageReport(String filename, byte[] bytes);
}
