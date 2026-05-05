require 'xcodeproj'
project = Xcodeproj::Project.open('Thrift.xcodeproj')
target = project.targets.find { |t| t.name == 'Thrift' }
group = project.main_group.find_subpath('Thrift/_ Fonts', true)
group.set_source_tree('<group>')
group.set_path('_ Fonts')

Dir.glob('Thrift/_ Fonts/*.ttf').each do |file|
  filename = File.basename(file)
  file_ref = group.files.find { |f| f.path == filename } || group.new_file(filename)
  unless target.resources_build_phase.files_references.include?(file_ref)
    target.add_resources([file_ref])
    puts "Added #{filename} to target"
  end
end
project.save
