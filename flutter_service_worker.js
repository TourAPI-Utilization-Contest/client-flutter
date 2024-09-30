'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "7f21d78cdf20d683f849c62c06c963ba",
"assets/assets/google_fonts/NotoSansKR-VariableFont_wght.ttf": "6e3addfaa6e4fa119ed006a3df59bf20",
"assets/assets/google_fonts/OFL.txt": "6c7802e99b3d76592e59e8d703e5c0f0",
"assets/assets/logo/symbol_icon1.png": "aae65446fdb50d04000f5c5e14f9eaec",
"assets/assets/logo/symbol_icon1.svg": "cead937b97cd45be266a1e7bb0fe1db8",
"assets/assets/logo/color_1.svg": "074b0076254e62c4039c3ddb2249f463",
"assets/assets/logo/symbol_icon2.svg": "bb0ec1ed9cd6fac5bc7200c43daa06b6",
"assets/assets/logo/white_2.svg": "49d226a2cad5107d46a2a18fd3203ae0",
"assets/assets/logo/tradule_text.svg": "9b99f8c7aff9838383db948ef5dbd5ac",
"assets/assets/logo/white_1.svg": "c2f02f564e1018c17be2f710111a0458",
"assets/assets/logo/symbol_icon2.png": "1479239d546e218a2d208e778aeb351d",
"assets/assets/logo/color_2.svg": "056db721957258a06717d0244c492974",
"assets/assets/icon/jam_star.svg": "178f10bbed9f01309b34f77a28f4f073",
"assets/assets/icon/jam_map_marker_f.svg": "65fadfab55ccc5eab62fcfc91d8c8741",
"assets/assets/icon/%25EB%2582%2598%25EC%25B9%25A8%25ED%258C%2590.svg": "af1745fbb0c1f7c787b80487fdbec590",
"assets/assets/icon/%25EA%25B8%25B0%25EB%25B3%25B8.svg": "f232193b9ff5fd212fe1e67761621dad",
"assets/assets/icon/jam_user.svg": "58e46ae70e23e28cb9aeb4c1f7fdeade",
"assets/assets/icon/jam_home.svg": "448ea9b042b27fb70fd4d7da983b7ef0",
"assets/assets/icon/jam_chevron_left.svg": "c0d81df43f4696edaafb93874163ae9c",
"assets/assets/icon/%25ED%259C%25B4%25EC%258B%259D.svg": "fc1453e750bc7728e937c66d80e74c91",
"assets/assets/icon/%25EA%25B4%2580%25EC%258B%25AC_%25EC%259E%25A5%25EC%2586%258C_on.svg": "1d31aa0287f2db544d8838c70fd2557a",
"assets/assets/icon/heroicons_map_pin.svg": "686dbb0377aa61f42d8b30c61af25ca0",
"assets/assets/icon/jam_plus.svg": "2e53f811a702e5a424bd9da2b9be411a",
"assets/assets/icon/search.svg": "fc1642cddfdf871b8447a9bdc5e13128",
"assets/assets/icon/jam_write.svg": "c42e7ff9ebd0ff6ef8b53b4e0888d77d",
"assets/assets/icon/%25EB%25B9%2584%25ED%2596%2589%25EA%25B8%25B0.svg": "ab087bd45a7a4471dc8d69da2e6507cb",
"assets/assets/icon/%25EA%25B2%258C%25EC%259E%2584.svg": "d4e86587f1ff5fbb5d35e24a6951023f",
"assets/assets/icon/jam_close_circle_f.svg": "25f7e60616cafc8116bec23c881b20eb",
"assets/assets/icon/jam_arrows_v.svg": "20b78729612a18d8947390cd790c637e",
"assets/assets/icon/%25EA%25B4%2580%25EC%258B%25AC_%25EC%259E%25A5%25EC%2586%258C_off.svg": "b444999c544fff1a2134a9167a641fb7",
"assets/assets/icon/jam_chevron_down.svg": "d05e6dbc084c4e9fc1862c8ebd389ddc",
"assets/assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg": "d8341ef1fe84992cfee17814288300f7",
"assets/assets/icon/jam_arrow_right.svg": "7cbbc323d510403b17336f78304f3b2a",
"assets/assets/icon/%25EB%25A7%259B%25EC%25A7%2591.svg": "babca054bdae4b3558411e4c31b1df0c",
"assets/assets/icon/jam_heart.svg": "195a788eedfd13c5badb426871d4c671",
"assets/assets/images/sp.svg": "f97059647ad766291e5afb65dc16a2f2",
"assets/assets/images/kakao_login_medium_narrow.svg": "9bc5cc31dd6a149a47f4c82d26d908c7",
"assets/assets/social/kakao_login.svg": "56a360dc09412517905a66a5b06b0806",
"assets/AssetManifest.bin.json": "e2f2e66a96167c5d3aeb3e704aad29d6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/white_2.svg": "49d226a2cad5107d46a2a18fd3203ae0",
"assets/AssetManifest.bin": "cc5e866d602b36a582126c97548a27b1",
"assets/FontManifest.json": "7d9327ec8249239697c3664d8bc45dd8",
"assets/NOTICES": "099ed21de5a5ffbb1bd739570c90fca5",
"assets/fonts/MaterialIcons-Regular.otf": "824009eeeb7cad4e377b48e0cc078578",
"assets/packages/flutter_iconpicker/fonts/fa-solid-900.ttf": "0a95f951745ba02faa8773ea6a1ebaed",
"assets/packages/flutter_iconpicker/fonts/LineAwesome.ttf": "bcc78af7963d22efd760444145073cd3",
"assets/packages/flutter_iconpicker/fonts/fa-regular-400.ttf": "3c264849ff4eb9b6e99eab9cd54c80ae",
"assets/packages/flutter_iconpicker/fonts/fa-brands-400.ttf": "b7dee83cb5ee2c47b053e2620f4bbb78",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/flex_color_picker/assets/opacity.png": "49c4f3bcb1b25364bb4c255edcaaf5b2",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "76bd55cc08e511bb603cc53003b81051",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"main.dart.js": "d2278f2bae93e613e1d5d1fd921185fc",
"icons/Icon-512.png": "48bebe2bd3f2049d97b06617d279882d",
"icons/Icon-192.png": "011d5640a7a6fc4ab71077772ca3d7b8",
"icons/Icon-maskable-512.png": "48bebe2bd3f2049d97b06617d279882d",
"icons/Icon-maskable-192.png": "011d5640a7a6fc4ab71077772ca3d7b8",
"flutter_bootstrap.js": "53993392131ce772cee530764d34e174",
"favicon.png": "7a365043e012e021e08a818be376c80d",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"index.html": "e0cad35ca4f82cb597e23c4a9f172d6d",
"/": "e0cad35ca4f82cb597e23c4a9f172d6d",
"favicon.ico": "66d5f2ad291265cb5d7876f8c554da7d",
"version.json": "488274092589ed5391505022876c96f7",
"manifest.json": "84bd9e552364baace268184a3ca7942a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
