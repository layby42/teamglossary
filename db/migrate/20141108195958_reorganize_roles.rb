class ReorganizeRoles < ActiveRecord::Migration
  def up
    execute(%q{
      UPDATE language_users SET role = 'user', level = 0
        WHERE (role = 'translator' OR role='proof_reader') AND
        NOT EXISTS(SELECT L.id FROM language_users AS L
            WHERE L.user_id = language_users.user_id
              AND L.role = 'user')
        ;
      });
    execute(%q{
      UPDATE language_users SET role = 'manager', level = 0 WHERE role = 'section_owner';
      });

    execute(%q{
      UPDATE language_users SET role = 'manager', level = 0
        WHERE (role = 'glossary_owner' OR
          (role = 'editor' AND level = 4)) AND
          NOT EXISTS(SELECT L.id FROM language_users AS L
            WHERE L.user_id = language_users.user_id
              AND L.role = 'manager') ;
      });

    execute(%q{
      DELETE FROM language_users WHERE role = 'glossary_owner';
      })
  end

  def down
  end
end
