Dashku - open source edition (beta)
===

Welcome to the open source edition of Dashku.

Dashku is a SocketStream application that let's you build real-time Dashboard and Widgets using HTML, CSS, and JavaScript.

The application was a prototype, and was well-received. We would like to share it with everyone, so we've decided to make it open source.

Enjoy.

Anephenix, 7th September 2012

Dependencies
---

- Node.js (0.8)
- MongoDB
- Redis

Installation
---

    git clone git://github.com/Anephenix/dashku.git
    cd dashku
    npm install

Usage
---

    mongod &
    redis-server &
    coffee app.coffee

Testing
---

Dashku has some tests, but not enough. More will be added in the future.

There are also a few unit tests run by Mocha

    cake test

To run the integration test suite

    node_modules/.bin/cucumber.js

License & Credits
---

&copy;2012 Anephenix Ltd.

Dashku is licensed under the [MIT license](www.opensource.org/licenses/MIT)