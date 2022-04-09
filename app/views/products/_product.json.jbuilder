json.extract! product, :account_id, :id, :uuid, :status, :name, :description, :type_of
json.url product_url(product, format: :json)

json.url product_url(product, format: :json)


json.variants product.variants do |variant|
  json.id variant.uuid
  json.name variant.name
  json.description variant.description
  json.standard_price variant.standard_pricing
  json.subscription_price variant.subscription_pricings
  json.inventory variant.inventory
  json.options variant.variant_options

  json.bundles variant.bundles do |bundle|
    json.id bundle.id
    json.variant_id bundle.variant_id
    json.bundled_product_id bundle.bundled_product_id
    json.quantity bundle.quantity

    json.bundled_products variant.bundled_products.where(id: bundle.bundled_product_id) do |b|
      json.id b.id
      json.product_name b.product.name
      json.name b.name
      json.price_per_lb b.price_per_lb
      json.weight b.weight
    end

  end

  json.image_url main_app.url_for(variant.images[0])

  json.images variant.images do |image|
    json.image_url main_app.url_for(image)
  end
end

