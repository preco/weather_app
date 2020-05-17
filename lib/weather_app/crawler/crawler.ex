defmodule WeatherApp.Crawler do
  require Logger

  @spec magic :: :ok
  def magic() do
    IO.puts 'It\'s a kind of magic'
  end
  @moduledoc false
  def get_url_info() do
    Logger.info("Iniciando crawler")
    url = "http://www.plantaragronomia.eng.br/"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        handle_table_info(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info "Not found"
      {_, %HTTPoison.Response{status_code: 500}} ->
        get_url_info()
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp handle_table_info(body) do
    body
    |> get_table_info
    |> IO.inspect
    |> Poison.encode!
  end

  def get_url() do
    html = '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>Plantar</title>
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-15" />
<meta name="author" content="Evoluma" />
<meta name="robots" content="all" />
<meta name="description" content="Plantar" />
<meta name="keywords" content="Agronomia, Arroz" />
<meta name="language" content="pt-br" />
<link rel="stylesheet" type="text/css" media="screen" href="css/estilonovo2.css" />
<meta http-equiv="refresh" content="60" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
</head>

<body>

<div id="fundofoto">
  <div id="foto"></div>
</div>

<div id="topo">
  <div id="fundo_logo">
  </div>
</div>

<div id="separador"> </div>

<div id="menu">
  <div id="menureal">
    <ul>
      <li><img src="imagens/seta2_dir.gif" alt="seta"/><a href="#" title="Página inicial">Início</a></li>
      <li><img src="imagens/seta2_dir.gif" alt="seta"/><a href="noticias.asp?pagina=1" title="Notícias e eventos">Notícias e eventos</a></li>
      <li><img src="imagens/seta2_dir.gif" alt="seta"/><a href="artigos.asp?pagina=1" title="Artigos">Artigos</a></li>
      <li><img src="imagens/seta2_dir.gif" alt="seta"/><a href="servicos.asp" title="Serviços da Plantar">Serviços</a></li>
      <li><img src="imagens/seta2_dir.gif" alt="seta"/><a href="contato.asp" title="Informações para contato">Contato</a></li>
    </ul>
  </div>

  <div id="dados_usuario">

  </div>
</div>

<div id="conteudo">
  <div id="submenu">
    <div id="estacoes_painel">
      <div class="estacao">
      <table class="table_estacao">
        <tr class="cor_sim">
          <td>Temperatura</td>
          <td>25.1 &deg;C</td>
        </tr>
        <tr class="cor_nao">
          <td>Umidade relativa do ar</td>
          <td>54%</td>
        </tr>
        <tr class="cor_sim">
          <td>Pressão atmosf&eacute;rica </td>
          <td>1023.0 hPa</td>
        </tr>
        <tr class="cor_nao">
          <td>Velocidade do vento</td>
          <td>11.2 km/h</td>
        </tr>
        <tr class="cor_sim">
          <td>Dire&ccedil;&atilde;o do vento</td>
          <td>E</td>
        </tr>
        <tr class="cor_nao">
          <td>Chuva do dia</td>
          <td>0.0 mm</td>
        </tr>
        <tr class="cor_sim">
          <td>Chuva do m&ecirc;s</td>
          <td>24.6 mm</td>
        </tr>
        <tr class="cor_nao">
          <td>Temp. m&iacute;n.  do dia </td>
          <td>15.6 &deg;C</td>
        </tr>
        <tr class="cor_sim">
          <td>Temp. m&aacute;x.  do dia</td>
          <td>26.8 &deg;C</td>
        </tr>
        <tr class="cor_nao">
          <td>N&iacute;vel do Rio Tubar&atilde;o </td>
          <td>1,39 m</td>
        </tr>
      </table>
      <p class="corpo_texto_menor">
      Estação Meteorológica INSTRUTEMP ITWH 1080<br />
      Localização: Vila Moema - Tubarão - SC<br />
      Coordenadas UTM: 22J 696.181 E 6.848.140 S <br />
      Última atualização: 19/04/20&nbsp;12:54:05<br />
      </p>
    </div>
    </div><!--fim painel estações-->
  </div>
  <div class="conteudo-interno">
    <div class="painel_central">
      <!--<div>
        <p><font size="3"><strong>Para melhor atender à demanda de acessos, o site da Plantar encontra-se em migração para um novo servidor. Em breve estaremos no ar novamente. (12/06/2012)</strong>
        </font></p>
      </div>-->
      <div>
        <img src="\estacao\grafico.jpg" alt="Grafico nivel" width="450" height="262"/> <br />
      </div>
      <div class="painel_aviso_esquerda">
O n&iacute;vel indicado &eacute; em rela&ccedil;&atilde;o ao n&iacute;vel do mar.<br />
  N&atilde;o nos responsabilizamos por eventuais leituras inconsistentes  e/ou interpreta&ccedil;&otilde;es inexatas. Os dados s&atilde;o para estudos agrometeorol&oacute;gicos de interesse da Plantar.
      </div>
      <div class="painel_aviso_direita">
      Medidor de nível Evoluma HIDRO-MDN KP100 <br />
      Localiza&ccedil;&atilde;o: Campestre - Tubarão - SC <br />
      Coordenadas UTM: 22J 698.467L, 6.8494.385S <br />
      Última atualização: 10/04/2020 21:46
      </div>

    </div>

  </div>

</div>

</body>

</html>
    '
    |> Floki.parse
    |> get_table_info
    |> Poison.encode!
  end


  defp get_table_info(body) do
    body
      |> Floki.find("table.table_estacao")
      |> Floki.find("tr")
      |> Enum.reduce(Map.new, fn(column, attr_map) ->
        {_, [_],
        [{_,_, [attr_name]},
        {_, _, [attr_value]}]
        } = column
        Map.put(attr_map, normalize_string(attr_name), normalize_value(attr_value))
      end)
  end

  defp normalize_value(value) do
    value_without_comma = value
      |> normalize_string
      |> String.replace(",", ".")
    Regex.replace(~r/[^0-9.NSEO]+/, value_without_comma, "")
  end

  def normalize_string(raw) do
    codepoints = String.codepoints(raw)
    Enum.reduce(codepoints,
      fn(w, result) ->
        cond do
          String.valid?(w) ->
            result <> w
          true ->
            << parsed :: 8>> = w
            result <>   << parsed :: utf8 >>
          end
        end)
   end
end
