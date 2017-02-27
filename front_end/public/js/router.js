(function(){
  angular
    .module('todo', ['ui.router'])
    .config(AuthRouter);

  function AuthRouter($stateProvider, $urlRouterProvider){

    $urlRouterProvider.otherwise("/index");

    $stateProvider
    .state('index', {
      url: '/index',
      params: {
        user: null
      }
    })
    .state('login', {
      url: '/login',
      templateUrl: '/partials/login.html',
    })
    .state('signup', {
      url: '/signup',
      templateUrl: '/partials/signup.html',
    })
    .state('addSong', {
      url: '/songs/new',
      templateUrl: '/partials/songs/new.html',
    })
    .state('editSong', {
      url: '/songs/edit',
      params: {
        song: null
      },
      templateUrl: '/partials/songs/edit.html',
    })
    .state('allSongs', {
      url: '/songs',
      templateUrl: '/partials/songs/index.html',
    })
  }
})()
