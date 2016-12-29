@JS()
library ace;

import "package:js/js.dart";
import "dart:html" show HtmlElement;
import "package:code_steps/js_map.dart";

/// Type definitions for Ace Ajax.org Cloud9 Editor
/// Project: http://ace.ajax.org/
/// Definitions by: Diullei Gomes <https://github.com/Diullei>
/// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped

// Module AceAjax
@anonymous
@JS()
abstract class Delta {
  external String get action;
  external set action(String v);
  external AceRange get range;
  external set range(AceRange v);
  external String get text;
  external set text(String v);
  external List<String> get lines;
  external set lines(List<String> v);
  external factory Delta(
      {String action, AceRange range, String text, List<String> lines});
}

@anonymous
@JS()
abstract class EditorCommand {
  external String get name;
  external set name(String v);
  external dynamic get bindKey;
  external set bindKey(dynamic v);
  external Function get exec;
  external set exec(Function v);
  external bool get readOnly;
  external set readOnly(bool v);
  external factory EditorCommand(
      {String name, dynamic bindKey, Function exec, bool readOnly});
}

@anonymous
@JS()
abstract class CommandManager {
  external dynamic get byName;
  external set byName(dynamic v);
  external dynamic get commands;
  external set commands(dynamic v);
  external String get platform;
  external set platform(String v);
  external void addCommands(List<EditorCommand> commands);
  external void addCommand(EditorCommand command);
  external void exec(String name, Editor editor, dynamic args);
}

@anonymous
@JS()
abstract class Annotation {
  external num get row;
  external set row(num v);
  external num get column;
  external set column(num v);
  external String get text;
  external set text(String v);
  external String get type;
  external set type(String v);
  external factory Annotation({num row, num column, String text, String type});
}

@anonymous
@JS()
abstract class TokenInfo {
  external String get value;
  external set value(String v);
  external factory TokenInfo({String value});
}

@anonymous
@JS()
abstract class Position {
  external num get row;
  external set row(num v);
  external num get column;
  external set column(num v);
  external factory Position({num row, num column});
}

@anonymous
@JS()
abstract class KeyBinding {
  external void setDefaultHandler(dynamic kb);
  external void setKeyboardHandler(dynamic kb);
  external void addKeyboardHandler(dynamic kb, dynamic pos);
  external bool removeKeyboardHandler(dynamic kb);
  external dynamic getKeyboardHandler();
  external void onCommandKey(dynamic e, dynamic hashId, dynamic keyCode);
  external void onTextInput(dynamic text);
}

@anonymous
@JS()
abstract class TextMode {
  external dynamic getTokenizer();
  external void toggleCommentLines(
      dynamic state, dynamic doc, dynamic startRow, dynamic endRow);
  external String getNextLineIndent(dynamic state, dynamic line, dynamic tab);
  external bool checkOutdent(dynamic state, dynamic line, dynamic input);
  external void autoOutdent(dynamic state, dynamic doc, dynamic row);
  external dynamic createWorker(dynamic session);
  external void createModeDelegates(dynamic mapping);
  external dynamic transformAction(dynamic state, dynamic action,
      dynamic editor, dynamic session, dynamic param);
}

/// /////////////
/// Ace
/// /////////////
/// The main class required to set up an Ace instance in the browser.
@anonymous
@JS()
abstract class Ace {
  /// Provides access to require in packed noconflict mode
  external dynamic require(String moduleName);

  /// Embeds the Ace editor into the DOM, at the element provided by `el`.
  /*external Editor edit(String el);*/
  /// Embeds the Ace editor into the DOM, at the element provided by `el`.
  /*external Editor edit(HtmlElement el);*/
  external Editor edit(dynamic /*String|HtmlElement*/ el);

  /// Creates a new [[EditSession]], and returns the associated [[Document]].
  /*external IEditSession createEditSession(Document text, TextMode mode);*/
  /// Creates a new [[EditSession]], and returns the associated [[Document]].
  /*external IEditSession createEditSession(String text, TextMode mode);*/
  external IEditSession createEditSession(
      dynamic /*Document|String*/ text, TextMode mode);
}

/// /////////////
/// Anchor
/// /////////////
/// Defines the floating pointer in the document. Whenever text is inserted or deleted before the cursor, the position of the cursor is updated.
@JS("AceAjax.Anchor")
abstract class Anchor {
  external dynamic on(String event, dynamic fn(dynamic e));

  /// Returns an object identifying the `row` and `column` position of the current anchor.
  external Position getPosition();

  /// Returns the current document.
  external Document getDocument();

  /// Fires whenever the anchor position changes.
  /// Both of these objects have a `row` and `column` property corresponding to the position.
  /// Events that can trigger this function include [[Anchor.setPosition `setPosition()`]].
  /// - `old`: An object describing the old Anchor position
  /// - `value`: An object describing the new Anchor position
  external void onChange(dynamic e);

  /// Sets the anchor position to the specified row and column. If `noClip` is `true`, the position is not clipped.
  external void setPosition(num row, num column, bool noClip);

  /// When called, the `'change'` event listener is removed.
  external void detach();

  /// Creates a new `Anchor` and associates it with a document.
  external factory Anchor(Document doc, num row, num column);
}

/// /////////////////////////////
/// BackgroundTokenizer
/// /////////////////////////////
/// Tokenizes the current [[Document `Document`]] in the background, and caches the tokenized rows for future use.
/// If a certain row is changed, everything below that row is re-tokenized.
@JS("AceAjax.BackgroundTokenizer")
abstract class BackgroundTokenizer {
  external List<dynamic> get states;
  external set states(List<dynamic> v);

  /// Sets a new tokenizer for this object.
  external void setTokenizer(Tokenizer tokenizer);

  /// Sets a new document to associate with this object.
  external void setDocument(Document doc);

  /// Emits the `'update'` event. `firstRow` and `lastRow` are used to define the boundaries of the region to be updated.
  external void fireUpdateEvent(num firstRow, num lastRow);

  /// Starts tokenizing at the row indicated.
  external void start(num startRow);

  /// Stops tokenizing.
  external void stop();

  /// Gives list of tokens of the row. (tokens are cached)
  external List<TokenInfo> getTokens(num row);

  /// [Returns the state of tokenization at the end of a row.]{: #BackgroundTokenizer.getState}
  external String getState(num row);

  /// Creates a new `BackgroundTokenizer` object.
  external factory BackgroundTokenizer(Tokenizer tokenizer, Editor editor);
}

/// /////////////
/// Document
/// /////////////
/// Contains the text of the document. Document can be attached to several [[EditSession `EditSession`]]s.
/// At its core, `Document`s are just an array of strings, with each row in the document matching up to the array index.
@JS("AceAjax.Document")
abstract class Document {
  external dynamic on(String event, dynamic fn(dynamic e));

  /// Replaces all the lines in the current `Document` with the value of `text`.
  external void setValue(String text);

  /// Returns all the lines in the document as a single string, split by the new line character.
  external String getValue();

  /// Creates a new `Anchor` to define a floating point in the document.
  external void createAnchor(num row, num column);

  /// Returns the newline character that's being used, depending on the value of `newLineMode`.
  external String getNewLineCharacter();

  /// [Sets the new line mode.]{: #Document.setNewLineMode.desc}
  external void setNewLineMode(String newLineMode);

  /// [Returns the type of newlines being used; either `windows`, `unix`, or `auto`]{: #Document.getNewLineMode}
  external String getNewLineMode();

  /// Returns `true` if `text` is a newline character (either `\r\n`, `\r`, or `\n`).
  external bool isNewLine(String text);

  /// Returns a verbatim copy of the given line as it is in the document
  external String getLine(num row);

  /// Returns an array of strings of the rows between `firstRow` and `lastRow`. This function is inclusive of `lastRow`.
  external List<String> getLines(num firstRow, num lastRow);

