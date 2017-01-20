# Geobot

[![CI Status](http://img.shields.io/travis/vadymmarkov/geobot.svg?style=flat)](https://travis-ci.org/vadymmarkov/geobot)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Mac OS X](https://img.shields.io/badge/os-Mac%20OS%20X-green.svg?style=flat)
![Swift](https://img.shields.io/badge/%20in-swift%203.0.1-orange.svg)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

[Wit.ai](https://wit.ai) chat bot built with [Vapor](https://github.com/vapor/vapor) Swift web framework.

A simple chat bot to work with https://restcountries.eu API, using Wit.ai.

## Test it out

- Don't be shy, just Say Hi! Don't leave [Geobot](https://geobot-swift.herokuapp.com)
alone.
- Don't forget to check [Wit Console](https://wit.ai/vadymmarkov/geobot) to
see all the magic behind it.

## Features

- [x] Greetings
- [x] Help and quick replies
- [x] Capitals
- [x] Location of countries in the world
- [x] Area of countries
- [x] Population of Countries

## Playground

Do you want to setup the project locally and pretend that you're doing some
real AI stuff? Be my guest!

### Setup Wit.ai

- [Sign up](https://wit.ai) for a **Wit.ai** account.
- Follow the [guidelines](https://wit.ai/docs/recipes#manage-link) on how to export
[geobot app](https://wit.ai/vadymmarkov/geobot) and import it when creating
your new mind-blowing app.
- Find the app token under Settings page in the **Wit.ai** console.
- Set environment variable `WIT_TOKEN` with your token or alternatively create
a new config file `geobot/Config/secrets/wit.json`:

```json
{
  "token": "$WIT_TOKEN"
}
```

### Setup project

```sh
git clone https://github.com/vadymmarkov/geobot.git
cd geobot
swift build
.build/debug/App
```

# Resources

- [Wit.ai Quick start](https://wit.ai/docs/quickstart)
- [Vapor documentation](https://vapor.github.io/documentation/)
- [REST Countries API](https://restcountries.eu)

## Author

Vadym Markov, markov.vadym@gmail.com

## Contributing

We would love you to contribute to **Geobot**, check the [CONTRIBUTING](https://github.com/vadymmarkov/geobot/blob/master/CONTRIBUTING.md)
file for more info.

## License

**Geobot** is available under the MIT license. See the [LICENSE](https://github.com/vadymmarkov/geobot/blob/master/LICENSE.md) file for more info.
