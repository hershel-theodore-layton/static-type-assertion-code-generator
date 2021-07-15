/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during benchmarking, run `hhvm benchmark/2-codegen.hack` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

function assert_json_shape(mixed $htl_static_type_assertion_codegen_seed_expression): JsonShape {
  return () ==> { $partial__0 = $htl_static_type_assertion_codegen_seed_expression as shape('search_metadata' => shape('completed_in' => float, 'count' => int, 'max_id' => int, 'max_id_str' => string, 'next_results' => string, 'query' => string, 'refresh_url' => string, 'since_id' => int, 'since_id_str' => string), 'statuses' => mixed); $partial__0['statuses'] = () ==> { $out__1 = vec[]; foreach (($partial__0['statuses'] as vec<_>) as $v__2) { $out__1[] = () ==> { $partial__3 = $v__2 as shape('contributors' => null, 'coordinates' => null, 'created_at' => string, 'entities' => mixed, 'favorite_count' => int, 'favorited' => bool, 'geo' => null, 'id' => int, 'id_str' => string, 'in_reply_to_screen_name' => ?string, 'in_reply_to_status_id' => ?int, 'in_reply_to_status_id_str' => ?string, 'in_reply_to_user_id' => ?int, 'in_reply_to_user_id_str' => ?string, 'lang' => string, 'metadata' => shape('iso_language_code' => string, 'result_type' => string), 'place' => null, ?'possibly_sensitive' => bool, 'retweet_count' => int, 'retweeted' => bool, ?'retweeted_status' => mixed, 'source' => string, 'text' => string, 'truncated' => bool, 'user' => mixed); $partial__3['entities'] = () ==> { $partial__4 = $partial__3['entities'] as shape('hashtags' => mixed, ?'media' => mixed, 'symbols' => mixed, 'urls' => mixed, 'user_mentions' => mixed); $partial__4['hashtags'] = () ==> { $out__5 = vec[]; foreach (($partial__4['hashtags'] as vec<_>) as $v__6) { $out__5[] = () ==> { $partial__7 = $v__6 as shape('indices' => mixed, 'text' => string); $partial__7['indices'] = () ==> { $out__8 = vec[]; foreach (($partial__7['indices'] as vec<_>) as $v__9) { $out__8[] = $v__9 as int; } return $out__8; }(); return $partial__7; }(); } return $out__5; }(); if (Shapes::keyExists($partial__4, 'media')) { $partial__4['media'] = () ==> { $out__10 = vec[]; foreach (($partial__4['media'] as vec<_>) as $v__11) { $out__10[] = () ==> { $partial__12 = $v__11 as shape('display_url' => string, 'expanded_url' => string, 'id' => int, 'id_str' => string, 'indices' => mixed, 'media_url' => string, 'media_url_https' => string, 'sizes' => shape('large' => shape('h' => int, 'resize' => string, 'w' => int), 'medium' => shape('h' => int, 'resize' => string, 'w' => int), 'small' => shape('h' => int, 'resize' => string, 'w' => int), 'thumb' => shape('h' => int, 'resize' => string, 'w' => int)), ?'source_status_id' => int, ?'source_status_id_str' => string, 'type' => string, 'url' => string); $partial__12['indices'] = () ==> { $out__13 = vec[]; foreach (($partial__12['indices'] as vec<_>) as $v__14) { $out__13[] = $v__14 as int; } return $out__13; }(); return $partial__12; }(); } return $out__10; }(); } else { Shapes::removeKey(inout $partial__4, 'media'); } $partial__4['symbols'] = () ==> { $out__15 = vec[]; foreach (($partial__4['symbols'] as vec<_>) as $v__16) { $out__15[] = $v__16 as null; } return $out__15; }(); $partial__4['urls'] = () ==> { $out__17 = vec[]; foreach (($partial__4['urls'] as vec<_>) as $v__18) { $out__17[] = () ==> { $partial__19 = $v__18 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__19['indices'] = () ==> { $out__20 = vec[]; foreach (($partial__19['indices'] as vec<_>) as $v__21) { $out__20[] = $v__21 as int; } return $out__20; }(); return $partial__19; }(); } return $out__17; }(); $partial__4['user_mentions'] = () ==> { $out__22 = vec[]; foreach (($partial__4['user_mentions'] as vec<_>) as $v__23) { $out__22[] = () ==> { $partial__24 = $v__23 as shape('id' => int, 'id_str' => string, 'indices' => mixed, 'name' => string, 'screen_name' => string); $partial__24['indices'] = () ==> { $out__25 = vec[]; foreach (($partial__24['indices'] as vec<_>) as $v__26) { $out__25[] = $v__26 as int; } return $out__25; }(); return $partial__24; }(); } return $out__22; }(); return $partial__4; }(); if (Shapes::keyExists($partial__3, 'retweeted_status')) { $partial__3['retweeted_status'] = () ==> { $partial__27 = $partial__3['retweeted_status'] as shape('contributors' => null, 'coordinates' => null, 'created_at' => string, 'entities' => mixed, 'favorite_count' => int, 'favorited' => bool, 'geo' => null, 'id' => int, 'id_str' => string, 'in_reply_to_screen_name' => ?string, 'in_reply_to_status_id' => ?int, 'in_reply_to_status_id_str' => ?string, 'in_reply_to_user_id' => ?int, 'in_reply_to_user_id_str' => ?string, 'lang' => string, 'metadata' => shape('iso_language_code' => string, 'result_type' => string), 'place' => null, ?'possibly_sensitive' => bool, 'retweet_count' => int, 'retweeted' => bool, 'source' => string, 'text' => string, 'truncated' => bool, 'user' => mixed); $partial__27['entities'] = () ==> { $partial__28 = $partial__27['entities'] as shape('hashtags' => mixed, ?'media' => mixed, 'symbols' => mixed, 'urls' => mixed, 'user_mentions' => mixed); $partial__28['hashtags'] = () ==> { $out__29 = vec[]; foreach (($partial__28['hashtags'] as vec<_>) as $v__30) { $out__29[] = () ==> { $partial__31 = $v__30 as shape('indices' => mixed, 'text' => string); $partial__31['indices'] = () ==> { $out__32 = vec[]; foreach (($partial__31['indices'] as vec<_>) as $v__33) { $out__32[] = $v__33 as int; } return $out__32; }(); return $partial__31; }(); } return $out__29; }(); if (Shapes::keyExists($partial__28, 'media')) { $partial__28['media'] = () ==> { $out__34 = vec[]; foreach (($partial__28['media'] as vec<_>) as $v__35) { $out__34[] = () ==> { $partial__36 = $v__35 as shape('display_url' => string, 'expanded_url' => string, 'id' => int, 'id_str' => string, 'indices' => mixed, 'media_url' => string, 'media_url_https' => string, 'sizes' => shape('large' => shape('h' => int, 'resize' => string, 'w' => int), 'medium' => shape('h' => int, 'resize' => string, 'w' => int), 'small' => shape('h' => int, 'resize' => string, 'w' => int), 'thumb' => shape('h' => int, 'resize' => string, 'w' => int)), ?'source_status_id' => int, ?'source_status_id_str' => string, 'type' => string, 'url' => string); $partial__36['indices'] = () ==> { $out__37 = vec[]; foreach (($partial__36['indices'] as vec<_>) as $v__38) { $out__37[] = $v__38 as int; } return $out__37; }(); return $partial__36; }(); } return $out__34; }(); } else { Shapes::removeKey(inout $partial__28, 'media'); } $partial__28['symbols'] = () ==> { $out__39 = vec[]; foreach (($partial__28['symbols'] as vec<_>) as $v__40) { $out__39[] = $v__40 as null; } return $out__39; }(); $partial__28['urls'] = () ==> { $out__41 = vec[]; foreach (($partial__28['urls'] as vec<_>) as $v__42) { $out__41[] = () ==> { $partial__43 = $v__42 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__43['indices'] = () ==> { $out__44 = vec[]; foreach (($partial__43['indices'] as vec<_>) as $v__45) { $out__44[] = $v__45 as int; } return $out__44; }(); return $partial__43; }(); } return $out__41; }(); $partial__28['user_mentions'] = () ==> { $out__46 = vec[]; foreach (($partial__28['user_mentions'] as vec<_>) as $v__47) { $out__46[] = () ==> { $partial__48 = $v__47 as shape('id' => int, 'id_str' => string, 'indices' => mixed, 'name' => string, 'screen_name' => string); $partial__48['indices'] = () ==> { $out__49 = vec[]; foreach (($partial__48['indices'] as vec<_>) as $v__50) { $out__49[] = $v__50 as int; } return $out__49; }(); return $partial__48; }(); } return $out__46; }(); return $partial__28; }(); $partial__27['user'] = () ==> { $partial__51 = $partial__27['user'] as shape('contributors_enabled' => bool, 'created_at' => string, 'default_profile' => bool, 'default_profile_image' => bool, 'description' => string, 'entities' => mixed, 'favourites_count' => int, 'follow_request_sent' => bool, 'followers_count' => int, 'following' => bool, 'friends_count' => int, 'geo_enabled' => bool, 'id' => int, 'id_str' => string, 'is_translation_enabled' => bool, 'is_translator' => bool, 'lang' => string, 'listed_count' => int, 'location' => string, 'name' => string, 'notifications' => bool, 'profile_background_color' => string, 'profile_background_image_url' => string, 'profile_background_image_url_https' => string, 'profile_background_tile' => bool, ?'profile_banner_url' => string, 'profile_image_url' => string, 'profile_image_url_https' => string, 'profile_link_color' => string, 'profile_sidebar_border_color' => string, 'profile_sidebar_fill_color' => string, 'profile_text_color' => string, 'profile_use_background_image' => bool, 'protected' => bool, 'screen_name' => string, 'statuses_count' => int, 'time_zone' => ?string, 'url' => ?string, 'utc_offset' => ?int, 'verified' => bool); $partial__51['entities'] = () ==> { $partial__52 = $partial__51['entities'] as shape('description' => mixed, ?'url' => mixed); $partial__52['description'] = () ==> { $partial__53 = $partial__52['description'] as shape('urls' => mixed); $partial__53['urls'] = () ==> { $out__54 = vec[]; foreach (($partial__53['urls'] as vec<_>) as $v__55) { $out__54[] = () ==> { $partial__56 = $v__55 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__56['indices'] = () ==> { $out__57 = vec[]; foreach (($partial__56['indices'] as vec<_>) as $v__58) { $out__57[] = $v__58 as int; } return $out__57; }(); return $partial__56; }(); } return $out__54; }(); return $partial__53; }(); if (Shapes::keyExists($partial__52, 'url')) { $partial__52['url'] = () ==> { $partial__59 = $partial__52['url'] as shape('urls' => mixed); $partial__59['urls'] = () ==> { $out__60 = vec[]; foreach (($partial__59['urls'] as vec<_>) as $v__61) { $out__60[] = () ==> { $partial__62 = $v__61 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__62['indices'] = () ==> { $out__63 = vec[]; foreach (($partial__62['indices'] as vec<_>) as $v__64) { $out__63[] = $v__64 as int; } return $out__63; }(); return $partial__62; }(); } return $out__60; }(); return $partial__59; }(); } else { Shapes::removeKey(inout $partial__52, 'url'); } return $partial__52; }(); return $partial__51; }(); return $partial__27; }(); } else { Shapes::removeKey(inout $partial__3, 'retweeted_status'); } $partial__3['user'] = () ==> { $partial__65 = $partial__3['user'] as shape('contributors_enabled' => bool, 'created_at' => string, 'default_profile' => bool, 'default_profile_image' => bool, 'description' => string, 'entities' => mixed, 'favourites_count' => int, 'follow_request_sent' => bool, 'followers_count' => int, 'following' => bool, 'friends_count' => int, 'geo_enabled' => bool, 'id' => int, 'id_str' => string, 'is_translation_enabled' => bool, 'is_translator' => bool, 'lang' => string, 'listed_count' => int, 'location' => string, 'name' => string, 'notifications' => bool, 'profile_background_color' => string, 'profile_background_image_url' => string, 'profile_background_image_url_https' => string, 'profile_background_tile' => bool, ?'profile_banner_url' => string, 'profile_image_url' => string, 'profile_image_url_https' => string, 'profile_link_color' => string, 'profile_sidebar_border_color' => string, 'profile_sidebar_fill_color' => string, 'profile_text_color' => string, 'profile_use_background_image' => bool, 'protected' => bool, 'screen_name' => string, 'statuses_count' => int, 'time_zone' => ?string, 'url' => ?string, 'utc_offset' => ?int, 'verified' => bool); $partial__65['entities'] = () ==> { $partial__66 = $partial__65['entities'] as shape('description' => mixed, ?'url' => mixed); $partial__66['description'] = () ==> { $partial__67 = $partial__66['description'] as shape('urls' => mixed); $partial__67['urls'] = () ==> { $out__68 = vec[]; foreach (($partial__67['urls'] as vec<_>) as $v__69) { $out__68[] = () ==> { $partial__70 = $v__69 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__70['indices'] = () ==> { $out__71 = vec[]; foreach (($partial__70['indices'] as vec<_>) as $v__72) { $out__71[] = $v__72 as int; } return $out__71; }(); return $partial__70; }(); } return $out__68; }(); return $partial__67; }(); if (Shapes::keyExists($partial__66, 'url')) { $partial__66['url'] = () ==> { $partial__73 = $partial__66['url'] as shape('urls' => mixed); $partial__73['urls'] = () ==> { $out__74 = vec[]; foreach (($partial__73['urls'] as vec<_>) as $v__75) { $out__74[] = () ==> { $partial__76 = $v__75 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__76['indices'] = () ==> { $out__77 = vec[]; foreach (($partial__76['indices'] as vec<_>) as $v__78) { $out__77[] = $v__78 as int; } return $out__77; }(); return $partial__76; }(); } return $out__74; }(); return $partial__73; }(); } else { Shapes::removeKey(inout $partial__66, 'url'); } return $partial__66; }(); return $partial__65; }(); return $partial__3; }(); } return $out__1; }(); return $partial__0; }();
}