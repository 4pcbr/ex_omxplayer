defmodule OmxplayerPlayerTest do
  use ExUnit.Case
  import Omxplayer.Player

  test "get_executable" do
    { status, info } = get_executable
    assert status == :ok
    assert File.exists?( info )
  end

  @tag :is_running
  test "get_pid" do
    case get_pid do
      { :ok, pid } ->
        assert is_number pid
        assert pid > 0
      { :error, _ } ->
        raise "The process is not running"
    end
  end

  @tag :is_running
  test "is_running?" do
    case get_pid do
      { :ok, _pid } ->
        assert is_running?
      { :error, _ } ->
        raise "The process is not running"
    end
  end

end
