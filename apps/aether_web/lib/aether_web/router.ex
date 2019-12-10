defmodule AetherWeb.Router do
  use AetherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AetherWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AetherWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/grades", GerasController, :grades
    get "/assignments", GerasController, :assignments
    resources "/uploads", UploadController, only: [:new, :create]
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", AetherWeb do
    pipe_through [:browser, :authenticate_user]


  end

  scope "/api", AetherWeb do
    pipe_through :api

    get "/example", GerasController, :example
    get "/grade", GerasController, :grade
    get "/assignment", GerasController, :assignment
  end
end
