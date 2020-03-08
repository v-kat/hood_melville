list = Enum.to_list(1..10_000)
hms = HoodMelville.from_list(list)

Benchee.run(%{
  "to_list" => fn -> HoodMelville.to_list(hms) end,
  "to_list_naive" => fn -> HoodMelville.to_list_naive(hms) end
},
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ]
)