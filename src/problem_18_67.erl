%% https://projecteuler.net/index.php?section=problems&id=18
%% https://projecteuler.net/problem=67
-module(problem_18_67).
-export([max_sum_path/1]).
-export([triangle/0, triangle_small/0, triangle_biased/0, triangle_from_file/1]).

-import(erlang, [append_element/2]).

max_sum_path(Triangle) ->
    [{{MaxSum}, _} | _] = Results = do_max_sum_path(lists:reverse(Triangle), []),
    Path = path(Results, 1),
    io:format("Max Path Sum: ~p, indices path: ~p~n", [MaxSum, Path]),
    {MaxSum, Path}.

do_max_sum_path([], Acc) ->
    Acc;
do_max_sum_path([ChildRow, Row | T], [] = Acc) ->
    do_max_sum_path(T, [row_maxs(Row, ChildRow) | Acc]);
do_max_sum_path([Row | T], [{PrevRowSums, _PrevNs} | _] = Acc) ->
    do_max_sum_path(T, [row_maxs(Row, PrevRowSums) | Acc]).

row_maxs(Row, ChildRow) ->
    do_row_maxs(Row, ChildRow, 1, {{}, {}}).

do_row_maxs(Row, _ChildRow, Seq, Acc) when Seq>tuple_size(Row) ->
    Acc;
do_row_maxs(Row, ChildRow, Seq, {MaxSums, Ns}) ->
    {MaxChild, ChildN} = max_child(Seq, ChildRow),
    Max = element(Seq, Row) + MaxChild,
    do_row_maxs(Row, ChildRow, Seq+1,
                {append_element(MaxSums, Max), append_element(Ns, ChildN)}).

max_child(N, ChildRow) ->
    Left = element(N, ChildRow),
    Right = element(N+1, ChildRow),
    if Left>Right ->
            {Left, N};
       true  ->
            {Right, N+1}
    end.

path([], N) ->
    [N];
path([{_, NextNs} | T], N) ->
    [N | path(T, element(N, NextNs))].

%% test data functions

triangle_from_file(FilePath) ->
    {ok, Content} = file:read_file(FilePath),
    Rows = binary:split(Content, <<"\n">>, [global, trim]),
    [begin
         ParsedR = binary:split(R, <<" ">>, [global, trim]),
         list_to_tuple([binary_to_integer(IntB) || IntB <- ParsedR])
     end
     || R <- Rows].

triangle() -> [
                              {75},
                            {95, 64},
                          {17, 47, 82},
                        {18, 35, 87, 10},
                      {20, 04, 82, 47, 65},
                    {19, 01, 23, 75, 03, 34},
                  {88, 02, 77, 73, 07, 63, 67},
                {99, 65, 04, 28, 06, 16, 70, 92},
              {41, 41, 26, 56, 83, 40, 80, 70, 33},
            {41, 48, 72, 33, 47, 32, 37, 16, 94, 29},
          {53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14},
        {70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57},
      {91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48},
    {63, 66, 04, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31},
  {04, 62, 98, 27, 23, 09, 70, 98, 73, 93, 38, 53, 60, 04, 23}
].

triangle_small() -> [
                              {75},
                            {95, 64},
                          {17, 47, 82},
                        {18, 35, 87, 10},
                      {20, 04, 82, 47, 65},
                    {19, 01, 23, 75, 03, 34}
              ].


triangle_biased() -> [
                              {1},
                            {1, 64},
                          {1, 47, 82},
                        {1, 35, 87, 10},
                      {1, 04, 82, 47, 65},
                    {1000, 01, 23, 75, 03, 34}
              ].
