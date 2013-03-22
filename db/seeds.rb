# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
User.new_admin(:email => 'admin@local.com',
               :password => 'admin',
               :name => 'System Administrator').save

User.create([{ :email => 'test1@local.com', :password => 'test1', :name => 'test1'},
             { :email => 'test2@local.com', :password => 'test2', :name => 'test2'}])

Department.delete_all
Department.create([ { name: 'Administration', description: 'Administration & Facility Department'},
                    { name: 'Facility', description: 'Facility'},
                    { name: 'Finance', description: 'Finanace'},
                    { name: 'IT', description: 'IT'},
                    { name: 'HR', description: 'Human Resource'},
                    { name: 'Marketing', description: 'Marketing'},
                    { name: 'R&D', description: 'Rearch and Development'},
                    ])
