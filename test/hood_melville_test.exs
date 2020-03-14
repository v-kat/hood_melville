defmodule HoodMelvilleTest do
  use ExUnit.Case
  use PropCheck

  test "empty list has no tail" do
    res = HoodMelville.new() |> HoodMelville.tail()
    assert res == {:error, :empty_queue}
  end

  test "empty list is empty" do
    assert HoodMelville.empty() |> HoodMelville.is_empty()
  end

  property "inserting two elements in queue then tail and get results in second element",
    numtests: 100 do
    forall {xs, ys} <- {integer(), integer()} do
      queue =
        HoodMelville.new()
        |> HoodMelville.insert(xs)
        |> HoodMelville.insert(ys)

      equals(HoodMelville.get(HoodMelville.tail(queue)), ys)
    end
  end

  property "to_list and from_list are inverses", numtests: 500 do
    forall xs <- noshrink(list(integer())) do
      ys = HoodMelville.from_list(xs)
      equals(HoodMelville.to_list(ys), xs)
    end
  end

  property "to_list and to_list_naive are equivalent", numtests: 100_000 do
    forall xs <- non_empty(list(noshrink(large_int()))) do
      ys = HoodMelville.from_list(xs)
      equals(HoodMelville.to_list(ys), HoodMelville.to_list_naive(ys))
    end
  end

  property "it is the same as a list for head", numtests: 400 do
    forall xs <- non_empty(noshrink(list(integer()))) do
      ys = HoodMelville.from_list(xs)
      equals(List.first(xs), HoodMelville.head(ys))
    end
  end
end
