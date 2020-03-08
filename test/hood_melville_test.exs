defmodule HoodMelvilleTest do
  use ExUnit.Case
  use PropCheck

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
