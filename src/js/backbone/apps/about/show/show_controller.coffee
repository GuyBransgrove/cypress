@App.module "AboutApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

    initialize: (options = {}) ->
      { window } = options

      updater = App.updater

      aboutView = @getAboutView(updater)

      @listenTo aboutView, "page:clicked", ->
        ## this needs to be moved to an .env variable
        App.execute "gui:external:open", "http://www.cypress.io"

      @show aboutView

    getAboutView: (updater) ->
      new Show.About
        model: updater