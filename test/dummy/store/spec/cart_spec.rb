require_relative 'spec_helper'

describe Cart do
  let(:pen) { Product.new(name: 'pen', price: 12).save }
  let(:pencil) { Product.new(name: 'pencil', price: 10).save }
  let(:cart) { described_class.new }

  context '#add' do
    it 'one more item' do
      expect { cart.add(pen) }.to change { cart.products.count }.by(1)
    end

    it 'includes product' do
      expect { cart.add(pen) }.to change { cart.products.include?(pen) }.to(true)
    end
  end

  context '#delete' do
    before { cart.add(pen) }

    it 'one more item' do
      expect { cart.delete(pen.name) }.to change { cart.products.count }.by(-1)
    end

    it 'nothing if item not included to order' do
      expect { cart.delete(pencil.name) }.to_not change { cart.products.count }
    end

    it 'excludes product' do
      expect { cart.delete(pen.name) }.to change { cart.products.include?(pen) }.to(false)
    end
  end

  context '#total_price' do
    it 'total' do
      cart.add(pen)
      cart.add(pencil)
      expect(cart.total_price).to eq(22)
    end
  end
end
