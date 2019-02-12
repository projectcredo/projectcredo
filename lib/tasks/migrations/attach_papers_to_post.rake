namespace :migrations do
  desc "Creates empty post for each list and attaches all current not attached to posts papers to that post"
  task attach_papers_to_post: :environment do
    List.all.each do |list|
      next if list.papers.count == 0
      puts 'Processing list ' + list.name
      post = list.posts.where(content: '').first
      if (! post)
        puts 'Create post'
        post = list.posts.build(user_id: list.user_id, content: '')
        post.save(validate: false)
      end
      print 'Processing papers count ' + list.papers.count.to_s + ' '
      papers = list.papers.all
      papers.each do |paper|
        list.papers.delete paper
        print '.'
        post.papers << paper unless post.papers.where(id: paper.id).count > 0
      end
      puts ''
    end
  end

end
