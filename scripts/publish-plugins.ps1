$current = git rev-parse --abbrev-ref HEAD
$dist = "dist/$current"

if ($current -like "dist/*" -or $current -like "plugins/*" -or $current -like "*/plugins/*") {
  Write-Output "Skipping plugin publish: source branch is '$current'."
  exit 0
}

Write-Output "Publishing plugins: $current -> $dist"

$exists = git show-ref refs/heads/$dist
if ($exists) {
  git branch -D $dist
}

Remove-Item -Recurse -Force .dist, .js, total.svg -ErrorAction SilentlyContinue
node scripts/generate-plugin-index.js
npm run build:compile
$env:BRANCH = $dist
npm run build:manifest
Remove-Item Env:BRANCH -ErrorAction SilentlyContinue

if (-not (Test-Path .dist/plugins.min.json)) {
  Write-Error "Manifest generation failed."
  exit 1
}

git checkout --orphan $dist
git reset
git add -f public/static .dist .js/plugins total.svg
git commit -m "chore(plugins): publish plugin manifest"
git push -f origin $dist
git checkout -f $current

Write-Output "Published to $dist"
