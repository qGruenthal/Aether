module Parser exposing (..)
import Json.Decode exposing (..)

import Tests exposing (..)

type alias JSONTest =
    { name : String
    , passed : Bool
    , value : Int
    }

testDecoder : Decoder JSONTest
testDecoder =
    map3 JSONTest
        (field "name" string)
        (field "passed" bool)
        (field "value" int)

decodeTests : Value -> List Test
decodeTests v =
    case decodeValue (list testDecoder) v of
        Ok jts ->
            List.map parseTest jts
        _ ->
            [Test "Error" Fail 0]

parseTest : JSONTest -> Test
parseTest jt =
    let
        r = if jt.passed then Pass else Fail
    in
    Test jt.name r jt.value
