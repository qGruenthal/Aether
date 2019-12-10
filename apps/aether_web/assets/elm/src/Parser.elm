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

type alias JSONResults =
    { tests: List JSONTest
    }

resultsDecoder : Decoder JSONResults
resultsDecoder =
    map JSONResults
        (field "tests" (list testDecoder))

parseResults : JSONResults -> List JSONTest
parseResults jr =
    jr.tests

type alias JSONGrade =
    { name : String
    , earned : Int
    , possible : Int
    }

gradeDecoder : Decoder JSONGrade
gradeDecoder =
    map3 JSONGrade
        (field "name" string)
        (field "earned" int)
        (field "possible" int)

decodeGrades : Value -> List Grade
decodeGrades v =
    case decodeValue (list gradeDecoder) v of
        Ok jgs ->
            List.map parseGrade jgs
        _ ->
            [Grade "Error" 0 0]    

parseGrade : JSONGrade -> Grade
parseGrade jg =
    Grade jg.name jg.earned jg.possible

type alias JSONAssignments =
    { grades: List JSONGrade
    }

assignmentsDecoder : Decoder JSONAssignments
assignmentsDecoder =
    map JSONAssignments
        (field "grades" (list gradeDecoder))

parseAssignments : JSONAssignments -> List JSONGrade
parseAssignments ja =
    ja.grades
