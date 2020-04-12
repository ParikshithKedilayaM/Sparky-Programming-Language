package edu.asu.sparky;

import org.junit.jupiter.api.Test;

import java.io.File;

import static org.junit.jupiter.api.Assertions.*;

class AppTest {


    @Test
    void runSuccess() {
        App app = new App();
        File folder = new File("testcases/success");
        File[] listOfFiles = folder.listFiles();
        for (File file : listOfFiles) {
            if (file.isFile()) {
                assertTrue(app.run(file.toString()));
            }
        }
    }

    @Test
    void runFailure() {
        App app = new App();
        File folder = new File("testcases/failure");
        File[] listOfFiles = folder.listFiles();
        for (File file : listOfFiles) {
            if (file.isFile()) {
                assertFalse(app.run(file.toString()));
            }
        }
    }

}