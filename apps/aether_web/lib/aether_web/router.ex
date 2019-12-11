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
    get "/landing", PageController, :landing
    get "/grades/:course/:assignment", GerasController, :grades
    get "/assignments/:course", GerasController, :assignments
    get "/uploads/new/:name", UploadController, :new
    post "/uploads", UploadController, :create
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
    get "/Stuff 101", GerasController, :assignment
    get "/Stuff 200", GerasController, :pool
  end
end
