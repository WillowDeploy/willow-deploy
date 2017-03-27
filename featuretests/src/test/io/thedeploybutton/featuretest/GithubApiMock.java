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

        mockServer
            .when(
                request()
                    .withMethod("OPTIONS")
                    .withPath("/user/repos")
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
                    .withPath("/user/repos")
                    .withHeader("Authorization", "token 92fgug27fg91fgfh")
            )
            .respond(
                response()
                    .withStatusCode(200)
                    .withHeader("Access-Control-Allow-Origin", "*")
                    .withHeader("Content-Type", "application/json; charset=utf-8")
                    .withBody("[\n" +
                        "  {\n" +
                        "    \"id\": 85626528,\n" +
                        "    \"name\": \"repo-with-releases\",\n" +
                        "    \"full_name\": \"noizwaves/repo-with-releases\",\n" +
                        "    \"owner\": {\n" +
                        "      \"login\": \"noizwaves\",\n" +
                        "      \"id\": 1007983,\n" +
                        "      \"avatar_url\": \"https://avatars3.githubusercontent.com/u/1007983?v=3\",\n" +
                        "      \"gravatar_id\": \"\",\n" +
                        "      \"url\": \"https://api.github.com/users/noizwaves\",\n" +
                        "      \"html_url\": \"https://github.com/noizwaves\",\n" +
                        "      \"followers_url\": \"https://api.github.com/users/noizwaves/followers\",\n" +
                        "      \"following_url\": \"https://api.github.com/users/noizwaves/following{/other_user}\",\n" +
                        "      \"gists_url\": \"https://api.github.com/users/noizwaves/gists{/gist_id}\",\n" +
                        "      \"starred_url\": \"https://api.github.com/users/noizwaves/starred{/owner}{/repo}\",\n" +
                        "      \"subscriptions_url\": \"https://api.github.com/users/noizwaves/subscriptions\",\n" +
                        "      \"organizations_url\": \"https://api.github.com/users/noizwaves/orgs\",\n" +
                        "      \"repos_url\": \"https://api.github.com/users/noizwaves/repos\",\n" +
                        "      \"events_url\": \"https://api.github.com/users/noizwaves/events{/privacy}\",\n" +
                        "      \"received_events_url\": \"https://api.github.com/users/noizwaves/received_events\",\n" +
                        "      \"type\": \"User\",\n" +
                        "      \"site_admin\": false\n" +
                        "    },\n" +
                        "    \"private\": false,\n" +
                        "    \"html_url\": \"https://github.com/noizwaves/repo-with-releases\",\n" +
                        "    \"description\": \"A dummy application with releases\",\n" +
                        "    \"fork\": false,\n" +
                        "    \"url\": \"https://api.github.com/repos/noizwaves/repo-with-releases\",\n" +
                        "    \"forks_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/forks\",\n" +
                        "    \"keys_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/keys{/key_id}\",\n" +
                        "    \"collaborators_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/collaborators{/collaborator}\",\n" +
                        "    \"teams_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/teams\",\n" +
                        "    \"hooks_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/hooks\",\n" +
                        "    \"issue_events_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/issues/events{/number}\",\n" +
                        "    \"events_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/events\",\n" +
                        "    \"assignees_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/assignees{/user}\",\n" +
                        "    \"branches_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/branches{/branch}\",\n" +
                        "    \"tags_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/tags\",\n" +
                        "    \"blobs_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/git/blobs{/sha}\",\n" +
                        "    \"git_tags_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/git/tags{/sha}\",\n" +
                        "    \"git_refs_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/git/refs{/sha}\",\n" +
                        "    \"trees_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/git/trees{/sha}\",\n" +
                        "    \"statuses_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/statuses/{sha}\",\n" +
                        "    \"languages_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/languages\",\n" +
                        "    \"stargazers_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/stargazers\",\n" +
                        "    \"contributors_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/contributors\",\n" +
                        "    \"subscribers_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/subscribers\",\n" +
                        "    \"subscription_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/subscription\",\n" +
                        "    \"commits_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/commits{/sha}\",\n" +
                        "    \"git_commits_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/git/commits{/sha}\",\n" +
                        "    \"comments_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/comments{/number}\",\n" +
                        "    \"issue_comment_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/issues/comments{/number}\",\n" +
                        "    \"contents_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/contents/{+path}\",\n" +
                        "    \"compare_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/compare/{base}...{head}\",\n" +
                        "    \"merges_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/merges\",\n" +
                        "    \"archive_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/{archive_format}{/ref}\",\n" +
                        "    \"downloads_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/downloads\",\n" +
                        "    \"issues_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/issues{/number}\",\n" +
                        "    \"pulls_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/pulls{/number}\",\n" +
                        "    \"milestones_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/milestones{/number}\",\n" +
                        "    \"notifications_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/notifications{?since,all,participating}\",\n" +
                        "    \"labels_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/labels{/name}\",\n" +
                        "    \"releases_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/releases{/id}\",\n" +
                        "    \"deployments_url\": \"https://api.github.com/repos/noizwaves/repo-with-releases/deployments\",\n" +
                        "    \"created_at\": \"2017-03-20T20:58:32Z\",\n" +
                        "    \"updated_at\": \"2017-03-20T21:01:48Z\",\n" +
                        "    \"pushed_at\": \"2017-03-20T21:10:51Z\",\n" +
                        "    \"git_url\": \"git://github.com/noizwaves/repo-with-releases.git\",\n" +
                        "    \"ssh_url\": \"git@github.com:noizwaves/repo-with-releases.git\",\n" +
                        "    \"clone_url\": \"https://github.com/noizwaves/repo-with-releases.git\",\n" +
                        "    \"svn_url\": \"https://github.com/noizwaves/repo-with-releases\",\n" +
                        "    \"homepage\": null,\n" +
                        "    \"size\": 1,\n" +
                        "    \"stargazers_count\": 0,\n" +
                        "    \"watchers_count\": 0,\n" +
                        "    \"language\": \"Python\",\n" +
                        "    \"has_issues\": true,\n" +
                        "    \"has_downloads\": true,\n" +
                        "    \"has_wiki\": true,\n" +
                        "    \"has_pages\": false,\n" +
                        "    \"forks_count\": 0,\n" +
                        "    \"mirror_url\": null,\n" +
                        "    \"open_issues_count\": 0,\n" +
                        "    \"forks\": 0,\n" +
                        "    \"open_issues\": 0,\n" +
                        "    \"watchers\": 0,\n" +
                        "    \"default_branch\": \"master\",\n" +
                        "    \"permissions\": {\n" +
                        "      \"admin\": true,\n" +
                        "      \"push\": true,\n" +
                        "      \"pull\": true\n" +
                        "    }\n" +
                        "  },\n" +
                        "  {\n" +
                        "    \"id\": 82588676,\n" +
                        "    \"name\": \"elm-calculator\",\n" +
                        "    \"full_name\": \"noizwaves/elm-calculator\",\n" +
                        "    \"owner\": {\n" +
                        "      \"login\": \"noizwaves\",\n" +
                        "      \"id\": 1007983,\n" +
                        "      \"avatar_url\": \"https://avatars3.githubusercontent.com/u/1007983?v=3\",\n" +
                        "      \"gravatar_id\": \"\",\n" +
                        "      \"url\": \"https://api.github.com/users/noizwaves\",\n" +
                        "      \"html_url\": \"https://github.com/noizwaves\",\n" +
                        "      \"followers_url\": \"https://api.github.com/users/noizwaves/followers\",\n" +
                        "      \"following_url\": \"https://api.github.com/users/noizwaves/following{/other_user}\",\n" +
                        "      \"gists_url\": \"https://api.github.com/users/noizwaves/gists{/gist_id}\",\n" +
                        "      \"starred_url\": \"https://api.github.com/users/noizwaves/starred{/owner}{/repo}\",\n" +
                        "      \"subscriptions_url\": \"https://api.github.com/users/noizwaves/subscriptions\",\n" +
                        "      \"organizations_url\": \"https://api.github.com/users/noizwaves/orgs\",\n" +
                        "      \"repos_url\": \"https://api.github.com/users/noizwaves/repos\",\n" +
                        "      \"events_url\": \"https://api.github.com/users/noizwaves/events{/privacy}\",\n" +
                        "      \"received_events_url\": \"https://api.github.com/users/noizwaves/received_events\",\n" +
                        "      \"type\": \"User\",\n" +
                        "      \"site_admin\": false\n" +
                        "    },\n" +
                        "    \"private\": false,\n" +
                        "    \"html_url\": \"https://github.com/noizwaves/elm-calculator\",\n" +
                        "    \"description\": \"Calculator written in Elm\",\n" +
                        "    \"fork\": false,\n" +
                        "    \"url\": \"https://api.github.com/repos/noizwaves/elm-calculator\",\n" +
                        "    \"forks_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/forks\",\n" +
                        "    \"keys_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/keys{/key_id}\",\n" +
                        "    \"collaborators_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/collaborators{/collaborator}\",\n" +
                        "    \"teams_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/teams\",\n" +
                        "    \"hooks_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/hooks\",\n" +
                        "    \"issue_events_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/issues/events{/number}\",\n" +
                        "    \"events_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/events\",\n" +
                        "    \"assignees_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/assignees{/user}\",\n" +
                        "    \"branches_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/branches{/branch}\",\n" +
                        "    \"tags_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/tags\",\n" +
                        "    \"blobs_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/git/blobs{/sha}\",\n" +
                        "    \"git_tags_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/git/tags{/sha}\",\n" +
                        "    \"git_refs_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/git/refs{/sha}\",\n" +
                        "    \"trees_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/git/trees{/sha}\",\n" +
                        "    \"statuses_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/statuses/{sha}\",\n" +
                        "    \"languages_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/languages\",\n" +
                        "    \"stargazers_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/stargazers\",\n" +
                        "    \"contributors_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/contributors\",\n" +
                        "    \"subscribers_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/subscribers\",\n" +
                        "    \"subscription_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/subscription\",\n" +
                        "    \"commits_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/commits{/sha}\",\n" +
                        "    \"git_commits_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/git/commits{/sha}\",\n" +
                        "    \"comments_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/comments{/number}\",\n" +
                        "    \"issue_comment_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/issues/comments{/number}\",\n" +
                        "    \"contents_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/contents/{+path}\",\n" +
                        "    \"compare_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/compare/{base}...{head}\",\n" +
                        "    \"merges_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/merges\",\n" +
                        "    \"archive_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/{archive_format}{/ref}\",\n" +
                        "    \"downloads_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/downloads\",\n" +
                        "    \"issues_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/issues{/number}\",\n" +
                        "    \"pulls_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/pulls{/number}\",\n" +
                        "    \"milestones_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/milestones{/number}\",\n" +
                        "    \"notifications_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/notifications{?since,all,participating}\",\n" +
                        "    \"labels_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/labels{/name}\",\n" +
                        "    \"releases_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/releases{/id}\",\n" +
                        "    \"deployments_url\": \"https://api.github.com/repos/noizwaves/elm-calculator/deployments\",\n" +
                        "    \"created_at\": \"2017-02-20T18:21:39Z\",\n" +
                        "    \"updated_at\": \"2017-02-20T18:46:55Z\",\n" +
                        "    \"pushed_at\": \"2017-02-23T02:48:18Z\",\n" +
                        "    \"git_url\": \"git://github.com/noizwaves/elm-calculator.git\",\n" +
                        "    \"ssh_url\": \"git@github.com:noizwaves/elm-calculator.git\",\n" +
                        "    \"clone_url\": \"https://github.com/noizwaves/elm-calculator.git\",\n" +
                        "    \"svn_url\": \"https://github.com/noizwaves/elm-calculator\",\n" +
                        "    \"homepage\": null,\n" +
                        "    \"size\": 5,\n" +
                        "    \"stargazers_count\": 0,\n" +
                        "    \"watchers_count\": 0,\n" +
                        "    \"language\": \"Elm\",\n" +
                        "    \"has_issues\": true,\n" +
                        "    \"has_downloads\": true,\n" +
                        "    \"has_wiki\": true,\n" +
                        "    \"has_pages\": false,\n" +
                        "    \"forks_count\": 0,\n" +
                        "    \"mirror_url\": null,\n" +
                        "    \"open_issues_count\": 0,\n" +
                        "    \"forks\": 0,\n" +
                        "    \"open_issues\": 0,\n" +
                        "    \"watchers\": 0,\n" +
                        "    \"default_branch\": \"master\",\n" +
                        "    \"permissions\": {\n" +
                        "      \"admin\": true,\n" +
                        "      \"push\": true,\n" +
                        "      \"pull\": true\n" +
                        "    }\n" +
                        "  }\n" +
                        "]\n")
            );
    }

    public void stop() {
        mockServer.stop();
    }
}
