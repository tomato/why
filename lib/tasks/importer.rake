require 'csv'
@import_path = File.join(File.dirname(__FILE__), "pantry.csv")


namespace :import do
  desc "Import products"
  task :products => :environment do
    CSV.open(@import_path, 'r') do |row|
      p = Product.new
      p.supplier_id = row[0]
      p.category = row[1]
      p.name = row[2] + ' - ' + row[3]
      p.price = row[4]
      puts p.inspect
      p.save!
    end 
  end
end
