defmodule RanchTalk.MixProject do
  use Mix.Project

  def project do
    [
      app: :ranch_talk,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.5.2"},
      {:ranch, "~> 2.1"}
    ]
  end
end
