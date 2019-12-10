# frozen_string_literal: true

class CartController < ApplicationController
  before_action :authenticate_user!, except: %i[add_to_cart view_order]

  def add_to_cart
    # create an order earlier using our helper method
    @order = current_order

    # check to see if product already exists in our order to prevent doubles
    line_item = @order.line_items.find_by(product_id: params[:product_id])

    # if the item is already in the order, update the quantity
    if line_item
      line_item.update(quantity: line_item.quantity += params[:quantity].to_i)
      line_item.update(line_item_total: line_item.quantity * line_item.product.price)

    else
      # if the item is not in the order add it
      line_item = @order.line_items.new(product_id: params[:product_id], quantity: params[:quantity])

      @order.save
      session[:order_id] = @order.id
      line_item.update(line_item_total: (line_item.quantity * line_item.product.price))

    end
    redirect_back(fallback_location: root_path)
  end

  def view_order
    @line_items = current_order.line_items
  end

  def order_complete
    @order = Order.find(params[:order_id])
    @order.line_items.destroy_all
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'SpreeShopper Purchase',
      :currency => 'usd'
    )

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to cart_path
  end

  def checkout
    line_items = current_order.line_items

    if line_items.present?
      #you didn't have to be logged in to create an order, but now you do so make sure 
      #the user id is set on the order and reset suptotal
      current_order.update(user_id: current_user.id, subtotal: 0)

      @order = current_order

      line_items.each do |line_item|
        #deduct from inventory
        line_item.product.update(quantity: (line_item.product.quantity - line_item.quantity))
        #update the order
        @order.order_items[line_item.product_id] = line_item.quantity
        @order.subtotal += line_item.line_item_total
      end
      @order.save

      @order.update(sales_tax: (@order.subtotal * 0.08))
      @order.update(grand_total: (@order.sales_tax + @order.subtotal))
      session[:order_id] = nil
    end
  end
end
