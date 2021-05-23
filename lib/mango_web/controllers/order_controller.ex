defmodule MangoWeb.OrderController do
  use MangoWeb, :controller
  alias Mango.Sales

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = Sales.list_customer_orders(customer)

    render(conn, "index.html", orders: orders)
  end
end
