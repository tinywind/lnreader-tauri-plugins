# Norea plugin API 0.2

The canonical TypeScript contract is `src/types/plugin.ts`. Every published
source implements `Plugin.PluginBase` and declares:

```ts
apiVersion = '0.2' as const; // "0.2"
```

## Plugin surface

Required fields are `apiVersion`, `id`, `name`, `version`, and `icon`.
Required methods are `getBaseUrl`, `popularNovels`, `searchNovels`,
`parseNovel`, `parseNovelSince`, and `getChapterAcquisitionPlan`.

Optional fields include filters, plugin inputs, image request headers, custom
assets, multi-source installation, `resolveUrl`, and `webStorageUtilized`.

## Chapter plans

`getChapterAcquisitionPlan(chapterPath, contentType)` is synchronous and must
not perform network traffic or mutate state.

```ts
type ChapterAcquisitionPlan =
  | {
      type: 'page';
      url: string;
      contentSelector: string;
      readySelector?: string;
      excludeSelectors?: string[];
      documentStartScript?: string;
      loadStrategy?: 'selector' | 'network-idle' | 'scroll-to-end';
      cacheBust?: boolean;
      timeoutMs?: number;
    }
  | { type: 'resource' };
```

Page plans are the default for website content. The host owns navigation, DOM
capture, sanitization, browser-cache reuse, media downloading, manifests,
archives, cancellation, and resume behavior. `cacheBust` adds a host query
value while preserving all source parameters.

Use `documentStartScript` only to prepare rendered content. It may observe
source responses and inject a stable light-DOM root. It must not emit its own
WebView result. Mark gates requiring user interaction with
`data-norea-manual-action`.

## Explicit resources

Resource plans require `getChapterResource(chapterPath, contentType)`.

```ts
type ChapterResource =
  | {
      type: 'content';
      contentType: 'html' | 'text' | 'markdown';
      content: string;
      baseUrl?: string;
    }
  | {
      type: 'binary';
      contentType: 'pdf' | 'epub';
      mediaType: 'application/pdf' | 'application/epub+zip';
      bytes: ArrayBuffer | Uint8Array;
      filename?: string;
      byteLength?: number;
    };
```

Use resources for documented connector APIs, archive decoding, PDF, and EPUB,
not as an alternative HTTP parser for ordinary chapter pages.

## Paths, authentication, and traffic

Paths may be relative, absolute, or opaque encoded payloads. Keep credentials
in private plugin inputs or request init objects. Do not persist secrets in
novel paths, chapter paths, or content.

All source traffic uses the sanctioned fetch and WebView shims so the Norea
scraper session owns cookies and challenge state. Page plan URLs must retain
every signed parameter and media access key.

See `docs/quickstart.md` and `docs/plugin-template.ts` for a minimal source.
