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


        find(".brand").withText("Willow Deploy")
            .should().exist();
        find(".navigation .links")
            .should().not().exist();

        find("label").withText("Personal Access Token")
            .should().exist();
        find("input")
            .should().exist();
        find("button").withText("Login")
            .should().exist();


        find("input").fill("92fgug27fg91fgfh");
        find("button").click();


        find(".current-username").withText("noizwaves")
            .should().exist();
        find(".logout-link").withText("logout")
            .should().exist();

        find("h2").withText("Repositories")
            .should().exist();

        find(".repositories .repository")
            .should().haveSize(2);
        find(".repository").withText("noizwaves/repo-with-releases")
            .should().exist();
        find(".repository").withText("noizwaves/elm-calculator")
            .should().exist();


        find(".repository").withText("noizwaves/repo-with-releases")
            .click();


        find("h2").withText("Repository noizwaves/repo-with-releases")
            .should().exist();

        find(".release").withText("Release: Release v1")
            .should().exist();
        find(".release").withText("Pre-release: Release v2")
            .should().exist();
        find(".release").withText("Draft: Release v3")
            .should().exist();


        find(".logout-link").click();


        find("button").withText("Login")
            .should().exist();
        find(".current-username")
            .should().not().exist();
        find(".logout-link")
            .should().not().exist();
    }
}
