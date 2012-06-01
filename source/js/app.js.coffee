#= require vendor/jquery-1.7.2
#= require vendor/bootstrap
#= require data
#= require library
#= require holiday

$(document).ready ->
  $libraryChooser = $("#library-chooser")
  Library.initialize()

  Library.updateClock()
  setInterval Library.updateClock, 1000 * 15

  $libraryChooser.find("a").click (event) ->
    Library.choose $(this).data('library')
    event.preventDefault()
