defmodule EatsWeb.PageController do
  use EatsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
