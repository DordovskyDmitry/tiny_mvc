class Product < TinyMVC::RedisModel
  stored_parameters :name, :price
end
