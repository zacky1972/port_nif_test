defmodule PortNifTest do
  def pelemay_fp_via_port(size, threshold) do
  	PelemayFp.map_chunk(1..size, & &1, chunk_func_port(size, threshold), threshold)
  end

  defp chunk_func_port(size, threshold) do
  	fn list -> 
  		ViaPort.via_port(div(size, threshold))
  		list
  	end
  end
end
