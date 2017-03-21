# A better Github Releases UI

A user-focussed workflow driven UI for Github.

# Setup

This project setup was inspired by the [Elm Tutorial](https://www.elm-tutorial.org/en/04-starting/06-webpack-4.html) and uses Webpack.

To get started developing, after cloning this repo run:

1) Install [Elm runtime package](https://guide.elm-lang.org/install.html)

1) Install some global dependencies
   ```bash
   brew install yarn
   ```

1) Install project's Node dependencies from NPM
   ```bash
   yarn install
   ```

1) Install the project's Elm dependencies
   ```bash
   elm package install
   ```

# Development

1) Start a local development server.
   ```bash
   yarn dev
   ```
1) Navigate to [http://localhost:3000/](http://localhost:3000/)

# Testing

Unit tests are written using [elm-test](http://package.elm-lang.org/packages/elm-community/elm-test) and [elm-html-test](http://package.elm-lang.org/packages/eeue56/elm-html-test). Run all tests using the CLI test runner by invoking `yarn test`.