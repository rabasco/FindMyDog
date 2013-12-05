/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;

import java.io.InputStream;

import org.findmydog.platform.module.exceptions.FileNotFoundException;
import static org.findmydog.platform.module.repository.MongoRepository.PETS_BUCKET;
import static org.findmydog.platform.module.repository.MongoRepository.REPORTS_BUCKET;

/**
 *
 * @author rabasco
 */
public class MediaRepositoryMongoImpl extends MongoRepository implements MediaRepository {

    public InputStream getImagePet(String filename) throws FileNotFoundException {
        return getMedia(filename, PETS_BUCKET);
    }

    public InputStream getImageReport(String filename) throws FileNotFoundException {
        return getMedia(filename, REPORTS_BUCKET);
    }

    private InputStream getMedia(String filename, String bucket) throws FileNotFoundException {

        try {

            GridFS gfs = new GridFS(mongoTemplate.getDb(), bucket);
            GridFSDBFile gfsFile = gfs.findOne(filename);

            return gfsFile.getInputStream();

        } catch (Exception e) {
            throw new FileNotFoundException();
        }
    }

    public void saveImagePet(String filename, byte[] bytes) {
        saveMedia(filename, bytes, PETS_BUCKET);
    }

    public void saveImageReport(String filename, byte[] bytes) {
        saveMedia(filename, bytes, REPORTS_BUCKET);
    }

    private void saveMedia(String filename, byte[] bytes, String bucket) {
        GridFS gfs = new GridFS(mongoTemplate.getDb(), bucket);
        GridFSInputFile gfsFile = gfs.createFile(bytes);
        gfsFile.setFilename(filename);
        gfsFile.save();
    }
}
