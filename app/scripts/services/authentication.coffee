###
# scripts/services/authentication.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.factory 'authentication', ($resource) ->
  $resource '/auth/'
