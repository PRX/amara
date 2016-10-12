# -*- encoding: utf-8 -*-

require 'rubygems'
require 'active_support/all'

require 'amara/version'
require 'amara/configuration'
require 'amara/connection'
require 'amara/response'
require 'amara/api'
require 'amara/api_factory'
require 'amara/languages'
require 'amara/teams'
require 'amara/teams/members'
require 'amara/teams/projects'
require 'amara/videos'
require 'amara/videos/languages'
require 'amara/videos/languages/subtitles'
require 'amara/videos/urls'
require 'amara/activity'
require 'amara/path'
require 'amara/client'

module Amara
  extend Configuration

  HEADERS = {
    :api_key      => 'X-apikey',
    :api_username => 'X-api-username'
  }

  TEAM_POLICIES = {
    :open           => 'Open',
    :apply          => 'Application',
    :invite         => 'Invitation by any team member',
    :manager_invite => 'Invitation by manager',
    :admin_invite   => 'Invitation by admin'
  }

  POLICIES = {
    :anyone   => 'Anyone',
    :member   => 'Any team member',
    :managers => 'Managers and admins',
    :admins   => 'Admins only'
  }

  class Error         < ::StandardError; end
  class ClientError   < Error; end
  class NotFoundError < Error; end
  class ServerError   < Error; end
  class UnknownError  < Error; end
end
