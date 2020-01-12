require './lib/tbclient/endpoints/versions/endpoint_v1'
require './lib/tbclient/endpoints/versions/mobile_v1'
require './lib/tbclient/endpoints/versions/mobile_v2'

module Teachbase
  module API
    module Endpoints
      VERSIONS = { endpoint_v1: "https://go.teachbase.ru/endpoint/v1",
                   mobile_v1: "https://go.teachbase.ru/mobile/v1",
                   mobile_v2: "https://go.teachbase.ru/mobile/v2" }.freeze
      LIST = { "users" => "User", "profile" => "Profile", "course_sessions" => "CourseSession" }.freeze # TODO: "clickmeeting-meetings" => "ClickmeetingMeeting"
    end
  end
end
