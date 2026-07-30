name: problemFun:
{
  hull,
  config,
  cplib,
  ...
}@args:
let
  includeDirFiles = builtins.attrNames (builtins.readDir (./. + "/${name}/include"));
  defaultConfig = {
    inherit name;
    documents = {
      "statement.zh.pdf" = {
        path = hull.xcpcStatement config {
          statement = ./. + "/${name}/document/statement/zh.typ";
          displayLanguage = "zh";
        };
        displayLanguage = "zh";
        participantVisibility = true;
      };
    };
    includes = [
      cplib
      (./. + "/${name}/include")
    ];

    targets.default = hull.problemTarget.legacy.hydro.batch {
      statements.zh = "statement.zh.pdf";
      testDataExtraFiles = builtins.listToAttrs (
        map (file: {
          name = file;
          value = (./. + "/${name}/include/${file}");
        }) includeDirFiles
      );
      judgeExtraFiles = includeDirFiles;
    };
  };
in
(import <nixpkgs> { }).pkgs.lib.recursiveUpdate defaultConfig (problemFun args)