  /// Returns all lines in the document as string array. Warning: The caller should not modify this array!
  external List<String> getAllLines();

  /// Returns the number of rows in the document.
  external num getLength();

  /// [Given a range within the document, this function returns all the text within that range as a single string.]{: #Document.getTextRange.desc}
  external String getTextRange(AceRange range);

  /// Inserts a block of `text` and the indicated `position`.
  external dynamic insert(Position position, String text);

  /// Inserts the elements in `lines` into the document, starting at the row index given by `row`. This method also triggers the `'change'` event.
  external dynamic insertLines(num row, List<String> lines);

  /// Inserts a new line into the document at the current row's `position`. This method also triggers the `'change'` event.
  external dynamic insertNewLine(Position position);

  /// Inserts `text` into the `position` at the current row. This method also triggers the `'change'` event.
  external dynamic insertInLine(dynamic position, String text);

  /// Removes the `range` from the document.
  external dynamic remove(AceRange range);

  /// Removes the specified columns from the `row`. This method also triggers the `'change'` event.
  external dynamic removeInLine(num row, num startColumn, num endColumn);

  /// Removes a range of full lines. This method also triggers the `'change'` event.
  external List<String> removeLines(num firstRow, num lastRow);

  /// Removes the new line between `row` and the row immediately following it. This method also triggers the `'change'` event.
  external void removeNewLine(num row);

  /// Replaces a range in the document with the new `text`.
  external dynamic replace(AceRange range, String text);

  /// Applies all the changes previously accumulated. These can be either `'includeText'`, `'insertLines'`, `'removeText'`, and `'removeLines'`.
  external void applyDeltas(List<Delta> deltas);

  /// Reverts any changes previously applied. These can be either `'includeText'`, `'insertLines'`, `'removeText'`, and `'removeLines'`.
  external void revertDeltas(List<Delta> deltas);

  /// Converts an index position in a document to a `{row, column}` object.
  /// Index refers to the "absolute position" of a character in the document. For example:
  /// ```javascript
  /// var x = 0; // 10 characters, plus one for newline
  /// var y = -1;
  /// ```
  /// Here, `y` is an index 15: 11 characters for the first row, and 5 characters until `y` in the second.
  external Position indexToPosition(num index, num startRow);

  /// Converts the `{row, column}` position in a document to the character's index.
  /// Index refers to the "absolute position" of a character in the document. For example:
  /// ```javascript
  /// var x = 0; // 10 characters, plus one for newline
  /// var y = -1;
  /// ```
  /// Here, `y` is an index 15: 11 characters for the first row, and 5 characters until `y` in the second.
  external num positionToIndex(Position pos, num startRow);

  /// Creates a new `Document`. If `text` is included, the `Document` contains those strings; otherwise, it's empty.
  /*external factory Document([String text]);*/
  /// Creates a new `Document`. If `text` is included, the `Document` contains those strings; otherwise, it's empty.
  /*external factory Document([List<String> text]);*/
  external factory Document([dynamic /*String|List<String>*/ text]);
}

/// /////////////////////////////
/// EditSession
/// /////////////////////////////
/// Stores all the data about [[Editor `Editor`]] state providing easy way to change editors state.
/// `EditSession` can be attached to only one [[Document `Document`]]. Same `Document` can be attached to several `EditSession`s.
@anonymous
@JS()
abstract class IEditSession {
  external Selection get selection;
  external set selection(Selection v);
  external BackgroundTokenizer get bgTokenizer;
  external set bgTokenizer(BackgroundTokenizer v);
  external Document get doc;
  external set doc(Document v);
  external dynamic on(String event, dynamic fn(dynamic e));
  external void findMatchingBracket(Position position);
  external void addFold(String text, AceRange range);
  external dynamic getFoldAt(num row, num column);
  external void removeFold(dynamic arg);
  external void expandFold(dynamic arg);
  external void unfold(dynamic arg1, bool arg2);
  external void screenToDocumentColumn(num row, num column);
  external dynamic getFoldDisplayLine(
      dynamic foldLine, num docRow, num docColumn);
  external dynamic getFoldsInRange(AceRange range);
  external void highlight(String text);

  /// Sets the `EditSession` to point to a new `Document`. If a `BackgroundTokenizer` exists, it also points to `doc`.
  external void setDocument(Document doc);

  /// Returns the `Document` associated with this session.
  external Document getDocument();

  /// undefined
  external void $resetRowCache(num row);

  /// Sets the session text.
  external void setValue(String text);
  external void setMode(String mode);

  /// Returns the current [[Document `Document`]] as a string.
  external String getValue();

  /// Returns the string of the current selection.
  external Selection getSelection();

  /// {:BackgroundTokenizer.getState}
  external String getState(num row);

  /// Starts tokenizing at the row indicated. Returns a list of objects of the tokenized rows.
  external List<TokenInfo> getTokens(num row);

  /// Returns an object indicating the token at the current row. The object has two properties: `index` and `start`.
  external TokenInfo getTokenAt(num row, num column);

  /// Sets the undo manager.
  external void setUndoManager(UndoManager undoManager);

  /// Returns the current undo manager.
  external UndoManager getUndoManager();

  /// Returns the current value for tabs. If the user is using soft tabs, this will be a series of spaces (defined by [[EditSession.getTabSize `getTabSize()`]]): void; otherwise it's simply `'\t'`.
  external String getTabString();

  /// Pass `true` to enable the use of soft tabs. Soft tabs means you're using spaces instead of the tab character (`'\t'`).
  external void setUseSoftTabs(bool useSoftTabs);

  /// Returns `true` if soft tabs are being used, `false` otherwise.
  external bool getUseSoftTabs();

  /// Set the number of spaces that define a soft tab; for example, passing in `4` transforms the soft tabs to be equivalent to four spaces. This function also emits the `changeTabSize` event.
  external void setTabSize(num tabSize);

  /// Returns the current tab size.
  external num getTabSize();

  /// Returns `true` if the character at the position is a soft tab.
  external bool isTabStop(dynamic position);

  /// Pass in `true` to enable overwrites in your session, or `false` to disable.
  /// If overwrites is enabled, any text you enter will type over any text after it. If the value of `overwrite` changes, this function also emites the `changeOverwrite` event.
  external void setOverwrite(bool overwrite);

  /// Returns `true` if overwrites are enabled; `false` otherwise.
  external bool getOverwrite();

  /// Sets the value of overwrite to the opposite of whatever it currently is.
  external void toggleOverwrite();

  /// Adds `className` to the `row`, to be used for CSS stylings and whatnot.
  external void addGutterDecoration(num row, String className);

  /// Removes `className` from the `row`.
  external void removeGutterDecoration(num row, String className);

  /// Returns an array of numbers, indicating which rows have breakpoints.
  external List<num> getBreakpoints();

  /// Sets a breakpoint on every row number given by `rows`. This function also emites the `'changeBreakpoint'` event.
  external void setBreakpoints(List<dynamic> rows);

  /// Removes all breakpoints on the rows. This function also emites the `'changeBreakpoint'` event.
  external void clearBreakpoints();

  /// Sets a breakpoint on the row number given by `rows`. This function also emites the `'changeBreakpoint'` event.
  external void setBreakpoint(num row, String className);

  /// Removes a breakpoint on the row number given by `rows`. This function also emites the `'changeBreakpoint'` event.
  external void clearBreakpoint(num row);

