list = Enum.to_list(1..10_000)
hm = HoodMelville.from_list(list)
queue = :queue.from_list(list)

Benchee.run(%{
  "to_list" => fn -> HoodMelville.to_list(hm) end,
  "to_list_naive" => fn -> HoodMelville.to_list_naive(hm) end,
  "to_list_queue" => fn -> :queue.to_list(queue) end
},
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  memory_time: 2
)

good_queue = Enum.reduce(1..5, HoodMelville.empty(), fn x, acc ->
  HoodMelville.snoc(acc, x)
end)
bad_queue = Enum.reduce(1..5, :queue.new(), fn x, acc ->
  :queue.snoc(acc, x)
end)

Benchee.run(%{
  "hood_melville_5" => fn ->
    {_, _, queue} = HoodMelville.uncons(good_queue)
    queue
  end,
  "queue_5" => fn ->
    {_, queue} = :queue.out(bad_queue)
    queue
  end
},
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  memory_time: 2
)

good_queue = Enum.reduce(1..50, HoodMelville.empty(), fn x, acc ->
  HoodMelville.snoc(acc, x)
end)
bad_queue = Enum.reduce(1..50, :queue.new(), fn x, acc ->
  :queue.snoc(acc, x)
end)

Benchee.run(%{
  "hood_melville_50" => fn ->
    {_, _, queue} = HoodMelville.uncons(good_queue)
    queue
  end,
  "queue_50" => fn ->
    {_, queue} = :queue.out(bad_queue)
    queue
  end
},
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  memory_time: 2
)
