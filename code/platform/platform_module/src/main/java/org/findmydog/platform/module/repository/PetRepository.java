/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.util.List;
import org.findmydog.platform.module.exceptions.PetNotFoundException;
import org.findmydog.platform.module.model.Pet;

/**
 *
 * @author rabasco
 */
public interface PetRepository {

    public Pet get(String userId, String petId) throws PetNotFoundException;

    public List<Pet> list(String userId);

    public void remove(String userId, String petId);

    public Pet save(Pet pet);
}
