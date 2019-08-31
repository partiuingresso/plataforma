# lib/tasks/temporary/offers.rake
namespace :companies do
  desc "Creates sellers companies"
  task create_sellers_companies: :environment do
    sellers = Seller.all
    puts "Going to create #{sellers.count} companies"

    ActiveRecord::Base.transaction do
      sellers.each do |seller|
        company = seller.build_company(
          name: seller.company.name,
          business_name: seller.business_name,
          document_number: seller.document_number,
          phone_area_code: seller.phone_area_code,
          phone_number: seller.phone_number,
          address_id: seller.address.id
        )
        company.save!
        print "."
      end
    end

    puts " All done now!"
  end
end