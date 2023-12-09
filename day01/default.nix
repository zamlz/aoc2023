# --- Day 1: Trebuchet?! ---
# 
# Something is wrong with global snow production, and you've been selected to
# take a look. The Elves have even given you a map; on it, they've used stars to
# mark the top fifty locations that are likely to be having problems.
# 
# You've been doing this long enough to know that to restore snow operations, you
# need to check all fifty stars by December 25th.
# 
# Collect stars by solving puzzles. Two puzzles will be made available on each
# day in the Advent calendar; the second puzzle is unlocked when you complete the
# first. Each puzzle grants one star. Good luck!
# 
# You try to ask why they can't just use a weather machine ("not powerful
# enough") and where they're even sending you ("the sky") and why your map looks
# mostly blank ("you sure ask a lot of questions") and hang on did you just say
# the sky ("of course, where do you think snow comes from") when you realize that
# the Elves are already loading you into a trebuchet ("please hold still, we need
# to strap you in").
# 
# As they're making the final adjustments, they discover that their calibration
# document (your puzzle input) has been amended by a very young Elf who was
# apparently just excited to show off her art skills. Consequently, the Elves are
# having trouble reading the values on the document.
# 
# The newly-improved calibration document consists of lines of text; each line
# originally contained a specific calibration value that the Elves now need to
# recover. On each line, the calibration value can be found by combining the
# first digit and the last digit (in that order) to form a single two-digit
# number.
# 
# For example:
# 
#     1abc2
#     pqr3stu8vwx
#     a1b2c3d4e5f
#     treb7uchet
# 
# In this example, the calibration values of these four lines are 12, 38, 15, and
# 77. Adding these together produces 142.
# 
# Consider your entire calibration document. What is the sum of all of the
# calibration values?
#
# My answers: { outputPart1 = 57346; outputPart2 = 57345; }

with (import <nixpkgs> {});
let
  fileSplitLines = fileContents: # fileContents: Str -> fileSplitContents: List[Str]
    lib.splitString "\n" fileContents;
  
  convertStringDigits = text: # text: Str -> text: Str
    lib.foldl
      (acc: replacement:
        builtins.replaceStrings [(lib.head replacement)] [(lib.last replacement)]
        acc)
      text [
        ["zero" "z0o"]
        ["one" "o1e"]
        ["two" "t2o"]
        ["three" "t3e"]
        ["four" "f4r"]
        ["five" "f5e"]
        ["six" "s6x"]
        ["seven" "s7n"]
        ["eight" "e8t"]
        ["nine" "n9e"]
      ];
  
  parseDigit = line: # line: String -> digitList: List[Str]
    lib.filter (c: c >= "0" && c <= "9") (lib.splitString "" line);
  
  parseCalValue = digitList: # digitList: List[Str] -> calValue: String
    if lib.length digitList > 0 then
      lib.head digitList + lib.last digitList
    else
      "0";
  
  sumCalValuesList = calValuesList: # calValuesList: List[Str] -> Int
    lib.foldl (acc: x: acc + x) 0 (map lib.toInt calValuesList);
  
  computeSumCalValue = fileSplitContents: # fileSplitContents: List[Str] -> Int
    (sumCalValuesList (map parseCalValue (map parseDigit fileSplitContents)));
  
  part1ReadFile = file: # file: Path -> fileSplitContents: List[Str]
    fileSplitLines (lib.fileContents file);

  part2ReadFile = file: # file: Path -> fileSplitContents: List[Str]
    fileSplitLines (convertStringDigits (lib.fileContents file));

in {
  outputPart1 = computeSumCalValue (part1ReadFile ./input);
  outputPart2 = computeSumCalValue (part2ReadFile ./input);
}
