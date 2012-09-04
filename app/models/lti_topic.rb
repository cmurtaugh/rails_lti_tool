class LtiTopic < ActiveRecord::Base
  attr_accessible :key, :name, :secret, :topic_id, :url, :user_id, :xml_snippet, :launch_url
end
