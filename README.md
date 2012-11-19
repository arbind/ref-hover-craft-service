# Craft Service (For Food Trucks)

Identifies Food Trucks from around the world, saves them to mongoDB and updates them in real time based on social activity.

## Capabilities

* Scans the web looking for Food Trucks in major metros around the world (scheduled jobs):
  * Populates DB with info about a Food Truck's Craft and its WebCrafts (Twitter, Yelp, Facebook and its website).
  * Uses the [craftoid gem](https://github.com/arbind/craftoid.git) to save a FoodTruck's Craft and its WebCrafts to mongoDB.
  * [Users can then search for Food Trucks +++TODO](http://www.food-truck.me) (a separate standalone app - which also uses the craftoid gem).
* Listens to real-time activity of a Food Truck to determine its location and schedule info:
  * Handles events emitted from data sources via redis to create, update and re-rank of Food Trucks based on activity.
  * [FoodTruck Tweet Stream Data Source +++TODO](http://food-truck.ws/) 
  * [FoodTruck Yelp Reviews Data Source +++TODO](https://github.com/arbind) 
  * [Food Trucks Search App +++TODO](http://www.food-truck.me) (Emits usage events when users and food truck owners engage with the app).

## Event Handling

This Craft Service handles the following events, which are emitted from the data sources and the search app:

* materialize-craft event (real-time from TweetStream and Scan Results)
  * Creates a new Food Truck on new twitter id or new yelp id.
* tweet event (real-time from TweetStream Data Source)
  * Increases the rank of a Food Truck on its tweet to reflect recent activity.
* location event (real-time from TweetStream Data Source)
  * Increases the rank of a Food Truck on location tweets and updates the craft with its new location and schedule info.
* user review event (on-demand from Yelp Datasource)
  * Increases the rank of a Food Truck on submission of new user reviews (and ratings).
* search event (real-time from search app)
  * Increases the rank of a Food Truck on user engagement from search app (search, favorite, whish-list, tweet, etc.)
* food truck owner events (real-time from search app)
  * Increases the rank of a Food Truck on owner engagement from search app(profile, location, coupons, survey, etc.)

Whenever a food truck tweets, 2 events could be fired: one for the recent tweet, and another if the tweet contains location info.
