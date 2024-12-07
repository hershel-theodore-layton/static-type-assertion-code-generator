/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
/** This code was generated during benchmarking, run `hhvm benchmark/2-codegen.hack` to update it. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

final abstract class AssertJsonShape {
  public static function assertJsonShape(
    mixed $htl_untyped_variable,
  )[]: JsonShape {
    $out__1 = $htl_untyped_variable as shape(
      'search_metadata' => shape(
        'completed_in' => float,
        'count' => int,
        'max_id' => int,
        'max_id_str' => string,
        'next_results' => string,
        'query' => string,
        'refresh_url' => string,
        'since_id' => int,
        'since_id_str' => string,
      ),
      'statuses' => mixed,
    );
    $out__12 = vec[];
    foreach (($out__1['statuses'] as vec<_>) as $v__12) {
      $out__13 = $v__12 as shape(
        'contributors' => null,
        'coordinates' => null,
        'created_at' => string,
        'entities' => mixed,
        'favorite_count' => int,
        'favorited' => bool,
        'geo' => null,
        'id' => int,
        'id_str' => string,
        'in_reply_to_screen_name' => ?string,
        'in_reply_to_status_id' => ?int,
        'in_reply_to_status_id_str' => ?string,
        'in_reply_to_user_id' => ?int,
        'in_reply_to_user_id_str' => ?string,
        'lang' => string,
        'metadata' => shape(
          'iso_language_code' => string,
          'result_type' => string,
        ),
        'place' => null,
        ?'possibly_sensitive' => bool,
        'retweet_count' => int,
        'retweeted' => bool,
        ?'retweeted_status' => mixed,
        'source' => string,
        'text' => string,
        'truncated' => bool,
        'user' => mixed,
      );
      $out__13['entities'] = self::assertTEntities($out__13['entities']);
      if (Shapes::keyExists($out__13, 'retweeted_status')) {
        $out__94 = $out__13['retweeted_status'] as shape(
          'contributors' => null,
          'coordinates' => null,
          'created_at' => string,
          'entities' => mixed,
          'favorite_count' => int,
          'favorited' => bool,
          'geo' => null,
          'id' => int,
          'id_str' => string,
          'in_reply_to_screen_name' => ?string,
          'in_reply_to_status_id' => ?int,
          'in_reply_to_status_id_str' => ?string,
          'in_reply_to_user_id' => ?int,
          'in_reply_to_user_id_str' => ?string,
          'lang' => string,
          'metadata' => shape(
            'iso_language_code' => string,
            'result_type' => string,
          ),
          'place' => null,
          ?'possibly_sensitive' => bool,
          'retweet_count' => int,
          'retweeted' => bool,
          'source' => string,
          'text' => string,
          'truncated' => bool,
          'user' => mixed,
        );
        $out__94['entities'] = self::assertTEntities($out__94['entities']);
        $out__94['user'] = self::assertTUser($out__94['user']);
        $out__13['retweeted_status'] = $out__94;
      } else {
        Shapes::removeKey(inout $out__13, 'retweeted_status');
      }
      $out__13['user'] = self::assertTUser($out__13['user']);
      $out__12[] = $out__13;
    }
    $out__1['statuses'] = $out__12;

    return $out__1;
  }
  private static function assertTEntities(
    mixed $htl_untyped_variable,
  )[]: TEntities {
    $out__1 = $htl_untyped_variable as shape(
      'hashtags' => mixed,
      ?'media' => mixed,
      'symbols' => mixed,
      'urls' => mixed,
      'user_mentions' => mixed,
    );
    $out__2 = vec[];
    foreach (($out__1['hashtags'] as vec<_>) as $v__2) {
      $out__3 = $v__2 as shape(
        'indices' => mixed,
        'text' => string,
      );
      $out__4 = vec[];
      foreach (($out__3['indices'] as vec<_>) as $v__4) {
        $out__4[] = $v__4 as int;
      }
      $out__3['indices'] = $out__4;
      $out__2[] = $out__3;
    }
    $out__1['hashtags'] = $out__2;
    if (Shapes::keyExists($out__1, 'media')) {
      $out__7 = vec[];
      foreach (($out__1['media'] as vec<_>) as $v__7) {
        $out__8 = $v__7 as shape(
          'display_url' => string,
          'expanded_url' => string,
          'id' => int,
          'id_str' => string,
          'indices' => mixed,
          'media_url' => string,
          'media_url_https' => string,
          'sizes' => shape(
            'large' => shape(
              'h' => int,
              'resize' => string,
              'w' => int,
            ),
            'medium' => shape(
              'h' => int,
              'resize' => string,
              'w' => int,
            ),
            'small' => shape(
              'h' => int,
              'resize' => string,
              'w' => int,
            ),
            'thumb' => shape(
              'h' => int,
              'resize' => string,
              'w' => int,
            ),
          ),
          ?'source_status_id' => int,
          ?'source_status_id_str' => string,
          'type' => string,
          'url' => string,
        );
        $out__13 = vec[];
        foreach (($out__8['indices'] as vec<_>) as $v__13) {
          $out__13[] = $v__13 as int;
        }
        $out__8['indices'] = $out__13;
        $out__7[] = $out__8;
      }
      $out__1['media'] = $out__7;
    } else {
      Shapes::removeKey(inout $out__1, 'media');
    }
    $out__38 = vec[];
    foreach (($out__1['symbols'] as vec<_>) as $v__38) {
      $out__38[] = $v__38 as null;
    }
    $out__1['symbols'] = $out__38;
    $out__40 = vec[];
    foreach (($out__1['urls'] as vec<_>) as $v__40) {
      $out__41 = $v__40 as shape(
        'display_url' => string,
        'expanded_url' => string,
        'indices' => mixed,
        'url' => string,
      );
      $out__44 = vec[];
      foreach (($out__41['indices'] as vec<_>) as $v__44) {
        $out__44[] = $v__44 as int;
      }
      $out__41['indices'] = $out__44;
      $out__40[] = $out__41;
    }
    $out__1['urls'] = $out__40;
    $out__47 = vec[];
    foreach (($out__1['user_mentions'] as vec<_>) as $v__47) {
      $out__48 = $v__47 as shape(
        'id' => int,
        'id_str' => string,
        'indices' => mixed,
        'name' => string,
        'screen_name' => string,
      );
      $out__51 = vec[];
      foreach (($out__48['indices'] as vec<_>) as $v__51) {
        $out__51[] = $v__51 as int;
      }
      $out__48['indices'] = $out__51;
      $out__47[] = $out__48;
    }
    $out__1['user_mentions'] = $out__47;

    return $out__1;
  }
  private static function assertTUser(mixed $htl_untyped_variable)[]: TUser {
    $out__1 = $htl_untyped_variable as shape(
      'contributors_enabled' => bool,
      'created_at' => string,
      'default_profile' => bool,
      'default_profile_image' => bool,
      'description' => string,
      'entities' => mixed,
      'favourites_count' => int,
      'follow_request_sent' => bool,
      'followers_count' => int,
      'following' => bool,
      'friends_count' => int,
      'geo_enabled' => bool,
      'id' => int,
      'id_str' => string,
      'is_translation_enabled' => bool,
      'is_translator' => bool,
      'lang' => string,
      'listed_count' => int,
      'location' => string,
      'name' => string,
      'notifications' => bool,
      'profile_background_color' => string,
      'profile_background_image_url' => string,
      'profile_background_image_url_https' => string,
      'profile_background_tile' => bool,
      ?'profile_banner_url' => string,
      'profile_image_url' => string,
      'profile_image_url_https' => string,
      'profile_link_color' => string,
      'profile_sidebar_border_color' => string,
      'profile_sidebar_fill_color' => string,
      'profile_text_color' => string,
      'profile_use_background_image' => bool,
      'protected' => bool,
      'screen_name' => string,
      'statuses_count' => int,
      'time_zone' => ?string,
      'url' => ?string,
      'utc_offset' => ?int,
      'verified' => bool,
    );
    $out__7 = $out__1['entities'] as shape(
      'description' => mixed,
      ?'url' => mixed,
    );
    $out__8 = $out__7['description'] as shape(
      'urls' => mixed,
    );
    $out__9 = vec[];
    foreach (($out__8['urls'] as vec<_>) as $v__9) {
      $out__10 = $v__9 as shape(
        'display_url' => string,
        'expanded_url' => string,
        'indices' => mixed,
        'url' => string,
      );
      $out__13 = vec[];
      foreach (($out__10['indices'] as vec<_>) as $v__13) {
        $out__13[] = $v__13 as int;
      }
      $out__10['indices'] = $out__13;
      $out__9[] = $out__10;
    }
    $out__8['urls'] = $out__9;
    $out__7['description'] = $out__8;
    if (Shapes::keyExists($out__7, 'url')) {
      $out__16 = $out__7['url'] as shape(
        'urls' => mixed,
      );
      $out__17 = vec[];
      foreach (($out__16['urls'] as vec<_>) as $v__17) {
        $out__18 = $v__17 as shape(
          'display_url' => string,
          'expanded_url' => string,
          'indices' => mixed,
          'url' => string,
        );
        $out__21 = vec[];
        foreach (($out__18['indices'] as vec<_>) as $v__21) {
          $out__21[] = $v__21 as int;
        }
        $out__18['indices'] = $out__21;
        $out__17[] = $out__18;
      }
      $out__16['urls'] = $out__17;
      $out__7['url'] = $out__16;
    } else {
      Shapes::removeKey(inout $out__7, 'url');
    }
    $out__1['entities'] = $out__7;

    return $out__1;
  }
}
