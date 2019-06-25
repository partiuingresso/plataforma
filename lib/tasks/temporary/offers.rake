# lib/tasks/temporary/offers.rake
namespace :offers do
  desc "Update offers sold column"
  task set_sold_column: :environment do
    offers = Offer.all
    puts "Going to update #{offers.count} offers"

    ActiveRecord::Base.transaction do
      offers.each do |offer|
        offer.sold = offer.quantity - offer.read_attribute(:available_quantity)
        offer.save!
        print "."
      end
    end

    puts " All done now!"
  end
  desc "Update offers end_t column"
  task set_end_t_column: :environment do
    offers = Offer.includes(:event).all
    puts "Going to update #{offers.count} offers"

    ActiveRecord::Base.transaction do
      offers.each do |offer|
        offer.end_t = offer.event.start_t
        offer.save!
        print "."
      end
    end

    puts " All done now!"
  end
end