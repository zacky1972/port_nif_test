defmodule PortNifTest do
  def via_port(size) do
    ViaPort.start_link(size)
    receive_get()
  end

  def receive_get() do
    ret = ViaPort.get()

    case ret do
      {:ok, result} ->
        {:ok, result}

      :not_yet ->
        Process.sleep(50)
        receive_get()

      :error ->
        :error
    end
  end
end
