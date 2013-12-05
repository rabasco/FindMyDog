/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Collection;
import java.util.List;

import org.findmydog.platform.module.model.Pet;
import org.findmydog.platform.services.util.JSONFormatter;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.mock.web.MockMultipartFile;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.fileUpload;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.junit.Assert.assertEquals;

/**
 *
 * @author rabasco
 */
@RunWith(SpringJUnit4ClassRunner.class)
public class PetControllerTest extends MongoControllerTest {

    //==========================================================================
    // create
    //==========================================================================
    @Test
    public void testCreate() throws Exception {

        String url = "/pets/?name=mypet";

        MockMultipartFile file = new MockMultipartFile("file", "orig", null, "bar".getBytes());
        final MvcResult mvcResult = mockMvc.perform(fileUpload(getSignedUrl(url)).file(file))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json")).andReturn();

        String response = mvcResult.getResponse().getContentAsString();

        List<Pet> list = template.findAll(Pet.class, "pets");
        Pet pet = list.get(0);

        assertEquals(JSONFormatter.formatString("id", pet.getId()), response);
    }

    //==========================================================================
    // downloadImage
    //==========================================================================
    @Test
    public void testDownloadImage() throws Exception {

        Pet pet = createSamplePet(signedUser.getId(), "Pet");
        mediaRepository.saveImagePet(pet.getId(), "bar".getBytes());

        String url = "/pets/" + pet.getId() + "/image/";
        String response = "bar";

        mockMvc.perform(
                get(getSignedUrl(url)))
                .andExpect(status().isOk())
                .andExpect(content().string(response));
    }

    @Test
    public void testDownloadImageNotExists() throws Exception {

        String url = "/pets/101/image/";
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

        createSamplePet(signedUser.getId(), "First pet");
        createSamplePet(signedUser.getId(), "Second pet");

        String url = "/pets/";

        final MvcResult mvcResult = mockMvc.perform(
                get(getSignedUrl(url)))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andReturn();

        String json = mvcResult.getResponse().getContentAsString();


        ObjectMapper mapper = new ObjectMapper();
        TypeReference<Collection<Pet>> ref = new TypeReference<Collection<Pet>>() {
        };

        Collection<Pet> list = (Collection<Pet>) mapper.readValue(json, ref);

        assertEquals(2, list.size());
    }

    @Test
    public void testListEmpty() throws Exception {

        String url = "/pets/";

        mockMvc.perform(
                get(getSignedUrl(url))
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string("[]"));
    }
    //==========================================================================
    // remove
    //==========================================================================

    @Test
    public void testRemove() throws Exception {

        Pet pet = createSamplePet(signedUser.getId(), "Pet");

        String url = "/pets/" + pet.getId() + "/";

        mockMvc.perform(
                delete(getSignedUrl(url))
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(""));
    }

    @Test
    public void testRemoveNotExists() throws Exception {

        String url = "/pets/101/";

        mockMvc.perform(
                delete(getSignedUrl(url))
                .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json"))
                .andExpect(content().string(""));
    }
}
