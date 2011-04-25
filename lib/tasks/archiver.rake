
namespace :archive do
  desc "Archive all orders past there last order date that have not already been archived"
  task :due => :environment do
    Delivery.archive
  end
end
