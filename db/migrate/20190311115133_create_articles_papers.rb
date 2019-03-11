class CreateArticlesPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :articles_papers, :id => false do |t|
      t.references :article, :null => false
      t.references :paper, :null => false
    end

    # Adding the index can massively speed up join tables. Don't use the
    # unique if you allow duplicates.
    add_index(:articles_papers, [:article_id, :paper_id], :unique => true)
  end
end
