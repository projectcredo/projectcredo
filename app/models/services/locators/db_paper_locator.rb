class DbPaperLocator
  attr_accessor :locator_id, :errors

  def initialize locator_params={}
    self.locator_id = locator_params[:id].strip
    self.errors = []
  end

  def find_or_import_paper
    Paper.find_by id: locator_id
  end

  def valid?
    is_id = locator_id.match(/^\d+$/)
    errors << "\"#{locator_id}\" is not a number" unless is_id
    is_id
  end
end
