# 15May2025

# Task list
1. Fix all errors and warnings, so that the app can be started without crash.
2. The circular bar does not show any actual progress. Can you fix it using existing solution?
- By applying pre-written CircularTimer
3. What would you improve? Why? Do you see any problems with the logic? Which?
- Area of improvement: 
  - App folder structure
  - Standardise naming conventions, variable formatting
  - Architecture - DI for testability
  - Utilise stringsdict for plural language handling

- Logic problem:
  - Several missing calculations like math operators, min functions for progress timer to work
  - Direct usage of hexadecimal format for creating CGColor 
  - Deprecated usage of .animation API