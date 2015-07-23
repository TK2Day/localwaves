## LocalWaves

* Currently running on: https://mighty-crag-3152.herokuapp.com/

## Authorization

Routes in the User Registration section are authenticated
by Username/Password unless otherwise mentioned.

Routes elsewhere in the app are authenticated by passing
an 'Access-Token' header along with the request.

## Parameters

Italicized parameters are optional.

### User Registration & Auth

#### Creating a User

**Route:** `POST /users`

**Params:**

| Parameter |  Type  |
| --------- |  ----  |
|  Email    | String |
|  Password | String |
|  City     | String |
|  State    | String |

Note that Usernames and Emails in LocalWaves must be unique.

Example success (Code 201 - Created):

```json
{
  "user": {
    "id": 7,
    "email": "foo6@bar.com",
    "username": "foo6",
    "access_token": "a1bf55c9f9a4e5002372be13fd2abb10"
  }
}
```

Example Failure (Code 422 - Unprocessable Entity):

```json
{
  "errors": [
    "Username has already been taken",
    "Email has already been taken"
  ]
}
```

#### Logging In with an Existing User

**Route:** `POST /users/sign_in`

**Params:**

| Parameter | Type   |
| --------- | ------ |
| Email     | String |
| Password  | String |

Example Success (Code 200 - OK) - Same as Created JSON

Example Failure (Code 401 - Unauthorized)

```json
{
  "message": "Incorrect email or password."
}
```

#### Adding OAuth Access to a User's Soundcloud Account

**NOTE:**

    This endpoint is not intended to be used directly, but rather to be used as a
    redirect URI for Soundcloud API integration with a separate frontend.

    This route requires coordination as to Client ID, Secret and Redirect URI
    with the Rails API user.

**Route:** `POST /users/oauth`

**Params:**

| Parameter | Type   |
| --------- | ------ |
| Code      | String |
| State     | String |

The *code* param should be an authorization code received from Soundclound.

The *state* param should be an email of a registered user.

Success will result in a redirect to the frontend home page.

### User Data

#### Getting a User's Info

**Route:** `GET /user/:id`

**Params:** None

Example Success (Code 200 - OK):

```json
{
  "user": {
    "id": 1,
    "email": "brit@tiy.com",
    "username": "awesomesauce",
    "artist_name": null,
    "access_token": "15b3215dbb564a1e539c9691f9da3152",
    "city": null,
    "state": null
  }
}
```

Example Failure (Code 404 - Not Found):

```json
{
  "message": "Couldn't find requested object",
  "method": "GET",
  "path": "/user/48"
}
```

#### Requesting Sync of User's Tracks

**Route:** `POST /user/:id/sync`

**Params:** None

Example Success (Code 200 - OK):

```json
{
  "message": "TrackImportJob has been queued."
}
```

#### Deleting a User

**Route:** `DELETE /user/:id`

**Params:**

| Parameter | Type   |
| --------- | ------ |
| Password  | String |

Example Success (Code 204 - No Content):

```json
```

Example Failure (Code 401 - Unauthorized):

```json
{
  "message": "Incorrect username or password."
}
```

#### Resetting a User's Access Token

**Route:** `DELETE /user/:id/token`

**Params:**

| Parameter | Type   |
| --------- | ------ |
| Password  | String |

Example Success (Code 202 - Accepted):

  (Same JSON as User Creation)

Example Failure: (Code 401 - Unauthorized):

```json
{
  "message": "You don't have permission to reset token for: 'foo5'."
}
```

### Track Data

#### Getting a User's Tracks

**Route:** `GET /user/:id/tracks`

**Params:** None

Example Success (Code 200 - OK):

```json
{
  "tracks": [
    {},
    {},
    {}
  ]
}
```

#### Track Search

**Route:** `GET /tracks/search`

**Params:**

| Parameter  | Type   |
| ---------- | ------ |
| City       | String |
| State      | String |
| *Genre*    | String |

Example Success (Code 200 - OK):

  Same format as User's Tracks.

#### Track Completions

**Route:** `GET /tracks/completion`

**Params:** None

Example Success (Code 200 - OK):

```json
{
  "cities": ["Atlanta", "Chicago", "New York", "San Antonio"],
  "states": ["GA", "IL", "NY", "TX"],
  "genres": ["Industrial", "Rap", "R&B", "Darkwave", "Witch Hop"]
}
```

#### All Tracks

**Route:** `GET /tracks`

**Params:**

| Parameter | Type   |
| --------- | -----  |
| *Page*    | Number |

Returns the tracks in pages of 25 ordered by database ID.

Example Success (Code 200 - OK):

  Same format as User's Tracks.
