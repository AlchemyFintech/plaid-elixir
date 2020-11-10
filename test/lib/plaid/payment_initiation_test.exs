defmodule Plaid.PaymentInitiationTest do
  use ExUnit.Case
  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "payment_initiation/payment" do
    test "get/1 requests POST and returns Plaid.PaymentInitiation.Payments.Payment", %{
      bypass: bypass
    } do
      body = http_response_body(:"payment_initiation/payment/get")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "payment_initiation/payment/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.PaymentInitiation.Payments.get(%{
                 payment_id: "some payment id"
               })

      assert Plaid.PaymentInitiation.Payments.Payment == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "create/1 requests POST and returns Plaid.PaymentInitiation.Payments", %{bypass: bypass} do
      body = http_response_body(:"payment_initiation/payment/create")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "payment_initiation/payment/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.PaymentInitiation.Payments.create(%{
                 recipient_id: "some recipient id",
                 reference: "some reference",
                 amount: %{
                   currency: "GBP",
                   value: 10
                 }
               })

      assert Plaid.PaymentInitiation.Payments == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end

  describe "payment_initiation/recipient" do
    test "create/1 requests POST and returns Plaid.Investments.Recipients", %{
      bypass: bypass
    } do
      body = http_response_body(:"payment_initiation/recipient/create")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "payment_initiation/recipient/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.PaymentInitiation.Recipients.create(%{
                 name: "recipient-name",
                 iban: "recipient-iban"
               })

      assert Plaid.PaymentInitiation.Recipients == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "get/1 requests POST and returns Plaid.Investments.Recipients.Recipient", %{
      bypass: bypass
    } do
      body = http_response_body(:"payment_initiation/recipient/get")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "payment_initiation/recipient/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.PaymentInitiation.Recipients.get(%{
                 recipient_id: "recipient-id"
               })

      assert Plaid.PaymentInitiation.Recipients.Recipient == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "list/1 requests POST and returns [Plaid.Investments.Recipients.Recipient]", %{
      bypass: bypass
    } do
      body = http_response_body(:"payment_initiation/recipient/list")

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "payment_initiation/recipient/list" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.PaymentInitiation.Recipients.list()
      assert [%Plaid.PaymentInitiation.Recipients.Recipient{}] = resp
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
