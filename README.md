# Planit Server

# Running the server

### Install elixir
```
brew install elixir
```

### Install hex
```
mix local.hex
```

### Install phoenix
```
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez
```

### Install Dependencies
```
mix deps.get
```

### Make sure that mysql.server is running
```
mysql.server start
```

Note: if you set a password for your mysql server, then you must configure your database to by setting the "password" field in config/dev.exs.

### Setup database and dependencies
```
make drop
make setup
```

### Run server
```
make start
```

# Endpoints V1

General information:

* All information should be sent in JSON. Set header to application/json.
* For updates, only include the fields that should be updated.

To create sample data (GET):

```
/api/v1/createsample
```

## Users
#### Get a user by user id (GET)
```
/api/v1/users/:id
```

Returns a user object if get is successful.
Returns null if no users with the provided user id exist in the database.

#### Create a user (POST)
```
/api/v1/users

payload = {
  fname: "John",
  lname: "Walsh",
  email: "johnwalsh@example.com",
  username: "jwalshy",
  birthday: "1996-02-19"
}
```
Email and username must be unique. 

Returns user id if create is successful.
Returns 400 and an error message if email/username is taken or if fields are entered incorrectly. 


#### Update a user's information (PUT)
```
/api/v1/users/:id

payload = {
  email: "walshyjohn@example.com"
}
```

Returns "ok" if update is successful.
Returns 400 and an error message if the update is not successful.

## Permissions
#### Get all users who have permission to edit a trip (GET)
```
/api/v1/permissions?trip_id=:id
```

Returns a list of user ids that correspond to the users that have permission to edit the trip. The user who created the trip is included in this list as well.

#### Check if a user has permission to edit a trip (GET)
```
/api/v1/permissions?trip_id=:trip_id&user_id=:user_id
```

Returns true if the given user has permission to edit the given trip.
Returns false if the given user does not have permission to edit the given trip.

#### Give a user permission to edit a trip (POST)

```
/api/v1/permissions

payload = {
  user_id: 10,
  trip_id: 5
}

```

Returns "ok" if insert is successful.
Returns 400 and an error message if not successful.

#### Remove editing permissions for a given user and trip
```
/api/v1/permissions?user_id=:user_id&trip_id=:trip_id
```

Returns "ok" if delete is successful.
Returns 400 and an error message if not successful.

## Trips

#### Get all "published" trips to display on the explore page (GET)
```
/api/v1/trips
```

Returns a list of trip objects if get is successful.
Returns an empty list if there are no trips in the database.

#### Get all trips created by a user (GET) 
```
/api/v1/trips?user_id=:id
```

Returns a list of trip objects if get is successful.
Returns an empty list if that user id isn't associated with any trips.

#### Get a trip by trip id (GET)
```
/api/v1/trips/:id
```

Returns a list containing one trip object if get is successful.
Returns an empty list if that trip id doesn't exist in the database.

#### Create a trip (POST)
```
/api/v1/trips

payload = {
  name: "Thailand Fun Adventure",
  publish: true,
  photo_url: "http://exampleurl.com/akagjagj.JPG"
  user_id: 2,
  start_time: "2017-12-12 00:00:00",
  end_time: "2017-12-24 00:00:00"
}
```

Returns trip id if create is successful.
Returns 400 and an error message if not successful.

#### Update a trip (PUT)
```
/api/v1/trips/:id

payload = {
  name: "Korea fun adventure"
}
```

Returns "ok" if update is successful.
Returns 400 and an error message if the update is not successful.

#### Delete a trip (DELETE)

Deleting a trip deletes any cards associated with the trip. The trip is also removed as a favorited trip for any users who have favorited it.

```
/api/v1/trips/:id
```

Returns "ok" if delete is successful. 
Returns 400 and an error message if the delete is not successful.

#### Upvote/downvote a trip (GET)
 
Upvote and downvote a trip.
Increments or decrements the number of upvotes or downvotes by 1

