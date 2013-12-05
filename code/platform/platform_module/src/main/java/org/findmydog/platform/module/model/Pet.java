/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.model;

import java.util.Calendar;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 *
 * @author rabasco
 */
@Document(collection = "pets")
public class Pet {

    @Id
    private String id;
    private String name;
    private String userId;
    private boolean missing;
    @GeoSpatialIndexed
    private double[] missingLocation;
    private long missingSince;

    public Pet(String userId, String name) {
        this.userId = userId;
        this.name = name;
        this.missing = false;
    }

    public Pet() {
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the userId
     */
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    /**
     *
     * @return
     */
    public boolean getMissing() {
        return missing;
    }

    /**
     *
     * @param missing
     */
    public void setMissing(boolean missing, double[] missingLocation) {

        if (missing) {
            this.missing = true;
            this.missingSince = Calendar.getInstance().getTimeInMillis();
            this.missingLocation = missingLocation;
        } else {
            this.missing = false;
            this.missingSince = -1;
            this.missingLocation = new double[]{-1, -1};
        }
    }

    public long getMissingSince() {
        return missingSince;
    }

    /**
     *
     * @return the position
     */
    public double[] getMissingLocation() {
        return missingLocation;
    }
}