  /// Adds a new marker to the given `Range`. If `inFront` is `true`, a front marker is defined, and the `'changeFrontMarker'` event fires; otherwise, the `'changeBackMarker'` event fires.
  /*external num addMarker(Range range, String clazz, Function type, bool inFront);*/
  /// Adds a new marker to the given `Range`. If `inFront` is `true`, a front marker is defined, and the `'changeFrontMarker'` event fires; otherwise, the `'changeBackMarker'` event fires.
  /*external num addMarker(Range range, String clazz, String type, bool inFront);*/
  external num addMarker(AceRange range, String clazz,
      dynamic /*Function|String*/ type, bool inFront);

  /// Adds a dynamic marker to the session.
  external void addDynamicMarker(dynamic marker, bool inFront);

  /// Removes the marker with the specified ID. If this marker was in front, the `'changeFrontMarker'` event is emitted. If the marker was in the back, the `'changeBackMarker'` event is emitted.
  external void removeMarker(num markerId);

  /// Returns an array containing the IDs of all the markers, either front or back.
  external dynamic getMarkers(bool inFront);

  /// Sets annotations for the `EditSession`. This functions emits the `'changeAnnotation'` event.
  external void setAnnotations(List<Annotation> annotations);

  /// Returns the annotations for the `EditSession`.
  external dynamic getAnnotations();

  /// Clears all the annotations for this session. This function also triggers the `'changeAnnotation'` event.
  external void clearAnnotations();

  /// If `text` contains either the newline (`\n`) or carriage-return ('\r') characters, `$autoNewLine` stores that value.
  external void $detectNewLine(String text);

  /// Given a starting row and column, this method returns the `Range` of the first word boundary it finds.
  external AceRange getWordRange(num row, num column);

  /// Gets the range of a word, including its right whitespace.
  external dynamic getAWordRange(num row, num column);

  /// {:Document.setNewLineMode.desc}
  external void setNewLineMode(String newLineMode);

  /// Returns the current new line mode.
  external String getNewLineMode();

  /// Identifies if you want to use a worker for the `EditSession`.
  external void setUseWorker(bool useWorker);

  /// Returns `true` if workers are being used.
  external bool getUseWorker();

  /// Reloads all the tokens on the current session. This function calls [[BackgroundTokenizer.start `BackgroundTokenizer.start ()`]] to all the rows; it also emits the `'tokenizerUpdate'` event.
  external void onReloadTokenizer();

  /// Sets a new text mode for the `EditSession`. This method also emits the `'changeMode'` event. If a [[BackgroundTokenizer `BackgroundTokenizer`]] is set, the `'tokenizerUpdate'` event is also emitted.
  external void $mode(TextMode mode);

  /// Returns the current text mode.
  external TextMode getMode();

  /// This function sets the scroll top value. It also emits the `'changeScrollTop'` event.
  external void setScrollTop(num scrollTop);

  /// [Returns the value of the distance between the top of the editor and the topmost part of the visible content.]{: #EditSession.getScrollTop}
  external num getScrollTop();

  /// [Sets the value of the distance between the left of the editor and the leftmost part of the visible content.]{: #EditSession.setScrollLeft}
  external void setScrollLeft();

  /// [Returns the value of the distance between the left of the editor and the leftmost part of the visible content.]{: #EditSession.getScrollLeft}
  external num getScrollLeft();

  /// Returns the width of the screen.
  external num getScreenWidth();

  /// Returns a verbatim copy of the given line as it is in the document
  external String getLine(num row);

  /// Returns an array of strings of the rows between `firstRow` and `lastRow`. This function is inclusive of `lastRow`.
  external List<String> getLines(num firstRow, num lastRow);

  /// Returns the number of rows in the document.
  external num getLength();

  /// {:Document.getTextRange.desc}
  external String getTextRange(AceRange range);

  /// Inserts a block of `text` and the indicated `position`.
  external dynamic insert(Position position, String text);

  /// Removes the `range` from the document.
  external dynamic remove(AceRange range);

  /// Reverts previous changes to your document.
  external AceRange undoChanges(List<dynamic> deltas, bool dontSelect);

  /// Re-implements a previously undone change to your document.
  external AceRange redoChanges(List<dynamic> deltas, bool dontSelect);

  /// Enables or disables highlighting of the range where an undo occured.
  external void setUndoSelect(bool enable);

  /// Replaces a range in the document with the new `text`.
  external dynamic replace(AceRange range, String text);

  /// Moves a range of text from the given range to the given position. `toPosition` is an object that looks like this:
  /// ```json
  /// { row: newRowLocation, column: newColumnLocation }
  /// ```
  external AceRange moveText(AceRange fromRange, dynamic toPosition);

  /// Indents all the rows, from `startRow` to `endRow` (inclusive), by prefixing each row with the token in `indentString`.
  /// If `indentString` contains the `'\t'` character, it's replaced by whatever is defined by [[EditSession.getTabString `getTabString()`]].
  external void indentRows(num startRow, num endRow, String indentString);

  /// Outdents all the rows defined by the `start` and `end` properties of `range`.
  external void outdentRows(AceRange range);

  /// Shifts all the lines in the document up one, starting from `firstRow` and ending at `lastRow`.
  external num moveLinesUp(num firstRow, num lastRow);

  /// Shifts all the lines in the document down one, starting from `firstRow` and ending at `lastRow`.
  external num moveLinesDown(num firstRow, num lastRow);

  /// Duplicates all the text between `firstRow` and `lastRow`.
  external num duplicateLines(num firstRow, num lastRow);

  /// Sets whether or not line wrapping is enabled. If `useWrapMode` is different than the current value, the `'changeWrapMode'` event is emitted.
  external void setUseWrapMode(bool useWrapMode);

  /// Returns `true` if wrap mode is being used; `false` otherwise.
  external bool getUseWrapMode();

  /// Sets the boundaries of wrap. Either value can be `null` to have an unconstrained wrap, or, they can be the same number to pin the limit. If the wrap limits for `min` or `max` are different, this method also emits the `'changeWrapMode'` event.
  external void setWrapLimitRange(num min, num max);

  /// This should generally only be called by the renderer when a resize is detected.
  external bool adjustWrapLimit(num desiredLimit);

  /// Returns the value of wrap limit.
  external num getWrapLimit();

  /// Returns an object that defines the minimum and maximum of the wrap limit; it looks something like this:
  /// { min: wrapLimitRange_min, max: wrapLimitRange_max }
  external dynamic getWrapLimitRange();

  /// Given a string, returns an array of the display characters, including tabs and spaces.
  external void $getDisplayTokens(String str, num offset);

  /// Calculates the width of the string `str` on the screen while assuming that the string starts at the first column on the screen.
  external List<num> $getStringScreenWidth(
      String str, num maxScreenColumn, num screenColumn);

  /// Returns number of screenrows in a wrapped line.
  external num getRowLength(num row);

  /// Returns the position (on screen) for the last character in the provided screen row.
  external num getScreenLastRowColumn(num screenRow);

  /// For the given document row and column, this returns the column position of the last screen row.
  external num getDocumentLastRowColumn(num docRow, num docColumn);

  /// For the given document row and column, this returns the document position of the last row.
  external num getDocumentLastRowColumnPosition(num docRow, num docColumn);

  /// For the given row, this returns the split data.
  external String getRowSplitData();

  /// The distance to the next tab stop at the specified screen column.
  external num getScreenTabSize(num screenColumn);

  /// Converts characters coordinates on the screen to characters coordinates within the document. [This takes into account code folding, word wrap, tab size, and any other visual modifications.]{: #conversionConsiderations}
  external dynamic screenToDocumentPosition(num screenRow, num screenColumn);

  /// Converts document coordinates to screen coordinates. {:conversionConsiderations}
  external dynamic documentToScreenPosition(num docRow, num docColumn);

  /// For the given document row and column, returns the screen column.
  external num documentToScreenColumn(num row, num docColumn);

  /// For the given document row and column, returns the screen row.
  external void documentToScreenRow(num docRow, num docColumn);

  /// Returns the length of the screen.
  external num getScreenLength();
}

