defmodule EvercamMedia.VendorView do
  use EvercamMedia.Web, :view

  def render("index.json", %{vendors: vendors}) do
    %{vendors: render_many(vendors, __MODULE__, "vendor.json")}
  end

  def render("show.json", %{vendor: vendor}) do
    %{vendors: render_many([vendor], __MODULE__, "vendor.json")}
  end

  def render("vendor.json", %{vendor: vendor}) do
    %{
      id: vendor.exid,
      name: vendor.name,
      known_macs: vendor.known_macs,
      total_models: Vendor.get_models_count(vendor),
      logo: "https://evercam-public-assets.s3.amazonaws.com/#{vendor.exid}/logo.jpg",
    }
  end
end
