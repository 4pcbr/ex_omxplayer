defmodule Omxplayer.Player.Dbus do

  @executable "dbus-send"
  @dbus_name  "org.mpris.MediaPlayer2.omxplayer"
  @dbus_dest  "/org/mpris/MediaPlayer2"

  @env_dbus_session_bus_address "DBUS_SESSION_BUS_ADDRESS"
  @env_dbus_session_bus_pid     "DBUS_SESSION_BUS_PID"

  defstruct addr: nil,
             pid: nil,
            name: nil,
            dest: nil,
            opts: []

  def init do
    { :ok, dbus_addr } = get_dbus_addr
    { :ok, dbus_pid  } = get_dbus_pid
    %Omxplayer.Player.Dbus{
      addr: dbus_addr,
       pid: dbus_pid,
      name: @dbus_name,
      dest: @dbus_dest,
      opts: ~w(--session)
    }
  end

  def call_method( dbus, method, opts ), do: call_method( dbus, method, [], opts )
  def call_method( dbus, method, args, opts ) do
    case System.cmd( @executable, dbus.opts ++ opts ++ [
      "--dest=#{dbus.name}",
      dbus.dest,
      method
    ] ++ args, env: [
      { @env_dbus_session_bus_address, dbus.addr },
      { @env_dbus_session_bus_pid    , dbus.pid  },
    ] ) do
      { response, 0 } ->
        { :ok, String.strip response }
      { error, status } ->
        { :error, error }
    end
  end

  def get_dbus_addr do
    case get_dbus_files do
      files when is_list( files ) ->
        case Enum.find( files, fn file -> ! Regex.match?( ~r/\.pid$/, file ) end ) do
          nil  ->
            { :error, "Dbus file could not be found or is not readable by the current user." }
          file ->
            case File.read( "/tmp/#{file}" ) do
              { :ok, data } -> { :ok, String.strip( data ) }
              error -> error
            end
        end
      _ -> { :error, 'DBUS files could not be found' }
    end
  end

  def get_dbus_pid do
    case get_dbus_files do
      files when is_list( files ) ->
        case Enum.find( files, fn file -> Regex.match?( ~r/\.pid$/, file ) end ) do
          nil ->
            { :error, "Dbus PID file could not be found or is not readable by the current user." }
          file ->
            case File.read( "/tmp/#{file}" ) do
              { :ok, data } -> { :ok, String.strip( data ) }
                error -> error
            end
        end
      _ -> { :error, 'DBUS files could not be found' }
    end
  end

  def get_duration( dbus ) do
    case call_method( dbus, "org.freedesktop.DBus.Properties.Duration",
      ~w(--print-reply=literal --reply-timeout=500) ) do
      { :ok, response } ->
        response
          |> String.split
            |> Enum.at 1
      { :error, reason } ->
        raise "Error calling method: #{reason}"
    end
  end

  def get_position( dbus ) do
    case call_method( dbus, "org.freedesktop.DBus.Properties.Position", 
      ~w(--print-reply=literal --reply-timeout=500) ) do
      { :ok, response } ->
        response
          |> String.split
            |> Enum.at 1
      { :error, reason } ->
        raise "Error calling method: #{reason}"
    end
  end

  def get_playback_status( dbus ) do
    case call_method( dbus, "org.freedesktop.DBus.Properties.PlaybackStatus",
      ~w(--print-reply=literal --reply-timeout=500) ) do
      { :ok, response } ->
        response
      { :error, reason } ->
        raise "Error calling method: #{reason}"
    end
  end

  def pause( dbus ) do
    call_method( dbus, "org.mpris.MediaPlayer2.Player.Action",
      ~w(int32:16), ~w(--print-reply=literal) )
  end

  def ls_mask( path, mask ) do
    case File.ls path do
      { :ok, files } ->
        Enum.filter( files, fn file ->
          Regex.match?( mask, file )
        end )
      err -> err
    end
  end

  def is_active? do
    case get_dbus_pid do
      { :ok, _pid } -> true
      _             -> false
    end
  end

  #============ PRIVATE METHODS ============

  defp get_dbus_files do
    ls_mask "/tmp/", ~r/omxplayerdbus.*/
  end

end

