defmodule Mango.CRM do
  @moduledoc """
  The CRM context.
  """

  import Ecto.Query, warn: false
  alias Mango.CRM.Customer
  alias Mango.CRM.Ticket
  alias Mango.Repo

  def build_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
  end

  def create_customer(attrs) do
    attrs
    |> build_customer()
    |> Repo.insert()
  end

  def get_customer(id), do: Repo.get(Customer, id)

  def get_customer_by_email(email), do: Repo.get_by(Customer, email: email)

  def get_customer_by_credentials(%{"email" => email, "password" => pass}) do
    email
    |> get_customer_by_email()
    |> Bcrypt.check_pass(pass)
  end

  @doc """
  Returns the list of a given customer's tickets.

  ## Examples

      iex> list_tickets(customer)
      [%Ticket{}, ...]

  """
  def list_customer_tickets(customer) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.all()
  end

  @doc """
  Gets a single ticket for a customer.

  Raises `Ecto.NoResultsError` if the Ticket does not exist, or if it does not
  belong to the given customer.

  ## Examples

      iex> get_ticket!(customer, 123)
      %Ticket{}

      iex> get_ticket!(customer, 456)
      ** (Ecto.NoResultsError)

  """
  def get_customer_ticket!(customer, id) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.get!(id)
  end

  @doc """
  Creates a ticket for a customer.

  ## Examples

      iex> create_ticket(customer, %{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    build_customer_ticket(customer, attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking a customer's ticket changes.

  ## Examples

      iex> change_ticket(cusomter, ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def build_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    Ecto.build_assoc(customer, :tickets, %{status: "New"})
    |> Ticket.changeset(attrs)
  end
end
