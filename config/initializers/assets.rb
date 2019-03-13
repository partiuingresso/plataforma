# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Add fonts folder
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( users/registrations/new.js )
Rails.application.config.assets.precompile += %w( users/registrations/edit.js )
Rails.application.config.assets.precompile += %w( events.js )
Rails.application.config.assets.precompile += %w( events/maps.js )
Rails.application.config.assets.precompile += %w( events/colors.js )
Rails.application.config.assets.precompile += %w( events/modal.js )
Rails.application.config.assets.precompile += %w( toggle.js )
Rails.application.config.assets.precompile += %w( events/cart.js )
Rails.application.config.assets.precompile += %w( orders.js )
Rails.application.config.assets.precompile += %w( orders/new.js )
Rails.application.config.assets.precompile += %w( carousel.js )
Rails.application.config.assets.precompile += %w( companies/new.js )
Rails.application.config.assets.precompile += %w( companies/show.js )
Rails.application.config.assets.precompile += %w( my_orders.js )
Rails.application.config.assets.precompile += %w( admin.js )