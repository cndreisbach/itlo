#= require_tree ./vendor
#= require data

class Holiday
  constructor: (data) ->
    {@name} = data
    @date = moment(data.date)

Holiday.getHoliday = (date) ->
  dateStr = date.format("YYYY-MM-DD")
  Holiday.all[dateStr]

Holiday.isHoliday = (date) ->
  @getHoliday(date)?

Holiday.all = {}

Holiday.add = (date, name) ->
  if not moment.isMoment(date)
    date = moment(date)
  dateStr = date.format("YYYY-MM-DD")
  Holiday.all[dateStr] = new Holiday(date: dateStr, name: name)

for date, name of holidays
  Holiday.add(date, name)

window.Holiday = Holiday
