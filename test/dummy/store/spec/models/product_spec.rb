require_relative '../spec_helper'

describe Product do
  let(:product) { Product.new(name: 'pen', price: 12) }

  it '.count ' do
    expect { product.save }.to change { Product.count }.by(1)
  end

  it '.all ' do
    expect{ product.save }.to change { Product.all.include?(product) }.to(true)
  end
end
