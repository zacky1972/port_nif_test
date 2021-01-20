defmodule ViaPort do
  use GenServer

  @command "#{:code.priv_dir(:port_nif_test)}/via_port"

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(args \\ []) do
    Port.open({:spawn, Enum.join([@command] ++ args, " ")}, [:binary, :exit_status])
    {:ok, %{latest_output: "", exit_status: nil}}
  end

  def handle_info({_port, {:data, text_line}}, state) do
    latest_output = text_line |> String.trim()
    {:noreply, %{state | latest_output: latest_output}}
  end

  def handle_info({_port, {:exit_status, status}}, state) do
    {:noreply, %{state | exit_status: status}}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  def handle_call(:get, _from, state) do
    exit_status = Map.get(state, :exit_status)

    if is_nil(exit_status) do
      {:reply, :not_yet, state}
    else
      result = Map.get(state, :latest_output)

      if exit_status == 0 do
        {:reply, {:ok, result}, state}
      else
        {:reply, :error, state}
      end
    end
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def via_port(size) do
    Port.open({:spawn, Enum.join([@command, size], " ")}, [:binary, :exit_status])
    receive_get()
  end

  defp receive_get() do
    receive do
      {_pid, {:data, _result}} -> receive_get()
      {_pid, {:exit_status, 0}} -> :ok
      {_pid, {:exit_status, _}} -> :error
      _ -> receive_get()
    end
  end

  defp receive_get(pid) do
    ret = ViaPort.get(pid)

    case ret do
      {:ok, result} ->
        {:ok, result}

      :not_yet ->
        Process.sleep(1)
        receive_get(pid)

      :error ->
        :error
    end
  end
end
