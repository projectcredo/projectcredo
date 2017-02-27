class Paper < ApplicationRecord
  attr_accessor :locator_id, :locator_type

  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies

  has_and_belongs_to_many :authors
  has_many :lists, through: :references
  has_many :references, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :api_import_responses, dependent: :destroy
  has_many :highlights

  accepts_nested_attributes_for :authors, reject_if: proc { |attributes| attributes['family_name'].blank? }
  accepts_nested_attributes_for :links
  validates_associated :links
  validates :title, presence: true
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

end
