defmodule MangoWeb.OrderView do
  use MangoWeb, :view

  def product_list(order) do
    order.line_items
    |> Enum.map(&short_product/1)
    |> Enum.join(", ")
  end

  def short_product(%{ product_name: name, quantity: quantity }) do
    "#{name} x #{quantity}"
  end
end
