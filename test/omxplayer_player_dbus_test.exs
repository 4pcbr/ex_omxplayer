defmodule OmxplayerPlayerDbusTest do
  use ExUnit.Case
  import Omxplayer.Player.Dbus

  test "ls_mask" do
    files = ls_mask( "/", ~r/usr|tmp|root/ )
    assert is_list files
    assert length( files ) == 3
    assert Enum.member?( files, "usr"  )
    assert Enum.member?( files, "tmp"  )
    assert Enum.member?( files, "root" )
  end

  @tag :is_running
  test "dbus_addr" do
    { :ok, addr } = dbus_addr
    assert is_bitstring addr
  end

  @tag :is_running
  test "dbus_pid" do
    { :ok, pid } = dbus_pid
    assert is_bitstring pid
    assert Regex.match?( ~r/^\d+$/, pid )
    assert pid > 0
  end

  @tag :is_running
  test "is_active?" do
    assert is_active?
  end

  @tag :is_running
  test "status" do
    IO.inspect status
  end


end
