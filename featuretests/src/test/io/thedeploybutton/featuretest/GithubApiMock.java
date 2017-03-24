package io.thedeploybutton.featuretest;

import org.mockserver.integration.ClientAndServer;

import static org.mockserver.integration.ClientAndServer.startClientAndServer;
import static org.mockserver.model.HttpRequest.request;
import static org.mockserver.model.HttpResponse.response;

public class GithubApiMock {
    private final ClientAndServer mockServer;

    public GithubApiMock(int port) {
        mockServer = startClientAndServer(port);

        mockServer
            .when(
                request()
                    .withMethod("OPTIONS")
                    .withPath("/user")
            )
            .respond(
                response()
                    .withStatusCode(204)
                    .withHeader("Access-Control-Allow-Origin", "*")
                    .withHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE")
                    .withHeader("Access-Control-Allow-Headers", "Authorization, Content-Type, If-Match, If-Modified-Since, If-None-Match, If-Unmodified-Since, Accept-Encoding, X-GitHub-OTP, X-Requested-With")
            );

        mockServer
            .when(
                request()
                    .withMethod("GET")
                    .withPath("/user")
                    .withHeader("Authorization", "token 92fgug27fg91fgfh")
            )
            .respond(
                response()
                    .withStatusCode(200)
                    .withHeader("Access-Control-Allow-Origin", "*")
                    .withHeader("Content-Type", "application/json; charset=utf-8")
                    .withBody("{\n" +
                        "  \"login\": \"noizwaves\",\n" +
                        "  \"id\": 1007983,\n" +
                        "  \"avatar_url\": \"https://avatars3.githubusercontent.com/u/1007983?v=3\",\n" +
                        "  \"gravatar_id\": \"\",\n" +
                        "  \"url\": \"https://api.github.com/users/noizwaves\",\n" +
                        "  \"html_url\": \"https://github.com/noizwaves\",\n" +
                        "  \"followers_url\": \"https://api.github.com/users/noizwaves/followers\",\n" +
                        "  \"following_url\": \"https://api.github.com/users/noizwaves/following{/other_user}\",\n" +
                        "  \"gists_url\": \"https://api.github.com/users/noizwaves/gists{/gist_id}\",\n" +
                        "  \"starred_url\": \"https://api.github.com/users/noizwaves/starred{/owner}{/repo}\",\n" +
                        "  \"subscriptions_url\": \"https://api.github.com/users/noizwaves/subscriptions\",\n" +
                        "  \"organizations_url\": \"https://api.github.com/users/noizwaves/orgs\",\n" +
                        "  \"repos_url\": \"https://api.github.com/users/noizwaves/repos\",\n" +
                        "  \"events_url\": \"https://api.github.com/users/noizwaves/events{/privacy}\",\n" +
                        "  \"received_events_url\": \"https://api.github.com/users/noizwaves/received_events\",\n" +
                        "  \"type\": \"User\",\n" +
                        "  \"site_admin\": false,\n" +
                        "  \"name\": \"Adam Neumann\",\n" +
                        "  \"company\": null,\n" +
                        "  \"blog\": \"http://blog.noizwaves.io\",\n" +
                        "  \"location\": \"Boulder, Colorado\",\n" +
                        "  \"email\": \"adam@noizwaves.com\",\n" +
                        "  \"hireable\": null,\n" +
                        "  \"bio\": \"Senior Software Engineer at Pivotal Labs.\",\n" +
                        "  \"public_repos\": 19,\n" +
                        "  \"public_gists\": 1,\n" +
                        "  \"followers\": 30,\n" +
                        "  \"following\": 15,\n" +
                        "  \"created_at\": \"2011-08-27T05:17:54Z\",\n" +
                        "  \"updated_at\": \"2017-03-20T20:11:45Z\",\n" +
                        "  \"private_gists\": 0,\n" +
                        "  \"total_private_repos\": 0,\n" +
                        "  \"owned_private_repos\": 0,\n" +
                        "  \"disk_usage\": 6112,\n" +
                        "  \"collaborators\": 0,\n" +
                        "  \"two_factor_authentication\": true,\n" +
                        "  \"plan\": {\n" +
                        "    \"name\": \"free\",\n" +
                        "    \"space\": 976562499,\n" +
                        "    \"collaborators\": 0,\n" +
                        "    \"private_repos\": 0\n" +
                        "  }\n" +
                        "}\n")
            );
    }

    public void stop() {
        mockServer.stop();
    }
}
