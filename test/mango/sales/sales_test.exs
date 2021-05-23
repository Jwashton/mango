defmodule Mano.SalesTest do
  use Mango.DataCase

  alias Mango.{Sales, Repo}
  alias Mango.Sales.Order
  alias Mango.Catalog.Product

  test "create_cart/0" do
    assert %Order{status: "In Cart"} = Sales.create_cart()
  end

  test "get_cart/1" do
    cart1 = Sales.create_cart()
    cart2 = Sales.get_cart(cart1.id)

    assert cart1.id == cart2.id
  end

  test "add_to_cart/2" do
    product =
      %Product{
        name: "Tomato",
        pack_size: "1 kg",
        price: 55,
        sku: "A123",
        is_seasonal: false,
        category: "vegetables"
      }
      |> Repo.insert!()

    cart = Sales.create_cart()

    {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => product.id, "quantity" => "2"})

    assert [line_item] = cart.line_items
    assert line_item.product_id == product.id
    assert line_item.product_name == "Tomato"
    assert line_item.pack_size == "1 kg"
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(product.price)
    assert line_item.total == Decimal.mult(Decimal.new(product.price), Decimal.new(2))
  end

  test "list_customer_orders/1" do
    {:ok, customer} = Mango.CRM.create_customer(%{
      "name" => "Jean-Luc Picard",
      "email" => "picard@starfleet.gov",
      "password" => "secret",
      "phone" => "1111",
      "residence_area" => "Area 1"
    })

    apple = Repo.insert!(%Product{
      name: "Apple",
      pack_size: "1 kg",
      price: 75,
      sku: "B232",
      is_seasonal: true
    })

    line_item = %{
      "product_id" => apple.id,
      "product_name" => apple.name,
      "pack_size" => apple.pack_size,
      "unit_price" => apple.price,
      "quantity" => 2
    }

    {:ok, cart} =
      Sales.create_cart()
      |> Sales.add_to_cart(line_item)

    Sales.confirm_order(cart, %{
      "customer_id" => customer.id,
      "customer_name" => customer.name,
      "residence_area" => customer.residence_area,
      "email" => customer.email,
      "comments" => "Please leave by the front door."
    })

    assert [%{status: "Confirmed"}] = Sales.list_customer_orders(customer)
  end

  # test "remove an item from the cart" do
  #   product =
  #     %Product{
  #       name: "Tomato",
  #       pack_size: "1 kg",
  #       price: 55,
  #       sku: "A123",
  #       is_seasonal: false,
  #       category: "vegetables"
  #     }
  #     |> Repo.insert!()

  #   cart = Sales.create_cart()

  #   {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => product.id, "quantity" => "2"})

  #   %{line_items: [li]} = cart

  #   result = Sales.update_cart(cart, %{
  #     "line_items" => %{
  #       "0" => %{
  #         "delete" => "true",
  #         "id" => li.id,
  #         "product_id" => product.id,
  #         "quantity" => "2"
  #       }
  #     }
  #   })

  #   assert {:ok, _} = result
  # end
end
