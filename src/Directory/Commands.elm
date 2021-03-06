module Commands exposing (CommunitiesRequestData, getCommunities, newPage)

{-| Contains Commands & Relevant Types Used in the Application.
-}

import Http
import Json.Decode as Decode
import Navigation
import Communities exposing (Community)
import Decoders
import Pagination
import Ports
import Routing exposing (Route, FilterParam(..), Ordering(..), reverse)


{-| The Data Type Stored by the Pagination & Passed to the Fetch Command.
-}
type alias CommunitiesRequestData =
    { filters : List FilterParam
    , ordering : Maybe Ordering
    }


{-| Fetch A Page of Communities Using The Set Filters & Ordering.
-}
getCommunities : CommunitiesRequestData -> Int -> Http.Request (Pagination.FetchResponse Community)
getCommunities { filters, ordering } page =
    let
        filterQueryString =
            if not (List.isEmpty filters) then
                "&" ++ String.join "&" (List.map filterToApiQuery filters)
            else
                ""

        orderQueryString =
            if not (String.isEmpty <| orderingToApiQuery ordering) then
                "&" ++ orderingToApiQuery ordering
            else
                ""
    in
        Decode.map2 Pagination.FetchResponse
            (Decode.field "listings" (Decode.list Decoders.community))
            (Decode.field "totalCount" Decode.int)
            |> Http.get
                (String.join ""
                    [ "/wp-json/v1/directory/entries/"
                    , "?page="
                    , toString page
                    , filterQueryString
                    , orderQueryString
                    ]
                )


{-| Return the Commands Relevant For Switching to a New `Route`:

  - Change the URL
  - Scroll to the #main Element
  - Set the Page Title

-}
newPage : Route -> Cmd msg
newPage newRoute =
    Cmd.batch
        [ Navigation.newUrl <| reverse newRoute
        , Ports.scrollTo "main"
        , Ports.setPageTitle <| Routing.getPageTitle newRoute
        ]


{-| Return the Backend API QueryString for a `FilterParam`.
-}
filterToApiQuery : FilterParam -> String
filterToApiQuery filter =
    case filter of
        VisitorsFilter ->
            "visitors[]=Yes"

        MembersFilter ->
            "members[]=Yes"

        EstablishedFilter ->
            "status[]=Established"

        FormingFilter ->
            "status[]=Forming,Re-forming"

        FICMemberFilter ->
            "membership[]=Yes"

        CommunesFilter ->
            "type[]=Commune"

        EcovillagesFilter ->
            "type[]=Ecovillage"

        CohousingFilter ->
            "type[]=Cohousing"

        CoopFilter ->
            "description[]=coop"

        ReligiousFilter ->
            "type[]=Spiritual"

        JewishFilter ->
            "spiritual[]=Jewish"

        ChristianFilter ->
            "spiritual[]=Christian"

        CountryFilter str ->
            "country=" ++ str

        StateFilter str ->
            "state=" ++ str

        ProvinceFilter str ->
            "province=" ++ str

        SearchFilter str ->
            "search=" ++ str


{-| Return the Backend API QueryString for a `Ordering` Parameter.
-}
orderingToApiQuery : Maybe Ordering -> String
orderingToApiQuery =
    let
        orderingToQuery ordering =
            case ordering of
                UpdatedDate ->
                    "order=updated"

                CreatedDate ->
                    "order=created"
    in
        Maybe.map orderingToQuery >> Maybe.withDefault ""