```
/api/v1/trips/:trip_id/upvote

/api/v1/trips/:trip_id/downvote
```
Returns "ok" if upvote/downvote is successful. 
Returns 400 and an error message if the upvote/downvote is not successful.

## Favorited trips
#### Get all trips favorited by a user (GET)
```
/api/v1/favorited?user_id=:id
```

Returns a list of trip ids that correspond to the user's favorited trips if get is successful. The list is ordered by descending update time (will change this to visited time soon). 
Returns an empty list if that user hasn't favorited any trips or does not exist.

#### Favorite a trip (POST)
```
/api/v1/favorited

payload = {
  user_id: 100,
  trip_id: 5
}

```

Returns "ok" if insert is successful.
Returns 400 and an error message if not successful.

#### Update a favorited trip (PUT)
```
/api/v1/favorited?user_id=:user_id&trip_id=:trip_id

payload = {
  visited_at: "2017-12-13 20:01:01"
}
```

Returns "ok" if update is successful.
Returns 400 and an error message if not successful.

#### Un-favorite a trip (DELETE)
```
/api/v1/favorited?user_id=:user_id&trip_id=:trip_id
```

Returns "ok" if delete is successful.
Returns 400 and an error message if not successful.

## Cards
#### Get cards by trip id  (GET)
```
/api/v1/cards?trip_id=:id
```
Returns a list of card objects if get is successful.
Returns an empty list if that trip id isn't associated with any cards.

#### Get cards by trip id and day number (GET)
```
/api/v1/cards?trip_id=:trip_id&day=:day_number
```
Returns a list of card objects if get is successful.
Returns an empty list if that combination of trip id and day number isn't associated with any cards.

#### Create new cards (POST)

Must provide a **list** of cards, even if you are only trying to insert one card.

```
/api/v1/cards

package = [ 
{ type:"hotel",
  name:"Hanover Inn",
  city:"hanover",
  country:"USA",
  address:"3 Wheelock street",
  lat:123123.12,
  long:121231.12312,
  start_time:"2017-12-12 20:01:01",
  end_time:"2017-12-13 20:01:01",
  day_number:1,
  trip_id:1,
  travel_duration:900,
  travel_type:"bike",
  description: "Hotel",
  photo_url: "http://examplephotourl.com/picture.jpg",
  url: "https://www.yelp.com/biz/pine-restaurant-hanover-2"
  },
{ type:"hotel",
  name:"Hanover Inn",
  city:"hanover",
  country:"USA",
  address:"3 Wheelock street",
  lat:123123.12,
  long:121231.12312,
  start_time:"2017-12-12 20:01:01",
  end_time:"2017-12-13 20:01:01",
  day_number:1,
  trip_id:1,
  travel_duration:900,
  travel_type:"bike"
  }
]
```

Returns "ok" if create is successful.
Returns 400 and "BAD" if the create is not successful. Nothing will be inserted into the database if this error message is returned. We're still working on figuring out a more useful error message.

#### Update multiple cards (POST)

Takes in a list of cards to update and/or insert into the database. Only one new card can be inserted into the database, and it must have an id of 0. Must provide a **list** of cards, even if you are only trying to insert/update one card.

```
/api/v1/cards?trip_id=:id

package = [ 
{ id: 5,
  type:"hotel",
  name:"Hanover Inn",
  city:"hanover",
  country:"USA",
  address:"3 Wheelock street",
  lat:123123.12,
  long:121231.12312,
  start_time:"2017-12-12 20:01:01",
  end_time:"2017-12-13 20:01:01",
  day_number:1,
  trip_id:1,
  travel_duration:900,
  travel_type:"bike",
  description:"Best hotel in Hanover",
  photo_url:""
  },
{ id: 0
  type:"restaurant",
  name:"Pine",
  city:"hanover",
  country:"USA",
  address:"3 Wheelock street",
  lat:123123.12,
  long:121231.12312,
  start_time:"2017-12-12 20:01:01",
  end_time:"2017-12-13 20:01:01",
  day_number:1,
  trip_id:1,
  travel_duration:900,
  travel_type:"walking"
  }
]
```