@JS("AceAjax.EditSession")
class EditSession {
  // @Ignore
  EditSession.fakeConstructor$();

  /// Sets up a new `EditSession` and associates it with the given `Document` and `TextMode`.
  /*external factory EditSession(String text, [TextMode mode]);*/
  /*external factory EditSession(String content, [String mode]);*/
  /*external factory EditSession(List<String> text, [String mode]);*/
  external factory EditSession(dynamic /*String|List<String>*/ text_content,
      [dynamic /*TextMode|String*/ mode]);
}

/// /////////////////////////////
/// Editor
/// /////////////////////////////
/// The main entry point into the Ace functionality.
/// The `Editor` manages the [[EditSession]] (which manages [[Document]]s), as well as the [[VirtualRenderer]], which draws everything to the screen.
/// Event sessions dealing with the mouse and keyboard are bubbled up from `Document` to the `Editor`, which decides what to do with them.
@JS("AceAjax.Editor")
abstract class Editor {
  external dynamic on(String ev, dynamic callback(dynamic e));
  /*external void addEventListener('change' ev, dynamic callback(EditorChangeEvent ev));*/
  /*external void addEventListener(String ev, Function callback);*/
  external void addEventListener(String /*'change'|String*/ ev,
      dynamic /*Func1<EditorChangeEvent, dynamic>|Function*/ callback);
  external bool get inMultiSelectMode;
  external set inMultiSelectMode(bool v);
  external void selectMoreLines(num n);
  external void onTextInput(String text);
  external void onCommandKey(dynamic e, dynamic hashId, dynamic keyCode);
  external CommandManager get commands;
  external set commands(CommandManager v);
  external IEditSession get session;
  external set session(IEditSession v);
  external Selection get selection;
  external set selection(Selection v);
  external VirtualRenderer get renderer;
  external set renderer(VirtualRenderer v);
  external KeyBinding get keyBinding;
  external set keyBinding(KeyBinding v);
  external HtmlElement get container;
  external set container(HtmlElement v);
  external void onSelectionChange(dynamic e);
  external void onChangeMode([dynamic e]);
  external void execCommand(String command, [dynamic args]);

  /// Sets a Configuration Option
  external void setOption(dynamic optionName, dynamic optionValue);

  /// Sets Configuration Options
  external void setOptions(dynamic keyValueTuples);

  /// Get a Configuration Option
  external dynamic getOption(dynamic name);

  /// Get Configuration Options
  external dynamic getOptions();

  /// Get rid of console warning by setting this to Infinity
  external num get $blockScrolling;
  external set $blockScrolling(num v);

  /// Sets a new key handler, such as "vim" or "windows".
  external void setKeyboardHandler(String keyboardHandler);

  /// Returns the keyboard handler, such as "vim" or "windows".
  external String getKeyboardHandler();

  /// Sets a new editsession to use. This method also emits the `'changeSession'` event.
  external void setSession(IEditSession session);

  /// Returns the current session being used.
  external IEditSession getSession();

  /// Sets the current document to `val`.
  external String setValue(String val, [num cursorPos]);

  /// Returns the current session's content.
  external String getValue();

  /// Returns the currently highlighted selection.
  external Selection getSelection();

  /// {:VirtualRenderer.onResize}
  external void resize([bool force]);

  /// {:VirtualRenderer.setTheme}
  external void setTheme(String theme);

  /// {:VirtualRenderer.getTheme}
  external String getTheme();

  /// {:VirtualRenderer.setStyle}
  external void setStyle(String style);

  /// {:VirtualRenderer.unsetStyle}
  external void unsetStyle();

  /// Set a new font size (in pixels) for the editor text.
  external void setFontSize(String size);

  /// Brings the current `textInput` into focus.
  external void focus();

  /// Returns `true` if the current `textInput` is in focus.
  external void isFocused();

  /// Blurs the current `textInput`.
  external void blur();

  /// Emitted once the editor comes into focus.
  external void onFocus();

  /// Emitted once the editor has been blurred.
  external void onBlur();

  /// Emitted whenever the document is changed.
  external void onDocumentChange(dynamic e);

  /// Emitted when the selection changes.
  external void onCursorChange();

  /// Returns the string of text currently highlighted.
  external String getCopyText();

  /// Called whenever a text "copy" happens.
  external void onCopy();

  /// Called whenever a text "cut" happens.
  external void onCut();

  /// Called whenever a text "paste" happens.
  external void onPaste(String text);

  /// Inserts `text` into wherever the cursor is pointing.
  external void insert(String text);

  /// Pass in `true` to enable overwrites in your session, or `false` to disable. If overwrites is enabled, any text you enter will type over any text after it. If the value of `overwrite` changes, this function also emites the `changeOverwrite` event.
  external void setOverwrite(bool overwrite);

  /// Returns `true` if overwrites are enabled; `false` otherwise.
  external bool getOverwrite();

  /// Sets the value of overwrite to the opposite of whatever it currently is.
  external void toggleOverwrite();

  /// Sets how fast the mouse scrolling should do.
  external void setScrollSpeed(num speed);

  /// Returns the value indicating how fast the mouse scroll speed is (in milliseconds).
  external num getScrollSpeed();

  /// Sets the delay (in milliseconds) of the mouse drag.
  external void setDragDelay(num dragDelay);

  /// Returns the current mouse drag delay.
  external num getDragDelay();

  /// Indicates how selections should occur.
  /// By default, selections are set to "line". There are no other styles at the moment,
  /// although this code change in the future.
  /// This function also emits the `'changeSelectionStyle'` event.
  external void setSelectionStyle(String style);

  /// Returns the current selection style.
  external String getSelectionStyle();

  /// Determines whether or not the current line should be highlighted.
  external void setHighlightActiveLine(bool shouldHighlight);

  /// Returns `true` if current lines are always highlighted.
  external void getHighlightActiveLine();

  /// Determines if the currently selected word should be highlighted.
  external void setHighlightSelectedWord(bool shouldHighlight);

  /// Returns `true` if currently highlighted words are to be highlighted.
  external bool getHighlightSelectedWord();

  /// If `showInvisibiles` is set to `true`, invisible characters&mdash;like spaces or new lines&mdash;are show in the editor.
  external void setShowInvisibles(bool showInvisibles);

  /// Returns `true` if invisible characters are being shown.
  external bool getShowInvisibles();

  /// If `showPrintMargin` is set to `true`, the print margin is shown in the editor.
  external void setShowPrintMargin(bool showPrintMargin);

  /// Returns `true` if the print margin is being shown.
  external bool getShowPrintMargin();

  /// Sets the column defining where the print margin should be.
  external void setPrintMarginColumn(num showPrintMargin);

  /// Returns the column number of where the print margin is.
  external num getPrintMarginColumn();

  /// If `readOnly` is true, then the editor is set to read-only mode, and none of the content can change.
  external void setReadOnly(bool readOnly);

  /// Returns `true` if the editor is set to read-only mode.
  external bool getReadOnly();

  /// Specifies whether to use behaviors or not. ["Behaviors" in this case is the auto-pairing of special characters, like quotation marks, parenthesis, or brackets.]{: #BehaviorsDef}
  external void setBehavioursEnabled(bool enabled);

  /// Returns `true` if the behaviors are currently enabled. {:BehaviorsDef}
  external bool getBehavioursEnabled();

  /// Specifies whether to use wrapping behaviors or not, i.e. automatically wrapping the selection with characters such as brackets
  /// when such a character is typed in.
  external void setWrapBehavioursEnabled(bool enabled);

  /// Returns `true` if the wrapping behaviors are currently enabled.
  external void getWrapBehavioursEnabled();

  /// Indicates whether the fold widgets are shown or not.
  external void setShowFoldWidgets(bool show);

