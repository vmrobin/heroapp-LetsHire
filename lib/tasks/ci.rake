task :ci do
  ENV['RAILS_ENV'] = 'ci'
  Rake::Task['spec'].invoke
end
