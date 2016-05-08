defmodule Omxplayer.Player do

  @executable "omxplayer"

  def get_executable do
    case System.find_executable( @executable ) do
      nil -> { :error, "Executable #{@executable} could not be found. Check your $PATH env var" }
      cmd -> { :ok, cmd }
    end
  end

  def get_pid do
    case System.cmd( "ps", ~w(-o pid= -C #{@executable}) ) do
      { resp, 0 }   -> { :ok, resp |> String.strip |> String.to_integer }
      { msg, _code } -> { :error, msg }
    end
  end

  def is_running? do
    case get_pid do
      { :ok, _pid } -> true
      _ -> false
    end
  end

  def installed? do
    case get_executable do
      { :error, _ } -> false
      { :ok, _ } -> true
      _ -> false
    end
  end

  def play( url ), do: play( url, [] )
  def play( url, args ) when is_list( args ) do
    if is_running? do
      stop
    end
    System.cmd( @executable, args ++ [ url ] )
  end
  def play( url, args ), do: raise "Unknown args format. List is expected."

  def stop do
    #TODO
  end

  def pause do
    #TODO
  end

end
