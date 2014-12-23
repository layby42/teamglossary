class AddRejectReason < ActiveRecord::Migration
  def change
    add_column :glossary_titles, :rejected_because, :text
    add_column :glossary_terms, :rejected_because, :text
    add_column :glossary_names, :rejected_because, :text
  end
end
