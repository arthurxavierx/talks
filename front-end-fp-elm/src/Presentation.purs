module App.Presentation
  ( view
  ) where

import App.Text as Text
import App.Colors (accent, black, primary, quartenary, secondary, tertiary, white)
import App.Elements (appearingItem, appearingItemMedium, appearingItemSmall, bold, codePane, codePaneSmall, color, contentSlide, heading, light, link, list, regular, resource, sectionTitleSlide, subtitle, title)
import App.Text (Language)
import Data.String (toLower)
import Data.Time.Duration (Milliseconds(..))
import Data.Tuple.Nested ((/\))
import Prelude (Unit, (<>))
import Pux.Html (Html, (!), (#), (##), (#>))
import Pux.Html (img, p, pre, span) as H
import Pux.Html.Attributes (className, size, src, style) as A
import Spectacle (appear, deck, listItem, spectacle) as H
import Spectacle.Attributes (Progress(Bar), Transition(Slide), bgColor, href, lang, margin, progress, textAlign, theme, transition, transitionDuration) as A
import Spectacle.CodeSlide (codeSlide)
import Spectacle.CodeSlide.Attributes (Loc(..), Range(..), RangeOption(..), code, ranges)

foreign import counterExampleSrc :: String

js :: String
js = "javascript"

elm :: String
elm = "elm"

view :: Language -> Html Unit
view lang =
  H.spectacle
    ! theme
    # H.deck
      ! A.progress A.Bar
      ! A.transition [ A.Slide, A.Slide ]
      ! A.transitionDuration (Milliseconds 500.0)
      ## slides lang
  where
    theme = A.theme
      { colors: { primary, secondary, tertiary, quartenary }
      , fonts:
        { primary: "Yantramanav, Roboto, Helvetica Neue, sans-serif"
        , secondary: "Yantramanav, Roboto, Helvetica Neue, sans-serif"
        , tertiary: "monospace"
        }
      }

slides :: Language -> Array (Html Unit)
slides lang =
  [ contentSlide ##
    [ heading
      ! A.size 1
      ##
      [ H.span ! A.style [ color tertiary ] #> (Text.title lang) <> " "
      , H.span ! A.style [ bold, color primary ] #> "Elm"
      ]
    , title ! A.style [ regular, color secondary ] #> toLower (Text.subtitle lang) <> "?"
    , H.p
      ! A.margin "4.0rem 0"
      # link
        ! A.href "http://arthur-xavier.github.io/talks/front-end-fp-elm"
        #> "arthur-xavier.github.io/talks/front-end-fp-elm"
    ]

  , contentSlide ##
    [ title #> (Text.whatIsFP lang) <> "?"
    , list ##
      [ H.appear
        # H.listItem
          ! A.style [ "textDecoration" /\ "line-through" ]
          # H.span
            ! A.className "strike"
            #> (Text.programmingWithFunctions lang) <> "?"
      , H.appear # H.listItem #> (Text.programmingWithValues lang)
      , H.appear # H.listItem #> (Text.functionsAreValues lang)
      ]
    ]

  , contentSlide ##
    [ list ##
      [ appearingItem primary #> "Estilo declarativo"
      , appearingItem tertiary #> "Expressões"
      , appearingItem accent #> "Familiar"
      , appearingItemSmall secondary
        ! A.style [ color secondary, bold, "marginTop" /\ "-1.0rem" ]
        #> "map, reduce, closures, Promise"
      ]
    ]

  -- IMMUTABILITY
  , sectionTitleSlide secondary (Text.immutability lang)

  , contentSlide ##
    [ codePane js """
// Bad
let maxArray = array[0];
for (let x in array) {
  maxArray = Math.max(x, maxArray);
}

// Good
const max = (a, b) => Math.max(a, b);
const maxArray = array.reduce(max, array[0]);
      """
    ]

  , contentSlide ##
    [ codePane js """
// Bad
let users = [ 'Ana', 'Marcos', 'José' ];

function modifyAt(array, x, n) {
  array[n] = x;
};

modifyAt(users, 2, 'João');

users;
// => [ 'Ana', 'Marcos', 'João' ]
      """
    ]

  , contentSlide ##
    [ codePaneSmall js """
// Good
const users = [ 'Ana', 'Marcos', 'José' ];

function modifyAt(array, x, n) {
  return [ ... array.slice(0, n), x, ...array.slice(n + 1) ];
};

const newUsers = modifyAt(users, 2, 'João');

newUsers;
// => [ 'Ana', 'Marcos', 'João' ]

users;
// => [ 'Ana', 'Marcos', 'José' ];
      """
    ]

  , contentSlide
    ! A.style [ color tertiary ]
    ##
    [ title #> "Não itere, use "
    , H.pre #> "map, reduce, filter, etc..."
    ]

  -- HIGHER ORDER FUNCTIONS
  , sectionTitleSlide accent (Text.higherOrderFunctions lang)

  , contentSlide ##
    [ codePane js """
function makeAdjectifier(adjective) {
  return function(string) {
    return `${adjective} ${string}`;
  };
}

var coolifier = makeAdjectifier("cool");
coolifier("meetup");
// => "cool meetup"
      """
    ]

  , contentSlide ##
    [ codePane js """
const makeAdjectifier =
  adjective => string => `${adjective} ${string}`;

const coolifier = makeAdjectifier("cool");
coolifier("meetup");
// => "cool meetup"
      """
    ]

  -- PURITY
  , sectionTitleSlide primary (Text.purity lang)

  , contentSlide ##
    [ codePane js """
// Bad
function append(x) {
  this.array.push(x);
}

// Good
function append(array, x) {
  return [ ...array, x ];
}
      """
    ]

  , contentSlide ##
    [ codePane js """
// Bad
function sumOfSquares(array) {
  let result = 0;

  for (let x in array) {
    result += x*x;
  }

  console.log(result);
};
      """
    ]

  , contentSlide ##
    [ codePane js """
// Good
const square = x => x*x;
const add = (a, b) => a + b;

function sumOfSquares(array) {
  return array
    .map(square)
    .reduce(add, 0);
}

console.log(sumOfSquares([2, 3, 5]));
      """
    ]

  -- COMPOSITION
  , sectionTitleSlide tertiary (Text.composition lang)

  , contentSlide ##
    [ list ##
      [ appearingItem tertiary
        ! A.style [ color tertiary, regular ]
        #> "view : State → Html"
      , appearingItemSmall secondary
        ! A.style [ color secondary, light ]
        #> "A visualização de uma aplicação web front end é o mapeamento de um espaço de estados para um espaço de elementos HTML."
      , appearingItemSmall secondary
        ! A.style [ color secondary, light ]
        ##
        let
          tn = H.span ! A.style [ color primary, regular ]
        in
          [ tn #> "React"
          , H.span #> " e "
          , tn #> "Elm"
          , H.span #> " fazem assim"
          ]
      ]
    ]

  , contentSlide ##
    [ list ##
      [ appearingItem primary #> Text.predictability lang
      , appearingItem tertiary #> Text.testability lang
      , appearingItem accent #> Text.easyToReasonAbout lang
      ]
    ]

  , contentSlide ##
    [ list ##
      [ appearingItemMedium tertiary #> Text.aGoodTypeSystem lang
      , appearingItemSmall secondary #> ("(" <> Text.notLikeJavas lang <> ")")
      , appearingItemMedium primary #> Text.andTheCompiler lang
      ]
    ]

  -- ELM
  , sectionTitleSlide primary "Elm"

  , contentSlide ##
    [ list ##
      [ appearingItem primary #> "Pura"
      , appearingItem tertiary #> "Compila para JS"
      , appearingItem accent #> "Rápida"
      , appearingItem secondary #> "Estaticamente tipada"
      ]
    ]

  , sectionTitleSlide tertiary "Tipos de dados são conjuntos"

  , contentSlide ##
    [ codePane elm """
type alias Age = Int

type Colors = Black | White | Red | Green | Blue
      """
    ]

  , codeSlide
    ! A.bgColor white
    ! A.style [ "fontSize" /\ "1rem" ]
    ! A.transition []
    ! A.lang elm
    ! code counterExampleSrc
    ! ranges
      [ Range (Loc 0 27) []
      , Range (Loc 12 12) [ Note "Renomeação de tipos" ]
      , Range (Loc 14 14) [ Note "Tipos de dados são conjuntos de valores" ]
      , Range (Loc 16 17) []
      , Range (Loc 19 26) [ Note "Pattern Matching" ]
      , Range (Loc 28 34) [ Note "Em Elm o HTML são funções" ]
      , Range (Loc 4 9) [ Note "Elm architecture" ]
      ]
    ## []

  , contentSlide ##
    [ list ##
      [ appearingItemMedium secondary
        ##
        [ H.span ! A.style [ bold ] #> "null"
        , H.span #> " é ruim"
        ]
      , appearingItemMedium secondary
        ##
        [ H.span #> "Por isso "
        , H.span ! A.style [ color primary, bold ] #> "Elm"
        , H.span #> " tem o tipo "
        , H.span ! A.style [ color accent, bold ] #> "Maybe"
        ]
      ]
    ]

  , contentSlide ##
    [ codePane elm """
type Maybe a = Nothing | Just a
      """
    ]

  , contentSlide ##
    [ codePane elm """
type alias Person =
  { name : String
  , age : Maybe Int
  }

mary : Person
mary =
  { name = "Mary"
  , age = Just 31
  }

john : Person
john =
  { name = "John"
  , age = Nothing
  }
      """
    ]

  , contentSlide ##
    [ codePane elm """
oldest : Person -> Person -> Maybe Person
oldest p1 p2 =
  case (p1.age, p2.age) of
    (Just age1, Just age2) ->
      Just (if age1 >= age2 then p1 else p2)

    _ ->
      Nothing
      """
    ]

  , contentSlide ##
    [ codePane elm """
toValidMonth : Int -> Maybe Int
toValidMonth month =
  if month >= 1 && month <= 12 then
      Just month
  else
      Nothing

getFirstMonth : List Int -> Maybe Int
getFirstMonth months =
  head months
    |> andThen toValidMonth
      """
    ]

  , sectionTitleSlide secondary "Parece confuso?"

  , sectionTitleSlide secondary (Text.andTheCompiler lang)

  , contentSlide
    ! A.bgColor black
    ##
    [ H.img
      ! A.src "http://elm-lang.org/assets/blog/error-messages/0.16/expected-arg.png"
      ## []
    ]

  , contentSlide
    ! A.bgColor black
    ##
    [ H.img
      ! A.src "https://cdn-images-1.medium.com/max/800/1*PnXjacg1e5nIQ3v9eO4-MQ.png"
      ## []
    ]

  , contentSlide
    ! A.bgColor "#242022"
    ##
    [ H.img
      ! A.src "http://ajhager.com/elm_compiler_errors_and_vim/elm-make-new-errors.png"
      ## []
    ]

  , sectionTitleSlide tertiary "Tipos algébricos tornam impossível representar estados impossíveis"

  , contentSlide ##
    [ codePane elm """
// Bad
type alias Destination =
  { country : Maybe Country
  , city : Maybe City
  }

// Good
type Destination
  = NotChosen
  | ToCountry Country
  | ToCity Country City
      """
    ]

  , contentSlide ##
    [ codePane elm """
// Bad
type alias QuestionsAndAnswers =
  { questions : List String
  , answers : List (Maybe String)
  }

// Good
type alias Question =
  { question : String
  , answer : Maybe String
  }

type alias QuestionsAndAnswers = List Question
      """
    ]

  , sectionTitleSlide accent "Separação de efeitos colaterais"

  , contentSlide ##
    [ codePane elm """
type alias Model =
  { dieFace : Int
  }

type Msg
  = Roll
  | NewFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))

    NewFace newFace ->
      (Model newFace, Cmd.none)
      """
    ]

  , sectionTitleSlide primary "Recursos"

  , contentSlide ##
      [ title #> "Programação funcional"
      , list
        ##
        [ resource "Learn You a Haskell for Great Good!" "http://learnyouahaskell.com/"
        , resource "Ramda — A practical functional library for JavaScript programmers" "http://ramdajs.com/"
        ]
      ]

  , contentSlide ##
      [ title #> "Elm"
      , list ##
        [ resource "Learn you an Elm" "https://learnyouanelm.github.io/"
        , resource "Elm documentation" "http://elm-lang.org/docs"
        , resource "Making Impossible States Impossible" "https://www.youtube.com/watch?v=IcgmSRJHu_8"
        ]
      ]

  , contentSlide ##
      [ subtitle #> "Arthur Xavier"
      , list ##
        [ H.listItem
          ! A.textAlign "center"
          ##
          [ H.span #> "Twitter: "
          , link
            ! A.href "https://twitter.com/arthurxavierx"
            #> "@arthurxavierx"
          ]
        , H.listItem
          ! A.textAlign "center"
          ##
          [ H.span #> "Github: "
          , link
            ! A.href "https://github.com/arthur-xavier"
            #> "@arthur-xavier"
          ]
        ]
      ]

  ]
