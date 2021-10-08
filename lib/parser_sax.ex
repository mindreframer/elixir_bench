defmodule ParserSAX do
  use Pathex, default_mod: :json

  def run(body) do
    {:ok, doc} = SAXMap.from_string(body, ignore_attribute: {false, "@"})
    result = myview(doc, path("search:search-result" / "content" ))
    vehicles = myview(doc, path("search:search-result" / "content" / "search:ads" / "content" / "ad:ad" ))
    %{
      total: myview(result, path("search:total" / "content")) |> to_int(),
      page_size: myview(result, path("search:page-size" / "content")) |> to_int(),
      max_pages: myview(result, path("search:max-pages" / "content")) |> to_int(),
      current_page: myview(result, path("search:current-page" / "content")) |> to_int(),
      vehicles: Enum.map(vehicles, &extract_vehicle/1),
    }
  end

  def extract_vehicle(doc) do

    advehic = myview(doc, path("content" / "ad:vehicle" / "content"))
    adspecific = myview(doc, path("content" / "ad:vehicle" / "content" / "ad:specifics" / "content"))
    adfeatures = myview(doc, path("content" / "ad:vehicle" / "content" / "ad:features" / "content" / "ad:feature"))

    %{
      id: myview(doc, path("@key")),
      url: myview(doc, path("content" / "ad:detail-page" / "@url")),

      # general info
      creation_time: myview(doc, path("content" / "ad:creation-date" / "@value")),
      modification_time: myview(doc, path("content" / "ad:modification-date" / "@value")),
      make: myview(advehic, path( "ad:make" / "@key")),
      model: myview(advehic, path("ad:model" / "@key")),
      class: myview(advehic, path("ad:class" / "@key")),
      category: myview(advehic, path("ad:category" / "@key")),
      model_description: myview(advehic, path("ad:model-description" / "@value")),

      ## specifics
      fuel: myview(adspecific, path("ad:fuel" / "@key")),
      power: myview(adspecific, path("ad:power" / "@value"), :int),
      mileage: myview(adspecific, path("ad:mileage" / "@value"), :int),
      gearbox: myview(adspecific, path("ad:gearbox" / "@key")),
      headlight: myview(adspecific, path("ad:headlight-type" / "@key")),
      num_seats: myview(adspecific, path("ad:num-seats" / "@value"), :int),
      climatisation: myview(adspecific, path("ad:climatisation" / "@key")),
      interior_type: myview(adspecific, path("ad:interior-type" / "@key")),
      interior_color: myview(adspecific, path("ad:interior-color" / "@key")),
      cubic_capacity: myview(adspecific, path("ad:cubic-capacity" / "@key")),
      construction_year: myview(adspecific, path("ad:construction-year" / "@value")),
      first_registration: myview(adspecific, path("ad:first-registration" / "@value")),
      number_of_previous_owners: myview(adspecific, path("ad:number-of-previous-owners" / "content"), :int),

      ## features (as booleans!)
      navigation: has_feature?(adfeatures, "NAVIGATION_SYSTEM"),
      electric_heated_seats: has_feature?(adfeatures, "ELECTRIC_HEATED_SEATS"),

      ## price
      consumer_price: myview(doc, path("content" / "ad:price" / "content" / "ad:consumer-price-amount" / "@value"), :float_int),
    }
  end

  def myview(doc, path, :bool) do
    myview(doc, path) |> to_bool()
  end

  def myview(doc, path, :int) do
    myview(doc, path) |> to_int()
  end
  def myview(doc, path, :float_int) do
    myview(doc, path) |> to_float_int()
  end
  def myview(doc, path) do
    with {:ok, v} <- Pathex.view(doc, path) do
      v |> empty_to_nil()
    else
      :error -> nil
    end
  end


  def has_feature?(nil, _name) do
    false
  end
  def has_feature?(features, name) when is_list(features) do
    Enum.any?(features, fn(x)-> Map.get(x, "@key") == name end)
  end
  def has_feature?(feature, name) do
    Map.get(feature, "@key") == name
  end

  def to_int(nil), do: nil
  def to_int(""), do: 0
  def to_int(v), do: String.to_integer(v)

  def to_bool(""), do: false
  def to_bool(nil), do: false
  def to_bool(0), do: false
  def to_bool(_v), do: true

  def empty_to_nil(""), do: nil
  def empty_to_nil(v), do: v

  def to_float_int(""), do: 0
  def to_float_int(v), do: String.to_float(v) |> trunc()


  def transform_by(v, func) do
    func.(v)
  end
end
