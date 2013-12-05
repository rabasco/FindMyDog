/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import org.findmydog.platform.module.exceptions.EmailExistsException;
import org.findmydog.platform.module.exceptions.UserNotFoundException;
import org.findmydog.platform.module.exceptions.UsernameExistsException;
import org.findmydog.platform.module.model.User;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

/**
 *
 * @author rabasco
 */
@Repository
public class UserRepositoryMongoImpl extends MongoRepository implements UserRepository {

    public String getApikey(String email, String secret) throws UserNotFoundException {

        Query searchQuery = new Query(Criteria.where("email").is(email).and("secret").is(secret));
        User user = mongoTemplate.findOne(searchQuery, User.class);

        if (user == null) {
            throw new UserNotFoundException();
        }

        return user.getApiKey();
    }

    public User getUserByApikey(String apikey) throws UserNotFoundException {

        Query searchQuery = new Query(Criteria.where("apiKey").is(apikey));
        User user = mongoTemplate.findOne(searchQuery, User.class);

        if (user == null) {
            throw new UserNotFoundException();
        }

        return user;
    }

    public User getUserByEmail(String email) throws UserNotFoundException {

        Query searchQuery = new Query(Criteria.where("email").is(email));
        User user = mongoTemplate.findOne(searchQuery, User.class);

        if (user == null) {
            throw new UserNotFoundException();
        }

        return user;
    }

    public User save(User user) throws Exception {

        Query searchQuery = new Query(new Criteria().orOperator(
                Criteria.where("email").is(user.getEmail()),
                Criteria.where("username").is(user.getUsername())));

        User existingUser = mongoTemplate.findOne(searchQuery, User.class);

        if (existingUser != null) {

            if (existingUser.getEmail().equals(user.getEmail())) {
                throw new EmailExistsException();
            }

            if (existingUser.getUsername().equals(user.getUsername())) {
                throw new UsernameExistsException();
            }
        }

        mongoTemplate.save(user);

        return user;
    }
}
