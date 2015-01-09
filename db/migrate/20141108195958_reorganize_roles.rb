class ReorganizeRoles < ActiveRecord::Migration
  def up
    LanguageUser.order('user_id, language_id, role').pluck(:user_id, :language_id, :role).group_by{|r| r[0]}.each do |user_id, record|
      language_roles = {}

      record.each do |r|
        language_roles[r[1]] ||= []
        language_roles[r[1]] << r[2]
      end

      language_roles.each do |key, roles|
        if roles.include?('section_owner')
          execute(%Q{DELETE FROM language_users WHERE user_id=#{user_id} AND language_id=#{key} AND role <> 'section_owner';})
          execute(%Q{UPDATE language_users SET role = 'manager' WHERE user_id=#{user_id} AND language_id=#{key} AND role = 'section_owner';})
        elsif roles.include?('glossary_owner')
          execute(%Q{DELETE FROM language_users WHERE user_id=#{user_id} AND language_id=#{key} AND role <> 'glossary_owner';})
          execute(%Q{UPDATE language_users SET role = 'manager' WHERE user_id=#{user_id} AND language_id=#{key} AND role = 'glossary_owner';})
        elsif roles.include?('editor')
          execute(%Q{DELETE FROM language_users WHERE user_id=#{user_id} AND language_id=#{key} AND role <> 'editor';})
          execute(%Q{UPDATE language_users SET role = 'editor' WHERE user_id=#{user_id} AND language_id=#{key} AND role = 'editor';})
        elsif roles.include?('translator')
          execute(%Q{DELETE FROM language_users WHERE user_id=#{user_id} AND language_id=#{key} AND role <> 'translator';})
          execute(%Q{UPDATE language_users SET role = 'user' WHERE user_id=#{user_id} AND language_id=#{key} AND role = 'translator';})
        elsif roles.include?('proof_reader')
          execute(%Q{DELETE FROM language_users WHERE user_id=#{user_id} AND language_id=#{key} AND role <> 'proof_reader';})
          execute(%Q{UPDATE language_users SET role = 'user' WHERE user_id=#{user_id} AND language_id=#{key} AND role = 'proof_reader';})
        end
      end
    end

  end

  def down
  end
end
