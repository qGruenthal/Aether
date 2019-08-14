defmodule AetherWeb.Router do
  use AetherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AetherWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/grades", GerasController, :grades
  end

  scope "/api", AetherWeb do
    pipe_through :api

    get "/example", GerasController, :example
  end
end
