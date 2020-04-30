require 'date'
require 'fileutils'

def parseDate(dateStr)
    date = nil

    begin
        date = DateTime.parse(dateStr)
    rescue => exception
        begin
            date = Date.strptime(dateStr, "%d%m%Y")
        rescue => exception
            puts "Invalid date: #{dateStr}"
        end
    end

    return date
end

if ARGV.length < 1
    puts "Too few arguments!"
    exit
  end

puts "Welcome to the Directory Date Organiser!" 

path = ARGV[0]

if path[path.length - 1] != '/'
    path += '/'
end

puts "0%"

folders = Dir.entries(path).select {|entry| File.directory? File.join(path,entry) and !(entry =='.' || entry == '..') }
increments = 100 / folders.length
count = 0

folders.map do |folder_name|
    folder_path = path + folder_name
    date = parseDate folder_name
    new_name = ""

    if date != nil
        new_name = date.strftime("%Y%m%d")
    else
        lastModified = File.mtime(folder_path)
        new_name = lastModified.strftime("%Y%m%d")
    end

    begin
        FileUtils.mv folder_path, path + new_name
    rescue => exception
        puts "Could not rename folder!"
    end

    count += 1
    puts "#{increments * count}%"
end

if increments * count < 100   
    puts "100%"
end