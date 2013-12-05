/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;

/**
 *
 * @author rabasco
 */
public class MongoRepository {

    // MongoDB buckets
    protected static final String REPORTS_BUCKET = "reports";
    protected static final String PETS_BUCKET = "pets";
    @Autowired
    protected MongoTemplate mongoTemplate;

    public void setMongoTemplate(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }
}