  /// Returns `true` if the fold widgets are shown.
  external void getShowFoldWidgets();

  /// Removes words of text from the editor. A "word" is defined as a string of characters bookended by whitespace.
  external void remove(String dir);

  /// Removes the word directly to the right of the current selection.
  external void removeWordRight();

  /// Removes the word directly to the left of the current selection.
  external void removeWordLeft();

  /// Removes all the words to the left of the current selection, until the start of the line.
  external void removeToLineStart();

  /// Removes all the words to the right of the current selection, until the end of the line.
  external void removeToLineEnd();

  /// Splits the line at the current selection (by inserting an `'\n'`).
  external void splitLine();

  /// Transposes current line.
  external void transposeLetters();

  /// Converts the current selection entirely into lowercase.
  external void toLowerCase();

  /// Converts the current selection entirely into uppercase.
  external void toUpperCase();

  /// Inserts an indentation into the current cursor position or indents the selected lines.
  external void indent();

  /// Indents the current line.
  external void blockIndent();

  /// Outdents the current line.
  external void blockOutdent([String arg]);

  /// Given the currently selected range, this function either comments all the lines, or uncomments all of them.
  external void toggleCommentLines();

  /// Works like [[EditSession.getTokenAt]], except it returns a number.
  external num getNumberAt();

  /// If the character before the cursor is a number, this functions changes its value by `amount`.
  external void modifyNumber(num amount);

  /// Removes all the lines in the current selection
  external void removeLines();

  /// Shifts all the selected lines down one row.
  external num moveLinesDown();

  /// Shifts all the selected lines up one row.
  external num moveLinesUp();

  /// Moves a range of text from the given range to the given position. `toPosition` is an object that looks like this:
  /// ```json
  /// { row: newRowLocation, column: newColumnLocation }
  /// ```
  external AceRange moveText(AceRange fromRange, dynamic toPosition);

  /// Copies all the selected lines up one row.
  external num copyLinesUp();

  /// Copies all the selected lines down one row.
  external num copyLinesDown();

  /// {:VirtualRenderer.getFirstVisibleRow}
  external num getFirstVisibleRow();

  /// {:VirtualRenderer.getLastVisibleRow}
  external num getLastVisibleRow();

  /// Indicates if the row is currently visible on the screen.
  external bool isRowVisible(num row);

  /// Indicates if the entire row is currently visible on the screen.
  external bool isRowFullyVisible(num row);

  /// Selects the text from the current position of the document until where a "page down" finishes.
  external void selectPageDown();

  /// Selects the text from the current position of the document until where a "page up" finishes.
  external void selectPageUp();

  /// Shifts the document to wherever "page down" is, as well as moving the cursor position.
  external void gotoPageDown();

  /// Shifts the document to wherever "page up" is, as well as moving the cursor position.
  external void gotoPageUp();

  /// Scrolls the document to wherever "page down" is, without changing the cursor position.
  external void scrollPageDown();

  /// Scrolls the document to wherever "page up" is, without changing the cursor position.
  external void scrollPageUp();

  /// Moves the editor to the specified row.
  external void scrollToRow();

  /// Scrolls to a line. If `center` is `true`, it puts the line in middle of screen (or attempts to).
  external void scrollToLine(
      num line, bool center, bool animate, Function callback);

  /// Attempts to center the current selection on the screen.
  external void centerSelection();

  /// Gets the current position of the cursor.
  external Position getCursorPosition();

  /// Returns the screen position of the cursor.
  external num getCursorPositionScreen();

  /// {:Selection.getRange}
  external AceRange getSelectionRange();

  /// Selects all the text in editor.
  external void selectAll();

  /// {:Selection.clearSelection}
  external void clearSelection();

  /// Moves the cursor to the specified row and column. Note that this does not de-select the current selection.
  external void moveCursorTo(num row, [num column, bool animate]);

  /// Moves the cursor to the position indicated by `pos.row` and `pos.column`.
  external void moveCursorToPosition(Position position);

  /// Moves the cursor's row and column to the next matching bracket.
  external void jumpToMatching();

  /// Moves the cursor to the specified line number, and also into the indiciated column.
  external void gotoLine(num lineNumber, [num column, bool animate]);

  /// Moves the cursor to the specified row and column. Note that this does de-select the current selection.
  external void navigateTo(num row, num column);

  /// Moves the cursor up in the document the specified number of times. Note that this does de-select the current selection.
  external void navigateUp([num times]);

  /// Moves the cursor down in the document the specified number of times. Note that this does de-select the current selection.
  external void navigateDown([num times]);

  /// Moves the cursor left in the document the specified number of times. Note that this does de-select the current selection.
  external void navigateLeft([num times]);

  /// Moves the cursor right in the document the specified number of times. Note that this does de-select the current selection.
  external void navigateRight(num times);

  /// Moves the cursor to the start of the current line. Note that this does de-select the current selection.
  external void navigateLineStart();

  /// Moves the cursor to the end of the current line. Note that this does de-select the current selection.
  external void navigateLineEnd();

  /// Moves the cursor to the end of the current file. Note that this does de-select the current selection.
  external void navigateFileEnd();

  /// Moves the cursor to the start of the current file. Note that this does de-select the current selection.
  external void navigateFileStart();

  /// Moves the cursor to the word immediately to the right of the current position. Note that this does de-select the current selection.
  external void navigateWordRight();

  /// Moves the cursor to the word immediately to the left of the current position. Note that this does de-select the current selection.
  external void navigateWordLeft();

  /// Replaces the first occurance of `options.needle` with the value in `replacement`.
  external void replace(String replacement, [dynamic options]);

  /// Replaces all occurances of `options.needle` with the value in `replacement`.
  external void replaceAll(String replacement, [dynamic options]);

  /// {:Search.getOptions} For more information on `options`, see [[Search `Search`]].
  external dynamic getLastSearchOptions();

  /// Attempts to find `needle` within the document. For more information on `options`, see [[Search `Search`]].
  external void find(String needle, [dynamic options, bool animate]);

  /// Performs another search for `needle` in the document. For more information on `options`, see [[Search `Search`]].
  external void findNext([dynamic options, bool animate]);

  /// Performs a search for `needle` backwards. For more information on `options`, see [[Search `Search`]].
  external void findPrevious([dynamic options, bool animate]);

  /// {:UndoManager.undo}
  external void undo();

  /// {:UndoManager.redo}
  external void redo();

  /// Cleans up the entire editor.
  external void destroy();

  /// Creates a new `Editor` object.
  external factory Editor(VirtualRenderer renderer, [IEditSession session]);
}

@anonymous
@JS()
abstract class EditorChangeEvent {
  external Position get start;
  external set start(Position v);
  external Position get end;
  external set end(Position v);
  external String get action;
  external set action(String v);
  external List<dynamic> get lines;
  external set lines(List<dynamic> v);
  external factory EditorChangeEvent(
      {Position start, Position end, String action, List<dynamic> lines});
}

/// /////////////////////////////
/// PlaceHolder
/// /////////////////////////////
@JS("AceAjax.PlaceHolder")
abstract class PlaceHolder {
  external dynamic on(String event, dynamic fn(dynamic e));

  /// PlaceHolder.setup()
  /// TODO
  external void setup();

  /// PlaceHolder.showOtherMarkers()
  /// TODO
  external void showOtherMarkers();

  /// PlaceHolder.hideOtherMarkers()
  /// Hides all over markers in the [[EditSession `EditSession`]] that are not the currently selected one.
  external void hideOtherMarkers();

  /// PlaceHolder@onUpdate(e)
  /// Emitted when the place holder updates.
  external void onUpdate();

  /// PlaceHolder@onCursorChange(e)
  /// Emitted when the cursor changes.
  external void onCursorChange();

