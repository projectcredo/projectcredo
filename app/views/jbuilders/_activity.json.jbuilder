json.user activity.sentence_parts[:username]
json.type activity.activity_type
json.updated_at time_ago_in_words(activity.updated_at)
json.addable activity.sentence_parts[:added]
json.addable_href activity.sentence_parts[:paper_direct_link]
