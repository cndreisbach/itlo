#= require vendor/jquery-1.7.2
#= require library

$(document).ready ->
  $libraryChooser = $("#library-chooser")
  Library.initialize()

  Library.updateClock()
  setInterval Library.updateClock, 1000 * 15
  
  $libraryChooser.find("a").click (event) ->
    Library.choose $(this).data('library')
    event.preventDefault()
