json.extract! paper, :id, :title, :title, :published_at, :created_at, :abstract, :doi, :pubmed_id, :publication, :abstract_editable, :paper_editable, :import_source, :referenced_by_count, :bookmarks_count
json.cover_thumb paper.cover.url(:thumb)
json.cover_medium paper.cover.url(:medium)
json.authors paper.authors
json.tags paper.tags
json.direct_link paper.direct_link
json.comments get_json_tree(paper.comments.order('created_at DESC'))