  /// PlaceHolder.detach()
  /// TODO
  external void detach();

  /// PlaceHolder.cancel()
  /// TODO
  external void cancel();

  /// -
  /// -
  /// -
  /// -
  /// -
  /// -
  /*external factory PlaceHolder(Document session, num length, num pos, String others, String mainClass, String othersClass);*/
  /*external factory PlaceHolder(IEditSession session, num length, Position pos, List<Position> positions);*/
  external factory PlaceHolder(
      dynamic /*Document|IEditSession*/ session,
      num length,
      dynamic /*num|Position*/ pos,
      dynamic /*String|List<Position>*/ others_positions,
      [String mainClass,
      String othersClass]);
}

/// /////////////
/// RangeList
/// /////////////
@anonymous
@JS()
abstract class IRangeList {
  external List<AceRange> get ranges;
  external set ranges(List<AceRange> v);
  external void pointIndex(Position pos, [num startIndex]);
  external void addList(List<AceRange> ranges);
  external void add(AceRange ranges);
  external List<AceRange> merge();
  external void substractPoint(Position pos);
}

@JS("AceAjax.RangeList")
class RangeList {
  // @Ignore
  RangeList.fakeConstructor$();
  external factory RangeList();
}

@JS()
@anonymous
class Marker {
  external String get clazz;
  external int get id;
  external AceRange get range;
  external String get type;
}

/// /////////////
/// Range
/// /////////////
/// This object is used in various places to indicate a region within the editor. To better visualize how this works, imagine a rectangle. Each quadrant of the rectangle is analogus to a range, as ranges contain a starting row and starting column, and an ending row, and ending column.

// requires AceRange to be manually loaded in JS as global
@JS()
abstract class AceRange {
  external num get startRow;
  external set startRow(num v);
  external num get startColumn;
  external set startColumn(num v);
  external num get endRow;
  external set endRow(num v);
  external num get endColumn;
  external set endColumn(num v);
  external Position get start;
  external set start(Position v);
  external Position get end;
  external set end(Position v);
  external bool isEmpty();

  /// Returns `true` if and only if the starting row and column, and ending row and column, are equivalent to those given by `range`.
  external bool isEqual(AceRange range);

  /// Returns a string containing the range's row and column information, given like this:
  /// ```
  /// [start.row/start.column] -> [end.row/end.column]
  /// ```
  external String toString(); // weird export??

  /// Returns `true` if the `row` and `column` provided are within the given range. This can better be expressed as returning `true` if:
  /// ```javascript
  /// this.start.row <= row <= this.end.row &&
  /// this.start.column <= column <= this.end.column
  /// ```
  external bool contains(num row, num column);

  /// Compares `this` range (A) with another range (B).
  external num compareRange(AceRange range);

  /// Checks the row and column points of `p` with the row and column points of the calling range.
  external num comparePoint(Position p);

  /// Checks the start and end points of `range` and compares them to the calling range. Returns `true` if the `range` is contained within the caller's range.
  external bool containsRange(AceRange range);

  /// Returns `true` if passed in `range` intersects with the one calling this method.
  external bool intersects(AceRange range);

  /// Returns `true` if the caller's ending row point is the same as `row`, and if the caller's ending column is the same as `column`.
  external bool isEnd(num row, num column);

  /// Returns `true` if the caller's starting row point is the same as `row`, and if the caller's starting column is the same as `column`.
  external bool isStart(num row, num column);

  /// Sets the starting row and column for the range.
  external void setStart(num row, num column);

  /// Sets the starting row and column for the range.
  external void setEnd(num row, num column);

  /// Returns `true` if the `row` and `column` are within the given range.
  external bool inside(num row, num column);

  /// Returns `true` if the `row` and `column` are within the given range's starting points.
  external bool insideStart(num row, num column);

  /// Returns `true` if the `row` and `column` are within the given range's ending points.
  external bool insideEnd(num row, num column);

  /// Checks the row and column points with the row and column points of the calling range.
  external num compare(num row, num column);

  /// Checks the row and column points with the row and column points of the calling range.
  external num compareStart(num row, num column);

  /// Checks the row and column points with the row and column points of the calling range.
  external num compareEnd(num row, num column);

  /// Checks the row and column points with the row and column points of the calling range.
  external num compareInside(num row, num column);

  /// Returns the part of the current `Range` that occurs within the boundaries of `firstRow` and `lastRow` as a new `Range` object.
  external AceRange clipRows(num firstRow, num lastRow);

  /// Changes the row and column points for the calling range for both the starting and ending points.
  external AceRange extend(num row, num column);

  /// Returns `true` if the range spans across multiple lines.
  external bool isMultiLine();

  /// Returns a duplicate of the calling range.
  external AceRange clone();

  /// Returns a range containing the starting and ending rows of the original range, but with a column value of `0`.
  external AceRange collapseRows();

  /// Given the current `Range`, this function converts those starting and ending points into screen positions, and then returns a new `Range` object.
  external AceRange toScreenRange(IEditSession session);

  /// Creates and returns a new `Range` based on the row and column of the given parameters.
  /*external Range fromPoints(Range start, Range end);*/
  /*external Range fromPoints(Position pos1, Position pos2);*/
  external static AceRange fromPoints(dynamic /*Range|Position*/ start_pos1,
      dynamic /*Range|Position*/ end_pos2);
  external factory AceRange(num startRow, num startColumn, num endRow, num endColumn);
}

/// /////////////
/// RenderLoop
/// /////////////
@JS("AceAjax.RenderLoop")
abstract class RenderLoop {
  external factory RenderLoop();
}

/// /////////////
/// ScrollBar
/// /////////////
/// A set of methods for setting and retrieving the editor's scrollbar.
@JS("AceAjax.ScrollBar")
abstract class ScrollBar {
  /// Emitted when the scroll bar, well, scrolls.
  external void onScroll(dynamic e);

  /// Returns the width of the scroll bar.
  external num getWidth();

  /// Sets the height of the scroll bar, in pixels.
  external void setHeight(num height);

  /// Sets the inner height of the scroll bar, in pixels.
  external void setInnerHeight(num height);

  /// Sets the scroll top of the scroll bar.
  external void setScrollTop(num scrollTop);

  /// Creates a new `ScrollBar`. `parent` is the owner of the scroll bar.
  external factory ScrollBar(HtmlElement parent);
}

/// /////////////
/// Search
/// /////////////
/// A class designed to handle all sorts of text searches within a [[Document `Document`]].
@JS("AceAjax.Search")
abstract class Search {
  /// Sets the search options via the `options` parameter.
  external Search JS$set(dynamic options);

  /// [Returns an object containing all the search options.]{: #Search.getOptions}
  external dynamic getOptions();

  /// Sets the search options via the `options` parameter.
  external void setOptions(dynamic An);

  /// Searches for `options.needle`. If found, this method returns the [[Range `Range`]] where the text first occurs. If `options.backwards` is `true`, the search goes backwards in the session.
  external AceRange find(IEditSession session);

  /// Searches for all occurances `options.needle`. If found, this method returns an array of [[Range `Range`s]] where the text first occurs. If `options.backwards` is `true`, the search goes backwards in the session.
  external List<AceRange> findAll(IEditSession session);

  /// Searches for `options.needle` in `input`, and, if found, replaces it with `replacement`.
  /// + (String): If `options.regExp` is `true`, this function returns `input` with the replacement already made. Otherwise, this function just returns `replacement`.<br/>
  /// If `options.needle` was not found, this function returns `null`.
  external String replace(String input, String replacement);

