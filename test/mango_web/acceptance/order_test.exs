defmodule MangoWeb.Acceptance.OrderTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Repo
    alias Mango.Catalog.Product
    alias Mango.Sales

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

    :ok
  end

  test "view orders" do
    login("picard@starfleet.gov", "secret")

    navigate_to("/orders")

    table = find_element(:id, "user-orders")

    assert visible_text(table) =~ "Confirmed"
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
