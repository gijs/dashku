Update a dashboard
===

Update an existing dashboard, based on an id passed in the url.

<span class="badge badge-put">PUT</span> <span class="url">/api/dashboards/:id</span>

Url Parameters
---

- ID: the id of the dashboard e.g. 4fd1f55b7e9b8705a1000054

Put Body
---

You will want to post a body with the following attributes:

- name: The name for your dashboard e.g. "Account Management"
- screenWidth: Defines whether the dashboard uses fixed or fluid width. Values ("fixed" | "fluid")
- css: The custom CSS for the dashboard


    curl -X PUT -d "name=Sterling%20Cooper%20Account%20Management&screenWidth=fluid" "DASHKU_API_URLapi/dashboards/ID?apiKey=API_KEY"

Response
---

You should expect to see a response containing the updated dashboard.

    {
      "_id"         : "4fd1f55b7e9b8705a1000054",
      "name"        : "Sterling Cooper Account Management",
      "userId"      : "4fd1f55b7e9b8705a1000053",
      "widgets"     : [],
      "screenWidth" : "fluid",
      "css"         : "",
      "updatedAt"   : "2012-06-08T14:30:25.940Z",
      "createdAt"   : "2012-06-08T12:51:39.695Z"
    }