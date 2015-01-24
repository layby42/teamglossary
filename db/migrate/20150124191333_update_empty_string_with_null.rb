class UpdateEmptyStringWithNull < ActiveRecord::Migration
  def up
    [
      :tibetan, :sanskrit, :pali,
      :alternative_tibetan, :alternative_sanskrit,
      :additional_explanation, :sanskrit_gender,
      :pali_gender, :definition].each do |field|
      execute("UPDATE glossary_terms SET #{field} = NULL WHERE #{field} = '';")
    end

    [
      :alt_term1, :alt_term2, :alt_term3,
      :notes, :term_gender, :definition].each do |field|
      execute("UPDATE glossary_term_translations SET #{field} = NULL WHERE #{field} = '';")
    end

    [
      :tibetan, :sanskrit, :explanation,
      :dates, :rejected_because].each do |field|
      execute("UPDATE glossary_names SET #{field} = NULL WHERE #{field} = '';")
    end

    [:alt_term1, :alt_term2, :alt_term3, :notes].each do |field|
      execute("UPDATE glossary_name_translations SET #{field} = NULL WHERE #{field} = '';")
    end

    [
      :alt_term1, :alt_term2, :popular_term, :author, :author_translit,
      :tibetan_full, :tibetan_short, :sanskrit_full, :sanskrit_short,
      :sanskrit_full_diacrit, :sanskrit_short_diacrit, :pali,
      :explanation, :rejected_because].each do |field|
      execute("UPDATE glossary_titles SET #{field} = NULL WHERE #{field} = '';")
    end

    [:alt_term1, :alt_term2, :alt_term3, :notes, :author].each do |field|
      execute("UPDATE glossary_title_translations SET #{field} = NULL WHERE #{field} = '';")
    end

    [
      :cms_name, :name, :remark, :item_type, :length_type,
      :additional_text, :wiki_qa, :full_cms_path].each do |field|
      execute("UPDATE general_menus SET #{field} = NULL WHERE #{field} = '';")
    end

    [ :name, :notes, :additional_text].each do |field|
      execute("UPDATE general_menu_translations SET #{field} = NULL WHERE #{field} = '';")
    end

    [:name].each do |field|
      execute("UPDATE general_menu_actions SET #{field} = NULL WHERE #{field} = '';")
    end
  end

  def down
  end
end
