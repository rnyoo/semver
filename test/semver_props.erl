%% -----------------------------------------------------------------------------
%% Copyright (c) 2002-2011 Tim Watson (watson.timothy@gmail.com)
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.
%%
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%% THE SOFTWARE.
%% -----------------------------------------------------------------------------
-module(semver_props).
-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-include_lib("hamcrest/include/hamcrest.hrl").
-include("semver.hrl").

-compile(export_all).

%%
%% Properties
%%

prop_all_valid_parse_strings() ->
    ?FORALL({Maj, Min, Build}, {integer(), integer(), integer()},
        ?IMPLIES(Maj > 0 andalso Min > 0 andalso Build > 0,
        ?assertThat(
            semver:parse(semver:vsn_string(semver:version(Maj, Min, Build))),
                is(equal_to(semver:version(Maj, Min, Build)))))).

prop_any_patch_is_allowed() ->
    ?FORALL(Patch, alphanum(), 
        ?IMPLIES(length(Patch) > 1,
        ?assertThat(semver:parse("0.0.0-" ++ Patch),
            is(equal_to(#semver{patch="-" ++ Patch}))))).

matches_patch(Patch) ->
    fun(V) ->
        V#semver.patch == Patch
    end.

alphanum() ->
    %% NB: make sure xmerl (which we're using in the matchers)
    %% doesn't fall on it's backside complaining about encodings and so on
    %% TODO: this is far too conservative, so we'll need to broaden it later
    union([non_empty(list(integer(97, 122))), 
           non_empty(list(integer(48, 57)))]).