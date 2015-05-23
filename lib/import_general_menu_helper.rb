require 'json'
require "open-uri"

module ImportGeneralMenuHelper

  def self.import!()
    url = 'http://www.berzinarchives.com/web/x/data/translation_state/original_resources_and_translations.json'
    file_data = open(url).read()

    # file_data = file.read

    options = { updated_from_cms_at: Time.zone.now }

    JSON.parse(file_data, :max_nesting => 300, :allow_nan => true).each do |item|
      language = Language.find_by_iso_code(item['cms_name'].upcase)
      next unless language

      options[:top_cms_path] = "/#{item['cms_name']}"
      options[:cms_path] = "/#{item['cms_name']}"

      (item['children'].presence || []).each_with_index do |child, sequence|
        self.import_item!(language, nil, child, sequence, options)
        # TODO
      end
      # break
    end
  end

  protected

  def self.import_item!(language, general_menu_id, item, sequence, options={})
    # add/update general_menu item
    full_cms_path = "#{options[:cms_path]}/#{item['cms_name']}"

    if language.is_base_language?
      general_menu = GeneralMenu.by_language(language.id).where(general_menu_id: general_menu_id, cms_name: item['cms_name']).first
    else
      general_menu = GeneralMenu.by_language(Language.base_language.id).where(general_menu_id: general_menu_id, cms_name: item['cms_name']).first
      general_menu ||= GeneralMenu.by_language(language.id).where(general_menu_id: general_menu_id, cms_name: item['cms_name']).first
    end

    general_menu ||= GeneralMenu.new(
      language_id: language.id,
      general_menu_id: general_menu_id,
      cms_name: item['cms_name']
      )

    # update general_menu attributes only
    if general_menu.language_id == language.id
      general_menu.name = (item['name'].presence || 'NO NAME!!!').gsub('&quot;', '"')
      general_menu.item_type = item['item_type']
      general_menu.sequence = sequence
      general_menu.synchronized = true
      general_menu.additional_text = item['additional_navtext'].to_s.gsub('&quot;', '"')
      general_menu.length_type = item['type_desc']
      if item['created'].to_s.length >= 10
        general_menu.online = Time.try(:at, item['created'][0..9].to_i)
      end
      if item['last_update'].to_s.length >= 10
        general_menu.cms_updated = Time.try(:at, item['last_update'][0..9].to_i)
      end

      general_menu.full_cms_path = full_cms_path
      general_menu.updated_from_cms_at = options[:updated_from_cms_at]

      if general_menu_id.present?
        general_menu.level = (general_menu.general_menu.level + 1)
      else
        general_menu.level = 0
      end
      general_menu.save!
    end


    # # old names
    # (item['old_names'].presence || []).each do |old_name|

    #   old_name.split('/').each do |cms_name|
    #     GeneralMenu.
    #   end
    # }
    # end

    # process tranlations
    (item['translations'].presence || []).each do |translation|
      translation_language = Language.find_by_iso_code(translation['language'].upcase)
      next unless translation_language
      import_item_translation!(translation_language, general_menu.id, translation, options)
    end

    # process children
    cms_path = options[:cms_path]
    options[:cms_path] = full_cms_path
    (item['children'].presence || []).each_with_index do |child, sequence|
      self.import_item!(language, general_menu.id, child, sequence, options)
    end
    options[:cms_path] = cms_path
  end

  def self.import_item_translation!(language, general_menu_id, item, options={})
    general_menu_translation = GeneralMenuTranslation.by_language(language.id).where(general_menu_id: general_menu_id).first
    general_menu_translation = GeneralMenuTranslation.new(
      language_id: language.id,
      general_menu_id: general_menu_id
    ) unless general_menu_translation

    general_menu_translation.name = (item['name'].presence || 'NO NAME!!!').gsub('&quot;', '"')
    general_menu_translation.additional_text = item['additional_navtext'].to_s.gsub('&quot;', '"')
    general_menu_translation.synchronized = true

    if item['created'].to_s.length >= 10
      general_menu_translation.online = Time.try(:at, item['created'][0..9].to_i)
    end
    if item['last_update'].to_s.length >= 10
      general_menu_translation.cms_updated = Time.try(:at, item['last_update'][0..9].to_i)
    end
    general_menu_translation.updated_from_cms_at = options[:updated_from_cms_at]
    general_menu_translation.save!
  end
end
