/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import java.util.List;
import org.findmydog.platform.module.exceptions.PetNotFoundException;
import org.findmydog.platform.module.model.Pet;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

/**
 *
 * @author rabasco
 */
public class PetRepositoryMongoImpl extends MongoRepository implements PetRepository {

    public Pet get(String userId, String petId) throws PetNotFoundException {

        Query query = new Query(Criteria.where("userId").is(userId).and("id").is(petId));
        Pet pet = mongoTemplate.findOne(query, Pet.class);

        if (pet == null) {
            throw new PetNotFoundException();
        }

        return pet;
    }

    public List<Pet> list(String userId) {

        Query query = new Query(Criteria.where("userId").is(userId));
        List<Pet> list = mongoTemplate.find(query, Pet.class);

        return list;
    }

    public void remove(String userId, String petId) {

        Query query = new Query(Criteria.where("userId").is(userId).and("id").is(petId));
        mongoTemplate.remove(query, Pet.class);
    }

    public Pet save(Pet pet) {

        mongoTemplate.save(pet);

        return pet;
    }
}
