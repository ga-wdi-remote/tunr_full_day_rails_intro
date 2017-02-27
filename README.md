---
title: Full Day Rails Lesson
type: lesson
duration: All Day
creator:
    name: Colin Hart
    campus: WDIR
competencies: Programming
---

## Learning Objectives

- Build a json api using Ruby on Rails
- Set up cors
- Describe and implement user sessions and auth in Rails
- Practice with multi-relational objects
- MVC in rails
- Models

---

1. Make a new rails app called `tunr_json_api`

  $`rails install tunr_json_api --api -d postgreql -T`

2. Add the following lines to `config/env/development.rb`

  ```ruby
  # Add Rails 4.2 serverside rendered errors
  config.debug_exception_response_format = :default
  ```

3. Replace byebug with `gem 'pry-rails'` on line 25 in the Gemfile then run `bundle install`

> GOTCHA: Definitely make sure you tack on the words `json_api` or just `_api` to the end of your Rails app name.

Take 10 minutes to quickly skim through the [getting started guides](http://guides.rubyonrails.org/getting_started.html)

Don't start writing any code.

### Walking through the folders and the response cycle compared to Node/Express


```
Rails
                                         -----> Model <----> DB
                                         |         |
            response        request      |         |
   Browser <-------- server/router -------> controller/json <--
                             GET         ^
                             PUT         |
                             POST         -----> ~view~ <----> ~html/images/css/js~
                             DELETE

```
```
Node/Express

                               |-----> Mongo Middleware <----> DB/Schema.rb
                               |         |         |
             response      request       |         |
    Browser <-------- server/router --> router <---
                              GET         ^
                              PUT         |
                              POST         -----> view <----> html/images/css/js
                              DELETE

```

Let's test this out and see what happens.

Run `rails server` to start the server. We should all get a sweet error!

Take two minutes to read through it.

```
FATAL: database "____________" does not exist
```

### The Database! but wait...

What flag do we add to configure rails for postgresql

> Remember that in MEAN mongo created the database automatically when we first inserted something. Not so in Ruby on Rails and PG

run the command

$`rails db:create`

```
Created database '____development'
Created database '____test'
```

*Databases!*

The database is created so now what?

Check the server again. What do we have now?

## Yay you're on Rails
#### Error Driven Development!


Open the file `config/routes.rb`

In Rails we define routes in the routes.rb file. We specify an http verb, a route to listen for and then a controller and method to run

1. Between `do` and `end` we're going to define a root route.

  ```ruby
  Rails.application.routes.draw do
    root 'welcome#index'
  end
  ```

  We could also wright this as

  ```ruby
  Rails.application.routes.draw do
    # verb route, goes to the welcome controller and the index method
    get '/', to: 'welcome#index'
  ```

  We can translate the above code to the following in english.

  `root` refers to get requests at `/`. When the root route is hit, look for a controller called WelcomeController in `app/controllers` and inside of that class look for a method named `index`

  Run the command $`rails routes` to see the routes that exist in a tabular format in the terminal.

  *Run the rails server and go to localhost:3000 and read the error*

  ```
    uninitialized constant WelcomeController
  ```

2. Touch a file called welcome_controller.rb in app/controllers

  $`touch app/controllers/welcome_controller.rb`

  *Run the rails server and go to localhost:3000 and read the error*

  ```
  #<LoadError: Unable to autoload constant WelcomeController, expected /app/controllers/welcome_controller.rb to define it
  ```

3. Add a class WelcomeController which inherits from ApplicationController to the `welcome_controller.rb` file

  ```
  class WelcomeController < ApplicationController

  end
  ```
  *Run the rails server and go to localhost:3000 and read the error*

  ```
    #<AbstractController::ActionNotFound: The action 'index' could not be found for WelcomeController>"
  ```

4. Great! It's sees that the controller exists. It's now looking for an index action. Meaning it's looking for a method called index to call when the route is hit.

  Inside of the `WelcomeController` define a method named `index` with one line `render json: {status: 200, message: "Hello World!"}`

  ```
  def index
    render json: {status: 200, message: "Hello World!"}
  end
  ```

  Check `localhost:3000`!

# QUESTIONS?!

### Let's get back to the database

So how do we add tables to the database: Take 10 minutes to refresh your brain about migrations.

http://guides.rubyonrails.org/active_record_migrations.html

DO NOT MIGRATE YET. We need to set up our migrations first.

Set up a migration for Users.

`rails g migration CreateUsers`

We can see from the output that it has created a new directory and a file for us inside of the `db` directory.

Open up that file.

```ruby
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    end
  end
end
```

Correct naming here and pluralization is _VITAL_ User/**s** table, plural.

```ruby
def change
  create_table :users do |t|
    t.string :username
  end
end
```

`|t|` refers to table
`t.string` refers to the data-type
`:username` the symbol refers to the name of the column

run $`rails db:migrate`

A successful migration will output the following:
```
== 20161026183909 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0213s
== 20161026183909 CreateUsers: migrated (0.0213s) =============================
```

We've successfully created a User table in our database. If we were to open psql:

1. `psql` (open the psql command-line toold)
2. `\l` (list databases)
3. `\c database_name_development` (connect to a database)
4. `\dt` (list the database tables)
5. `\d+ users` (list information about the users table)

We'd see a users table with the columns `id`, `username`.

So how do we access our postgres database using Rails?

You should remember this from yesterday!

We need to create a user model file in `app/models` and make a class user that inherits from ApplicationModel.

1. $`touch app/models/user.rb` (SINGULAR)

2. In `models/user.rb`

```rb
class User < ApplicationRecord

end
```

3. Now run the command $`rails console` and type `User.new`

It's a new User template! We now can make new users from our Controller


**You do** (30mins)

Make a migration and model for the following database object. Run rails db:migrate after you finish the migration. Run rails c to create some test objects

```ruby
# Songs
rails generate migration CreateSongs

- Should have the following attributes:
  - title - string
  - artist - text
  - preview_url - string
  - artwork - string
  - price - integer
  - artist_id - references  
```

###  Models

Spend 10 minutes reading through Rails documentation on [validations](http://guides.rubyonrails.org/active_record_validations.html)

Add validations to the User model:

In user.rb add:

`validates :username, presence: true, uniqueness: true`

Let's test this in the Rails Console

**You do** (15mins)

Set up validations on Song
- should validate the presence of title, artist, preview_url, artwork
BONUS:
- should validate that price is a number, and is between 0 and 99

#Seed

**We do**

With the db all setup lets seed our database, using the seeds.rb file!

Add the `gem faker` to line 26 in the gemfile. run `bundle installs`

https://github.com/stympy/faker#fakername

```ruby
10.times do
  User.create(name: Faker::Name.name)
end

10.times do
  Song.create(
    title: Faker::Hipster.sentence(3),
    artist: Faker::Team.name,
    preview_url: "preview_url.com",
    artwork: Faker::Placeholdit.image("50x50"),
    price: .99
  )
end
```

run $`rails db:seed` to run the ruby code in `seed.rb`


### Routes

Take 10 minutes and read the [routing documentation](http://guides.rubyonrails.org/routing.html).

Specifically, make sure you read these two sections:
- [2.4 Defining multiple resources at the same time](http://guides.rubyonrails.org/routing.html#defining-multiple-resources-at-the-same-time)
- 4.6 Restricting the Routes Created

#### Using Resources

**We do**

We need to set up our routes for our application.

Set up a root route. So we're going to modify and remove our dummy welcome controller and route and make real ones.

Add `resources :user` to the routes.rb file

run $`rails -T`

*All the routes!*

We actually only need create, show, and destroy:

`resources :user, only: [:create, :show, :destroy]``

**You do**(7 mins)

Create the routes for songs as we did for users.

Songs should have the routes create, show, update, index, and destroy

### Controllers and accessing parameters

We will build the Users controller together.

In our routes file we defined three user routes. We need to create three methods one for each route.

```
def create
end

def show
end

def destroy
end
```

What type of code do you think needs to go in each route?


```ruby
# [...]

def show
  binding.pry
  user = User.find(5)
end

# [...]
```

```ruby
# [...]

def show
  user = User.find(params[:id])

  render json: {status: 200, user: user}
end

# [...]
```

*You do:* Fill in the delete route with the active record command to destroy and access the dynamic segment using the params method

Bonus: what status code should you send when you delete a resource?

### Creating resources and the Strong Params pattern

Read:

- [Strong Params](http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters)
- [Strong Params addition Post](http://weblog.rubyonrails.org/2012/3/21/strong-parameters/)
- [Optional - What is Mass Assignment:](https://code.tutsplus.com/tutorials/mass-assignment-rails-and-you--net-31695)


Let's add the strong params pattern to our users controller!

Under our three controller methods:

```ruby
# [controller methods ...]

private

def user_params
  params.required(:user).permit(:username)
end

```
Create users using `user_params` method

```ruby
  def create
    user = User.new(user_params)

    if user.save
      render json: {status: 200, message: "ok"}
    else
      render json: {status: 422, user: user}
    end
  end  
```

**You do** (25 min)

### Song Controller


- *index* - should render json of all the songs
- *show* - should find an individual song by id
- *create* - should create a new song based on the song_params. It should render 200 and the song if `create` was successful, and 422 and the song if unsuccessful.
- *update* - should find a song by id and update the song with the song_params. It should render 200 and the song if `update` was successful, and 422 and the song if unsuccessful.
- *destroy* - should find a song by id and destroy that song. It should render 204, and `message: "no content"` if `delete` was successful, and 400, message: "bad request" if unsuccessful.
- song_params - should require all of the needed attributes to create a song.

----

*You Do*

# Create Artists

1. Should have five routes, same five as the song controller.
2. Needs an Artist Model
3. An artist migration

  $`rails generate migration CreateArtists`

  - Should have the following attributes:
    - name - string
    - img_url - text
    - nationality - string

### Artist Controller

- *index* - should render json of all the artists
- *show* - should find an individual artist by id
- *create* - should create a new artist based on the artist_params. It should render 200 and the artist if `create` was successful, and 422 and the artist if unsuccessful.
- *update* - should find a artist by id and update the artist with the artist_params. It should render 200 and the artist if `update` was successful, and 422 and the artist if unsuccessful.
- *destroy* - should find a artist by id and destroy that artist. It should render 204, and `message: "no content"` if `delete` was successful, and 400, message: "bad request" if unsuccessful.
- artist_params - should require all of the needed information to create a artist.

BONUS:
- should validate the presence of name and if name is not entered give a message of "Name can not be blank"
- should validate the presence of name and if nationality is not entered give a message of "Nationality can not be blank"
- should validate the presence of name and if img_url is not entered give a message of "Photo can not be blank"
- should validate that the genre the user inputs is valid. Valid options are Electronic, House, Jazz, Indie, Hip Hop
- should delete all of the artists songs if the artist is deleted


### We do, Associating artists with songs

Spend 10 more minutes reading up on [associations](http://guides.rubyonrails.org/association_basics.html)

1. Create and run a migration that adds an `artist_id` to the songs table

  $`rails g migration AddArtistReferenceToSongs`

  `add_reference :todos, :user, foreign_key: true`

We have the right foreign keys in our database but Rails requires that we actually specify our Relationships/Associations

- Song belongs_to :artist
- Artist has_many :songs

The way this Rails app has been built we'd probably want our routes to look like this:

```
/artists/:artist_id/songs/:id
```

We could achieve this really easily by modifying our routes

```ruby
resources :artists do
  resources :songs
end
```

This lab was structured to give you practice writing controllers individually. We could refactor our controllers, database objects and routes to match the above pattern, so that we can't create songs until we have an Artist.

That's actually a fairly straightforward process, unfortunately we have time constraints and that's not quite the App that we're building

We want to be able to have songs without artists but if the artist exists, we want to create the relation.

Currently with our association a song *_must_* have an artist_id or it will fail to load. We can modify that behavior by adding `belongs_to :artists, optional: true` to the Song Model

### Updating the Songs Controller

We want to update the create method so it will query the database by the name of the Artist the user passed and set the foreign_key *if* it exists or don't if it does not.

Add :artist_id to your strong params

```ruby
def create
  artist = Artist.where(name: song_params.artist)

  song = Song.new(song_params)

  song.artist_id = artist.id if !artist.empty?

  if song.save
    render json: {status: 200, message: "ok"}
  else
    render json: {status: 422, song: song}
  end
end

private

def song_params
  params.required(:song).permit(
    :title, :artist, :preview_url, :artwork, :price, :artist_id
  )
end
```

# Join table bonus fun time

### Create a playlists table.

`rails generate migration CreatePlaylists`

- Should have the following attributes:
  - name - string

#### PlaylistsSongs Join table [We do!]

Set up the join table. `rails g migration CreateJoinTable playlists songs`

- Should have the following attributes
  - playlist_id - integer
  - song_id - integer

- should have a has_and_belongs_to_many relationship with songs and vice versa
- should validate the presence of name
- should validate the uniqueness of name
- should have a method `add_song(song)` on the model. Leave empty for now
- should have a method `remove_song(song)`. Leave empty for now.

Add a playlist resources helper with members of add_song and remove_song

Member blocks allow us to add additional routes to the standard http routes given to us by resources.

The member block specifically let's us add routes that require an ID, because it acts on a member — a specific type of resource

```ruby
resources :playlists do
  member do
    put 'add_song'
    put 'remove_song'
  end
end
```

- playlist controller together

```ruby
def index
  playlists = Playlist.all
end

def show
  playlist = Playlist.find(params[:id])
end

def create
  playlist = Playlist.new(playlist_params)
  if playlist.save
    render json: {status: 200, playlist: playlist}
  else
    render json: {status: 400, playlist: playlist}
  end
end

def update
  playlist = Playlist.find(params[:id])
  playlist.update(playlist_params)
  render json: {status: 200, playlist: playlist}
end

def destroy
  playlist = Playlist.find(params[:id])
  playlist.destroy
  render json: {status: 204}
end

def add_song
  playlist = Playlist.find(params[:id])
  song = Song.find(params[:song_id])
  #TODO playlist.add_song ??

  playlist.add_song(song)
  render json: {status: 200, playlist: playlist}
end

def remove_song
  playlist = Playlist.find(params[:id])
  song = Song.find(params[:song_id])
  playlist.remove_song(song)

  render json: {status: 204, playlist: playlist}
end

private

def playlist_params
  params.require(:playlist).permit(:name)
end

```

Playlist model
```ruby
class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :songs

  validates :name, presence: true
  validates :name, uniqueness: true

  #TODO check these figure out how these work
  def add_song(song)
    self.songs.push(song) unless self.songs.include?(song)
  end

  #TODO this to class methods
  def remove_song(song)
    self.songs.destroy(song) if self.songs.include?(song)
  end
end
```

Add `has_and_belongs_to_many :playlists` to the Song model


# BREATHE AND RELAX WE JUST BUILT A GIANT RAILS APP.
