class CreateLtiTopics < ActiveRecord::Migration
  def change
    create_table :lti_topics do |t|
      t.string :name
      t.string :topic_id
      t.string :url
      t.string :key
      t.string :secret
      t.string :user_id
      t.text :xml_snippet

      t.timestamps
    end
  end
end
