namespace :migrations do
  desc "Migrates data to new db structure for new UX"
  task ux_upgrade: :environment do

    print 'Processing reference comments ' + Comment.where(commentable_type: 'Reference').count.to_s + ' '
    Comment.where(commentable_type: 'Reference').order('id asc').all.each do |comment|
      reference = comment.commentable
      if reference.blank? then
        print 'm'
        next
      end
      comment.commentable_id = reference.paper_id
      comment.commentable_type = 'Paper'
      comment.list_id = reference.list_id
      comment.save
      print '.'
    end
    puts ''

    print 'Processing reference activities ' + Activity.where(addable_type: 'Reference').count.to_s + ' '
    Activity.where(addable_type: 'Reference').order('id asc').all.each do |activity|
      reference = activity.addable
      if reference.blank? then
        print 'm'
        next
      end
      activity.addable_id = reference.paper_id
      activity.addable_type = 'Paper'
      activity.save
      print '.'
    end
    puts ''

    puts 'Processing all lists, attaching referenced paper to empty article and article to empty post'
    List.all.each do |list|
      next if list.papers.count == 0
      puts 'Processing list ' + list.name
      list.summaries.all.each do |summary|
        summary.content = summary.content.gsub(/\[r-cite id=(\d+)\]/) do |m|
          ref = Reference.find_by_id(Regexp.last_match[1])
          ref ? '[cite_paper id=' + ref.paper_id.to_s + ']' : m
        end
        summary.save
      end
      post = list.posts.where(content: '').first
      if (! post)
        puts 'Create post'
        post = list.posts.build(user_id: list.user_id, content: '')
        post.save(validate: false)

        puts 'Create article'
        article = post.articles.build(title: '')
        article.save(validate: false)
      end
      print 'Processing papers count ' + list.papers.count.to_s + ' '
      papers = list.papers.all
      papers.each do |paper|
        list.papers.delete paper
        print '.'
        article.papers << paper unless article.papers.where(id: paper.id).count > 0
      end
      puts ''
    end
  end

end
