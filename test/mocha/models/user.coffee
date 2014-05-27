###
# test/mocha/models/user.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Tests for our User model
###
'use strict'

# External libs
should   = require 'should'

# Internal libs
require '../../../lib/bootstrap'
Factory = require '../../factories/user'
User    = require '../../../lib/models/user'

###
# User model test cases
###
describe 'Model - User', ->
  # Ensure we are in a clean state by removing all users at start
  before (done) ->
    User.remove done

  describe 'Method Save', ->
    it 'should save valid users', (done) ->
      user = Factory.build('user')
      user.save (err) ->
        should.not.exist err
        done()

    it 'should not allow duplicate emails', (done) ->
      user = Factory.build('user', email: 'dupeme@dupe.com')
      dupe = Factory.build('user', email: 'dupeme@dupe.com')
      user.save (err) ->
        should.not.exist err
        dupe.save (err) ->
          should.exist err
          done()

  # Clean up by removing all users after each test case
  afterEach (done) ->
    User.remove done
