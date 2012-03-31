#= require jquery-1.7.2
#= require moment
#= require bootstrap
#= require libraries
#= require hours

$(document).ready ->
  $("#now").html moment().format("h:mm a")
  $("#library-chooser a").click ->
    $("#library-chooser .btn-text").text($(this).text())
    $(document).data('library', $(this).data('library'))
