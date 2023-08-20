/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was @generated during benchmarking, run `hhvm benchmark/2-codegen.hack` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

final abstract class AssertJsonShape {
  public static function assertJsonShape(mixed $htl_untyped_variable): JsonShape {
    $partial__1 = $htl_untyped_variable as shape('search_metadata' => shape('completed_in' => float, 'count' => int, 'max_id' => int, 'max_id_str' => string, 'next_results' => string, 'query' => string, 'refresh_url' => string, 'since_id' => int, 'since_id_str' => string), 'statuses' => mixed); $partial__1['statuses'] = () ==> { $out__2 = vec[]; foreach (($partial__1['statuses'] as vec<_>) as $v__2) { $out__2[] = () ==> { $partial__3 = $v__2 as shape('contributors' => null, 'coordinates' => null, 'created_at' => string, 'entities' => mixed, 'favorite_count' => int, 'favorited' => bool, 'geo' => null, 'id' => int, 'id_str' => string, 'in_reply_to_screen_name' => ?string, 'in_reply_to_status_id' => ?int, 'in_reply_to_status_id_str' => ?string, 'in_reply_to_user_id' => ?int, 'in_reply_to_user_id_str' => ?string, 'lang' => string, 'metadata' => shape('iso_language_code' => string, 'result_type' => string), 'place' => null, ?'possibly_sensitive' => bool, 'retweet_count' => int, 'retweeted' => bool, ?'retweeted_status' => mixed, 'source' => string, 'text' => string, 'truncated' => bool, 'user' => mixed); $partial__3['entities'] = self::assertTEntities($partial__3['entities']); if (Shapes::keyExists($partial__3, 'retweeted_status')) { $partial__3['retweeted_status'] = () ==> { $partial__4 = $partial__3['retweeted_status'] as shape('contributors' => null, 'coordinates' => null, 'created_at' => string, 'entities' => mixed, 'favorite_count' => int, 'favorited' => bool, 'geo' => null, 'id' => int, 'id_str' => string, 'in_reply_to_screen_name' => ?string, 'in_reply_to_status_id' => ?int, 'in_reply_to_status_id_str' => ?string, 'in_reply_to_user_id' => ?int, 'in_reply_to_user_id_str' => ?string, 'lang' => string, 'metadata' => shape('iso_language_code' => string, 'result_type' => string), 'place' => null, ?'possibly_sensitive' => bool, 'retweet_count' => int, 'retweeted' => bool, 'source' => string, 'text' => string, 'truncated' => bool, 'user' => mixed); $partial__4['entities'] = self::assertTEntities($partial__4['entities']); $partial__4['user'] = self::assertTUser($partial__4['user']); return $partial__4; }(); } else { Shapes::removeKey(inout $partial__3, 'retweeted_status'); } $partial__3['user'] = self::assertTUser($partial__3['user']); return $partial__3; }(); } return $out__2; }(); return $partial__1;
  }
  private static function assertTEntities(mixed $htl_untyped_variable): TEntities {
    $partial__1 = $htl_untyped_variable as shape('hashtags' => mixed, ?'media' => mixed, 'symbols' => mixed, 'urls' => mixed, 'user_mentions' => mixed); $partial__1['hashtags'] = () ==> { $out__2 = vec[]; foreach (($partial__1['hashtags'] as vec<_>) as $v__2) { $out__2[] = () ==> { $partial__3 = $v__2 as shape('indices' => mixed, 'text' => string); $partial__3['indices'] = () ==> { $out__4 = vec[]; foreach (($partial__3['indices'] as vec<_>) as $v__4) { $out__4[] = $v__4 as int; } return $out__4; }(); return $partial__3; }(); } return $out__2; }(); if (Shapes::keyExists($partial__1, 'media')) { $partial__1['media'] = () ==> { $out__2 = vec[]; foreach (($partial__1['media'] as vec<_>) as $v__2) { $out__2[] = () ==> { $partial__3 = $v__2 as shape('display_url' => string, 'expanded_url' => string, 'id' => int, 'id_str' => string, 'indices' => mixed, 'media_url' => string, 'media_url_https' => string, 'sizes' => shape('large' => shape('h' => int, 'resize' => string, 'w' => int), 'medium' => shape('h' => int, 'resize' => string, 'w' => int), 'small' => shape('h' => int, 'resize' => string, 'w' => int), 'thumb' => shape('h' => int, 'resize' => string, 'w' => int)), ?'source_status_id' => int, ?'source_status_id_str' => string, 'type' => string, 'url' => string); $partial__3['indices'] = () ==> { $out__4 = vec[]; foreach (($partial__3['indices'] as vec<_>) as $v__4) { $out__4[] = $v__4 as int; } return $out__4; }(); return $partial__3; }(); } return $out__2; }(); } else { Shapes::removeKey(inout $partial__1, 'media'); } $partial__1['symbols'] = () ==> { $out__2 = vec[]; foreach (($partial__1['symbols'] as vec<_>) as $v__2) { $out__2[] = $v__2 as null; } return $out__2; }(); $partial__1['urls'] = () ==> { $out__2 = vec[]; foreach (($partial__1['urls'] as vec<_>) as $v__2) { $out__2[] = () ==> { $partial__3 = $v__2 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__3['indices'] = () ==> { $out__4 = vec[]; foreach (($partial__3['indices'] as vec<_>) as $v__4) { $out__4[] = $v__4 as int; } return $out__4; }(); return $partial__3; }(); } return $out__2; }(); $partial__1['user_mentions'] = () ==> { $out__2 = vec[]; foreach (($partial__1['user_mentions'] as vec<_>) as $v__2) { $out__2[] = () ==> { $partial__3 = $v__2 as shape('id' => int, 'id_str' => string, 'indices' => mixed, 'name' => string, 'screen_name' => string); $partial__3['indices'] = () ==> { $out__4 = vec[]; foreach (($partial__3['indices'] as vec<_>) as $v__4) { $out__4[] = $v__4 as int; } return $out__4; }(); return $partial__3; }(); } return $out__2; }(); return $partial__1;
  }
  private static function assertTUser(mixed $htl_untyped_variable): TUser {
    $partial__1 = $htl_untyped_variable as shape('contributors_enabled' => bool, 'created_at' => string, 'default_profile' => bool, 'default_profile_image' => bool, 'description' => string, 'entities' => mixed, 'favourites_count' => int, 'follow_request_sent' => bool, 'followers_count' => int, 'following' => bool, 'friends_count' => int, 'geo_enabled' => bool, 'id' => int, 'id_str' => string, 'is_translation_enabled' => bool, 'is_translator' => bool, 'lang' => string, 'listed_count' => int, 'location' => string, 'name' => string, 'notifications' => bool, 'profile_background_color' => string, 'profile_background_image_url' => string, 'profile_background_image_url_https' => string, 'profile_background_tile' => bool, ?'profile_banner_url' => string, 'profile_image_url' => string, 'profile_image_url_https' => string, 'profile_link_color' => string, 'profile_sidebar_border_color' => string, 'profile_sidebar_fill_color' => string, 'profile_text_color' => string, 'profile_use_background_image' => bool, 'protected' => bool, 'screen_name' => string, 'statuses_count' => int, 'time_zone' => ?string, 'url' => ?string, 'utc_offset' => ?int, 'verified' => bool); $partial__1['entities'] = () ==> { $partial__2 = $partial__1['entities'] as shape('description' => mixed, ?'url' => mixed); $partial__2['description'] = () ==> { $partial__3 = $partial__2['description'] as shape('urls' => mixed); $partial__3['urls'] = () ==> { $out__4 = vec[]; foreach (($partial__3['urls'] as vec<_>) as $v__4) { $out__4[] = () ==> { $partial__5 = $v__4 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__5['indices'] = () ==> { $out__6 = vec[]; foreach (($partial__5['indices'] as vec<_>) as $v__6) { $out__6[] = $v__6 as int; } return $out__6; }(); return $partial__5; }(); } return $out__4; }(); return $partial__3; }(); if (Shapes::keyExists($partial__2, 'url')) { $partial__2['url'] = () ==> { $partial__3 = $partial__2['url'] as shape('urls' => mixed); $partial__3['urls'] = () ==> { $out__4 = vec[]; foreach (($partial__3['urls'] as vec<_>) as $v__4) { $out__4[] = () ==> { $partial__5 = $v__4 as shape('display_url' => string, 'expanded_url' => string, 'indices' => mixed, 'url' => string); $partial__5['indices'] = () ==> { $out__6 = vec[]; foreach (($partial__5['indices'] as vec<_>) as $v__6) { $out__6[] = $v__6 as int; } return $out__6; }(); return $partial__5; }(); } return $out__4; }(); return $partial__3; }(); } else { Shapes::removeKey(inout $partial__2, 'url'); } return $partial__2; }(); return $partial__1;
  }
}
