class ModifyActivitiesWithListsAndReferences < ActiveRecord::Migration[5.0]
  def up
    Activity.where("activity_type = 'created' or activity_type = 'added'").each(&:destroy)

    List.find_each(batch_size: 50) do |l|
      Activity.create(user_id: l.owner.id, activity_type: "created", actable: l, created_at: l.created_at, updated_at: l.created_at) unless Activity.find_by(actable: l, activity_type: "created")

      l.references.each do |r|
        Activity.create(user_id: r.user_id, activity_type: "added", actable: l, addable: r, created_at: r.created_at, updated_at: r.created_at) unless Activity.find_by(actable: l, addable: r, activity_type: "added")
      end
    end
  end

  def down
    Activity.where("activity_type = 'created' or activity_type = 'added'").each(&:destroy)
  end
end
