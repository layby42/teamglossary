class RemoveAdminsFromLanguageUsers < ActiveRecord::Migration
  def up
    LanguageUser.where(role: :admin).delete_all
    LanguageUser.all.group_by{|l| l.language_id}.each do |language_id, language_users|
      language_users.group_by{|l| l.user_id}.each do |user_id, user_roles|
        grouped_by_roles = user_roles.group_by{|l| l.role}

        if grouped_by_roles.has_key?('manager')
          id = grouped_by_roles['manager'].first.id
        elsif grouped_by_roles.has_key?('editor')
          id = grouped_by_roles['editor'].first.id
        else
          id = user_roles.first.id
        end
        ids = user_roles.select{|r| r.id != id}.collect{|r| r.id}

        next if ids.empty?

        LanguageUser.where(id: ids).delete_all
      end
    end
  end

  def down
  end
end
