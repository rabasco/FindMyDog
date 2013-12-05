/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Collection;
import java.util.List;
import org.findmydog.platform.module.model.User;

import org.findmydog.platform.module.model.Report;

import org.findmydog.platform.services.util.JSONFormatter;
import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MvcResult;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.fileUpload;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 *
 * @author rabasco
 */
@RunWith(SpringJUnit4ClassRunner.class)
public class ReportControllerTest extends MongoControllerTest {

    //==========================================================================
    // create
    //==========================================================================
    @Test
    public void testCreate() throws Exception {

        String url = "/reports/?x=" + locationGranada[0] + "&y=" + locationGranada[1];

        MockMultipartFile file = new MockMultipartFile("file", "orig", null, "bar".getBytes());
        final MvcResult mvcResult = mockMvc.perform(fileUpload(getSignedUrl(url)).file(file))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json")).andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        List<Report> list = template.findAll(Report.class, "reports");
        Report report = list.get(0);

        assertEquals(JSONFormatter.formatString("id", report.getId()), response);
    }

    //==========================================================================
    // downloadImage
    //==========================================================================
    @Test
    public void testDownloadImage() throws Exception {

        User user = createSampleUser("new username", "user@findmydog.com", "secret", "apikey_test");
        Report report = createSampleReport(user.getId(), user.getUsername(), locationJaen);

        mediaRepository.saveImageReport(report.getId(), "bar".getBytes());

        String url = "/reports/" + report.getId() + "/image/";
        String response = "bar";

        mockMvc.perform(
                get(getSignedUrl(url)))
                .andExpect(status().isOk())
                .andExpect(content().string(response));
    }

    @Test
    public void testDownloadImageNotExists() throws Exception {

        String url = "/reports/101/image/";
        String response = "";

        mockMvc.perform(
                get(getSignedUrl(url)))
                .andExpect(status().isOk())
                .andExpect(content().string(response));
    }

    //==========================================================================
    // list
    //==========================================================================
    @Test
    public void testList() throws Exception {

        User user = createSampleUser("new username", "user@findmydog.com", "secret", "apikey_test");
        createSampleReport(user.getId(), user.getUsername(), locationJaen);
        locationJaen[0] += 0.001;
        locationJaen[1] -= 0.001;
        createSampleReport(user.getId(), user.getUsername(), locationJaen);
        createSampleReport(user.getId(), user.getUsername(), locationMadrid); // So far

        String url = "/reports/?x=" + locationJaen[0] + "&y=" + locationJaen[1] + "&timestamp=0";

        final MvcResult mvcResult = mockMvc.perform(
                get(getSignedUrl(url)))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andReturn();

        String json = mvcResult.getResponse().getContentAsString();

        ObjectMapper mapper = new ObjectMapper();
        TypeReference<Collection<Report>> ref = new TypeReference<Collection<Report>>() {
        };

        Collection<Report> list = (Collection<Report>) mapper.readValue(json, ref);

        assertEquals(2, list.size());
    }

    @Test
    public void testListEmpty() throws Exception {

        String url = "/reports/?x=" + locationJaen[0] + "&y=" + locationJaen[1] + "&timestamp=0";

        mockMvc.perform(
                get(getSignedUrl(url))
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string("[]"));
    }
}
