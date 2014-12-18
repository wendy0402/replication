require 'active_record'
require 'active_support'
require 'yaml'
ROOT = File.expand_path('../../replication', __FILE__)

ActiveRecord::Base::CONNECTION_CONFIG = YAML::load(IO.read(ROOT + '/config/database.yml'))
ActiveRecord::Base.configurations['local'] = ActiveRecord::Base::CONNECTION_CONFIG['local']

class History < ::ActiveRecord::Base
  self.establish_connection :local
end

module Schema
  extend self
  def migrate!
    unless History.connection.tables.include?(History.table_name)
      puts "Creating table `#{History.table_name}`"
      History.connection.create_table History.table_name do |t|
        t.datetime  "checked_at"
        t.string    "message"
        t.boolean   "success", default: 1

        t.timestamps
      end
      History.connection.add_index History.table_name, :checked_at
    end
  end
end