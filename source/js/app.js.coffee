#= require vendor/jquery-1.7.2
#= require_tree ./vendor
#= require libraries
#= require templates

chooseLibrary = (library) ->
  monster.set('library', library)
  newLibrary = libraries[library]
  $("#library-chooser .btn-text").text(newLibrary.name)
  $("#hours").html(templates.hours(name: newLibrary.name, hours: newLibrary.hours))
  newLibrary

getDefaultLibrary = () ->
  library = monster.get('library')
  chooseLibrary(library)
  libraries[library]

updateClock = () ->
  $("#now").html moment().format("dddd [at] h:mm a")

$(document).ready ->
  $libraryChooser = $("#library-chooser")
  defaultLibrary = getDefaultLibrary()

  updateClock()
  setInterval updateClock, 1000 * 60
  
  $libraryChooser.find("a").click (event) ->
    library = $(this).data('library')
    defaultLibrary = chooseLibrary(library)
    event.preventDefault()
