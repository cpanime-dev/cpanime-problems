{
  ...
}:
{
  displayName.zh = "最大公约数";

  tickLimit = 50 * 10000000;
  memoryLimit = 512 * 1024 * 1024;

  generators.rand.src = ./generator/rand.23.cpp;

  validator = {
    src = ./validator.23.cpp;
    tests = {
      sample = {
        inputFile = ./data/1.in;
        prediction = { status, ... }: status == "valid";
      };
      zero = {
        inputFile = builtins.toFile "zero.in" "0 1\n";
        prediction = { status, ... }: status == "invalid";
      };
      tooBig = {
        inputFile = builtins.toFile "tooBig.in" "1000000001 1\n";
        prediction = { status, ... }: status == "invalid";
      };
    };
  };

  checker = {
    src = ./checker.23.cpp;
    tests = {
      ac = {
        inputFile = ./data/1.in;
        outputFile = builtins.toFile "ac.out" "6\n";
        prediction = { status, ... }: status == "accepted";
      };
      wa = {
        inputFile = ./data/1.in;
        outputFile = builtins.toFile "wa.out" "5\n";
        prediction = { status, ... }: status == "wrong_answer";
      };
    };
  };

  traits = {
    both_le_1000 = {
      descriptions.zh = "$a <= 1000$ 且 $b <= 1000$．";
    };
  };

  testCases = {
    sample = {
      inputFile = ./data/1.in;
      groups = [
        "sample"
        "small"
      ];
    };
    smallRand = {
      generator = "rand";
      arguments = [
        "--a-min=1"
        "--a-max=1000"
        "--b-min=1"
        "--b-max=1000"
        "--salt=1"
      ];
      groups = [ "small" ];
    };
    rand = {
      generator = "rand";
      arguments = [
        "--a-min=1"
        "--a-max=1000000000"
        "--b-min=1"
        "--b-max=1000000000"
        "--salt=1"
      ];
    };
    max = {
      inputFile = ./data/max.in;
    };
  };

  solutions = {
    std = {
      src = ./solution/std.14.cpp;
      mainCorrectSolution = true;
      subtaskPredictions = {
        "0" = { score, ... }: score == 1.0;
      };
    };
    bruteForce = {
      src = ./solution/bf.14.cpp;
      subtaskPredictions = {
        "0" = { score, ... }: score == 1.0;
        "1" =
          { statuses, ... }:
          builtins.all (status: status == "accepted" || status == "time_limit_exceeded") statuses;
      };
    };
  };

  subtasks = [
    {
      traits.both_le_1000 = true;
      fullScore = 0.3;
    }
    { fullScore = 0.7; }
  ];
}
