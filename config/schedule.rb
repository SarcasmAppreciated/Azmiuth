# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# YOU MUST CALL 'whenever -i' for this to work

env :PATH, ENV['PATH']
set :output, {:error => "/log/cron_error_log.log", :standard => "/home/alimv/CPSC310/Azimuth/log/cron_log.log"}

every 15.minutes do
	rake "user:user_update", :environment => 'development' 
end

every 15.minutes do
	rake "user:user_update", :environment => 'production' 
end
