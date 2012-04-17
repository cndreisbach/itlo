#= require vendor/mocha
#= require vendor/chai
#= require library
#= require holiday

mocha.setup 'bdd'
should = chai.should()

describe "Library", ->
  library = new Library
    name: "Test Library"
    hours:
      Sunday: [1400, 1800]
      Monday: [0900, 1800]
      Tuesday: []
    address:
      street: "103 Choctaw Dr"
      zip: "27701"
      phone: "919-867-5309"

  describe "#fullAddress", ->
    it "should add Durham, NC to the address", ->
      library.fullAddress().should.equal("103 Choctaw Dr, Durham NC 27701")

  describe "#isOpen", ->
    it "should be open when the data shows it would be open", ->
      library.isOpen(moment().day(0).hours(15)).should.be.true
    it "should not be open when the data for the day is empty", ->
      library.isOpen(moment().day(2)).should.be.false
    it "should not be open when there is no data for the day", ->
      library.isOpen(moment().day(3)).should.be.false
    it "should not be open when there is a holiday", ->
      Holiday.add(moment().day(1), "Special Monday")
      library.isOpen(moment().day(1).hours(10)).should.be.false

describe "Holiday", ->
  it "can be created from a text date", ->
    holiday = new Holiday(name: "June First", date: "2012-06-01")
    holiday.date.valueOf().should.equal(moment("June 1, 2012").valueOf())

