defmodule PortBench do
  use Benchfella

  @size 6000

  setup_all do
  	ViaPort.via_port(100)
  	{:ok, nil}
  end

  bench "ViaPort" do
  	ViaPort.via_port(@size)
  end

  bench "PelemayFp ViaPort core 1 even" do
  	PortNifTest.pelemay_fp_via_port(@size, @size)
  end

  bench "PelemayFp ViaPort core 2 even" do
  	PortNifTest.pelemay_fp_via_port(@size, div(@size, 2))
  end

  bench "PelemayFp ViaPort core 3 even" do
  	PortNifTest.pelemay_fp_via_port(@size, div(@size, 3))
  end

  bench "PelemayFp ViaPort core 4 even" do
  	PortNifTest.pelemay_fp_via_port(@size, div(@size, 4))
  end

  bench "PelemayFp ViaPort core 5 even" do
  	PortNifTest.pelemay_fp_via_port(@size, div(@size, 5))
  end

  bench "PelemayFp ViaPort core 6 even" do
  	PortNifTest.pelemay_fp_via_port(@size, div(@size, 6))
  end
end
