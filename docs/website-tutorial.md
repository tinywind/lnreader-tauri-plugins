# Plugin development website

The development website loads a source module and exercises its 0.2 metadata,
listing, search, novel, and chapter acquisition methods.

| Screen | 0.2 behavior |
| --- | --- |
| Plugin info | Displays the source identity and `apiVersion`. |
| Popular/Search | Calls the source listing methods. |
| Novel | Calls `parseNovel` or `parseNovelSince`. |
| Chapter | Calls `getChapterAcquisitionPlan`. Resource plans execute `getChapterResource`; page plans display the host capture instructions. |
| EPUB export | Includes explicit resources. Page-plan chapters are marked as requiring the Norea host WebView capture pipeline. |

The website cannot reproduce the native host's persistent scraper WebView,
executor scheduling, cookie jar, media archive, or resume manifest. Validate
page plans in the Norea app when source behavior depends on those facilities.

For a normal chapter, confirm that the plan returns an absolute page URL, a
selector that contains only reader content, and any required exclusions. For
rendered sources, confirm that `documentStartScript` creates the declared
synthetic content root without removing signed media query parameters.
