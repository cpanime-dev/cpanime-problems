#include <print>

#include "cplib.hpp"

CPLIB_REGISTER_GENERATOR(
    gen, args,
    a_min = Var<cplib::var::i32>("a-min", 1, 1000000000),
    a_max = Var<cplib::var::i32>("a-max", 1, 1000000000),
    b_min = Var<cplib::var::i32>("b-min", 1, 1000000000),
    b_max = Var<cplib::var::i32>("b-max", 1, 1000000000),
    salt = Var<cplib::var::String>("salt"));

void generator_main() {
  using args::a_max, args::a_min, args::b_max, args::b_min;

  if (a_min > a_max || b_min > b_max) cplib::panic("invalid range");

  auto a = gen.rnd.next(a_min, a_max);
  auto b = gen.rnd.next(b_min, b_max);
  std::println("{} {}", a, b);

  gen.quit_ok();
}
