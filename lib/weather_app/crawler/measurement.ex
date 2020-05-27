defmodule Measurement do
  @derive Jason.Encoder
  defstruct date_time: "", weather_data: %{}
end
