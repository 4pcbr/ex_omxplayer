defmodule Omxplayer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :omxplayer,
      version: "0.0.1",
      elixir: "~> 1.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      build_tool: 'rebar',
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      { :dbus,        "~> 0.5.0"  },
      { :rebar3_hex,  "~> 2.0"    },
    ]
  end
end
