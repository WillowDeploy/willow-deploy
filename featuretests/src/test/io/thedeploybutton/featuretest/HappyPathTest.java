package io.thedeploybutton.featuretest;

import net.codestory.simplelenium.SeleniumTest;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ConfigurableApplicationContext;

public class HappyPathTest extends SeleniumTest {
    ConfigurableApplicationContext applicationContext;
    GithubApiMock githubApi;

    @Before
    public void before() throws Exception {
        applicationContext = SpringApplication.run(Application.class, "--server.port=9292");
        githubApi = new GithubApiMock(9050);
    }

    @After
    public void after() throws Exception {
        applicationContext.close();
        githubApi.stop();
    }

    @Override
    public String getDefaultBaseUrl() {
        return "http://localhost:9292/index.html";
    }

    @Test()
    public void happyPath() {
        goTo("http://localhost:9292/index.html");

        find("input").fill("92fgug27fg91fgfh");
        find("button").click();

        find("h2").withText("Repositories")
            .should()
            .exist();
    }
}
