/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.findmydog.platform.module.model.Pet;
import org.findmydog.platform.module.model.User;
import org.findmydog.platform.module.repository.MediaRepository;
import org.findmydog.platform.module.repository.PetRepository;
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
@RequestMapping(value = "/pets")
public class PetController extends SecureController {

    @Autowired
    private PetRepository petRepository;
    @Autowired
    private MediaRepository mediaRepository;

    @RequestMapping(value = "/", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    String create(@RequestParam("name") String name, @RequestParam("file") MultipartFile file) {

        try {

            User user = getAutenticatedUser();

            // Save pet
            Pet pet = new Pet(user.getId(), name);
            pet = petRepository.save(pet);

            // Save image
            mediaRepository.saveImagePet(pet.getId(), file.getBytes());

            return JSONFormatter.formatString("id", pet.getId());

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/{petId}/image/", method = RequestMethod.GET, produces = "application/json")
    public void downloadImage(@PathVariable("petId") String petId, HttpServletResponse response) {

        try {

            // Check user
            getAutenticatedUser();

            // Get image
            InputStream is = mediaRepository.getImagePet(petId);

            response.setContentType("image/jpeg");
            IOUtils.copy(is, response.getOutputStream());
            response.flushBuffer();

        } catch (Exception e) {
        }
    }

    @RequestMapping(value = "/", method = RequestMethod.GET, produces = "application/json")
    public @ResponseBody
    String list() {

        try {

            User user = getAutenticatedUser();

            List<Pet> list = petRepository.list(user.getId());

            // Hide userId
            for (int i = 0; i < list.size(); i++) {
                list.get(i).setUserId(null);
            }

            ObjectMapper mapper = new ObjectMapper();
            mapper.setSerializationInclusion(Include.NON_NULL);
            String response = mapper.writeValueAsString(list);

            return response;

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/{petId}/missing/", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    String setMissing(@PathVariable("petId") String petId, @RequestParam("longitude") double longitude, @RequestParam("lattitude") double lattitude) {

        try {

            User user = getAutenticatedUser();

            // Get pet
            Pet pet = petRepository.get(user.getId(), petId);

            // Set missing and save
            pet.setMissing(true, new double[]{longitude, lattitude});
            petRepository.save(pet);

            return "";

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/{petId}/found/", method = RequestMethod.POST, produces = "application/json")
    public @ResponseBody
    String setFound(@PathVariable("petId") String petId) {

        try {

            User user = getAutenticatedUser();

            // Get pet
            Pet pet = petRepository.get(user.getId(), petId);

            // Set missing and save
            pet.setMissing(false, new double[]{-1, -1});
            petRepository.save(pet);

            return "";

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @RequestMapping(value = "/{petId}", method = RequestMethod.DELETE, produces = "application/json")
    public @ResponseBody
    String remove(@PathVariable("petId") String petId) {

        try {

            User user = getAutenticatedUser();

            // Remove pet
            petRepository.remove(user.getId(), petId);

            return "";

        } catch (Exception e) {
            return e.getMessage();
        }
    }
}
