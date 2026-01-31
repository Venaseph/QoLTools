# QoL Tools - WoW Addon

A simple World of Warcraft addon that generates Wowhead lookup URLs for items, achievements, and quests using their IDs directly from the game.

## Features

- Quick Wowhead item lookups using the `/wh` command
- **Alt-Click for instant lookup:**
  - ✅ Items in bags, bank, chat, tooltips
  - ✅ Achievements in Krowi's Achievement Filter addon
  - ✅ Achievements in the Blizzard achievement frame
  - ✅ Quests in the quest log
  - ✅ Regular quests in the objective tracker
  - ✅ All clickable links in chat (items, achievements, quests)
  - ❌ World quests in objective tracker (not yet working - use quest log or chat links instead)
  - ❌ Handy Notes map and minimap icon support (not yet working - use quest log or chat links instead)
- Uses actual IDs for accurate Wowhead URLs
- Generates clean URLs like `https://www.wowhead.com/item=212283`
- Styled popup window with dynamic icons matching the clicked object
- Auto-closes on ESC or Ctrl+C
- Alternative `/wowhead` command also available

## Installation

1. Download or copy the addon files
2. Place the `QoLTools` folder (containing both `.toc` and `.lua` files) into your WoW addons directory:
   - **Windows**: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - **Mac**: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
3. Restart WoW or type `/reload` in-game

## Usage

### Quick Method: Alt-Click
The fastest way to look up items, achievements, and quests:
1. Hold **Alt**
2. Click on:
   - Any item in your bags, bank, or chat
   - Any achievement in Krowi's Achievement Filter addon
   - Any achievement in the Blizzard achievement frame
   - Any quest in your quest log
   - Regular quests in the objective tracker
   - Any item/achievement/quest link in chat
3. The Wowhead URL popup appears instantly with the correct icon!

**Note:** World quests in the objective tracker aren't supported yet. For world quests, open your quest log (L key) and Alt-Click there, or Alt-Click the world quest link in chat.

### Slash Command Method
```
/wh [item link]
```

**Important:** You must use item links (shift-click items), not plain text names. The addon needs the item ID from the game to generate the correct Wowhead URL.

#### How to Use Slash Command
1. Type `/wh ` (with a space after it)
2. Shift-click any item from:
   - Your bags or bank
   - The auction house
   - Chat messages
   - Tooltips
3. Press Enter

The addon will extract the item ID and generate the correct Wowhead URL like:
`https://www.wowhead.com/item=212283`

### Examples of Generated URLs
- Items: `https://www.wowhead.com/item=212283`
- Achievements: `https://www.wowhead.com/achievement=14145`
- Quests: `https://www.wowhead.com/quest=12345`

### Help
```
/wh help
```

## How It Works

1. Type the command with an item name
2. A popup window appears with the Wowhead URL pre-selected
3. Press Ctrl+C (Cmd+C on Mac) to copy the URL
4. When you copy the URL, your default browser will open automatically
5. Paste the URL (Ctrl+V) in your browser to view the item on Wowhead

## Notes

- **Alt-Click items, achievements, or quests** for the fastest lookup!
- Works with:
  - Items in bags, bank, chat links, tooltips, and AH
  - Achievements in Krowi's Achievement Filter addon
  - Achievements in the Blizzard achievement frame
  - Quests in the quest log
  - **Regular quests in the objective tracker**
  - All types of links in chat
- **World quest limitation:** World quests in the objective tracker don't work yet. Use quest log or chat links instead.
- Won't interfere with Shift-Click stack splitting
- The addon extracts IDs directly from WoW's link data for 100% accuracy
- Dynamic icons - the popup shows the actual icon of what you clicked
- Works with both `/wh` and `/wowhead` commands
- The popup window can be dragged around your screen
- Window closes automatically on ESC or Ctrl+C
- Copying text in WoW automatically triggers your browser to open

## Version History

- **v1.3.0**: Added Objective Tracker support
  - Alt-Click quests in the objective tracker (including world quests!)
  - Styled popup window with PortraitFrameTemplate
  - Dynamic icons that match the clicked object
  - Auto-close on ESC or Ctrl+C
- **v1.2.0**: Added Achievement and Quest support
  - Alt-Click achievements in the achievement UI
  - Alt-Click quests in quest log
  - Alt-Click achievement/quest links in chat
  - Generates proper Wowhead URLs for all content types
- **v1.1.0**: Added Alt-Click functionality
  - Alt-Click any item for instant lookup
  - Works on items in bags, bank, chat, and tooltips
  - Won't interfere with Shift-Click stack splitting
- **v1.0.0**: Initial release
  - Basic `/wh` command functionality
  - Item link support
  - Copy-friendly popup that triggers browser opening

## Support

If you find any issues or have suggestions, feel free to modify the addon to suit your needs!

## License

Free to use and modify.