  /// Creates a new `Search` object. The following search options are avaliable:
  /// - `needle`: The string or regular expression you're looking for
  /// - `backwards`: Whether to search backwards from where cursor currently is. Defaults to `false`.
  /// - `wrap`: Whether to wrap the search back to the beginning when it hits the end. Defaults to `false`.
  /// - `caseSensitive`: Whether the search ought to be case-sensitive. Defaults to `false`.
  /// - `wholeWord`: Whether the search matches only on whole words. Defaults to `false`.
  /// - `range`: The [[Range]] to search within. Set this to `null` for the whole document
  /// - `regExp`: Whether the search is a regular expression or not. Defaults to `false`.
  /// - `start`: The starting [[Range]] or cursor position to begin the search
  /// - `skipCurrent`: Whether or not to include the current line in the search. Default to `false`.
  external factory Search();
}

/// /////////////
/// Search
/// /////////////
/// Contains the cursor position and the text selection of an edit session.
/// The row/columns used in the selection are in document coordinates representing ths coordinates as thez appear in the document before applying soft wrap and folding.
@JS("AceAjax.Selection")
abstract class Selection {
  external void addEventListener(String ev, Function callback);
  external void moveCursorWordLeft();
  external void moveCursorWordRight();
  external void fromOrientedRange(AceRange range);
  external void setSelectionRange(dynamic match);
  external List<AceRange> getAllRanges();
  external dynamic on(String event, dynamic fn(dynamic e));
  external void addRange(AceRange range);

  /// Returns `true` if the selection is empty.
  external bool isEmpty();

  /// Returns `true` if the selection is a multi-line.
  external bool isMultiLine();

  /// Gets the current position of the cursor.
  external Position getCursor();

  /// Sets the row and column position of the anchor. This function also emits the `'changeSelection'` event.
  external void setSelectionAnchor(num row, num column);

  /// Returns an object containing the `row` and `column` of the calling selection anchor.
  external dynamic getSelectionAnchor();

  /// Returns an object containing the `row` and `column` of the calling selection lead.
  external dynamic getSelectionLead();

  /// Shifts the selection up (or down, if [[Selection.isBackwards `isBackwards()`]] is true) the given number of columns.
  external void shiftSelection(num columns);

  /// Returns `true` if the selection is going backwards in the document.
  external bool isBackwards();

  /// [Returns the [[Range]] for the selected text.]{: #Selection.getRange}
  external AceRange getRange();

  /// [Empties the selection (by de-selecting it). This function also emits the `'changeSelection'` event.]{: #Selection.clearSelection}
  external void clearSelection();

  /// Selects all the text in the document.
  external void selectAll();

  /// Sets the selection to the provided range.
  external void setRange(AceRange range, bool reverse);

  /// Moves the selection cursor to the indicated row and column.
  external void selectTo(num row, num column);

  /// Moves the selection cursor to the row and column indicated by `pos`.
  external void selectToPosition(dynamic pos);

  /// Moves the selection up one row.
  external void selectUp();

  /// Moves the selection down one row.
  external void selectDown();

  /// Moves the selection right one column.
  external void selectRight();

  /// Moves the selection left one column.
  external void selectLeft();

  /// Moves the selection to the beginning of the current line.
  external void selectLineStart();

  /// Moves the selection to the end of the current line.
  external void selectLineEnd();

  /// Moves the selection to the end of the file.
  external void selectFileEnd();

  /// Moves the selection to the start of the file.
  external void selectFileStart();

  /// Moves the selection to the first word on the right.
  external void selectWordRight();

  /// Moves the selection to the first word on the left.
  external void selectWordLeft();

  /// Moves the selection to highlight the entire word.
  external void getWordRange();

  /// Selects an entire word boundary.
  external void selectWord();

  /// Selects a word, including its right whitespace.
  external void selectAWord();

  /// Selects the entire line.
  external void selectLine();

  /// Moves the cursor up one row.
  external void moveCursorUp();

  /// Moves the cursor down one row.
  external void moveCursorDown();

  /// Moves the cursor left one column.
  external void moveCursorLeft();

  /// Moves the cursor right one column.
  external void moveCursorRight();

  /// Moves the cursor to the start of the line.
  external void moveCursorLineStart();

  /// Moves the cursor to the end of the line.
  external void moveCursorLineEnd();

  /// Moves the cursor to the end of the file.
  external void moveCursorFileEnd();

  /// Moves the cursor to the start of the file.
  external void moveCursorFileStart();

  /// Moves the cursor to the word on the right.
  external void moveCursorLongWordRight();

  /// Moves the cursor to the word on the left.
  external void moveCursorLongWordLeft();

  /// Moves the cursor to position indicated by the parameters. Negative numbers move the cursor backwards in the document.
  external void moveCursorBy(num rows, num chars);

  /// Moves the selection to the position indicated by its `row` and `column`.
  external void moveCursorToPosition(dynamic position);

  /// Moves the cursor to the row and column provided. [If `preventUpdateDesiredColumn` is `true`, then the cursor stays in the same column position as its original point.]{: #preventUpdateBoolDesc}
  external void moveCursorTo(num row, num column, [bool keepDesiredColumn]);

  /// Moves the cursor to the screen position indicated by row and column. {:preventUpdateBoolDesc}
  external void moveCursorToScreen(num row, num column, bool keepDesiredColumn);

  /// Creates a new `Selection` object.
  external factory Selection(IEditSession session);
}

/// /////////////
/// Split
/// /////////////
@JS("AceAjax.Split")
abstract class Split {
  /// Returns the number of splits.
  external num getSplits();

  /// Returns the editor identified by the index `idx`.
  external void getEditor(num idx);

  /// Returns the current editor.
  external Editor getCurrentEditor();

  /// Focuses the current editor.
  external void focus();

  /// Blurs the current editor.
  external void blur();

  /// Sets a theme for each of the available editors.
  external void setTheme(String theme);

  /// Sets the keyboard handler for the editor.
  external void setKeyboardHandler(String keybinding);

  /// Executes `callback` on all of the available editors.
  external void forEach(Function callback, String scope);

  /// Sets the font size, in pixels, for all the available editors.
  external void setFontSize(num size);

  /// Sets a new [[EditSession `EditSession`]] for the indicated editor.
  external void setSession(IEditSession session, num idx);

  /// Returns the orientation.
  external num getOrientation();

  /// Sets the orientation.
  external void setOrientation(num orientation);

  /// Resizes the editor.
  external void resize();
  external factory Split();
}

/// ///////////////
/// TokenIterator
/// ///////////////
/// This class provides an essay way to treat the document as a stream of tokens, and provides methods to iterate over these tokens.
@JS("AceAjax.TokenIterator")
abstract class TokenIterator {
  /// Tokenizes all the items from the current point to the row prior in the document.
  external List<String> stepBackward();

  /// Tokenizes all the items from the current point until the next row in the document. If the current point is at the end of the file, this function returns `null`. Otherwise, it returns the tokenized string.
  external String stepForward();

  /// Returns the current tokenized string.
  external TokenInfo getCurrentToken();

  /// Returns the current row.
  external num getCurrentTokenRow();

  /// Returns the current column.
  external num getCurrentTokenColumn();

  /// Creates a new token iterator object. The inital token index is set to the provided row and column coordinates.
  external factory TokenIterator(
      IEditSession session, num initialRow, num initialColumn);
}

/// ///////////////
/// Tokenizer
/// ///////////////
/// This class takes a set of highlighting rules, and creates a tokenizer out of them. For more information, see [the wiki on extending highlighters](https://github.com/ajaxorg/ace/wiki/Creating-or-Extending-an-Edit-Mode#wiki-extendingTheHighlighter).
@JS("AceAjax.Tokenizer")
abstract class Tokenizer {
  /// Returns an object containing two properties: `tokens`, which contains all the tokens; and `state`, the current state.
  external dynamic getLineTokens();

  /// Constructs a new tokenizer based on the given rules and flags.
  external factory Tokenizer(dynamic rules, String flag);
}

