/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.findmydog.platform.module.model.Report;
import org.findmydog.platform.module.model.User;
import org.findmydog.platform.module.repository.MediaRepository;
import org.findmydog.platform.module.repository.ReportRepository;
import org.findmydog.platform.services.util.JSONFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author rabasco
 */
@Controller
@RequestMapping(value = "/reports")
public class ReportController extends SecureController {

    private final double RADIUS = 25.0;
    @Autowired
    private ReportRepository reportRepository;
    @Autowired
    private MediaRepository mediaRepository;

    @RequestMapping(value = "/", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    String create(@RequestParam("x") double x, @RequestParam("y") double y, @RequestParam("file") MultipartFile file) {

        try {

            // Check user
            User user = getAutenticatedUser();

            // Save report
            double[] position = new double[]{x, y};
            Report report = new Report(user.getId(), user.getUsername(), position);
            report = reportRepository.save(report);

            // Save image
            mediaRepository.saveImageReport(report.getId(), file.getBytes());

            return JSONFormatter.formatString("id", report.getId());

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/{reportId}/image/", method = RequestMethod.GET, produces = "application/json")
    public void downloadImage(@PathVariable("reportId") String reportId, HttpServletResponse response) {

        try {

            // Check user
            getAutenticatedUser();

            // Get image
            InputStream is = mediaRepository.getImageReport(reportId);

            IOUtils.copy(is, response.getOutputStream());
            response.flushBuffer();

        } catch (Exception e) {
        }

    }

    @RequestMapping(value = "/", method = RequestMethod.GET, produces = "application/json")
    public @ResponseBody
    String list(@RequestParam("x") double x, @RequestParam("y") double y,
            @RequestParam("timestamp") long timestamp) {

        try {

            User user = getAutenticatedUser();

            List<Report> list = reportRepository.list(x, y, RADIUS);
            List<Report> result = new ArrayList<Report>();

            for (int i = 0; i < list.size(); i++) {

                Report report = list.get(i);

                if (!report.getReporterId().equals(user.getId()) && report.getTimestamp() >= timestamp) {
                    report.setReporterId(""); // Hide reporterId
                    result.add(report);
                }
            }

            ObjectMapper mapper = new ObjectMapper();
            String response = mapper.writeValueAsString(result);

            return response;

        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
