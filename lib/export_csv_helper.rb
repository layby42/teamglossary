module ExportCsvHelper
  require 'csv'

  def self.prepare(glossary_class, language, data, options={})
    case glossary_class.to_s
    when 'GlossaryName'
      if language.is_base_language?
        self.prepare_base_proper_names(language, data, options)
      else
        self.prepare_proper_names(language, data, options)
      end
    when 'GlossaryTerm'
      if language.is_base_language?
        self.prepare_base_technical_terms(language, data, options)
      else
        self.prepare_technical_terms(language, data, options)
      end
    when 'GlossaryTitle'
      if language.is_base_language?
        self.prepare_base_text_titles(language, data, options)
      else
        self.prepare_text_titles(language, data, options)
      end
    else
      raise 'invalid data type'
    end
  end

  private

  def self.prepare_base_proper_names(language, data, options)
    csv_string = CSV.generate({force_quotes: true, encoding: 'UTF-8', col_sep: ','}) do |csv|
      csv << self.cms_file_title(language.full_name, data.count, options[:query])

      # columns
      csv << [
        'PROPER_NAME_TYPE',
        'PROPER_NAME_CREATED_DATE',
        'PROPER_NAME_CHANGED_DATE',
        'PROPER_NAME_INTEGRATION_STATUS',
        'PROPER_NAME',
        'TIBETAN',
        'SANSKRIT',
        'DATES',
        'EXPLANATION'
      ]
      # CMS columns, must start with #
      csv << [
        "##{ProperNameType.full_name_csv}",
        "#{language.iso_code} Proper Name Created",
        "#{language.iso_code} Proper Name Changed",
        IntegrationStatus.full_name_csv(language.iso_code),
        "#{language.iso_code} Proper Name",
        'Tibetan',
        'Sanskrit',
        'Person dates',
        'Explanation'
      ]
      # data
      data.each do |term|
        csv << [
          term.proper_name_type.code,
          term.created_at,
          term.updated_at,
          term.integration_status.code,
          term.term,
          term.tibetan,
          term.sanskrit,
          term.dates,
          term.explanation
        ]
      end
    end
  end

  def self.prepare_proper_names(language, data, options)
    csv_string = CSV.generate({force_quotes: true, encoding: 'UTF-8', col_sep: ','}) do |csv|
      csv << self.cms_file_title(language.full_name, data.count, options[:query])
      # columns
      csv << [
        'PROPER_NAME_TYPE',
        'PROPER_NAME_CREATED_DATE',
        'PROPER_NAME_CHANGED_DATE',
        'PROPER_NAME_INTEGRATION_STATUS',
        'PROPER_NAME', 'TIBETAN',
        'SANSKRIT',
        'DATES',
        'PROPER_NAME_TRANSLATION',
        'PROPER_NAME_TRANSLATION_ALTERNATIVE_1',
        'PROPER_NAME_TRANSLATION_ALTERNATIVE_2',
        'PROPER_NAME_TRANSLATION_ALTERNATIVE_3',
        'PROPER_NAME_TRANSLATION_CREATED_DATE',
        'PROPER_NAME_TRANSLATION_CHANGED_DATE',
        'PROPER_NAME_TRANSLATION_INTEGRATION_STATUS',
        'EXPLANATION',
        'NOTE'
      ]

      base_language = Language.base_language
      # CMS columns, must start with #
      csv << [
        "##{ProperNameType.full_name_csv}",
        "#{base_language.iso_code} Proper Name Created",
        "#{base_language.iso_code} Proper Name Changed",
        IntegrationStatus.full_name_csv(base_language.iso_code),
        "#{base_language.iso_code} Proper Name",
        'Tibetan',
        'Sanskrit',
        'Person dates',
        "#{language.english_name} (#{language.iso_code}) Proper Name",
        "#{language.english_name} (#{language.iso_code}) Alternative Proper Name #1",
        "#{language.english_name} (#{language.iso_code}) Alternative Proper Name #2",
        "#{language.english_name} (#{language.iso_code}) Alternative Proper Name #3",
        "#{language.iso_code} Proper Name Created", "#{language.iso_code} Proper Name Changed",
        IntegrationStatus.full_name_csv(language.iso_code),
        'Explanation',
        'Notes'
      ]

      data.each do |term|
        translation = term.glossary_name_translations.by_language(language.id).first
        csv << [
          term.proper_name_type.code,
          term.created_at,
          term.updated_at,
          term.integration_status.code,
          term.term,
          term.tibetan,
          term.sanskrit,
          term.dates,
          "#{translation.term if translation}",
          "#{translation.alt_term1 if translation}",
          "#{translation.alt_term2 if translation}",
          "#{translation.alt_term3 if translation}",
          "#{translation.created_at if translation}",
          "#{translation.updated_at if translation}",
          term.explanation,
          "#{translation.notes if translation}"
        ]
      end
    end
  end

  def self.prepare_base_technical_terms(language, data, options)
    csv_string = CSV.generate({force_quotes: true, encoding: 'UTF-8', col_sep: ','}) do |csv|
      csv << self.cms_file_title(language.full_name, data.count, options[:query])

      # columns
      csv << [
        'TERM_GENERAL_STATUS',
        'TERM_REFERENCE_TYPE',
        'TERM_SANSKRIT_STATUS',
        'TERM_CREATED_DATE',
        'TERM_CHANGED_DATE',
        'TERM_INTEGRATION_STATUS',
        'TERM',
        'TIBETAN',
        'ALTERNATIVE_TIBETAN',
        'SANSKRIT',
        'ALTERNATIVE_SANSKRIT',
        'PALI',
        'ARABIC',
        'TERM_DEFINITION',
        'ADDITIONAL_EXPLANATION'
      ]
      # CMS columns, must start with #
      csv << [
        "##{GeneralStatus.full_name_csv}",
        ReferenceType.full_name_csv,
        SanskritStatus.full_name_csv,
        "#{language.iso_code} Term Created",
        "#{language.iso_code} Term Changed",
        IntegrationStatus.full_name_csv(language.iso_code),
        "#{language.iso_code} Term",
        'Tibetan',
        'Alternative Tibetan',
        'Sanskrit',
        'Alternative Sanskrit',
        'Pali',
        'Arabic',
        "#{language.iso_code} Definition",
        'Additional explanation'
      ]
      # data
      data.each do |term|
        csv << [
          term.general_status.code,
          term.reference_type.code,
          term.sanskrit_status.code,
          term.created_at,
          term.updated_at,
          term.integration_status.code,
          term.term,
          term.tibetan,
          term.alternative_tibetan,
          term.sanskrit,
          term.alternative_sanskrit,
          term.pali,
          term.arabic,
          term.definition,
          term.additional_explanation
        ]
      end
    end
  end

  def self.prepare_technical_terms(language, data, options)
    csv_string = CSV.generate({force_quotes: true, encoding: 'UTF-8', col_sep: ','}) do |csv|
      csv << self.cms_file_title(language.full_name, data.count, options[:query])
      # columns
      csv << [
        'TERM_GENERAL_STATUS',
        'TERM_REFERENCE_TYPE',
        'TERM_SANSKRIT_STATUS',
        'TERM_CREATED_DATE',
        'TERM_CHANGED_DATE',
        'TERM_INTEGRATION_STATUS',
        'TERM',
        'TIBETAN',
        'ALTERNATIVE_TIBETAN',
        'SANSKRIT',
        'ALTERNATIVE_SANSKRIT',
        'PALI',
        'ARABIC',
        'TERM_TRANSLATION',
        'TERM_TRANSLATION_ALTERNATIVE_1',
        'TERM_TRANSLATION_ALTERNATIVE_2',
        'TERM_TRANSLATION_ALTERNATIVE_3',
        'TERM_TRANSLATION_CREATED_DATE',
        'TERM_TRANSLATION_CHANGED_DATE',
        'TERM_TRANSLATION_INTEGRATION_STATUS',
        'TERM_DEFINITION',
        'TERM_DEFINITION_TRANSLATION',
        'ADDITIONAL_EXPLANATION',
        'NOTE'
      ]
      base_language = Language.base_language
      # CMS columns, must start with #
      csv << [
        "##{GeneralStatus.full_name_csv}",
        ReferenceType.full_name_csv,
        SanskritStatus.full_name_csv,
        "#{base_language.iso_code} Term Created",
        "#{base_language.iso_code} Term Changed",
        IntegrationStatus.full_name_csv(base_language.iso_code),
        "#{base_language.iso_code} Term",
        'Tibetan',
        'Alternative Tibetan',
        'Sanskrit',
        'Alternative Sanskrit',
        'Pali',
        'Arabic',
        "#{language.english_name} (#{language.iso_code}) Term",
        "#{language.english_name} (#{language.iso_code}) Alternative Term #1",
        "#{language.english_name} (#{language.iso_code}) Alternative Term #2",
        "#{language.english_name} (#{language.iso_code}) Alternative Term #3",
        "#{language.iso_code} Term Created",
        "#{language.iso_code} Term Changed",
        IntegrationStatus.full_name_csv(language.iso_code),
        "#{base_language.iso_code} Definition",
        "#{language.iso_code} Definition",
        'Additional explanation',
        'Notes'
      ]
      # data
      data.each do |term|
        translation = term.glossary_term_translations.by_language(language.id).first

        csv << [
          term.general_status.code,
          term.reference_type.code,
          term.sanskrit_status.code,
          term.created_at,
          term.updated_at,
          term.integration_status.code,
          term.term,
          term.tibetan,
          term.alternative_tibetan,
          term.sanskrit,
          term.alternative_sanskrit,
          term.pali,
          term.arabic,
          "#{translation.term if translation}",
          "#{translation.alt_term1 if translation}",
          "#{translation.alt_term2 if translation}",
          "#{translation.alt_term3 if translation}",
          "#{translation.created_at if translation}",
          "#{translation.updated_at if translation}",
          "#{translation.integration_status.code if translation}",
          term.definition,
          "#{translation.definition if translation}",
           term.additional_explanation,
          "#{translation.notes if translation}"
        ]
      end
    end
  end

  def self.prepare_base_text_titles(language, data, options)
    csv_string = CSV.generate({force_quotes: true, encoding: 'UTF-8', col_sep: ','}) do |csv|
      csv << self.cms_file_title(language.full_name, data.count, options[:query])

      # columns
      csv << [
        'TEXT_TITLE_CREATED_DATE',
        'TEXT_TITLE_CHANGED_DATE',
        'TEXT_TITLE_INTEGRATION_STATUS',
        'TEXT_TITLE',
        'AUTHOR',
        'TIBETAN_FULL',
        'TIBETAN_ABBREVIATED',
        'SANSKRIT_FULL_WITHOUT_DIACRIT',
        'SANSKRIT_ABBREVIATED_WITHOUT_DIACRIT',
        'SANSKRIT_FULL_WITH_DIACRIT',
        'SANSKRIT_ABBREVIATED_WITH_DIACRIT',
        'EXPLANATION'
      ]
      # CMS columns, must start with #
      csv << [
        "#{language.iso_code} Text Title Created",
        "#{language.iso_code} Text Title Changed",
        IntegrationStatus.full_name_csv(language.iso_code),
        "#{language.iso_code} Text Title",
        'Author',
        'Tibetan Full',
        'Tibetan Abbreviated',
        'Sanskrit Full without diacritical marks',
        'Sanskrit Abbreviated without diacritical marks',
        'Sanskrit Full with diacritical marks',
        'Sanskrit Abbreviated with diacritical marks',
        'Explanation'
      ]
      # data
      data.each do |term|
        csv << [
          term.created_at,
          term.updated_at,
          term.integration_status.code,
          term.term,
          term.author,
          term.tibetan_full,
          term.tibetan_short,
          term.sanskrit_full,
          term.sanskrit_short,
          term.sanskrit_full_diacrit,
          term.sanskrit_short_diacrit,
          term.explanation
        ]
      end
    end
  end

  def self.prepare_text_titles(language, data, options)
    csv_string = CSV.generate({force_quotes: true, encoding: 'UTF-8', col_sep: ','}) do |csv|
      csv << self.cms_file_title(language.full_name, data.count, options[:query])
      # columns
      csv << [
        'TEXT_TITLE_CREATED_DATE',
        'TEXT_TITLE_CHANGED_DATE',
        'TEXT_TITLE_INTEGRATION_STATUS',
        'TEXT_TITLE',
        'AUTHOR',
        'TIBETAN_FULL',
        'TIBETAN_ABBREVIATED',
        'SANSKRIT_FULL_WITHOUT_DIACRIT',
        'SANSKRIT_ABBREVIATED_WITHOUT_DIACRIT',
        'SANSKRIT_FULL_WITH_DIACRIT',
        'SANSKRIT_ABBREVIATED_WITH_DIACRIT',
        'TEXT_TITLE_TRANSLATION',
        'TEXT_TITLE_TRANSLATION_ALTERNATIVE_1',
        'TEXT_TITLE_TRANSLATION_ALTERNATIVE_2',
        'TEXT_TITLE_TRANSLATION_ALTERNATIVE_3',
        'AUTHOR_TRANSLATION',
        'TEXT_TITLE_TRANSLATION_CREATED_DATE',
        'TEXT_TITLE_TRANSLATION_CHANGED_DATE',
        'TEXT_TITLE_TRANSLATION_INTEGRATION_STATUS',
        'EXPLANATION',
        'NOTE'
      ]
      base_language = Language.base_language
      # CMS columns, must start with #
      csv << [
        "#{base_language.iso_code} Text Title Created",
        "#{base_language.iso_code} Text Title Changed",
        IntegrationStatus.full_name_csv(base_language.iso_code),
        "#{base_language.iso_code} Text Title",
        'Author',
        'Tibetan Full',
        'Tibetan Abbreviated',
        'Sanskrit Full without diacritical marks',
        'Sanskrit Abbreviated without diacritical marks',
        'Sanskrit Full with diacritical marks',
        'Sanskrit Abbreviated with diacritical marks',
        "#{language.english_name} (#{language.iso_code}) Text Title",
        "#{language.english_name} (#{language.iso_code}) Alternative Text Title #1",
        "#{language.english_name} (#{language.iso_code}) Alternative Text Title #2",
        "#{language.english_name} (#{language.iso_code}) Alternative Text Title #3",
        "#{language.english_name} (#{language.iso_code}) Author",
        "#{language.iso_code} Text Title Created",
        "#{language.iso_code} Text Title Changed",
        IntegrationStatus.full_name_csv(language.iso_code),
        'Explanation', 'Notes'
      ]

      data.each do |term|
        translation = term.glossary_title_translations.by_language(language.id).first

        csv << [
          term.created_at,
          term.updated_at,
          term.integration_status.code,
          term.term,
          term.author,
          term.tibetan_full,
          term.tibetan_short,
          term.sanskrit_full,
          term.sanskrit_short,
          term.sanskrit_full_diacrit,
          term.sanskrit_short_diacrit,
          "#{translation.term if translation}",
          "#{translation.alt_term1 if translation}",
          "#{translation.alt_term2 if translation}",
          "#{translation.alt_term3 if translation}",
          "#{translation.author if translation}",
          "#{translation.created_at if translation}",
          "#{translation.updated_at if translation}",
          "#{translation.integration_status.code if translation}",
          term.explanation,
          "#{translation.notes if translation}"
        ]
      end
    end
  end

  def self.cms_file_title(language_name, count, filter_text)
    # CMS file title, must start with #
    [
      "##{language_name} glossary",
      "Exported: #{Date.today}",
      "Number of names exported: #{count}",
      "Filter options: #{filter_text}"
      ]
  end
end
