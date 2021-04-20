defmodule MangoWeb.Acceptance.CheckoutTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do
    alias Mango.Repo
    alias Mango.Catalog.Product

    Repo.insert(%Product{
      name: "Carrot",
      pack_size: "1 kg",
      price: 55,
      sku: "A123",
      is_seasonal: true
    })

    Repo.insert(%Product{
      name: "Apple",
      pack_size: "1 kg",
      price: 75,
      sku: "B232",
      is_seasonal: true
    })

    :ok
  end

  test "add to cart" do
    navigate_to("/")

    [product | _rest] = find_all_elements(:css, ".product")

    find_within_element(product, :name, "cart[quantity]")
    |> fill_field(2)

    find_within_element(product, :tag, "button")
    |> click()

    navigate_to("/cart")

    find_element(:css, ".checkout-btn")
    |> click()

    expected =
      find_element(:tag, "h1")
      |> visible_text()

    assert expected =~ "Login"
  end
end
