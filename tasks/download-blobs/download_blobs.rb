require 'yaml'
require 'set'

blobs_config = YAML.load_file(ARGV[0])

cachedBlobs= Dir.glob('./**/*').select{ |e| File.file? e }.map{ |f| f.reverse.chomp("./".reverse).reverse }.to_set
requiredBLobs = Set.new
blobs_config.each { |item| requiredBLobs << item.fetch("bosh_blob_path") }
unusedBlobs = cachedBlobs.difference(requiredBLobs.to_set)
unusedBlobs.each { |file | File.delete(file) if File.exist?(file) }

blobs_config.each do |blob_info|
  `curl --create-dirs --location -o "#{blob_info.fetch('bosh_blob_path')}" "#{blob_info.fetch('url')}"` unless File.exist?("#{blob_info.fetch('bosh_blob_path')}")
end