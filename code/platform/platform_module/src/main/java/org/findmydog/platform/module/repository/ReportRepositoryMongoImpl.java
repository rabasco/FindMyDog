/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.util.ArrayList;
import java.util.List;
import org.findmydog.platform.module.model.Report;
import org.springframework.data.mongodb.core.geo.GeoResults;
import org.springframework.data.mongodb.core.geo.Metrics;
import org.springframework.data.mongodb.core.query.NearQuery;

/**
 *
 * @author rabasco
 */
public class ReportRepositoryMongoImpl extends MongoRepository implements ReportRepository {

    public List<Report> list(double x, double y, double radius) {

        NearQuery geoNear = NearQuery.near(x, y, Metrics.KILOMETERS).maxDistance(radius);

        GeoResults<Report> geoResults = mongoTemplate.geoNear(geoNear, Report.class);

        List<Report> list = new ArrayList<Report>();

        for (int i = 0; i < geoResults.getContent().size(); i++) {
            list.add(geoResults.getContent().get(i).getContent());
        }

        return list;
    }

    public Report save(Report report) {

        mongoTemplate.save(report);

        return report;
    }

    public void removeReportsOlderThan(long seconds) {
    }
}
