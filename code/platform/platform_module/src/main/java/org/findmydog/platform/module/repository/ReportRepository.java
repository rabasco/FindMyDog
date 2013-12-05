/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.util.List;
import org.findmydog.platform.module.model.Report;

/**
 *
 * @author rabasco
 */
public interface ReportRepository {

    public List<Report> list(double x, double y, double radius);

    public Report save(Report report);

    public void removeReportsOlderThan(long seconds);
}
