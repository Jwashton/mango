defmodule Mango.DataBuilder do
  alias Mango.Repo
  alias Mango.Catalog.Product

  def product(attrs \\ %{}) do
    %Product{
      name: Faker.Food.ingredient(),
      pack_size: "1 kg",
      price: 75,
      sku: "B232",
      is_seasonal: true
    }
    |> Map.merge(attrs)
    |> Repo.insert!()
  end

  def customer(attrs \\ %{}) do
    {:ok, customer} =
      %{
        "name" => Faker.Person.name(),
        "email" => Faker.Internet.email(),
        "password" => "secret",
        "phone" => Faker.Phone.EnUs.extension(),
        "residence_area" => "Area 1"
      }
      |> Map.merge(stringify_keys(attrs))
      |> Mango.CRM.create_customer()

    customer
  end

  defp stringify_keys(map) do
    for {key, value} <- map, into: %{} do
      {to_string(key), value}
    end
  end
end
