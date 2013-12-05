/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.module.repository;

import com.mongodb.Mongo;
import com.mongodb.MongoClient;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSInputFile;
import de.flapdoodle.embed.mongo.MongodExecutable;
import de.flapdoodle.embed.mongo.MongodProcess;
import de.flapdoodle.embed.mongo.MongodStarter;
import de.flapdoodle.embed.mongo.config.MongodConfig;
import de.flapdoodle.embed.mongo.distribution.Version;
import de.flapdoodle.embed.process.runtime.Network;
import java.io.IOException;
import org.findmydog.platform.module.model.Pet;
import org.findmydog.platform.module.model.Report;
import org.findmydog.platform.module.model.User;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.rules.ExpectedException;
import org.springframework.data.mongodb.core.MongoTemplate;

/**
 *
 * @author rabasco
 */
public class MongoEnvironmentTest {

    // MongoDB coniguration
    private static int port = 12345;
    private static MongodExecutable mongodExecutable;
    private static final String DB_NAME = "findmydog_test";
    private static MongodProcess mongoProcess;
    private static Mongo mongo;
    protected MongoTemplate template;
    /**
     *
     */
    @Rule
    public ExpectedException thrown = ExpectedException.none();
    // Repos
    protected UserRepositoryMongoImpl userRepository;
    protected PetRepositoryMongoImpl petRepository;
    protected ReportRepositoryMongoImpl reportRepository;
    protected MediaRepositoryMongoImpl mediaRepository;
    // Locations
    protected double[] locationGranada = new double[]{-3.5985571, 37.1773363};
    protected double[] locationMalaga = new double[]{-4.4212655, 36.721261};
    protected double[] locationMadrid = new double[]{-3.7037902, 40.4167754};
    protected double[] locationJaen = new double[]{-3.790845, 37.767826};

    /**
     *
     * @throws IOException
     */
    @BeforeClass
    public static void initializeDB() throws IOException {

        MongodConfig mongodConfig = new MongodConfig(Version.Main.PRODUCTION, port, Network.localhostIsIPv6());

        MongodStarter runtime = MongodStarter.getDefaultInstance();

        mongodExecutable = runtime.prepare(mongodConfig);
        mongoProcess = mongodExecutable.start();

        mongo = new MongoClient("localhost", port);
    }

    /**
     *
     */
    @AfterClass
    public static void shutdownDB() {

        if (mongoProcess != null) {
            mongoProcess.stop();
        }
    }

    /**
     *
     * @throws Exception
     */
    @Before
    public void setUp() throws Exception {

        template = new MongoTemplate(mongo, DB_NAME);

        userRepository = new UserRepositoryMongoImpl();
        userRepository.setMongoTemplate(template);

        petRepository = new PetRepositoryMongoImpl();
        petRepository.setMongoTemplate(template);

        reportRepository = new ReportRepositoryMongoImpl();
        reportRepository.setMongoTemplate(template);

        mediaRepository = new MediaRepositoryMongoImpl();
        mediaRepository.setMongoTemplate(template);
    }

    /**
     *
     * @throws Exception
     */
    @After
    public void tearDown() throws Exception {
        template.dropCollection(User.class);
        template.dropCollection(Pet.class);
        template.dropCollection(Report.class);
    }

    protected User createSampleUser(String username) throws Exception {

        User user = new User(username, username + "@email.com", "1234", username);
        userRepository.save(user);

        return user;
    }

    protected Pet createSamplePet(String username, String petName) throws Exception {

        User user = createSampleUser(username);
        Pet pet = new Pet(user.getId(), petName);

        pet = petRepository.save(pet);

        return pet;
    }

    protected Report createSampleReport(String username, double[] location) throws Exception {

        User user = createSampleUser(username);

        Report report = new Report(user.getId(), user.getUsername(), location);
        report = reportRepository.save(report);

        return report;
    }

    protected void saveImage(String filename, String bucket, String bytes) {
        GridFS gfs = new GridFS(template.getDb(), bucket);
        GridFSInputFile gfsFile = gfs.createFile(bytes.getBytes());
        gfsFile.setFilename(filename);
        gfsFile.save();
    }
}
