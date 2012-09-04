class AddLaunchUrlToLtiTopics < ActiveRecord::Migration
  def change
    add_column :lti_topics, :launch_url, :string
  end
end