/// ///////////////
/// UndoManager
/// ///////////////
/// This object maintains the undo stack for an [[EditSession `EditSession`]].
@JS("AceAjax.UndoManager")
abstract class UndoManager {
  /// Provides a means for implementing your own undo manager. `options` has one property, `args`, an [[Array `Array`]], with two elements:
  /// - `args[0]` is an array of deltas
  /// - `args[1]` is the document to associate with
  external void execute(dynamic options);

  /// [Perform an undo operation on the document, reverting the last change.]{: #UndoManager.undo}
  external AceRange undo([bool dontSelect]);

  /// [Perform a redo operation on the document, reimplementing the last change.]{: #UndoManager.redo}
  external void redo(bool dontSelect);

  /// Destroys the stack of undo and redo redo operations.
  external void reset();

  /// Returns `true` if there are undo operations left to perform.
  external bool hasUndo();

  /// Returns `true` if there are redo operations left to perform.
  external bool hasRedo();

  /// Returns `true` if the dirty counter is 0
  external bool isClean();

  /// Sets dirty counter to 0
  external void markClean();

  /// Resets the current undo state and creates a new `UndoManager`.
  external factory UndoManager();
}

/// /////////////////
/// VirtualRenderer
/// /////////////////
/// The class that is responsible for drawing everything you see on the screen!
@JS("AceAjax.VirtualRenderer")
abstract class VirtualRenderer {
  external dynamic get scroller;
  external set scroller(dynamic v);
  external num get characterWidth;
  external set characterWidth(num v);
  external num get lineHeight;
  external set lineHeight(num v);
  external void screenToTextCoordinates(num left, num top);

  /// Associates the renderer with an [[EditSession `EditSession`]].
  external void setSession(IEditSession session);

  /// Triggers a partial update of the text, from the range given by the two parameters.
  external void updateLines(num firstRow, num lastRow);

  /// Triggers a full update of the text, for all the rows.
  external void updateText();

  /// Triggers a full update of all the layers, for all the rows.
  external void updateFull(bool force);

  /// Updates the font size.
  external void updateFontSize();

  /// [Triggers a resize of the editor.]{: #VirtualRenderer.onResize}
  external void onResize(bool force, num gutterWidth, num width, num height);

  /// Adjusts the wrap limit, which is the number of characters that can fit within the width of the edit area on screen.
  external void adjustWrapLimit();

  /// Identifies whether you want to have an animated scroll or not.
  external void setAnimatedScroll(bool shouldAnimate);

  /// Returns whether an animated scroll happens or not.
  external bool getAnimatedScroll();

  /// Identifies whether you want to show invisible characters or not.
  external void setShowInvisibles(bool showInvisibles);

  /// Returns whether invisible characters are being shown or not.
  external bool getShowInvisibles();

  /// Identifies whether you want to show the print margin or not.
  external void setShowPrintMargin(bool showPrintMargin);

  /// Returns whether the print margin is being shown or not.
  external bool getShowPrintMargin();

  /// Identifies whether you want to show the print margin column or not.
  external void setPrintMarginColumn(bool showPrintMargin);

  /// Returns whether the print margin column is being shown or not.
  external bool getPrintMarginColumn();

  /// Returns `true` if the gutter is being shown.
  external bool getShowGutter();

  /// Identifies whether you want to show the gutter or not.
  external void setShowGutter(bool show);

  /// Returns the root element containing this renderer.
  external HtmlElement getContainerElement();

  /// Returns the element that the mouse events are attached to
  external HtmlElement getMouseEventTarget();

  /// Returns the element to which the hidden text area is added.
  external HtmlElement getTextAreaContainer();

  /// [Returns the index of the first visible row.]{: #VirtualRenderer.getFirstVisibleRow}
  external num getFirstVisibleRow();

  /// Returns the index of the first fully visible row. "Fully" here means that the characters in the row are not truncated; that the top and the bottom of the row are on the screen.
  external num getFirstFullyVisibleRow();

  /// Returns the index of the last fully visible row. "Fully" here means that the characters in the row are not truncated; that the top and the bottom of the row are on the screen.
  external num getLastFullyVisibleRow();

  /// [Returns the index of the last visible row.]{: #VirtualRenderer.getLastVisibleRow}
  external num getLastVisibleRow();

  /// Sets the padding for all the layers.
  external void setPadding(num padding);

  /// Returns whether the horizontal scrollbar is set to be always visible.
  external bool getHScrollBarAlwaysVisible();

  /// Identifies whether you want to show the horizontal scrollbar or not.
  external void setHScrollBarAlwaysVisible(bool alwaysVisible);

  /// Schedules an update to all the front markers in the document.
  external void updateFrontMarkers();

  /// Schedules an update to all the back markers in the document.
  external void updateBackMarkers();

  /// Deprecated; (moved to [[EditSession]])
  external void addGutterDecoration();

  /// Deprecated; (moved to [[EditSession]])
  external void removeGutterDecoration();

  /// Redraw breakpoints.
  external void updateBreakpoints();

  /// Sets annotations for the gutter.
  external void setAnnotations(List<dynamic> annotations);

  /// Updates the cursor icon.
  external void updateCursor();

  /// Hides the cursor icon.
  external void hideCursor();

  /// Shows the cursor icon.
  external void showCursor();

  /// Scrolls the cursor into the first visibile area of the editor
  external void scrollCursorIntoView();

  /// {:EditSession.getScrollTop}
  external num getScrollTop();

  /// {:EditSession.getScrollLeft}
  external num getScrollLeft();

  /// Returns the first visible row, regardless of whether it's fully visible or not.
  external num getScrollTopRow();

  /// Returns the last visible row, regardless of whether it's fully visible or not.
  external num getScrollBottomRow();

  /// Gracefully scrolls from the top of the editor to the row indicated.
  external void scrollToRow(num row);

  /// Gracefully scrolls the editor to the row indicated.
  external void scrollToLine(
      num line, bool center, bool animate, Function callback);

  /// Scrolls the editor to the y pixel indicated.
  external num scrollToY(num scrollTop);

  /// Scrolls the editor across the x-axis to the pixel indicated.
  external num scrollToX(num scrollLeft);

  /// Scrolls the editor across both x- and y-axes.
  external void scrollBy(num deltaX, num deltaY);

  /// Returns `true` if you can still scroll by either parameter; in other words, you haven't reached the end of the file or line.
  external bool isScrollableBy(num deltaX, num deltaY);

  /// Returns an object containing the `pageX` and `pageY` coordinates of the document position.
  external dynamic textToScreenCoordinates(num row, num column);

  /// Focuses the current container.
  external void visualizeFocus();

  /// Blurs the current container.
  external void visualizeBlur();

  /// undefined
  external void showComposition(num position);

  /// Sets the inner text of the current composition to `text`.
  external void setCompositionText(String text);

  /// Hides the current composition.
  external void hideComposition();

  /// [Sets a new theme for the editor. `theme` should exist, and be a directory path, like `ace/theme/textmate`.]{: #VirtualRenderer.setTheme}
  external void setTheme(String theme);

  /// [Returns the path of the current theme.]{: #VirtualRenderer.getTheme}
  external String getTheme();

  /// [Adds a new class, `style`, to the editor.]{: #VirtualRenderer.setStyle}
  external void setStyle(String style);

  /// [Removes the class `style` from the editor.]{: #VirtualRenderer.unsetStyle}
  external void unsetStyle(String style);

  /// Destroys the text and cursor layers for this renderer.
  external void destroy();

  /// Constructs a new `VirtualRenderer` within the `container` specified, applying the given `theme`.
  external factory VirtualRenderer(HtmlElement container, [String theme]);
}

// End module AceAjax
@JS()
external Ace get ace;
@JS()
external set ace(Ace v);

