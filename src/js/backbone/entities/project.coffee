@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Project extends Entities.Model
    defaults:
      loading: false

    initialize: ->
      @setName()

    loaded: ->
      @set("loading", false)

    isLoading: ->
      !!@get("loading")

    setName: ->
      @set name: @getNameFromPath()

    getNameFromPath: ->
      _(@get("path").split("/")).last()

    setClientUrl: (url, display) ->
      @set
        clientUrl: url
        clientUrlDisplay: display

    setError: (err) ->
      if err.portInUse
        @set("portInUse", true)

      @set "error", err.toString()

    reset: ->
      props = {
        error: null
        portInUse: null
        clientUrl: null
        clientUrlDisplay: null
      }

      @set(props, {silent: true})

      @trigger("rebooted")

  class Entities.ProjectsCollection extends Entities.Collection
    model: Entities.Project

    getProjectByPath: (path) ->
      @findWhere({path: path})

  API =
    getProjects: ->
      projects = new Entities.ProjectsCollection
      App.ipc("get:project:paths").then (paths) ->
        projects.add _(paths).map (path) -> {path: path}
        projects.trigger("fetched")
      projects

  App.reqres.setHandler "project:entities", ->
    API.getProjects()