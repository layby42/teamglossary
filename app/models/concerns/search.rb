module Search
  extend ActiveSupport::Concern

  module ClassMethods

    # base language state condition
    def base_states_condition(language, states)
      condition = 'FALSE'

      if (states & [:private, :public, :proposed]).length == 3
        condition = [%Q{
          (#{self.table_name}.language_id = ? OR NOT #{self.table_name}.is_private)
          }, language.id]
      elsif (states & [:private, :public]).length == 2
          # only terms for this language
          condition = {language_id: language.id}
      elsif (states & [:private, :proposed]).length == 2
        # private for the language + proposed by other languages
        condition = [%Q{
        ((#{self.table_name}.language_id = ? AND #{self.table_name}.is_private)
         OR
         (#{self.table_name}.language_id <> ? AND NOT #{self.table_name}.is_private)
         )
        }, language.id, language.id]
      elsif (states & [:public, :proposed]).length == 2
        # non-private of any language
        condition = {is_private: false}
      else
        case states[0]
        when :private # only for language
          condition = {language_id: language.id, is_private: true}
        when :public # only for language
          condition = {language_id: language.id, is_private: false}
        when :proposed # by other languages
          condition = [%Q{
          (#{self.table_name}.language_id <> ? AND NOT #{self.table_name}.is_private)
          }, language.id]
        end
      end
      condition
    end

    # non-base language state condition
    def non_base_states_condition(language, states)
      condition = 'FALSE'

      if (states & [:private, :public, :proposed]).length == 3
        # belongs to language or any non-private
        condition = [%Q{
          #{self.table_name}.language_id = ? OR NOT #{self.table_name}.is_private
        }, language.id]
      elsif (states & [:private, :public]).length == 2
        # private for language or non-private for other languages
        condition = [%Q{
          ( (#{self.table_name}.language_id = ? AND #{self.table_name}.is_private)
            OR
            ( #{self.table_name}.language_id <> ? AND NOT #{self.table_name}.is_private))
          }, language.id, language.id]
      elsif (states & [:private, :proposed]).length == 2
        # for selected language only
        condition = {language_id: language.id}
      elsif (states & [:public, :proposed]).length == 2
        # non-private of any language
        condition = {is_private: false}
      else
        case states[0]
        when :private # only for languages
          condition = {language_id: language.id, is_private: true}
        when :public
          # base or proposed by other languages
          condition = [%Q{
          #{self.table_name}.language_id <> ? AND NOT #{self.table_name}.is_private
        }, language.id]
        when :proposed # only by languages
          condition = {language_id: language.id, is_private: false}
        end
      end
      condition
    end
  end
end
