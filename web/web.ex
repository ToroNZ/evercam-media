defmodule EvercamMedia.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use EvercamMedia.Web, :controller
      use EvercamMedia.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      use Calecto.Schema
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, log: :info

      alias EvercamMedia.Repo
      alias EvercamMedia.Util

      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]
      import EvercamMedia.Router.Helpers

      require Logger
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import EvercamMedia.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias EvercamMedia.Repo
      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
