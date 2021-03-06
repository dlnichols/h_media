###
# models/archive.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This is our archive model.  This resource describes an object that is being
# stored by our archival system.  Initially this archival process will be
# backed by the AWS Glacier service, though plans are to keep it flexible
# eneough to allow for other backends.
###
'use strict'

# External libs
_        = require 'lodash'
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:models:archive'

###
# ArchiveSchema
###
debug 'Loading archive model...'

ArchiveSchema = new mongoose.Schema(
  glacierId:
    type  : String
    unique: true
  glacierDescription: String
)

###
# Whitelist mass assignment fields
###
ArchiveSchema.safeFields = [ "glacierId", "glacierDescription" ]

###
# Virtual Fields
###
# Filter for users
ArchiveSchema
  .virtual 'user'
  .get ->
    @

# Filter for admin
ArchiveSchema
  .virtual 'admin'
  .get ->
    @

###
# Validations
###
# Validate glacierId
ArchiveSchema
  .path 'glacierId'
  .required true,
    'Glacier ID is required'
  .validate (value) ->
    value && Buffer.byteLength(value) == 42
  , 'Glacier ID must be 42?? bytes'
  .validate (value, respond) ->
    self = @
    @constructor.findOne { glacierId: value }, (err, archive) ->
      throw err if err
      if archive
        respond self.id == archive.id
      else
        respond true
  , 'The specified Glacier ID is already in use.'

# Validate glacierDescription
ArchiveSchema
  .path 'glacierDescription'
  .required true,
    'Glacier Description cannot be blank'

###
# Methods
###
ArchiveSchema.methods =
  ###
  # safeAssign - only mass assign whitelisted attributes
  #
  # @params {Object} fields
  # @return {Archive} this
  # @api public
  ###
  safeAssign: (fields) ->
    @[key] = value for key, value of _.pick(fields, ArchiveSchema.safeFields)
    @

module.exports = mongoose.model 'Archive', ArchiveSchema
