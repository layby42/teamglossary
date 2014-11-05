# == Schema Information
#
# Table name: language_import_settings
#
#  id                :integer          not null, primary key
#  language_id       :integer          not null
#  import_setting_id :integer          not null
#  csv_column        :integer          default(-1), not null
#  do_not_import     :boolean          default(FALSE), not null
#  created_at        :datetime
#  updated_at        :datetime
#

class LanguageImportSetting < ActiveRecord::Base
  belongs_to :language
  belongs_to :import_setting
end
