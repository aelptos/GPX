#!/bin/sh

if [[ $OTHER_SWIFT_FLAGS == *"-D ED_SKIP_SWIFT_FORMAT"* ]]; then
  exit 0;
fi

BuildTools/SwiftFormat/swiftformat "$PROJECT_DIR" --swiftversion 5 --rules indent,linebreaks,trailingSpace,consecutiveBlankLines,blankLinesAtEndOfScope,blankLinesAtStartOfScope,blankLinesBetweenScopes,consecutiveSpaces,duplicateImports,elseOnSameLine,emptyBraces,redundantBreak,redundantInit,redundantLetError,redundantNilInit,redundantType,redundantVoidReturnType,spaceAroundBraces,spaceAroundBrackets,spaceAroundComments,spaceAroundGenerics,spaceAroundOperators,spaceAroundParens,spaceInsideBraces,spaceInsideBrackets,spaceInsideGenerics,spaceInsideParens,void --quiet
