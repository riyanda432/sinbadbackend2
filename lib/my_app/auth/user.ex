defmodule MyApp.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :is_active, :password])
    |> validate_required([:name, :email, :is_active, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end
  # hash password dengan bcrypt
  def put_password_hash(
          %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
        ) do
     change(changeset, Bcrypt.add_hash(password))
   end

  def put_password_hash(changeset) do
    changeset
  end
end
