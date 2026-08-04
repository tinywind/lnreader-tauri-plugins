# Plugin quickstart

Norea plugins implement the 0.2 source contract from
`src/types/plugin.ts`. Start from `docs/plugin-template.ts`.

## Required identity

```ts
class ExampleSource implements Plugin.PluginBase {
  apiVersion = '0.2' as const;
  id = 'example-source';
  name = 'Example Source';
  version = '1.0.0';
  icon = 'siteNotAvailable.png';
}
```

Use a stable lowercase kebab-case ID. `apiVersion` is the host contract
version; `version` is the source plugin release version.

## Required methods

Implement `getBaseUrl`, `popularNovels`, `searchNovels`, `parseNovel`,
`parseNovelSince`, and `getChapterAcquisitionPlan`.

Each chapter needs a stable numeric `chapterNumber`, a path, and an optional
`contentType`. The default content type is `html`.

## Page chapters

Normal website chapters use a page plan:

```ts
getChapterAcquisitionPlan(
  chapterPath: string,
): Plugin.ChapterAcquisitionPlan {
  return {
    type: 'page',
    url: new URL(chapterPath, this.getBaseUrl()).href,
    contentSelector: '.chapter-content',
    excludeSelectors: ['.advertisement'],
    loadStrategy: 'network-idle',
  };
}
```

The Norea host navigates the scraper WebView, captures the selected DOM,
stores partial HTML, downloads media with the global resource slot limit, and
resumes from its manifest. Preserve signed query parameters and access keys in
the plan URL.

Rendered or shadow-DOM content may use `documentStartScript` to place the final
content in a synthetic light-DOM container. The script must not post its own
capture result. Add `data-norea-manual-action` when login, a challenge, or a
paid gate needs user interaction.

## Resource chapters

Use `{ type: 'resource' }` only for non-page APIs, archives, PDF, or EPUB.
Implement `getChapterResource` and return either a text-like content resource
or a binary resource.

```ts
getChapterAcquisitionPlan(): Plugin.ChapterAcquisitionPlan {
  return { type: 'resource' };
}

async getChapterResource(path: string): Promise<Plugin.ChapterResource> {
  const response = await fetchApi(path);
  const bytes = await response.arrayBuffer();
  return {
    type: 'binary',
    contentType: 'pdf',
    mediaType: 'application/pdf',
    bytes,
    byteLength: bytes.byteLength,
  };
}
```

Use sanctioned fetch shims for all plugin-owned source traffic. Do not copy
cookies into a separate HTTP client.
