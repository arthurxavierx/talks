import Html exposing (Html, beginnerProgram, div, button, text)
import Html.Events exposing (onClick)

main =
  beginnerProgram
    { model = init
    , view = view
    , update = update
    }

--
type alias Model = Int

type Msg = Increment | Decrement

init : Model
init = 0

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
