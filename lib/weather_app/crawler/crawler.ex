defmodule WeatherApp.Crawler do
  require Logger
  @moduledoc false
  def get_url_info() do
    Logger.info("Iniciando crawler")
    url = "http://www.plantaragronomia.eng.br/"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        get_table_info(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info "Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def get_table_info(body) do
    body
      |> Floki.find("table.table_estacao")
      |> Floki.find("tr")
      |> Enum.map(fn colunas-> Floki.find(colunas, "td") end)
      |> Enum.map(fn [nome, conteudo] -> [Tuple.to_list(nome) ,  Tuple.to_list(conteudo)] end)
      |> Enum.map(fn [nome, _conteudo] -> List.last(nome) end )
      #|> Poison.decode!

  end

end
