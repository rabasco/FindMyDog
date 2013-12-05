/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.util.List;
import org.findmydog.platform.module.model.Report;
import org.findmydog.platform.module.model.User;
import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 *
 * @author rabasco
 */
public class ReportRepositoryMongoImplTest extends MongoEnvironmentTest {

    //==========================================================================
    // list
    //==========================================================================
    @Test
    public void testList() throws Exception {

        createSampleReport("user1", locationGranada);
        createSampleReport("user2", locationMalaga);
        createSampleReport("user3", locationMadrid);

        List<Report> list = reportRepository.list(locationJaen[0], locationJaen[1], 200);

        assertEquals("Report list must contains 2 elements but contains "
                + list.size(), 2, list.size());
    }

    @Test
    public void testListEmpty() throws Exception {

        List<Report> list = reportRepository.list(locationJaen[0], locationJaen[1], 200);

        assertEquals("Report list must contains 0 elements but contains "
                + list.size(), 0, list.size());
    }

    //==========================================================================
    // save
    //==========================================================================
    @Test
    public void testSave() throws Exception {

        User user = createSampleUser("User");
        Report report = new Report(user.getId(), user.getUsername(), new double[]{-3.5985571, 37.1773363});

        reportRepository.save(report);

        List<Report> list = template.findAll(Report.class);

        assertEquals("Report list must contains 1 element but contains "
                + list.size(), 1, list.size());
    }
}
