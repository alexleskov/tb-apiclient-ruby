require './client'
require './endpoints/load_checker'
require './endpoints/load_helper'
require './endpoints/versions/endpoint_v1'
require './endpoints/versions/mobile_v1'
require './endpoints/versions/mobile_v2'

module Teachbase
  module API
    module EndpointsVersion
      LIST = { "users" => "User",
               "course-sessions" => "CourseSession",
               "documents" => "Document",
               "news" => "New",
               "oauth" => "Oauth",
               "offline-events" => "OfflineEvent",
               "profile" => "Profile",
               "user-accounts" => "UserAccount",
               "programs" => "Program",
               "tokens" => "Token",
               "user-activity" => "UserActivity" }.freeze # TODO: "clickmeeting-meetings" => "ClickmeetingMeeting"
    end
  end
end
