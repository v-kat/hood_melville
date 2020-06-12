# HoodMelville

[![Build Status](https://travis-ci.com/IRog/hood_melville.svg?branch=master)](https://travis-ci.com/IRog/hood_melville)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Hex pm](http://img.shields.io/hexpm/v/hood_melville.svg?style=flat)](https://hex.pm/packages/hood_melville)
[![hexdocs.pm](https://img.shields.io/badge/docs-latest-green.svg?style=flat)](https://hexdocs.pm/hood_melville/)

## Description

Real-time purely functional persistent (in the data-structure sense not that it goes to disk) queue. Will never get into a bad state unlike the erlang queue although has lower throughput for good states. Optimized for consistent latency instead of throughput.

## Installation

[available in Hex](https://hex.pm/packages/hood_melville), the package can be installed
by adding `hood_melville` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hood_melville, "~> 0.1.0"}
  ]
end
```

```elixir
queue =
  HoodMelville.new()
  |> HoodMelville.insert("sample")

HoodMelville.get(queue)
```

See the linked docs for more function info and/or the test directory 
