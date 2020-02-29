defmodule HoodMelvilleTest do
  use ExUnit.Case
  use PropCheck

  property "to_list and from_list are inverses", numtests: 500 do
    forall xs <- list() do
      ys = HoodMelville.from_list(xs)
      equals(HoodMelville.to_list_naive(ys), xs)
    end
  end

  property "it is the same as a list for head", numtests: 400 do
    forall xs <- non_empty(list()) do
      ys = HoodMelville.from_list(xs)
      equals(List.first(xs), HoodMelville.head(ys))
    end
  end
end
