/** static-type-assertion-code-generator is MIT licensed, see /LICENSE. */
namespace HTL\StaticTypeAssertionCodegen\Bench;

use namespace HH;
use namespace HH\Asio;

<<__EntryPoint>>
async function download_async(): Awaitable<void> {
  $autoloader = __DIR__.'/../vendor/autoload.hack';
  if (HH\could_include($autoloader)) {
    require_once $autoloader;
    HH\dynamic_fun('Facebook\AutoloadMap\initialize')();
  }

  $cache_file = __DIR__.'/benchmark.json';
  $file_url =
    'https://raw.githubusercontent.com/simdjson/simdjson/master/jsonexamples/twitter.json';

  if (!\file_exists($cache_file)) {
    /* HHAST_IGNORE_ERROR[NoStringInterpolation] */
    echo <<<IMPORTANT



[[[[ IMPORTANT ]]]]
The default benchmark for this project is a twitter.json file, which we download from:
$file_url
You can check the license of the repository here:
https://github.com/simdjson/simdjson/blob/master/LICENSE
The authors of simdjson use this file as a benchmark.
The file is complex enough to be tough to parse and validate, but very realisitic.
I did not create a specially crafted json file for this benchmark. https://en.wikipedia.org/wiki/Nothing-up-my-sleeve_number.
I do not claim that the authors of simdjson have licensed this file correctly.
If downloading or benchmarking with this file makes you uncomfortable, please exit this application now.
You can benchmark using a file you provide by placing the file at:
$cache_file
[[[[ IMPORTANT ]]]]


IMPORTANT;

    \readline('Press [enter] to download twitter.json from github.');
    \file_put_contents($cache_file, await Asio\curl_exec($file_url));
  }
}
