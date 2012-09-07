Using the API
===

You'll notice that the API url currently points to the ip address for Dashku.com. This is because there is a DNS issue with dashku.com, which is causing any API requests with the domain name to hang for a bit. Until this is fixed, please use the ip address for the API.

API Key
---

Requests are matched based on your API key (shown below). 

Use this API key as a query parameter in your api requests like so:

    curl -H "Content-Type: application/json" "DASHKU_API_URLapi/dashboards?apiKey=API_KEY"

NOTE: For transmission API requests, the API key can be passed directly in the body, rather than in the url as a query parameter. This was done for the download script feature to function. At some point this may change in the future. 