#= require ./vendor/moment
#= require ./vendor/monster
#= require_tree ./templates

class Library
  constructor: (data) ->
    {@name, @hours, @address, @phone} = data

  fullAddress: ->
    "#{@address.street}, Durham NC #{@address.zip}"

  isOpen: (date) ->
    day = date.format("dddd")
    time = date.format("HHmm")
    not(Holiday.isHoliday(date)) and
      @hours[day]? and
      @hours[day].length == 2 and
      @hours[day][0] <= time <= @hours[day][1]

  openMessage: (date) ->
    dow = date.day()
    day = moment.weekdays[dow]
    if @isOpen(date)
      "until #{mt @hours[day][1]}"
    else
      time = date.format("HHmm")
      if not(Holiday.isHoliday(date)) and @hours[day][0] > time
        "It will open at #{mt @hours[day][0]} today."
      else
        date = date.add('days', 1)
        dow = date.day()
        day = moment.weekdays[dow]
        while Holiday.isHoliday(date) or @hours[day].length != 2
          date = date.add('days', 1)
          dow = date.day()
          day = moment.weekdays[dow]
        "It will open at #{mt @hours[day][0]} on #{day}."

Library.current = ->
  $(document).data('library')

Library.choose = (library) ->
  if (library isnt Library.current())
    monster.set 'library', library, 365
    $(document).data('library', library);
    newLibrary = Library.all[library]
    $("#library-chooser .btn-text").text "the #{newLibrary.name}"
    @displayOpenInfo(library)
    $("#hours").html JST['templates/hours']
      name: newLibrary.name
      hours: newLibrary.hours
      mt: Library.formatMilTime
      mod: (a, b) -> a % b
    $("#contact").html JST['templates/contact']
      name: newLibrary.name
      address: newLibrary.address
      phone: newLibrary.phone
    $("#map").gMap
      address: newLibrary.fullAddress()
      zoom: 16
      controls: ["GSmallZoomControl3D"]
      scrollwheel: false
      markers: [
        address: newLibrary.fullAddress()
        html: "#{newLibrary.name}<br><a target='_blank' href='http://maps.google.com/maps?q=#{newLibrary.fullAddress()}'>Google Map</a>"
      ]

Library.displayOpenInfo = (library) ->
  library = @all[library]
  $("#open-info").html JST['templates/open']
    open: library.isOpen moment()
    message: library.openMessage moment()

Library.updateClock = () ->
  $("#now").html moment().format "dddd, MMMM Do, YYYY [at] h:mm a"
  if Library.current()
    Library.displayOpenInfo(Library.current())

Library.formatMilTime = (milTime) ->
  hours = milTime.slice(0, 2)
  minutes = milTime.slice(2, 4)
  am_pm = if hours < 12 then "AM" else "PM"
  printed_hours = hours % 12
  printed_hours += 12 if printed_hours == 12
  if minutes is "00"
    "#{printed_hours} #{am_pm}"
  else
    "#{printed_hours}:#{minutes} #{am_pm}"

this.mt = Library.formatMilTime

Library.initialize = () ->
  library = monster.get('library') ? "main"
  @choose library if library

Library.all = {}

for key, data of libraries
  Library.all[key] = new Library(data)

window.Library = Library
