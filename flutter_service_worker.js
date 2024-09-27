'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "c37c55f8d8810cd91aea1b211efce215",
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
"assets/assets/icon/search.svg": "fc1642cddfdf871b8447a9bdc5e13128",
"assets/assets/icon/travel_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg": "d8341ef1fe84992cfee17814288300f7",
"assets/assets/images/sp.svg": "f97059647ad766291e5afb65dc16a2f2",
"assets/assets/images/kakao_login_medium_narrow.svg": "9bc5cc31dd6a149a47f4c82d26d908c7",
"assets/assets/social/kakao_login.svg": "56a360dc09412517905a66a5b06b0806",
"assets/AssetManifest.bin.json": "a8730bbebf0a3d358bc0238f03f16c71",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/white_2.svg": "49d226a2cad5107d46a2a18fd3203ae0",
"assets/AssetManifest.bin": "9aab4d0088c4ceedc0ef83ed36dafb67",
"assets/FontManifest.json": "e8dd9281a7b5e37b6cf6105c17f23f06",
"assets/NOTICES": "dc6a40ac6ebb09c047acc7eeb739b153",
"assets/fonts/MaterialIcons-Regular.otf": "77e277dafc95391b38188159d9871717",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
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
"main.dart.js": "a2e8f765033896819a57cecc94b7d170",
"icons/Icon-512.png": "48bebe2bd3f2049d97b06617d279882d",
"icons/Icon-192.png": "011d5640a7a6fc4ab71077772ca3d7b8",
"icons/Icon-maskable-512.png": "48bebe2bd3f2049d97b06617d279882d",
"icons/Icon-maskable-192.png": "011d5640a7a6fc4ab71077772ca3d7b8",
"flutter_bootstrap.js": "ccf34c964804607df028343844d4d5dc",
"favicon.png": "7a365043e012e021e08a818be376c80d",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"index.html": "6abc357f21f13af725b26da621e61d16",
"/": "6abc357f21f13af725b26da621e61d16",
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
