defmodule Omxplayer do
  
  use GenServer
  require Record
  Record.defrecord :bus_id, Record.extract(:bus_id, from_lib: "dbus/include/dbus.hrl")

  def start_link do
    { :ok, pid } = GenServer.start_link( __MODULE__, nil, name: __MODULE__ )
  end

  # Public API

  def is_running? do
    GenServer.call( __MODULE__, :is_running? )
  end

  def play( path, attrs ) do
    GenServer.cast( __MODULE__, { :play, path, attrs } )
  end

  def stop, do: stop( false )
  def stop( force ) do
    GenServer.cast( __MODULE__, { :stop, force } )
  end
  # GenServer callbacks

  # Helper functions

  defp started_by do
    #TODO
  end


end
