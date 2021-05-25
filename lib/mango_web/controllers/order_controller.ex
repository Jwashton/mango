defmodule MangoWeb.OrderController do
  use MangoWeb, :controller
  alias Mango.Sales

  action_fallback MangoWeb.FallbackController

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = Sales.list_customer_orders(customer)

    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"id" => order_id}) do
    customer = conn.assigns.current_customer

    with {:ok, order} <- Sales.get_customer_order(customer, order_id) do
      render(conn, "show.html", order: order)
    end
  end
end
