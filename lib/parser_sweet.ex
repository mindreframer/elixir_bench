defmodule ParserSweet do
  import SweetXml

  def run(body) do
    body
    |> parse(dtd: :none)
    |> xpath(
      ~x"//search:search-result",
      total: ~x"/search:search-result/search:total/text()"i,
      page_size: ~x"/search:search-result/search:page-size/text()"i,
      current_page: ~x"/search:search-result/search:current-page/text()"i,
      max_pages: ~x"/search:search-result/search:max-pages/text()"i,
      vehicles: [
        ~x"//search:search-result/search:ads/ad:ad"l,
        id: ~x"./@key"S,
        url: ~x"./ad:detail-page/@url"S,

        ## general info
        creation_time: value("./ad:creation-date"),
        modification_time: value("./ad:modification-date"),
        make: key("./ad:vehicle/ad:make"),
        model: key("./ad:vehicle/ad:model"),
        class: key("./ad:vehicle/ad:class"),
        category: key("./ad:vehicle/ad:category"),
        model_description: value("./ad:vehicle/ad:model-description"),

        ## specifics
        fuel: specific_key("ad:fuel"),
        power: specific_value("ad:power", :int),
        mileage: specific_value("ad:mileage", :int),
        gearbox: specific_key("ad:gearbox"),
        headlight: specific_key("ad:headlight-type"),
        num_seats: specific_value("ad:num-seats", :int),
        climatisation: specific_key("ad:climatisation"),
        interior_type: specific_key("ad:interior-type"),
        interior_color: specific_key("ad:interior-color"),
        cubic_capacity: specific_value("ad:cubic-capacity", :int),
        construction_year: specific_value("ad:construction-year"),
        first_registration: specific_value("ad:first-registration"),
        number_of_previous_owners: specific_text("ad:number-of-previous-owners", :int),

        ## features (as booleans!)
        navigation: feature("NAVIGATION_SYSTEM"),
        electric_heated_seats: feature("ELECTRIC_HEATED_SEATS"),

        ## price
        consumer_price:
          value("./ad:price/ad:consumer-price-amount") |> transform_by(&to_float_int/1)
      ]
    )
  end

  @doc """
  Boolean!
  """
  def feature(f) do
    key("./ad:vehicle/ad:features/ad:feature[@key='#{f}']") |> transform_by(&to_bool/1)
  end

  def specific_key(f) do
    key("./ad:vehicle/ad:specifics/#{f}")
  end

  def specific_text(f) do
    text("./ad:vehicle/ad:specifics/#{f}")
  end

  def specific_text(f, :int) do
    text("./ad:vehicle/ad:specifics/#{f}") |> transform_by(&to_int/1)
  end

  def specific_value(f) do
    value("./ad:vehicle/ad:specifics/#{f}")
  end

  def specific_value(f, :int) do
    value("./ad:vehicle/ad:specifics/#{f}") |> transform_by(&to_int/1)
  end

  def desc(path) do
    ~x"#{path}/resource:local-description/text()"S |> empty_to_nil()
  end

  def value(path) do
    ~x"#{path}/@value"S |> transform_by(&empty_to_nil/1)
  end

  def text(path) do
    ~x"#{path}/text()"S
  end

  def key(path) do
    ~x"#{path}/@key"S |> transform_by(&empty_to_nil/1)
  end

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
end
