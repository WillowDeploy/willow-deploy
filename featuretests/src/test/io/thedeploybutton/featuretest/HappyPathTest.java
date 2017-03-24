package io.thedeploybutton.featuretest;

import net.codestory.simplelenium.SeleniumTest;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;

public class HappyPathTest extends SeleniumTest {
    ConfigurableApplicationContext applicationContext;

    @Before
    public void before() throws Exception {
        System.setProperty("browser", "chrome");
        applicationContext = SpringApplication.run(Application.class, "--server.port=9292");
    }

    @After
    public void after() throws Exception {
        applicationContext.close();
    }

    @Override
    public String getDefaultBaseUrl() {
        return "http://localhost:9292/index.html";
    }

    @Test()
    public void happyPath() {
        goTo("http://localhost:9292/index.html");

        find("button").click();
    }
}
