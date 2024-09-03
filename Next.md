# What's Next


> [!NOTE] Key
> F: Feature
> R: Refactor
> B: Bug

### Priority Tickets
Adding words, groups, and sources via main menu/keyboard shortcut.
Show images in the words summary view.
Adding nationality, archaic
Dealing with exact synonyms (saloon/sedan; bosun/boatswain).


### WordList
- [✓] Search bar

### Model
- [✓] Add generic `fetchByUUID` static method to all persistent model classes (currently only available on `Definition`).
- [F] Get the database onto the cloud and allow the iOS app read/write access.
- [F] Handling synonyms (boatswain/bosun).
- [F] Add 'facts' or 'did you know' field for words. For example 'transit van': 'introduced by Ford in 1965', or 'Luton Van': 'the biggest vehicle you can drive on a standard licence.'
- [F] Add geography flags for definitions (e.g. american, australian, irish, etc).
- [F] Add concept of primary definition image.

### WordDetail
- [F] Users should be able to delete words.
- [F] Display groups on word summary/definition summary.

### View (Universal)
- [F] Get focus up and running, then implement image deletion via the backspace key.

### Inspector
- [✓] Get expand-all/collapse-all working for inspector's words list.
- [F] Allow user to filter out words that are already part of the selected group.

### Sidebar


### Definiton Detail
- [R] A reusable `Picker` that can edit the source and word-type selections.
- [F] Deleting images.

### Project
🏴󠁧󠁢󠁳󠁣󠁴󠁿