Returns a list of the updated cards sorted by start time. Returns any error messages appended to the end of the list. Cards with invalid ids error out and are not created/inserted. Instead an error message is added to the end of the list of updated cards. 

#### Update single card (PUT) 
Update single card. Returnes an error if the card id does not exist.

```
/api/v1/cards/:id


package =  
{ id: 5,
type:"hotel",
     name:"Hanover Inn",
     city:"hanover",
     country:"USA",
     address:"3 Wheelock street",
     lat:123123.12,
     long:121231.12312,
     start_time:"2017-12-12 20:01:01",
     end_time:"2017-12-13 20:01:01",
     day_number:1,
     trip_id:1,
     travel_duration:900,
     travel_type:"bike",
     description:"Best hotel in Hanover",
     photo_url:""
}


```


Returns a list of card objects if create is successful. You'll have to get the new id from this list.
Returns "BAD" if the update/insert is not successful.

#### Update a single card (PUT)
```
/api/v1/cards/:id

payload =  
{ 
  start_time:"2017-12-12 20:01:01",
  end_time:"2017-12-13 20:01:01",
  travel_duration:"10:10:10"
}
```

Returns "ok" if update is successful.
Returns 400 and an error message if not successful.

#### Delete a card (DELETE)
```
/api/v1/cards/:id
```

Returns "ok" if delete is successful. 
Returns 400 and an error message if the delete is not successful.

## Yelp 

#### Get businesses near a location (GET)
```
/api/v1/yelp?latitude=:lat&longitude=:long
```

Returns 20 businesses if get is successful.
Returns an error message if no businesses were found near the provided coordinates. Make sure that South latitudes and west longitudes are negative.

#### Get certain categories of businesses near a location (GET)
```
/api/v1/yelp?latitude=:lat&longitude=:long&categories=:categories
```

The categories should be a string of categories, separated by commas, with no spaces in the string. For example, "bars,french" will filter by Bars and French (i.e. will return bars AND French restaurants). For a list of supported categories, see https://www.yelp.com/developers/documentation/v2/all\_category\_list.

Returns 20 businesses if get is successful.
Returns an error message if no businesses in those categories were found near the provided coordinates. 

# TESTING

## Example curls 

### Create a user
curl -X POST -d '{"fname":"david","lname":"walsh","email":"davidwalsh@example.com","username":"davidwalsh2","birthday":"2000-11-20"}' -H "Content-Type: application/json" http://localhost:4000/api/v1/users

### Update a user
curl -X PUT -d '{"fname":"john","email":"davidwalsh@example.com"}' -H "Content-Type: application/json" http://localhost:4000/api/v1/users/1

### Give edit permissions to a user
curl -X POST -d '{"user_id":4,"trip_id":1}' -H "Content-Type: application/json" http://localhost:4000/api/v1/permissions

### Create a trip 
curl -X POST -d '{"name":"updated trip name","user_id":1}' -H "Content-Type: application/json" http://localhost:4000/api/v1/trips

### Copy an existing trip
curl -X POST -d '{"user_id":1}' -H "Content-Type: application/json" http://localhost:4000/api/v1/trips?original_id=1

### Update a trip
curl -X PUT -d '{"name":"updated trip name"}' -H "Content-Type: application/json" http://localhost:4000/api/v1/trips/1

### Create cards
curl -X POST -d '[
{"type":"hotel","name":"Hanover Inn","city":"hanover","country":"USA","address":"3 Wheelock street","lat":123123.12,"long":121231.12312,"start_time":"2017-12-12 20:01:01","end_time":"2017-12-13 20:01:01","day_number":1,"trip_id":1,"travel_duration":"10:10:10","travel_type":"bike"},
{"type":"attraction","name":"Baker Berry","city":"hanover","country":"USA","address":"1 Tuck street","lat":1231.12,"long":123.12,"start_time":"2017-12-14 20:01:01","end_time":"2017-12-15 20:01:01","day_number":2,"trip_id":1,"travel_duration":"10:10:10","travel_type":"bike"}]' -H "Content-Type: application/json" http://localhost:4000/api/v1/cards

