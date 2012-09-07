Transmit data to the widget
===

Transmits data to a widget

<span class="badge badge-post">POST</span> <span class="url">/api/transmission</span>

There are 2 ways you can pass your API key: either as a query parameter, or in the body

Passing API Key as a query parameter
---

Just like the other API methods, append the apiKey query parameter to the url, like this:

    ?apiKey=API_KEY

Passing API Key in the body
---

Alternatively, you can embed the apiKey attribute in the body.

Post Body
---

You will want to post a body with the following attributes:

- _id: the id of the widget


    curl -X POST -d "_id=:id" "DASHKU_API_URLapi/transmission?apiKey=API_KEY"

Response
---

You will get back a simple response:

    { status: 'success' }