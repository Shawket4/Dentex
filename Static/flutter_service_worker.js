'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "b25d7af6bc595164ffeb958e27d14bd6",
"index.html": "080d31103373d52587bac41527659700",
"/": "080d31103373d52587bac41527659700",
"main.dart.js": "92a8b8d44275106c0c89c066cd77d3fa",
"favicon.png": "00fb84c7203d5066dea108f366e5b2f5",
"icons/Icon-192.png": "62c5e946de660270f815cba9d9a6ff0c",
"icons/Icon-maskable-192.png": "62c5e946de660270f815cba9d9a6ff0c",
"icons/Icon-maskable-512.png": "1c6ff8ad0fbb2c785be89acc723b4738",
"icons/Icon-512.png": "1c6ff8ad0fbb2c785be89acc723b4738",
"manifest.json": "0438e856a7b431fd9745a98e8cd63549",
"assets/AssetManifest.json": "cd6439d694e8fb83aaabbf731e273dd8",
"assets/NOTICES": "438bd4f0019031e2a33fde6cfb62fd62",
"assets/FontManifest.json": "65fd670c5380d436f2a00be02ec63be8",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/images/teeth/T1.png": "a25793c9db552ce56d85366421169e10",
"assets/assets/images/teeth/T7_Colored.png": "cbc804d0edda507bde402dd638f3f81d",
"assets/assets/images/teeth/Lateral_3.png": "aee74ba887a569c88d465813e0cacaee",
"assets/assets/images/teeth/Lateral_2.png": "82db528057ae37d3b0e316516d7fa5f1",
"assets/assets/images/teeth/Lateral_5_Colored.png": "9eaa82ddc35d1c25bdefb77c43f07751",
"assets/assets/images/teeth/T2.png": "12acb50f86e19cb23dab95da318c016e",
"assets/assets/images/teeth/Lateral_1.png": "93fa4dc19c469be537732fba24a2f2dd",
"assets/assets/images/teeth/B6_Colored.png": "22e9b9e1bf49fc569c73226396a42a93",
"assets/assets/images/teeth/T3.png": "24a4ff2af3c04398a4af999de0057b25",
"assets/assets/images/teeth/T7.png": "1c6b4c376d6e876c23c9813008d03a95",
"assets/assets/images/teeth/Lateral_5.png": "0ff41f580056570c5302efcdab9dfc21",
"assets/assets/images/teeth/Lateral_4.png": "081c774ccb31297f18971929097a4a9c",
"assets/assets/images/teeth/B3_Colored.png": "3832a9f462e3b4c54354db5f7002ea65",
"assets/assets/images/teeth/T6.png": "5952030ceae6e48f9369adcad36564e2",
"assets/assets/images/teeth/T4.png": "08895ffb7750f4437f450221527b7378",
"assets/assets/images/teeth/T2_Colored.png": "3a43ef028b5f5675b4ca8e03d7d3abe7",
"assets/assets/images/teeth/Lateral_6.png": "2b05b9b7f028ae849df8ca07499d170f",
"assets/assets/images/teeth/Lateral_7.png": "b402204aa00018db8f0ad4bab568b2f2",
"assets/assets/images/teeth/B8.png": "3c4f4359e346a8af9aa135facea78210",
"assets/assets/images/teeth/T5.png": "491ccadefbc0b2a1e9c3c5c82d5886cc",
"assets/assets/images/teeth/Lateral_3_Colored.png": "a09d666fd0a8856a92fcc35507648e06",
"assets/assets/images/teeth/T1_Colored.png": "660679c4384700ebe8787a87b4f3696d",
"assets/assets/images/teeth/T8_Colored.png": "eebc58d498a38192eb7e40a434279607",
"assets/assets/images/teeth/B5_Colored.png": "6115ec4910c2efcf63c9fb051c593a95",
"assets/assets/images/teeth/Lateral_6_Colored.png": "d4d00e6dc8124e1390548aed98b6d61b",
"assets/assets/images/teeth/T4_Colored.png": "c61d9df76545698bf71246b400891550",
"assets/assets/images/teeth/Lateral_1_Colored.png": "a417d5dc5db3c8be578df93ad3888fb8",
"assets/assets/images/teeth/T3_Colored.png": "60e791eac162857474ca3562c6cfcb63",
"assets/assets/images/teeth/B2_Colored.png": "a68629364841f16cacfa389846f66661",
"assets/assets/images/teeth/Lateral_8_Colored.png": "c6b5b3d717ab61fe8635ed12e8d326ef",
"assets/assets/images/teeth/B7_Colored.png": "106dd65ad3aaad30e5dbe14d57753599",
"assets/assets/images/teeth/Lateral_4_Colored.png": "eccde4d0464840768fc839866325cfdd",
"assets/assets/images/teeth/T6_Colored.png": "1bf76d76964e0381a84aff6e7efab406",
"assets/assets/images/teeth/T8.png": "cade48f00472fd809961bd7bc7b22da8",
"assets/assets/images/teeth/T5_Colored.png": "c0d50776200f3b649c6865d4bc5cdedd",
"assets/assets/images/teeth/B5.png": "5c8a265cec70f8bbbd8b36287b0e851a",
"assets/assets/images/teeth/Lateral_7_Colored.png": "3b8976bcacd227d0a334e06125e56b23",
"assets/assets/images/teeth/B4.png": "ff514eee2b7427afdbfc115a67394bee",
"assets/assets/images/teeth/B6.png": "cf636efe3450d3c4c006b3bff8f831e3",
"assets/assets/images/teeth/Lateral_8.png": "10003af9330cf4f9a0811232ec5d53cd",
"assets/assets/images/teeth/B4_Colored.png": "951e1414951538a0701118f31e85a48d",
"assets/assets/images/teeth/B7.png": "dc156a4117edc369cc4400fa1443a9c8",
"assets/assets/images/teeth/B3.png": "accb7708a3e5a866f92f092bf4ff9b8e",
"assets/assets/images/teeth/B2.png": "257360ab9860bacb5e967dc3f6619f24",
"assets/assets/images/teeth/B1_Colored.png": "5ccc1f65c6543c27434956e831ac90a4",
"assets/assets/images/teeth/B1.png": "c4884b4a88ef37612854e35340a6e5d9",
"assets/assets/images/teeth/Lateral_2_Colored.png": "34ac4c68182507cc66a5846113bee2e2",
"assets/assets/images/teeth/B8_Colored.png": "97ba763ce957166de32ba16f537151ae",
"assets/assets/images/Logo_Dark.png": "29e156887fbbec5df99a9495ac0a92a7",
"assets/assets/images/Logo_White.png": "577fe0a8f2adba2a1a3f7a88a0ff9875",
"assets/assets/rive/add_icon.riv": "934f97516c147d96225bef0de86e25a7",
"assets/assets/rive/icons.riv": "162e8114717a3e37193d6c11d805571a",
"assets/assets/lottie/Error.json": "11c1fc60a91dad6379265cbfbad242e4",
"assets/assets/lottie/Loading.json": "84ba42a5bd4eb14939045a516e30eb5b",
"assets/assets/lottie/Success.json": "a6e8bcd9d89b26e9919a49ab944d22ce",
"assets/assets/lottie/AppointmentOnGoing.json": "ed5c00383ce225f6bf30d153eef6b8ce",
"assets/assets/lottie/Searching.json": "e6e2846b1fda789d8e59ec8da7ca6cec",
"assets/assets/fonts/Inter-Bold.ttf": "275bfea5dc74c33f51916fee80feae67",
"assets/assets/fonts/Inter-ExtraBold.ttf": "c9709fb8e32755490795ce5bd226c3a0",
"assets/assets/fonts/Inter%2520Normal.ttf": "ba8d154465f7fd15e2fc2ced6dceec90",
"assets/assets/fonts/Iowan%2520Old%2520Style.ttf": "4aff88a6ebaf4eb3596d41fd3ffed96b"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
