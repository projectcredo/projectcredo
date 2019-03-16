namespace :migrations do
  desc "Creates empty post for each list and attaches all current not attached to posts papers to that post"
  task attach_papers_articles_and_posts: :environment do
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
