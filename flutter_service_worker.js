'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "main.dart.js": "12d1c144f174bd54123a83888366bc57",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/FontManifest.json": "580ff1a5d08679ded8fcf5c6848cece7",
"assets/LICENSE": "9332dd43249e4889c32a36d5e01b95f1",
"assets/assets/bugs.json": "fe1e6da1eab7ce9d78e0c45e0078689c",
"assets/assets/fish.json": "317f4abd82d166c8b293cceeb7cdd4d1",
"assets/AssetManifest.json": "1ab8a3dcd0b3c81c8b7dfce216547b32",
"favicon.png": "540e34c6c37d4ab81bef5a6c6c14477d",
"manifest.json": "6b6f5a737687f21e0a8454dd9834c972",
"icons/Icon-512.png": "37533ef8c72545ecd91d32a556af72bc",
"icons/Icon-192.png": "4b2a41efef9236bc2af2388904bbc2d1",
"index.html": "6634187f07d946b46a684d8d2e18a30e"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
