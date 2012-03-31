#= require vendor/coffeekup

window.templates = templates = {}

helpers =
  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

templates.hours = ->
  h2 "#{@name} hours"
  dl '.dl-horizontal', ->
    for day, [start, stop] of @hours
      dt capitalize(day)
      dd "#{start} - #{stop}"

for key, template of templates
  templates[key] = CoffeeKup.compile(template, hardcode: helpers)

