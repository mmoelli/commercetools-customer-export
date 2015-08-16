_ = require 'underscore'
_.mixin require('underscore-mixins')
Promise = require 'bluebird'
CustomerExport = require '../lib/customerexport'
Config = require '../config'

describe 'CustomerExport', ->

  beforeEach ->
    @customerExport = new CustomerExport client: Config
    expect(@customerExport._exportOptions).toEqual
      fetchHours: 48

  #it '#run', -> # TODO

  #it '#csvExport', -> # TODO

  it '#_fetchCustomers (all)', (done) ->
    spyOn(@customerExport.client.customers, 'fetch').andCallFake -> Promise.resolve
      body:
        results: [1, 2]
    @customerExport._fetchCustomers()
    .then (customers) ->
      expect(customers).toEqual [1, 2]
      done()
    .catch (e) -> done e
