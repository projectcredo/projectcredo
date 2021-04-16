json.array!(@notifications) do |notification|
   json.extract! notification, :id, :user_id, :has_read, :created_at
   json.activity do
      json.added notification.activity.sentence_parts[:added]
      json.preposition notification.activity.sentence_parts[:preposition]
      json.username notification.activity.sentence_parts[:username]
      json.actable notification.activity.actable
      json.type notification.activity.activity_type
   end
end
