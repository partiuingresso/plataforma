# lib/tasks/temporary/release.rake
namespace :release do
  desc "Data integrity changes for release."
  task data_changes: :environment do
    ActiveRecord::Base.transaction do
      Company.all.each do |c|
        Seller.create!(
          id: c.id,
          moip_id: c.moip_id,
          moip_access_token: c.moip_access_token,
          email: c.email,
          phone_area_code: c.phone_area_code,
          phone_number: c.phone_number,
          verified: true
        )
        c.update!(seller_id: c.id)
        Seller.connection.execute("ALTER SEQUENCE sellers_id_seq RESTART #{Seller.count + 1}")
      end

      Transfer.all.each do |t|
        t.update!(seller_id: t.company_id)
      end

      Event.all.each do |e|
        e.update!(seller_id: e.company_id)
      end

      Finance.all.each do |f|
        f.update!(seller_id: f.id)
      end

      User.where(role: 3).each do |u|
        u.update!(actor_type: 'Seller', actor_id: u.company_id)
      end

      User.where(role: 2).each do |u|
        new_staff = SellerStaff.create!(seller_id: u.company_id)
        u.update!(actor_type: 'SellerStaff', actor_id: new_staff.id)
      end
    end

    puts "All done!"
  end
end
