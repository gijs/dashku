Delete a dashboard
===

Delete a dashboard, based on an id passed in the url.

<span class="badge badge-delete">DELETE</span> <span class="url">/api/dashboards/:id</span>

Url Parameters
---

- ID: the id of the dashboard e.g. 4fd1f55b7e9b8705a1000054


    curl -X DELETE "DASHKU_API_URLapi/dashboards/ID?apiKey=API_KEY"

Response
---

You will get back the id of the dashboard that you deleted

    {"dashboardId":"4fd1f55b7e9b8705a1000054"}