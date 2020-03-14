defmodule HoodMelville do
  @moduledoc """
  Documentation for HoodMelville.
  """
  @type rotation_state ::
          {:reversing, integer(), [term()], [term()], [term()], [term()]}
          | {:idle}
          | {:appending, integer(), [term()], [term()]}
          | {:done, [term()]}

  @type queue :: {integer(), [term()], rotation_state(), integer(), [term()]}

  @empty {0, [], {:idle}, 0, []}
  @spec empty() :: queue()
  def empty do
    @empty
  end

  defdelegate new(), to: HoodMelville, as: :empty

  @spec is_empty(queue()) :: boolean()
  def is_empty({lenf, _f, _state, _lenr, _r}) do
    lenf == 0
  end

  @spec from_list(list()) :: queue()
  def from_list(list) do
    Enum.reduce(list, empty(), fn x, acc -> snoc(acc, x) end)
  end

  @spec to_list(queue()) :: list()
  def to_list({lenf, front, state, _lenr, reversed}) do
    case state do
      {:reversing, _ok, ws, xs, ys, zs} ->
        n = lenf - Kernel.length(front) - 1

        front ++
          Enum.drop(Enum.reverse(ws) ++ xs ++ Enum.reverse(ys) ++ zs, n) ++ Enum.reverse(reversed)

      {:appending, _ok, xs, ys} ->
        n = lenf - Kernel.length(front) - 1
        front ++ Enum.drop(Enum.reverse(xs) ++ ys, n) ++ Enum.reverse(reversed)

      {:idle} ->
        front ++ Enum.reverse(reversed)

      {:done, xs} ->
        front ++ xs ++ Enum.reverse(reversed)
    end
  end

  @spec to_list_naive(queue()) :: list()
  def to_list_naive(queue, acc \\ []) do
    case uncons(queue) do
      {:error, :empty_queue} -> Enum.reverse(acc)
      {:ok, x, tl} -> to_list_naive(tl, [x | acc])
    end
  end

  @spec uncons(queue()) :: {:ok, term(), queue()} | {:error, :empty_queue}
  def uncons({_lenf, [], _state, _lenr, _r}) do
    {:error, :empty_queue}
  end

  def uncons({lenf, [x | xs], state, lenr, r}) do
    {:ok, x, check({lenf - 1, xs, invalidate(state), lenr, r})}
  end

  @spec snoc(queue(), term()) :: queue()
  def snoc({lenf, f, state, lenr, r}, x) do
    check({lenf, f, state, lenr + 1, [x | r]})
  end

  defdelegate insert(queue, item), to: HoodMelville, as: :snoc

  @spec head(queue()) :: term() | {:error, :empty_queue}
  def head({_lenf, [], _state, _lenr, _r}) do
    {:error, :empty_queue}
  end

  defdelegate get(queue), to: HoodMelville, as: :head

  def head({_lenf, [x | _f], _state, _lenr, _r}) do
    x
  end

  @spec tail(queue()) :: queue() | {:error, :empty_queue}
  def tail({_lenf, [], _state, _lenr, _r}) do
    {:error, :empty_queue}
  end

  def tail({lenf, [_x | f], state, lenr, r}) do
    check({lenf - 1, f, invalidate(state), lenr, r})
  end

  # @spec exec(rotation_state()) :: rotation_state()
  defp exec({:reversing, ok, [x | xs], ys, [z | zs], as}) do
    {:reversing, ok + 1, xs, [x | ys], zs, [z | as]}
  end

  defp exec({:reversing, ok, [], ys, [z], as}) do
    {:appending, ok, ys, [z | as]}
  end

  defp exec({:appending, 0, _xs, ys}) do
    {:done, ys}
  end

  defp exec({:appending, ok, [x | xs], ys}) do
    {:appending, ok - 1, xs, [x | ys]}
  end

  defp exec(state) do
    state
  end

  # @spec invalidate(rotation_state()) :: rotation_state()
  defp invalidate({:reversing, ok, ws, xs, ys, zs}) do
    {:reversing, ok - 1, ws, xs, ys, zs}
  end

  defp invalidate({:appending, 0, _xs, [_y | ys]}) do
    {:done, ys}
  end

  defp invalidate({:appending, ok, xs, ys}) do
    {:appending, ok - 1, xs, ys}
  end

  defp invalidate(state) do
    state
  end

  # @spec exec2(queue()) :: queue()
  defp exec2({lenf, f, state, lenr, r}) do
    case exec(exec(state)) do
      {:done, newf} -> {lenf, newf, {:idle}, lenr, r}
      newstate -> {lenf, f, newstate, lenr, r}
    end
  end

  # @spec check(queue()) :: queue()
  defp check({lenf, f, _state, lenr, r} = q) do
    if lenr <= lenf do
      exec2(q)
    else
      new_state = {:reversing, 0, f, [], r, []}
      exec2({lenf + lenr, f, new_state, 0, []})
    end
  end
end
