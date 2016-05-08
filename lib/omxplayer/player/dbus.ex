defmodule Omxplayer.Player.Dbus do

  @executable "dbus-send"
  @dbus_name  "org.mpris.MediaPlayer2.omxplayer"
  @dbus_dest  "/org/mpris/MediaPlayer2"

  @env_dbus_session_bus_address "DBUS_SESSION_BUS_ADDRESS"
  @env_dbus_session_bus_pid     "DBUS_SESSION_BUS_PID"

  def dbus_addr do
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

  def dbus_pid do
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
    case dbus_pid do
      { :ok, _pid } -> true
      _             -> false
    end
  end

  def status do
    { :ok, my_dbus_addr } = dbus_addr
    { :ok, my_dbus_pid  } = dbus_pid
    duration = System.cmd( @executable, [
      "--print-reply=literal",
      "--session",
      "--reply-timeout=500",
      "--dest=#{@dbus_name}",
      @dbus_dest,
      "org.freedesktop.DBus.Properties.Duration"
    ], env: [
      { @env_dbus_session_bus_address, my_dbus_addr },
      { @env_dbus_session_bus_pid    , my_dbus_pid  },
    ] )
  end


  #============ PRIVATE METHODS ============

  defp get_dbus_files do
    ls_mask "/tmp/", ~r/omxplayerdbus.*/
  end

end

