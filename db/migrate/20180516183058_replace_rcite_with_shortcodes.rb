class ReplaceRciteWithShortcodes < ActiveRecord::Migration[5.0]

  class Summary < ActiveRecord::Base
  end

  def up
    Summary.find_each do |summary|
      summary.content = summary.content.gsub(/<r-cite\s:r=["']r\((\d+)\)["']>(?:<\/r-cite>)?/m, '[r-cite id=\1]')
      summary.save!
    end
  end

  def down
    Summary.find_each do |summary|
      summary.content = summary.content.gsub(/\[r-cite\sid=(\d+)\]/m, '<r-cite :r="r(\1)"></r-cite>')
      summary.save!
    end
  end
end
