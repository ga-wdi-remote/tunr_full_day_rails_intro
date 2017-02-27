(function(){
  var app = angular.module('todo')
  app.controller('MainCtrl', function($http, $state)  {
      var self = this;
      var rootUrl = "http://localhost:3000"

      $http.get(`${rootUrl}/songs`, {
          headers: {
            'Authorization': 'Bearer ' + JSON.parse(localStorage.getItem('token'))
          }
        })
        .then(function(response) {
          self.songs = response.data.songs;
        })
        .catch(function(err) {
          console.log('err',err);
        });

      // CRUD LOGIC
      // ==============================
      function addSong(newSong) {
        console.log(newSong)
        $http.post(`${rootUrl}/songs`, {song: newSong}, {
            headers: {
              'Authorization': 'Bearer ' + JSON.parse(localStorage.getItem('token'))
            }
          })
          .then(function(response) {
            newSong.title = '';
            newSong.artist_name ='';
            newSong.preview_url = '';
            newSong.artwork = '';
            newSong.price = '';

            $state.go('allSongs', {url: '/songs'})
          })
          .catch(function(err) {
            console.log(err);
          });
      }

      function deleteSong(id) {
        $http.delete(`${rootUrl}/songs/${id}`, {
           headers: {
             'Authorization': 'Bearer ' + JSON.parse(localStorage.getItem('token'))
           }
         })
          .then(function(response) {
            console.log(response);
            $state.go('allSongs', {url: '/songs'}, {reload: true})
          })
      }

      function editSong(song) {
        $http.put(`${rootUrl}/songs/${$state.params.song.id}`,
           { song: song }, {
              headers: {
                'Authorization': 'Bearer ' + JSON.parse(localStorage.getItem('token'))
              }
            })
          .then(function(response){
            console.log(response);
            $state.go('allSongs', {url: '/songs'})
          })
      }

      // PUBLIC METHODS
      this.addSong = addSong;
      this.deleteSong = deleteSong;
      this.editSong = editSong;
    })

    app.controller('AuthCtrl', function($http, $state, $stateParams)  {
      var self = this;
      var rootUrl = "http://localhost:3000"

      function login(userPass) {
        $http.post(`${rootUrl}/users/login`, {user: {username: userPass.username, password: userPass.password}})
          .then(function(response) {
            self.user = response.data.user

            localStorage.setItem('token', JSON.stringify(response.data.token))
            $state.go('index', {url: '/', user: response.data.user})
          })
          .catch((err) => {
            console.log(err);
          });
      }

      function signup(userPass) {
        $http.post(`${rootUrl}/users`, {user: {username: userPass.username, password: userPass.password }})
          .then(function(response) {
            console.log(response)

            $state.go('login', {url: '/login'})
          })
          .catch((err) => {
            console.log(err);
          });
      }

      function logout(userPass) {
        // logout just deletes the token from localStorage
        localStorage.removeItem('token')
        self.user = false // unsets self.user

        $state.go('index', {url: '/'}, { reload: true }) // reload the controller on redirect
      }

      this.login = login;
      this.signup = signup;
      this.logout = logout;
    })
  })();
