module ImportHopkinsHelper
  require 'csv'

  def self.import!(file_large, file_small)
    hopkins = {}

    file_attributes = {
      '0' => { columns: 3},
      '1' => { columns: 2}
    }
    # collect terms
    [file_large, file_small].each_with_index do |file, idx|

      file_data = file.read
      file_data = file_data.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")

      CSV.parse(file_data) do |row|
        raise "Invalid CSV format: incorrect number of columns" if row.length != file_attributes[idx.to_s][:columns]
        hopkins[row[0]] = row[1]
      end
    end

    hopkins_language = Language.hopkins.first
    base_language = Language.base.first
    default_integration_status = IntegrationStatus.default.first

    # Glossary Terms ONLY!!!!
    glossary_terms = GlossaryTerm.where('tibetan is not null').pluck(:tibetan, :id).group_by do |t|
      t[0].downcase.gsub('-', ' ').gsub('‘', '''')
    end

    # p '!!!!!!!!!!!!!'
    # p (glossary_terms.keys & hopkins.keys).count

    (glossary_terms.keys & hopkins.keys).each do |tibetan|
      ids = glossary_terms[tibetan].collect{|t| t[1]}
      GlossaryTerm.where(id: ids).includes([:glossary_term_translations]).each do |term|
        translation = term.glossary_term_translations.select{|t| t.language_id == hopkins_language.id}.first
        translation ||= term.glossary_term_translations.new(
          language_id: hopkins_language.id,
          integration_status: default_integration_status)
        translation.term = hopkins[tibetan]
        translation.alt_term3 = tibetan
        translation.save!
      end
    end
  end
end

