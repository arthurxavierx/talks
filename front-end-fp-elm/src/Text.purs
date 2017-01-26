module App.Text where

data Language
  = EN
  | PT

type Translation = Language -> String

title :: Translation
title EN = "Functional programming with"
title PT = "Programação funcional com"

subtitle :: Translation
subtitle EN = "Why is it important"
subtitle PT = "Por que isto é importante"

whatIsFP :: Translation
whatIsFP EN = "What is functional programming"
whatIsFP PT = "O que é programação funcional"

programmingWithFunctions :: Translation
programmingWithFunctions EN = "Programming with functions"
programmingWithFunctions PT = "Programar com funções"

programmingWithValues :: Translation
programmingWithValues EN = "Programming with values"
programmingWithValues PT = "Programar com valores"

functionsAreValues :: Translation
functionsAreValues EN = "Functions are values"
functionsAreValues PT = "Funções são valores"

immutability :: Translation
immutability EN = "Immutability"
immutability PT = "Imutabilidade"

purity :: Translation
purity EN = "Purity"
purity PT = "Pureza"

composition :: Translation
composition EN = "Composition"
composition PT = "Composição"

higherOrderFunctions :: Translation
higherOrderFunctions EN = "Higher order functions"
higherOrderFunctions PT = "Funções de alta ordem"

containmentOfEffects :: Translation
containmentOfEffects EN = "Minimizing and containing effects"
containmentOfEffects PT = "Minimização e contenção de efeitos"

predictability :: Translation
predictability EN = "Predictability"
predictability PT = "Previsibilidade"

testability :: Translation
testability EN = "Testability"
testability PT = "Testabilidade"

easyToReasonAbout :: Translation
easyToReasonAbout EN = "Easy to reason about"
easyToReasonAbout PT = "Facilidade de raciocínio"

aGoodTypeSystem :: Translation
aGoodTypeSystem EN = "A good type system can help"
aGoodTypeSystem PT = "Um bom sistema de tipos pode ajudar"

notLikeJavas :: Translation
notLikeJavas EN = "No, not like Java's"
notLikeJavas PT = "Não como o do Java"

andTheCompiler :: Translation
andTheCompiler EN = "The compiler is your best friend"
andTheCompiler PT = "O compilador é o seu melhor amigo"
