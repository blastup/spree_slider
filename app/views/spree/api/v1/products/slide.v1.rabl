node(:master){ |p| p.master }

child(badges: :badges) do
  extends "spree/api/v1/badges/show"
end

node(:link){ |p| product_path(p) }
node(:image){ |p| p.images.first.nil? ? "" : p.images.first.large_url }
node(:name){ |p| p.name }
node(:display_price){ |p| p.master.display_user_currency_price(@current_api_user) }
node(:display_default_price){ |p| p.master.display_default_user_currency_price(@current_api_user) }

current_price = root_object.master.current_price(@current_api_user)

node(:price_type){ |p| current_price.class.name == "Spree::PriceGroup" ? (current_price.price_type ? (current_price.price_type.key != 'default' ? current_price.price_type : nil) : nil) : nil }
node(:variants){ |p| p.variants }
node(:web_shorts) { |p| p.product_properties.where(:webshort => true).map { |prop| prop.value.split('-n-').map(&:strip).map{|v| prop.get_translations_values(v, I18n.locale.to_s)}.join(', ') }.join(', ')}
node(:is_mobile){true}