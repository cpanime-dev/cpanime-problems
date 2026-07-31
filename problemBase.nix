name: problemFun:
{
  hull,
  config,
  cplib,
  ...
}@args:
let
  includeDirFiles = builtins.attrNames (builtins.readDir (./problems + "/${name}/include"));
  defaultConfig = {
    inherit name;
    documents = {
      "statement.zh.pdf" = {
        path = hull.xcpcStatement config {
          statement = ./problems + "/${name}/document/statement/zh.typ";
          displayLanguage = "zh";
        };
        displayLanguage = "zh";
        participantVisibility = true;
      };
    };
    includes = [
      cplib
      (./problems + "/${name}/include")
    ];

    targets.default = hull.problemTarget.legacy.hydro.batch {
      statements.zh = "statement.zh.pdf";
      testDataExtraFiles = builtins.listToAttrs (
        map (file: {
          name = file;
          value = (./problems + "/${name}/include/${file}");
        }) includeDirFiles
      );
      judgeExtraFiles = includeDirFiles;
      zipped = false;
    };
  };
in
(import <nixpkgs> { }).pkgs.lib.recursiveUpdate defaultConfig (problemFun args)
