Delete a widget
===

Deletes a widget from a dashboard, given the dashboard id and widget id.

<span class="badge badge-delete">DELETE</span> <span class="url">/api/dashboards/:dashboard_id/widgets/:id</span>

Url Parameters
---

- dashboard_id: the id of the dashboard e.g. 4fd1f55b7e9b8705a1000054
- id: the id of the widget e.g. 4fd331e38caaf987a7000052

    
    curl -X DELETE "http://localhost:3000/api/dashboards/:dashboard_id/widgets/:id?apiKey=aa3431ef-dfc7-44cd-992b-1324a1fc0034"

Response
---

You should expect to get back the id of the widget you have deleted.

    {"widgetId":"4fd331e38caaf987a7000052"}