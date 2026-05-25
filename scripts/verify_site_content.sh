#!/usr/bin/env bash
set -euo pipefail

require_pattern() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if ! grep -Eq "$pattern" "$file"; then
    echo "Missing: ${description} (${file})" >&2
    exit 1
  fi
}

reject_pattern() {
  local file="$1"
  local pattern="$2"
  local description="$3"

  if grep -Eq "$pattern" "$file"; then
    echo "Unexpected: ${description} (${file})" >&2
    exit 1
  fi
}

reject_path() {
  local path="$1"
  local description="$2"

  if [ -e "$path" ]; then
    echo "Unexpected: ${description} (${path})" >&2
    exit 1
  fi
}

require_path() {
  local path="$1"
  local description="$2"

  if [ ! -s "$path" ]; then
    echo "Missing: ${description} (${path})" >&2
    exit 1
  fi
}

require_pattern "_config.yml" 'title[[:space:]]*:[[:space:]]*"Stefanos Poulidis"' "site title"
require_pattern "_config.yml" 'name[[:space:]]*:[[:space:]]*"Stefanos Poulidis"' "site name"
require_pattern "_config.yml" 'author:[[:space:]]*$' "author block"
require_pattern "_config.yml" '^[[:space:]]+name[[:space:]]*:[[:space:]]*"Stefanos Poulidis"' "author name"
require_pattern "_config.yml" 'github[[:space:]]*:[[:space:]]*StefanosPoulidis' "GitHub username"
require_pattern "_config.yml" 'linkedin[[:space:]]*:[[:space:]]*stefanospoul' "LinkedIn username"
require_pattern "_config.yml" '^[[:space:]]+- scripts$' "verification scripts excluded from generated site"

reject_pattern "_includes/author-profile.html" 'btn btn--inverse">Follow' "empty Follow button"
reject_pattern "_includes/author-profile.html" 'class="author__avatar" alt="\{\{ author.name \}\}" class="profile-photo"' "duplicate avatar class attribute"
require_pattern "_includes/masthead.html" 'class="site-nav-static"' "static wrapped masthead navigation"
reject_pattern "_includes/masthead.html" 'hidden-links hidden|navicon' "greedy nav controls"
reject_pattern "_includes/head.html" 'swiper' "unused Swiper dependency"
reject_pattern "_includes/footer.html" 'Swiper|swiper' "unused Swiper initialization"
require_pattern "_data/navigation.yml" 'AI Field Deployments' "AI field deployments navigation label"
require_pattern "_data/navigation.yml" '#ai-field-deployments' "AI field deployments navigation anchor"

require_pattern "assets/css/main.scss" 'max-width:[[:space:]]*100%' "mobile overflow guard"
require_pattern "assets/css/main.scss" '^\.author__urls-wrapper,' "author URL wrapper override"
require_pattern "assets/css/main.scss" '^\.author__urls \{' "author URL list override"
require_pattern "assets/css/main.scss" 'float:[[:space:]]*none' "mobile layout float reset"
require_pattern "assets/css/main.scss" 'flex-wrap:[[:space:]]*wrap' "mobile nav wraps instead of widening page"
require_pattern "assets/css/main.scss" 'fieldwork-paper' "fieldwork paper grouping styles"
require_pattern "assets/css/main.scss" 'font-size:[[:space:]]*0\.95rem' "larger fieldwork captions"
require_pattern "assets/css/main.scss" 'fieldwork-paper-grid--learning' "larger self-regulated fieldwork gallery"
require_pattern "assets/css/main.scss" 'media-mention-grid' "media mention grid styles"
require_pattern "assets/css/main.scss" 'media-paper-links' "related paper link styles"

