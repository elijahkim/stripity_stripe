defmodule Stripe.Customer do
  @moduledoc """
  Work with Stripe customer objects.

  You can:

  - Create a customer
  - Retrieve a customer
  - Update a customer
  - Delete a customer

  Stripe API reference: https://stripe.com/docs/api#customer
  """

  use Stripe.Entity
  import Stripe.Request

  @type t :: %__MODULE__{
          id: Stripe.id(),
          object: String.t(),
          account_balance: integer,
          business_vat_id: String.t(),
          created: Stripe.timestamp(),
          currency: String.t() | nil,
          default_source: Stripe.id() | Stripe.Source.t() | nil,
          delinquent: boolean | nil,
          description: String.t() | nil,
          discount: Stripe.Discount.t() | nil,
          email: String.t() | nil,
          invoice_prefix: String.t() | nil,
          livemode: boolean,
          metadata: Stripe.Types.metadata(),
          shipping: Stripe.Types.shipping() | nil,
          sources: Stripe.List.t(Stripe.Source.t()),
          subscriptions: Stripe.List.t(Stripe.Subscription.t())
        }

  defstruct [
    :id,
    :object,
    :account_balance,
    :business_vat_id,
    :created,
    :currency,
    :default_source,
    :delinquent,
    :description,
    :discount,
    :email,
    :invoice_prefix,
    :livemode,
    :metadata,
    :shipping,
    :sources,
    :subscriptions
  ]

  @plural_endpoint "customers"

  @doc """
  Create a customer.
  """
  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:account_balance) => integer,
               optional(:business_vat_id) => String.t(),
               optional(:coupon) => Stripe.id() | Stripe.Coupon.t(),
               optional(:default_source) => Stripe.id() | Stripe.Source.t(),
               optional(:description) => String.t(),
               optional(:email) => String.t(),
               optional(:invoice_prefix) => String.t(),
               optional(:metadata) => Stripe.Types.metadata(),
               optional(:shipping) => Stripe.Types.shipping(),
               optional(:source) => Stripe.Source.t()
             } | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :default_source, :source])
    |> make_request()
  end

  @doc """
  Retrieve a customer.
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a customer.
  """
  @spec update(Stripe.id() | t, params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:account_balance) => integer,
               optional(:business_vat_id) => String.t(),
               optional(:coupon) => Stripe.id() | Stripe.Coupon.t(),
               optional(:default_source) => Stripe.id() | Stripe.Source.t(),
               optional(:description) => String.t(),
               optional(:email) => String.t(),
               optional(:invoice_prefix) => String.t(),
               optional(:metadata) => Stripe.Types.metadata(),
               optional(:shipping) => Stripe.Types.shipping(),
               optional(:source) => Stripe.Source.t()
             } | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Delete a customer.
  """
  @spec delete(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all customers.
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params: %{
               optional(:created) => String.t() | Stripe.date_query(),
               optional(:email) => String.t(),
               optional(:ending_before) => t | Stripe.id(),
               optional(:limit) => 1..100,
               optional(:starting_after) => t | Stripe.id()
             } | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions("data")
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end

  @doc """
  Deletes the discount on a customer
  """
  @spec delete_discount(Stripe.id() | t, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
  def delete_discount(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/discount")
    |> put_method(:delete)
    |> make_request()
  end
end
