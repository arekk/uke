def putsnb(s)
  puts Time.now.strftime("%H:%M:%S") + ': ' + s
  $stdout.flush
end

ARGV.each do|a|
  putsnb "Argument: #{a}"
  @import_release_date = a.sub(/--release-date=/, '').to_s unless (a =~ /--release-date=/).nil?
end

if @import_release_date.nil?
  putsnb "Give UKE database release date as --release-date= argument"
  exit
end

@uke_import = UkeImport.create(released_on: Date.parse(@import_release_date))

putsnb 'Done'
