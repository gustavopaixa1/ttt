defmodule ChatWeb.ChatLive.Index do
  use ChatWeb, :live_view

  @names ["Fulano", "Ciclano"]

  def mount(_params, _session, socket) do
  if connected?(socket) do
    ChatWeb.Endpoint.subscribe(topic())
  end

    {:ok, assign(socket, username: username(), messages: [])}
  end

  def handle_info(%{event: "message", payload: message},socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_event("send", %{"text" => text}, socket) do
    ChatWeb.Endpoint.broadcast(topic(), "message", %{
      text: text,
      name: socket.assigns.username
    })
    {:noreply, socket}
  end

  defp username do
    name = Enum.random(@names)
    "#{name}"
  end

  defp topic do
    "chat"
  end

end
