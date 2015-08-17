class Product < TinyMVC::RedisModel
  attributes name: :string, price: :integer
end
