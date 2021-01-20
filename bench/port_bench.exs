defmodule PortBench do
  use Benchfella

  setup_all do
  	ViaPort.via_port(100)
  end

  bench "ViaPort 1000" do
  	ViaPort.via_port(1000)
  end

  bench "ViaPort 600000" do
  	ViaPort.via_port(600000)
  end
end
