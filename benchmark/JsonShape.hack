/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

type TEntities = shape(
  'hashtags' => vec<shape('indices' => vec<int>, 'text' => string)>,
  ?'media' => vec<
    shape(
      'display_url' => string,
      'expanded_url' => string,
      'id' => int,
      'id_str' => string,
      'indices' => vec<int>,
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
    )
  >,
  'symbols' => vec<null>,
  'urls' => vec<
    shape(
      'display_url' => string,
      'expanded_url' => string,
      'indices' => vec<int>,
      'url' => string,
    )
  >,
  'user_mentions' => vec<
    shape(
      'id' => int,
      'id_str' => string,
      'indices' => vec<int>,
      'name' => string,
      'screen_name' => string,
    )
  >,
);

type TUser = shape(
  'contributors_enabled' => bool,
  'created_at' => string,
  'default_profile' => bool,
  'default_profile_image' => bool,
  'description' => string,
  'entities' => shape(
    'description' => shape(
      'urls' => vec<
        shape(
          'display_url' => string,
          'expanded_url' => string,
          'indices' => vec<int>,
          'url' => string,
        )
      >,
    ),
    ?'url' => shape(
      'urls' => vec<
        shape(
          'display_url' => string,
          'expanded_url' => string,
          'indices' => vec<int>,
          'url' => string,
        )
      >,
    ),
  ),
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

type JsonShape = shape(
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
  'statuses' => vec<
    shape(
      'contributors' => null,
      'coordinates' => null,
      'created_at' => string,
      'entities' => TEntities,
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
      ?'retweeted_status' => shape(
        'contributors' => null,
        'coordinates' => null,
        'created_at' => string,
        'entities' => TEntities,
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
        'user' => TUser,
      ),
      'source' => string,
      'text' => string,
      'truncated' => bool,
      'user' => TUser,
    )
  >,
);
