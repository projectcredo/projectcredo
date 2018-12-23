class Paper < PaperBase
  attr_accessor :locator_id, :locator_type

  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies

  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :api_import_responses, dependent: :destroy

  accepts_nested_attributes_for :authors, reject_if: proc { |attributes| attributes['family_name'].blank? }
  accepts_nested_attributes_for :links
  validates_associated :links
  validate :allowed_biases, :allowed_methodologies

  before_save :downcase_name

  def downcase_name
    # This needs to be fixed - either we require a publication name or we stop downcasing
    self.publication.try :downcase!
  end

  def allowed_biases
	  invalid_biases = bias_list - valid_biases
	  invalid_biases.each {|b| errors.add(b, 'is not a supported bias') }
	end

  def allowed_methodologies
    invalid_methodologies = methodology_list - valid_methodologies
    invalid_methodologies.each {|b| errors.add(b, 'is not a supported methodology') }
  end

  def valid_biases
    [
      'selection',
      'performance',
      'detection',
      'attrition',
      'reporting',
      'small sample size'
    ]
  end

  def valid_methodologies
    [
      'meta-analysis',
      'systematic review',
      'randomized control trial',
      'quasi-experiment',
      'cohort',
      'case-control',
      'cross-sectional survey',
      'case report'
    ]
  end

  # Skips validations, fallthrough to autosave methods for easy import
  def validate_associated_records_for_authors; true; end
  def validate_associated_records_for_links; true; end

  def autosave_associated_records_for_authors
    self.authors = authors.map do |author|
      Author.find_or_create_by given_name: author.given_name, family_name: author.family_name
    end
  end

  def direct_link
    if self.doi.present?
      "http://dx.doi.org/#{self.doi}"
    elsif self.pubmed_id.present?
      "https://www.ncbi.nlm.nih.gov/pubmed/#{self.pubmed_id}"
    else
      self.links.first.url
    end
  end

  def age
    if self.published_at
      now = Time.now.utc.to_date
      age = now.year - self.published_at.year - ((now.month > self.published_at.month || (now.month == self.published_at.month && now.day >= self.published_at.day)) ? 0 : 1)
      return age < 1 ? '< 1' : age
    end
  end

end
