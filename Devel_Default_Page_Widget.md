# Introduction #

This page lists ideas and plans to implement default page widgets in Kopal. Original inspiration from "Pages" feature in 37signals' Backpack application.

# Default Widgets #

Default widgets provided by Kopal are

  1. Note
  1. List
  1. 2-column list
  1. Table
  1. Divider (built-in)

On hover, all elements display options at left. These options are - Delete (dustbin icon), Edit (text "edit"), Advanced options (text "more") and Move (icon).

Unless otherwise noted, all text fields support HTML.

## Note ##

Note has one "heading", optional "description" (shown in italics below heading) and text box for note.
Clicking "more" on heading shows options -
  1. Add/Remove description.
  1. Markup {{HTML (default), Markdown, ....}}
  1. Environment (depends on Markup) {{YUI simple (default), YUI advanced, ....}} (overkill?)

## List ##

Clicking "more" on heading shows options -

  1. Add/Remove description.
  1. Listing type {{bullet, digit, check-box}}
  1. (Shown if listing type = check-box) {{check-box here}} Cross entries if check-box is selected.

On right side of every entry there is an icon which when clicked converts one-line text field into multi-line text-area.

Clicking "more" on an entry shows options -

  1. Add/Remove description (shown in italics below entry)
  1. Add a (nested) child list (only one child list per level).

## 2-column list / Paired list ##

_TODO: Think of a better name._

Clicking "more" on heading shows options -

  1. Add/Remove description.

Each entry has two part - "name" and "value".
Clicking on "Add new entry" adds a pair of "name" and "value". Both are rendered as text-field. "value" field has a link "Add an item", which when clicked converts "value" in a list from text and in "more" options of that paired entry an option appears to render the list as "bullet" or "number" (default).
Each entry in "value" has an icon on right side to make it multi-line.

## Table ##

Clicking "more" on heading shows options -

  1. Add/Remove description.

# Templates #

Templates are what make these widgets appear useful. A "profile template" is a set of definitions about how a profile page should include these widgets in what order and with what default values.
A template can only be added/executed on a blank profile page.
For example a template "personal profile" may contain a paired-list with blank values for "height", "languages I speak" (list) etc.

Third-parties can also provide templates, some default templates included in Kopal are -

  1. Personal profile
  1. Favourites
  1. Educational profile
  1. Professional profile
  1. CV/Résumé