#pragma once

#include <cstdint>
#include <tuple>
#include <vector>

#include "cplib.hpp"

struct Input {
  std::int32_t a, b;

  static auto read(cplib::var::Reader &in) -> Input {
    std::int32_t a, b;
    std::tie(a, std::ignore, b, std::ignore) =
        in(cplib::var::i32("a", 1, 1000000000), cplib::var::space,
           cplib::var::i32("b", 1, 1000000000), cplib::var::eoln);
    return {.a = a, .b = b};
  }
};

struct Output {
  std::int32_t answer;

  static auto read(cplib::var::Reader &in, const Input &) -> Output {
    auto answer = in.read(cplib::var::i32("answer"));
    return {answer};
  }

  static auto evaluate(cplib::evaluate::Evaluator &ev, const Output &pans,
                       const Output &jans, const Input &)
      -> cplib::evaluate::Result {
    auto result = cplib::evaluate::Result::ac();
    result &= ev.eq("answer", pans.answer, jans.answer);
    return result;
  }
};

inline auto traits(const Input &input) -> std::vector<cplib::validator::Trait> {
  return {
      {"both_le_1000", [&]() -> bool {
        return input.a <= 1000 && input.b <= 1000;
      }},
  };
}
