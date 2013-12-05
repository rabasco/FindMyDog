/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import org.findmydog.platform.module.model.Pet;
import org.findmydog.platform.module.model.Report;
import org.findmydog.platform.module.model.User;
import org.findmydog.platform.module.repository.MediaRepositoryMongoImpl;
import org.findmydog.platform.module.repository.PetRepositoryMongoImpl;
import org.findmydog.platform.module.repository.ReportRepositoryMongoImpl;
import org.findmydog.platform.module.repository.UserRepositoryMongoImpl;
import org.junit.After;
import org.junit.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

/**
 *
 * @author rabasco
 */
@WebAppConfiguration
@ContextConfiguration("test-servlet-context.xml")
public class MongoControllerTest {

    private SecureController secureController; // To get sign method
    @Autowired
    protected WebApplicationContext wac;
    @Autowired
    protected MongoTemplate template;
    protected MockMvc mockMvc;
    // Repos
    @Autowired
    private UserRepositoryMongoImpl userRepository;
    @Autowired
    private PetRepositoryMongoImpl petRepository;
    @Autowired
    private ReportRepositoryMongoImpl reportRepository;
    @Autowired
    protected MediaRepositoryMongoImpl mediaRepository;
    // Locations
    protected double[] locationGranada = new double[]{-3.5985571, 37.1773363};
    protected double[] locationMalaga = new double[]{-4.4212655, 36.721261};
    protected double[] locationMadrid = new double[]{-3.7037902, 40.4167754};
    protected double[] locationJaen = new double[]{-3.790845, 37.767826};
    // Signed user
    protected User signedUser;

    protected User createSampleUser(String username, String email, String secret, String apikey) throws Exception {
        User user = new User(username, email, secret, apikey);
        user = userRepository.save(user);
        return user;
    }

    protected Pet createSamplePet(String userId, String petName) {
        Pet pet = new Pet(userId, petName);
        pet = petRepository.save(pet);
        return pet;
    }

    protected Report createSampleReport(String userId, String username, double[] location) {
        Report report = new Report(userId, username, location);
        report = reportRepository.save(report);
        return report;
    }

    @Before
    public void setup() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
        secureController = new SecureController();

        signedUser = createSampleUser("test", "test@findmydog.com", "1234", "APIKEY");
    }

    @After
    public void tearDown() throws Exception {
        template.remove(new Query(), User.class);
        template.remove(new Query(), Pet.class);
        template.remove(new Query(), Report.class);
    }

    public String getSignedUrl(String url) throws Exception {

        String apikey = signedUser.getApiKey();
        String secret = signedUser.getSecret();

        if (url.charAt(url.length() - 1) == '/') {

            // URL sin variables
            url = url + "?apikey=" + apikey;
        } else {

            // La URL contiene variables
            url = url + "&apikey=" + apikey;
        }

        // Generamos la firma de la URL
        String sign = secureController.getSign(url, secret);

        // Le añadimos la firma a la URL
        url = url + "&sign=" + sign;

        return url;
    }
}
