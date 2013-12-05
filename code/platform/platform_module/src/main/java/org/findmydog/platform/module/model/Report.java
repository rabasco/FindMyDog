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
@Document(collection = "reports")
public class Report {

    @Id
    private String id;
    private String reporterId;
    private String reporterUsername;
    @GeoSpatialIndexed
    private double[] position;
    private long timestamp;

    public Report(String reporterId, String reporterUsername, double[] position) {
        this.reporterId = reporterId;
        this.reporterUsername = reporterUsername;
        this.position = position;
        this.timestamp = Calendar.getInstance().getTimeInMillis() / 1000;
    }

    public Report() {
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @return the reporterId
     */
    public String getReporterId() {
        return reporterId;
    }

    /**
     * @return the position
     */
    public double[] getPosition() {
        return position;
    }

    /**
     * @return the reporterUsername
     */
    public String getReporterUsername() {
        return reporterUsername;
    }

    /**
     * @return the timestamp
     */
    public long getTimestamp() {
        return timestamp;
    }

    public void setReporterId(String reporterId) {
        this.reporterId = reporterId;
    }
}