### Update single card
curl -X PUT -d '
{"type":"attraction","name":"Baker Berry","city":"hanover","country":"USA","address":"1 Tuck street","lat":1231.12,"long":123.12,"start_time":"2017-12-14 20:01:01","end_time":"2017-12-15 20:01:01","day_number":2,"trip_id":1,"travel_duration":"10","travel_type":"bus"}' -H "Content-Type: application/json" http://localhost:4000/api/v1/cards/2

### Update multiple cards
curl -X POST -d '[
{"id":0,"type":"new act","name":"boloco","city":"hanover","country":"USA","address":"lebanon street 2","lat":121.12,"long":12123.12312,"start_time":"2017-12-12 20:01:01","end_time":"2017-12-13 20:01:01","day_number":1,"trip_id":1,"travel_duration":"10","travel_type":"bike"},
{"id":5,"type":"hotel","name":"Hanover Inn","city":"hanover","country":"USA","address":"3 Wheelock street","lat":123123.12,"long":121231.12312,"start_time":"2017-12-12 20:01:01","end_time":"2017-12-13 20:01:01","day_number":1,"trip_id":1,"travel_duration":"10","travel_type":"uber"},
{"id":6,"type":"attraction","name":"Baker Berry","city":"hanover","country":"USA","address":"1 Tuck street","lat":1231.12,"long":123.12,"start_time":"2017-12-14 20:01:01","end_time":"2017-12-15 20:01:01","day_number":2,"trip_id":1,"travel_duration":"10","travel_type":"bus"}]' -H "Content-Type: application/json" http://localhost:4000/api/v1/cards?trip_id=1

### Update multiple cards to reorder them (drag and drop test). Use right after creating sample
#### List returned should be bolocco -> Hanover Inn -> Baker Berry
curl -X POST -d '[
{"id":0,"type":"new act","name":"boloco","city":"hanover","country":"USA","address":"lebanon street 2","lat":121.12,"long":12123.12312,"start_time":"2017-12-12 20:01:01","end_time":"2017-12-13 20:01:01","day_number":1,"trip_id":1,"travel_duration":"10","travel_type":"bike"},
{"id":2,"type":"hotel","name":"Hanover Inn","city":"hanover","country":"USA","address":"3 Wheelock street","lat":123123.12,"long":121231.12312,"start_time":"2017-12-12 20:11:01","end_time":"2017-12-13 20:01:01","day_number":1,"trip_id":1,"travel_duration":"10","travel_type":"uber"},
{"id":3,"type":"attraction","name":"Baker Berry","city":"hanover","country":"USA","address":"1 Tuck street","lat":1231.12,"long":123.12,"start_time":"2017-12-14 20:10:01","end_time":"2017-12-15 20:01:01","day_number":2,"trip_id":1,"travel_duration":"10","travel_type":"bus"}]' -H "Content-Type: application/json" http://localhost:4000/api/v1/cards?trip_id=1

### Update a card
curl -X PUT -d '{"lat":1123.123}' -H "Content-Type: application/json" http://localhost:4000/api/v1/cards/1

### Get businesses near Hanover with Yelp API
curl -X GET http://localhost:4000/api/v1/yelp?latitude=43.7022&longitude=-72.2896

### Get chocolate- and donut-related businesses near Hanover with Yelp API
curl -X GET http://localhost:4000/api/v1/yelp?latitude=43.7022&longitude=-72.2896&categories=chocolate,donuts

### Get business near Hanover with Foursquare API
curl -X GET http://localhost:4000/api/v1/foursquare?latitude=43.7022&longitude=-72.2896
or
curl -X GET http://localhost:4000/api/v1/foursquare?near=Hanover,NH

### Get chocolate- and donut-related businesses near Hanover with Foursquare API
curl -X GET http://localhost:4000/api/v1/foursquare?latitude=43.7022&longitude=-72.2896&categories=chocolate,donuts
or
curl -X GET http://localhost:4000/api/v1/foursquare?near=Hanover,NH&categories=chocolate,donuts

