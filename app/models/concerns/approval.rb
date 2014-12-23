module Approval
  extend ActiveSupport::Concern

  def approve!
    base_language = Language.base_language
    return if self.language_id == base_language.id
    self.language_id = base_language.id
    self.rejected_because = nil
    self.save!
  end
end
