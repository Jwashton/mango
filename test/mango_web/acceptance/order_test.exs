defmodule MangoWeb.Acceptance.OrderTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Sales

    customer = Mango.DataBuilder.customer()
    product = Mango.DataBuilder.product()

    line_item = %{
      "product_id" => product.id,
      "product_name" => product.name,
      "pack_size" => product.pack_size,
      "unit_price" => product.price,
      "quantity" => 2
    }

    {:ok, cart} =
      Sales.create_cart()
      |> Sales.add_to_cart(line_item)

    {:ok, order} =
      Sales.confirm_order(cart, %{
        "customer_id" => customer.id,
        "customer_name" => customer.name,
        "residence_area" => customer.residence_area,
        "email" => customer.email,
        "comments" => "Please leave by the front door."
      })

    %{
      order: order,
      customer: customer
    }
  end

  test "view orders", %{customer: customer} do
    login(customer.email, "secret")

    navigate_to("/orders")

    table = find_element(:id, "user-orders")

    assert visible_text(table) =~ "Confirmed"
  end

  test "viewing a specific order", %{customer: customer, order: order} do
    login(customer.email, "secret")

    navigate_to("/orders/#{order.id}")

    order_info = find_element(:id, "order")

    assert visible_text(order_info) =~ "Confirmed"
  end

  defp login(email, password) do
    navigate_to("/login")

    form = find_element(:id, "session-form")

    find_within_element(form, :name, "session[email]")
    |> fill_field(email)

    find_within_element(form, :name, "session[password]")
    |> fill_field(password)

    find_within_element(form, :tag, "button")
    |> click()

    message =
      find_element(:class, "alert-info")
      |> visible_text()

    assert message == "Login successful"
  end
end
