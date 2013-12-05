/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.util.List;
import org.findmydog.platform.module.exceptions.PetNotFoundException;
import org.findmydog.platform.module.model.Pet;
import org.findmydog.platform.module.model.User;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import org.junit.Test;

/**
 *
 * @author rabasco
 */
public class PetRepositoryMongoImplTest extends MongoEnvironmentTest {

    //==========================================================================
    // get
    //==========================================================================
    @Test
    public void testGet() throws Exception {

        Pet pet = createSamplePet("username", "My Pet");

        Pet savedPet = petRepository.get(pet.getUserId(), pet.getId());

        assertEquals(pet.getId(), savedPet.getId());
    }

    @Test
    public void testGetPetNotFound() throws Exception {

        thrown.expect(PetNotFoundException.class);

        petRepository.get("test", "test");
    }

    //==========================================================================
    // list
    //==========================================================================
    @Test
    public void testList() throws Exception {

        Pet first = createSamplePet("User", "Pet");

        Pet second = new Pet(first.getUserId(), "My second pet");
        petRepository.save(second);

        Pet third = new Pet(first.getUserId(), "My third pet");
        petRepository.save(third);


        List<Pet> petList = petRepository.list(first.getUserId());

        assertEquals("Pet list must contains 3 elements but contains "
                + petList.size(), 3, petList.size());
    }

    @Test
    public void testListEmpty() throws Exception {

        List<Pet> petList = petRepository.list("");

        assertEquals("Pet list must contains 0 elements but contains "
                + petList.size(), 0, petList.size());
    }

    //==========================================================================
    // remove
    //==========================================================================
    @Test
    public void testRemove() throws Exception {

        Pet pet = createSamplePet("User", "Pet");

        petRepository.remove(pet.getUserId(), pet.getId());

        List<Pet> list = template.findAll(Pet.class);

        assertEquals("Only 0 Pets should exist in user pets, but there are "
                + list.size(), 0, list.size());
    }

    @Test
    public void testRemoveNotExists() throws Exception {

        petRepository.remove("", "");

    }

    //==========================================================================
    // save
    //==========================================================================
    @Test
    public void testSave() throws Exception {

        User user = createSampleUser("User");
        Pet pet = new Pet(user.getId(), "My first pet");

        pet = petRepository.save(pet);

        assertNotEquals("Pet id was not generated, result: "
                + pet.getId(), "", pet.getId());
    }
}
