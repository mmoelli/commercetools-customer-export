_ = require 'underscore'
_.mixin require('underscore-mixins')
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
{SphereClient} = require 'sphere-node-sdk'
CsvMapping = require './mapping-utils/csv'

class CustomerExport

  constructor: (options = {}) ->
    @_exportOptions = _.defaults (options.export or {}),
      fetchHours: 48
    @client = new SphereClient options.client
    @csvMapping = new CsvMapping @_exportOptions

  run: ->
    @_fetchCustomers().then (customers) => @csvExport(customers)

  csvExport: (customers) ->
    throw new Error 'You need to provide a csv template for exporting customer information' unless @_exportOptions.csvTemplate
    fs.readFileAsync(@_exportOptions.csvTemplate, {encoding: 'utf-8'})
    .then (content) => @csvMapping.mapCustomers content, customers

  _fetchCustomers: ->
    @client.customers.all()
    .expand('customerGroup')
    .last("#{@_exportOptions.fetchHours}h")
    .fetch()
    .then (result) ->
      allCustomers = result.body.results
      Promise.resolve allCustomers

module.exports = CustomerExport
