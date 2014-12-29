class FillTasks < ActiveRecord::Migration
  def up
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Translation', true, false, false);})
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Evaluation', true, true, true);})
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Transcribing', true, false, false);})
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Editing', true, true, true);})
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Copyediting', true, false, false);})
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Proofreading', true, false, false);})
    execute(%q{INSERT INTO tasks(title, article, audio, video) VALUES('Publishing', true, true, true);})

    add_column :general_menu_actions, :task_id, :integer

    {
      :translation => 'T',
      :evaluation => 'EV',
      :transcribing => 'TC',
      :editing => 'E',
      :copyediting => 'CE',
      :proofreading => 'PR',
      :publishing => 'P'
      }.each do |action, code|
        id = Task.where(title: action.capitalize).pluck(:id).first
        execute(%Q{UPDATE general_menu_actions SET task_id = #{id} WHERE action = '#{code}';}) if id
      end

    change_column :general_menu_actions, :task_id, :integer, null: false
    add_foreign_key :general_menu_actions, :tasks
  end

  def down
    remove_column :general_menu_actions, :task_id
    execute('DELETE FROM tasks;')
  end
end
