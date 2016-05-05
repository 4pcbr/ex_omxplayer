defmodule OmxplayerPlayerTest do
  use ExUnit.Case
  import Omxplayer.Player

  test "get_executable" do
    { status, info } = get_executable
    assert status == :ok
    assert File.exists?( info )
  end

  test "get_pid" do
    case get_pid do
      { :ok, pid } ->
        assert is_number pid
        assert pid > 0
      { :error, _ } ->
        raise "The process is not running"
    end
  end

  test "is_running?" do
    case get_pid do
      { :ok, _pid } ->
        assert is_running?
      { :error, _ } ->
        raise "The process is not running"
    end
  end

  test "ls_mask" do
    files = ls_mask( "/", ~r/usr|tmp|root/ )
    assert is_list files
    assert length( files ) == 3
    assert Enum.member?( files, "usr"  )
    assert Enum.member?( files, "tmp"  )
    assert Enum.member?( files, "root" )
  end

  test "dbus_addr" do
    { :ok, addr } = dbus_addr
    assert is_bitstring addr
  end


end
