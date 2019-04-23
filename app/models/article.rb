class Article < ApplicationRecord
  include HasBookmarks

  attr_reader :cover_remote_url

  acts_as_taggable

  belongs_to :post
  has_and_belongs_to_many :papers

  validates :title, presence: true

  has_attached_file :cover, styles: { thumb: '100x100#', medium: '1280x1024#', original: '2000x2000>' },
                    :convert_options => { :all => '-quality 75' },
                    default_url: '/images/article/cover/:style/missing.jpg'
  validates_attachment :cover, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }


  def cover_thumb() cover.url(:thumb) end
  def cover_medium() cover.url(:medium) end

  def avatar_remote_url=(url_value)
    self.cover = URI.parse(url_value)
    @cover_remote_url = url_value
  end
end
