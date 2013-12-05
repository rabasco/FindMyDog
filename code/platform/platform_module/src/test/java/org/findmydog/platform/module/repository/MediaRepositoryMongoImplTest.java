/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import com.mongodb.gridfs.GridFS;
import java.io.InputStream;
import java.util.Arrays;
import org.apache.commons.io.IOUtils;
import org.findmydog.platform.module.exceptions.FileNotFoundException;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

import static org.findmydog.platform.module.repository.MongoRepository.PETS_BUCKET;
import static org.findmydog.platform.module.repository.MongoRepository.REPORTS_BUCKET;
import static org.junit.Assert.assertEquals;

/**
 *
 * @author rabasco
 */
public class MediaRepositoryMongoImplTest extends MongoEnvironmentTest {

    //==========================================================================
    // getImagePet
    //==========================================================================
    @Test
    public void getImagePetTest() throws Exception {

        String filename = "test.jpg";
        String bucket = "pets";
        String bytes = "TEST";
        saveImage(filename, bucket, bytes);

        InputStream is = mediaRepository.getImagePet(filename);

        byte[] result = IOUtils.toByteArray(is);

        assertTrue(Arrays.equals(bytes.getBytes(), result));
    }

    @Test
    public void getImagePetImageNotExistsTest() throws Exception {

        thrown.expect(FileNotFoundException.class);

        mediaRepository.getImagePet("fileThatNotExists.jpg");
    }

    //==========================================================================
    // getImageReport
    //==========================================================================
    @Test
    public void getImageReportTest() throws Exception {

        String filename = "test.jpg";
        String bucket = "reports";
        String bytes = "TEST";
        saveImage(filename, bucket, bytes);

        InputStream is = mediaRepository.getImageReport(filename);

        byte[] result = IOUtils.toByteArray(is);

        assertTrue(Arrays.equals(bytes.getBytes(), result));
    }

    @Test
    public void getImageReportImageNotExistsTest() throws Exception {

        thrown.expect(FileNotFoundException.class);

        mediaRepository.getImageReport("fileThatNotExists.jpg");
    }

    //==========================================================================
    // saveImagePet
    //==========================================================================
    @Test
    public void saveImagePetTest() throws Exception {

        String byteString = "TEST";
        String filename = "test.png";

        mediaRepository.saveImagePet(filename, byteString.getBytes());

        GridFS gfs = new GridFS(template.getDb(), PETS_BUCKET);

        assertEquals("DB must contains 1 element but contains "
                + gfs.getFileList().count(), 1, gfs.getFileList().count());
    }

    //==========================================================================
    // saveImageReport
    //==========================================================================
    @Test
    public void saveImageReportTest() throws Exception {

        String byteString = "TEST";
        String filename = "test.png";

        mediaRepository.saveImageReport(filename, byteString.getBytes());

        GridFS gfs = new GridFS(template.getDb(), REPORTS_BUCKET);

        assertEquals("DB must contains 1 element but contains "
                + gfs.getFileList().count(), 1, gfs.getFileList().count());
    }
}
