defmodule OmxplayerPlayerDbusTest do
  use ExUnit.Case
  import Omxplayer.Player.Dbus
  alias Omxplayer.Player.Dbus

  def looks_like_number( str ) when is_bitstring( str ) do
    Regex.match?( ~r/^\d+$/, str )
  end

  setup do
    dbus = Dbus.init
    { :ok, dbus: dbus }
  end

  test "ls_mask" do
    files = ls_mask( "/", ~r/usr|tmp|root/ )
    assert is_list files
    assert length( files ) == 3
    assert Enum.member?( files, "usr"  )
    assert Enum.member?( files, "tmp"  )
    assert Enum.member?( files, "root" )
  end

  @tag :is_running
  test "get_dbus_addr" do
    { :ok, addr } = get_dbus_addr
    assert is_bitstring addr
  end

  @tag :is_running
  test "get_dbus_pid" do
    { :ok, pid } = get_dbus_pid
    assert is_bitstring pid
    assert looks_like_number pid
  end

  @tag :is_running
  test "is_active?" do
    assert is_active?
  end

  @tag :is_running
  test "get_duration", context do
    duration = get_duration context[:dbus]
    assert is_bitstring duration
    assert looks_like_number duration
  end

  @tag :is_running
  test "get_position", context do
    position = get_position context[:dbus]
    assert is_bitstring position
    assert looks_like_number position
  end

  @tag :is_running
  test "get_playback_status", context do
    playback_status = get_playback_status context[:dbus]
    assert Regex.match?( ~r/Playing|Paused/, playback_status )
  end

end
