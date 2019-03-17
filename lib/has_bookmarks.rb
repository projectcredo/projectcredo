module HasBookmarks

  def self.included(base)
    base.class_eval do
      # associations
      has_many :bookmarks, as: :bookmarkable, :dependent => :destroy
    end
  end

  def has_bookmarks_options
    {
      :type => self.class.base_class.name.to_s
    }
  end

  def find_bookmark_by_user(options={})
    (options[:user_id] || options[:user]) || options[:user] = User.current

    options[:user_id] = options.delete(:user).id if options[:user]
    result = self.bookmarks.where(:user_id => options.delete(:user_id))
    result[0]
  end

  def bookmark(options={})
    options[:user_id] = options.delete(:user).id if options[:user]
    self.bookmarks.create(options)
  end

  def remove_bookmark_for(options={})
    bookmark = find_bookmark_by_user(options)
    return !!bookmark.destroy unless bookmark.nil?
    return false
  end

  def bookmarked?(options={})
    ! find_bookmark_by_user(options).nil?
  end

  def bookmarked(options={})
    ! find_bookmark_by_user(options).nil?
  end

  def find_users_that_bookmarked(options={})
    conditions = [
      'bookmarks.bookmarkable_type = ? and bookmarks.bookmarkable_id = ?',
      self.class.has_bookmarks_options[:type],
      self.id
    ]

    unless options[:name].blank?
      conditions[0] += ' and bookmarks.name = ?'
      conditions << options[:name]
      options.delete(:name)
    end

    options = {
      :limit => 10,
      :conditions => conditions,
      :include => :has_bookmarks
    }.merge(options)

    if Object.const_defined?('Paginate')
      User.paginate(options)
    else
      User.all(options)
    end
  end
end