require_pattern "_pages/about.md" 'fieldwork-paper' "fieldwork paper grouping markup"
require_pattern "_pages/about.md" 'AI Field Deployments' "AI field deployments section heading"
require_pattern "_pages/about.md" 'Self-Regulated AI Use' "Self-regulated fieldwork group"
require_pattern "_pages/about.md" 'fieldwork-paper-grid--learning' "Self-regulated gallery modifier"
reject_pattern "_pages/about.md" 'fieldwork-paper__label">Action vs\. Attention Signals|FIDE officially communicated the study' "FIDE fieldwork block"
reject_pattern "_pages/about.md" 'External communication and research visibility|Chess academies, student training, and dissemination|grouped with' "fieldwork explanatory blurbs"
reject_pattern "_pages/about.md" 'swiper-container' "carousel markup"
require_pattern "_pages/about.md" 'Media Mentions' "media mentions section"
require_pattern "_pages/about.md" 'www\.economist\.com/business/2026/04/30/ai-and-the-danger-of-cognitive-surrender' "The Economist media link"
require_pattern "_pages/about.md" 'knowledge\.insead\.edu/responsibility/how-demand-ai-assistance-undermines-learning' "INSEAD learning media link"
require_pattern "_pages/about.md" 'knowledge\.wharton\.upenn\.edu/article/when-does-ai-assistance-undermine-learning' "Wharton media link"
require_pattern "_pages/about.md" 'knowledge\.insead\.edu/operations/should-ai-nudge-you-or-tell-you-what-do' "INSEAD nudge media link"
require_pattern "_pages/about.md" 'x\.com/FIDE_chess/status/1751912810705977839' "FIDE media link"
require_pattern "_pages/about.md" 'papers\.ssrn\.com/sol3/papers\.cfm\?abstract_id=5604932' "Self-regulated paper link"
require_pattern "_pages/about.md" 'papers\.ssrn\.com/sol3/papers\.cfm\?abstract_id=5128584' "Action vs. Attention paper link"
require_path "assets/images/media/economist-ai-cognitive-surrender.png" "The Economist screenshot"
require_path "assets/images/media/insead-demand-ai-assistance.png" "INSEAD learning screenshot"
require_path "assets/images/media/wharton-ai-assistance-learning.png" "Wharton screenshot"
require_path "assets/images/media/insead-ai-nudge.png" "INSEAD nudge screenshot"

require_pattern "_pages/teaching.md" 'https://stefanospoulidis.github.io/pom-tutorials/' "POM Tutorials link"
require_pattern "_pages/cv.md" '/files/Stefanos_Poulidis_CV\.pdf' "CV page points to existing PDF path"

reject_path "_posts/2012-08-14-blog-post-1.md" "sample blog post"
reject_path "_posts/2013-08-14-blog-post-2.md" "sample blog post"
reject_path "_posts/2014-08-14-blog-post-3.md" "sample blog post"
reject_path "_posts/2015-08-14-blog-post-4.md" "sample blog post"
reject_path "_posts/2199-01-01-future-post.md" "sample future blog post"
reject_path "_publications/2009-10-01-paper-title-number-1.md" "sample publication"
reject_path "_publications/2010-10-01-paper-title-number-2.md" "sample publication"
reject_path "_publications/2015-10-01-paper-title-number-3.md" "sample publication"
reject_path "_portfolio/portfolio-1.md" "sample portfolio item"
reject_path "_portfolio/portfolio-2.html" "sample portfolio item"
reject_path "_talks/2012-03-01-talk-1.md" "sample talk"
reject_path "_talks/2013-03-01-tutorial-1.md" "sample talk"
reject_path "_talks/2014-02-01-talk-2.md" "sample talk"
reject_path "_talks/2014-03-01-talk-3.md" "sample talk"
reject_path "_pages/markdown.md" "template markdown help page"
reject_path "_pages/page-archive.html" "template page archive"
reject_path "_pages/category-archive.html" "template category archive"
reject_path "_pages/tag-archive.html" "template tag archive"
reject_path "_pages/year-archive.html" "template year archive"
reject_path "_pages/portfolio.html" "template portfolio archive"
reject_path "_pages/talks.html" "template talks archive"
reject_path "_pages/talkmap.html" "template talk map"

echo "Site content checks passed."
