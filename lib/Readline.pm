use v6;
use NativeCall;
#
# XXX &cglobal.signature -> (Any $libname, Any $symbol, Any $target-type)
#

=begin pod

=begin NAME

Readline - GNU Readline binding for perl6

=end NAME

=begin SYNOPSIS

    my $readline = Readline.new;
    while my $response = $readline.readline( "prompt here (<cr> to exit)> " ) {
        $readline.add-history( $response ) if $response ~~ /\S/;
        say "[$response]";
    }

=end SYNOPSIS

=begin DESCRIPTION

A thin OO wrapper around the GNU Readline library. It exposes every function that the current Readline library does, along with some of the structs for history and keymap manipulation from the header files, so that you can peek into the internals. Most people will just use the basic C<readline> and C<add-history> functions, but the more advanced keymapping, history and completion bindings are available for use.

Method names are taken verbatim from the GNU Readline library, with one exception. Library calls use '_', Readline methods use '-'. This helps keep the two layers separate, and is a not-so-subtle reminder that you're using perl6 when using the library.

The documentation in the METHODS section is a verbatim paste of the appropriate bits from the GNU Readline documentation, so for further explanation of the methods, especially callbacks and completion, please see the L<GNU Readline> documentation.

Any chapter references in the documentation refer to the GNU Readline or GNU History manual.

=end DESCRIPTION

=begin METHODS

=item readline( Str $prompt ) returns Str

=item rl-initialize( ) returns Int

    Initialize or re-initialize Readline's internal state. It's not strictly necessary to call this; readline() calls it before reading any input. 

=item rl-ding( ) returns Int

    Ring the terminal bell, obeying the setting of bell-style. 

=begin History

=item add-history( Str $history )

    Place string at the end of the history list. The associated data field (if any) is set to NULL. 

=item using-history( )

    Begin a session in which the history functions might be used. This initializes the interactive variables. 

    Author's note - C<add-history()> works fine without this call, maybe it's for methods that require state.

=item history-get-history-state( ) returns HISTORY_STATE

    Return a structure describing the current state of the input history. 

=item history-set-history-state( HISTORY_STATE $state )

    Set the state of the history list according to state. 

=item add-history-time( Str $timestamp )

    Change the time stamp associated with the most recent history entry to string. 

=item remove-history( Int $which ) returns HIST_ENTRY

    Remove history entry at offset which from the history. The removed element is returned so you can free the line, data, and containing structure. 

=item free-history-entry( HIST_ENTRY $entry ) returns histdata_t

    Free the history entry histent and any history library private data associated with it. Returns the application-specific data so the caller can dispose of it. 

=item replace-history-entry( Int $which, Str $line, histdata_t $data ) returns HIST_ENTRY

    Make the history entry at offset which have line and data. This returns the old entry so the caller can dispose of any application-specific data. In the case of an invalid which, a NULL pointer is returned. 

=item clear-history( )

    Clear the history list by deleting all the entries. 

=item stifle-history( Int $max )

    Stifle the history list, remembering only the last max entries. 

=item unstifle-history( )

    Stop stifling the history. This returns the previously-set maximum number of history entries (as set by stifle_history()). The value is positive if the history was stifled, negative if it wasn't. 

=item history-is-stifled( ) returns Bool

    Returns non-zero if the history is stifled, zero if it is not. 

=item history-list( ) returns CArray[HIST_ENTRY]

    Return a NULL terminated array of HIST_ENTRY * which is the current input history. Element 0 of this list is the beginning of time. If there is no history, return NULL. 

=item where-history( ) returns Int

    Returns the offset of the current history element. 

=item current-history( Int $which ) returns HIST_ENTRY

    Return the history entry at the current position, as determined by where_history(). If there is no entry there, return a NULL pointer. 

=item history-get( Int $which ) returns HIST_ENTRY

    Return the history entry at position offset, starting from history_base (see section 2.4 History Variables). If there is no entry there, or if offset is greater than the history length, return a NULL pointer. 

=item history-get-time( HIST_ENTRY $h ) returns time_t

    Return the time stamp associated with the history entry entry. 

=item history-total-bytes( ) returns Int

    Return the number of bytes that the primary history entries are using. This function returns the sum of the lengths of all the lines in the history. 

=item history-set-pos( Int $pos ) returns Int

    Set the current history offset to pos, an absolute index into the list. Returns 1 on success, 0 if pos is less than zero or greater than the number of history entries. 

=item previous-history( ) returns HIST_ENTRY

    Back up the current history offset to the previous history entry, and return a pointer to that entry. If there is no previous entry, return a NULL pointer. 

=item next-history( ) returns HIST_ENTRY

    Move the current history offset forward to the next history entry, and return the a pointer to that entry. If there is no next entry, return a NULL pointer. 

=item history-search( Str $text, Int $pos ) returns Int

    Search the history for string, starting at the current history offset. If direction is less than 0, then the search is through previous entries, otherwise through subsequent entries. If string is found, then the current history index is set to that history entry, and the value returned is the offset in the line of the entry where string was found. Otherwise, nothing is changed, and a -1 is returned. 

=item history-search-prefix( Str $text, Int $pos ) returns Int

    Search the history for string, starting at the current history offset. The search is anchored: matching lines must begin with string. If direction is less than 0, then the search is through previous entries, otherwise through subsequent entries. If string is found, then the current history index is set to that entry, and the return value is 0. Otherwise, nothing is changed, and a -1 is returned. 

=item history-search-pos( Str $text, Int $pos, Int $dir ) returns Int

    Search for string in the history list, starting at pos, an absolute index into the list. If direction is negative, the search proceeds backward from pos, otherwise forward. Returns the absolute index of the history element where string was found, or -1 otherwise. 

=item read-history( Str $text ) returns Int

    Add the contents of filename to the history list, a line at a time. If filename is NULL, then read from `~/.history'. Returns 0 if successful, or errno if not. 

=item read-history-range( Str $text, Int $from, Int $to ) returns Int

    Read a range of lines from filename, adding them to the history list. Start reading at line from and end at to. If from is zero, start at the beginning. If to is less than from, then read until the end of the file. If filename is NULL, then read from `~/.history'. Returns 0 if successful, or errno if not. 

=item write-history( Str $filename ) returns Int

    Write the current history to filename, overwriting filename if necessary. If filename is NULL, then write the history list to `~/.history'. Returns 0 on success, or errno on a read or write error. 

=item append-history( Int $offset, Str $filename ) returns Int

    Append the last nelements of the history list to filename. If filename is NULL, then append to `~/.history'. Returns 0 on success, or errno on a read or write error. 

=item history-truncate-file( Str $filename, Int $lines ) returns Int

    Truncate the history file filename, leaving only the last nlines lines. If filename is NULL, then `~/.history' is truncated. Returns 0 on success, or errno on failure. 

=item history-expand( Str $string, Pointer[Str] $output ) returns Int

    Expand string, placing the result into output, a pointer to a string (see section 1.1 History Expansion). Returns:

    0
        If no expansions took place (or, if the only change in the text was the removal of escape characters preceding the history expansion character); 
    1
        if expansions did take place; 
    -1
        if there was an error in expansion; 
    2
        if the returned line should be displayed, but not executed, as with the :p modifier (see section 1.1.3 Modifiers). 

    If an error occurred in expansion, then output contains a descriptive error message. 

=item history-arg-extract( Int $first, Int $last, Str $string ) returns Str

    Extract a string segment consisting of the first through last arguments present in string. Arguments are split using history_tokenize. 

=item get-history-event( Str $string, Pointer[Int] $index, Int $delimiting-quote ) returns Str

    Returns the text of the history event beginning at string + *cindex. *cindex is modified to point to after the event specifier. At function entry, cindex points to the index into string where the history event specification begins. qchar is a character that is allowed to end the event specification in addition to the "normal" terminating characters. 

=item history-tokenize( Str $string ) returns CArray[Str]

    Return an array of tokens parsed out of string, much as the shell might. The tokens are split on the characters in the history_word_delimiters variable, and shell quoting conventions are obeyed. 

=end History

=begin Keymap

=item rl-make-bare-keymap( ) returns Keymap

    Returns a new, empty keymap. The space for the keymap is allocated with malloc(); the caller should free it by calling rl_free_keymap() when done. 

=item rl-copy-keymap( Keymap $k ) returns Keymap

    Return a new keymap which is a copy of map. 

=item rl-make-keymap( ) returns Keymap

    Return a new keymap with the printing characters bound to rl_insert, the lowercase Meta characters bound to run their equivalents, and the Meta digits bound to produce numeric arguments. 

=item rl-discard-keymap( Keymap $k )

    Free the storage associated with the data in keymap. The caller should free keymap. 

=item rl-free-keymap( Keymap $k )

    Free all storage associated with keymap. This calls rl_discard_keymap to free subordindate keymaps and macros. 

=item rl-get-keymap-by-name( Str $name ) returns Keymap

    Return the keymap matching name. name is one which would be supplied in a set keymap inputrc line (see section 1.3 Readline Init File). 

=item rl-get-keymap( ) returns Keymap

    Returns the currently active keymap. 

=item rl-get-keymap-name( Keymap $k ) returns Str

    Return the name matching keymap. name is one which would be supplied in a set keymap inputrc line (see section 1.3 Readline Init File). 

=item rl-set-keymap( Keymap $k )

    Makes keymap the currently active keymap. 

=end Keymap

=begin Callback

=item rl-callback-handler-install( Str $s, rl_vcpfunc_t $cb )

    Set up the terminal for readline I/O and display the initial expanded value of prompt. Save the value of lhandler to use as a handler function to call when a complete line of input has been entered. The handler function receives the text of the line as an argument. 

=item rl-callback-read-char( )

    Whenever an application determines that keyboard input is available, it should call rl_callback_read_char(), which will read the next character from the current input source. If that character completes the line, rl_callback_read_char will invoke the lhandler function installed by rl_callback_handler_install to process the line. Before calling the lhandler function, the terminal settings are reset to the values they had before calling rl_callback_handler_install. If the lhandler function returns, and the line handler remains installed, the terminal settings are modified for Readline's use again. EOF is indicated by calling lhandler with a NULL line. 

=item rl-callback-handler-remove( )

    Restore the terminal to its initial state and remove the line handler. This may be called from within a callback as well as independently. If the lhandler installed by rl_callback_handler_install does not exit the program, either this function or the function referred to by the value of rl_deprep_term_function should be called before the program exits to reset the terminal settings. 

=end Callback

=begin Prompt

=item rl-set-prompt( Str $prompt ) returns Int

    Make Readline use prompt for subsequent redisplay. This calls rl_expand_prompt() to expand the prompt and sets rl_prompt to the result. 

=item rl-expand-prompt( Str $prompt ) returns Int

    Expand any special character sequences in prompt and set up the local Readline prompt redisplay variables. This function is called by readline(). It may also be called to expand the primary prompt if the rl_on_new_line_with_prompt() function or rl_already_prompted variable is used. It returns the number of visible characters on the last line of the (possibly multi-line) prompt. Applications may indicate that the prompt contains characters that take up no physical screen space when displayed by bracketing a sequence of such characters with the special markers RL_PROMPT_START_IGNORE and RL_PROMPT_END_IGNORE (declared in `readline.h'. This may be used to embed terminal-specific escape sequences in prompts. 

=end Prompt

=begin Binding

=item rl-bind-key( Int $i, rl_command_func_t $cb ) returns Int

    rl_bind_key() takes two arguments: key is the character that you want to bind, and function is the address of the function to call when key is pressed. Binding TAB to rl_insert() makes TAB insert itself. rl_bind_key() returns non-zero if key is not a valid ASCII character code (between 0 and 255).

=item rl-bind-key-in-map( Int $i, rl_command_func_t $cb, Keymap $k ) returns Int

    Bind key to function in map. Returns non-zero in the case of an invalid key. 
=item rl-unbind-key( Int $i ) returns Int

    Bind key to the null function in the currently active keymap. Returns non-zero in case of error. 

=item rl-unbind-key-in-map( Int $i, Keymap $k ) returns Int

    Bind key to the null function in map. Returns non-zero in case of error. 

=item rl-bind-key-if-unbound( Int $i, rl_command_func_t $cb ) returns Int

    Binds key to function if it is not already bound in the currently active keymap. Returns non-zero in the case of an invalid key or if key is already bound. 

=item rl-bind-key-if-unbound-in-map( Int $i, rl_command_func_t $cb, Keymap $k ) returns Int {

    Binds key to function if it is not already bound in map. Returns non-zero in the case of an invalid key or if key is already bound. 

=item rl-unbind-function-in-map ( rl_command_func_t $cb, Keymap $k ) returns Int

    Unbind all keys that execute function in map. 

=item rl-bind-keyseq( Str $str, rl_command_func_t $cb ) returns Int

    Bind the key sequence represented by the string keyseq to the function function, beginning in the current keymap. This makes new keymaps as necessary. The return value is non-zero if keyseq is invalid. 

=item rl-bind-keyseq-in-map( Str $str, rl_command_func_t $cb, Keymap $k )

    Bind the key sequence represented by the string keyseq to the function function. This makes new keymaps as necessary. Initial bindings are performed in map. The return value is non-zero if keyseq is invalid. 

=item rl-bind-keyseq-if-unbound( Str $str, rl_command_func_t $cb ) returns Int

    Binds keyseq to function if it is not already bound in the currently active keymap. Returns non-zero in the case of an invalid keyseq or if keyseq is already bound. 

=item rl-bind-keyseq-if-unbound-in-map( Str $str, rl_command_func_t $cb, Keymap $k ) returns Int

    Binds keyseq to function if it is not already bound in map. Returns non-zero in the case of an invalid keyseq or if keyseq is already bound. 

=item rl-generic-bind( Int $i, Str $s, Str $t, Keymap $k ) returns Int

    Bind the key sequence represented by the string keyseq to the arbitrary pointer data. type says what kind of data is pointed to by data; this can be a function (ISFUNC), a macro (ISMACR), or a keymap (ISKMAP). This makes new keymaps as necessary. The initial keymap in which to do bindings is map. 

=end Binding

=item rl-add-defun( Str $str, rl_command_func_t $cb, Int $i ) returns Int

    Add name to the list of named functions. Make function be the function that gets called. If key is not -1, then bind it to function using rl_bind_key(). 

    Using this function alone is sufficient for most applications. It is the recommended way to add a few functions to the default functions that Readline has built in. If you need to do something other than adding a function to Readline, you may need to use the underlying functions described below.

=item rl-variable-value( Str $s ) returns Str

    Return a string representing the value of the Readline variable variable. For boolean variables, this string is either `on' or `off'. 

=item rl-variable-bind( Str $s, Str $t ) returns Int

    Make the Readline variable variable have value. This behaves as if the readline command `set variable value' had been executed in an inputrc file (see section 1.3.1 Readline Init File Syntax). 

=item rl-set-key( Str $str, rl_command_func_t $cb, Keymap $k )

    Equivalent to rl_bind_keyseq_in_map. 

=item rl-macro-bind( Str $str, Str $b, Keymap $k ) returns Int

    Bind the key sequence keyseq to invoke the macro macro. The binding is performed in map. When keyseq is invoked, the macro will be inserted into the line. This function is deprecated; use rl_generic_bind() instead. 

=item rl-named-function( Str $s ) returns rl_command_func_t

    Return the function with name name. 

=item rl-function-of-keyseq( Str $s, Keymap $k, Pointer[Int] $p ) returns rl_command_func_t

    Return the function invoked by keyseq in keymap map. If map is NULL, the current keymap is used. If type is not NULL, the type of the object is returned in the int variable it points to (one of ISFUNC, ISKMAP, or ISMACR). 

=item rl-list-funmap-names( )

    Print the names of all bindable Readline functions to rl_outstream. 

=item rl-invoking-keyseqs-in-map( Pointer[rl_command_func_t] $p-cmd, Keymap $k ) returns Pointer[Str]

    Return an array of strings representing the key sequences used to invoke function in the keymap map. 

=item rl-invoking-keyseqs( Pointer[rl_command_func_t] $p-cmd ) returns Pointer[Str]

    Return an array of strings representing the key sequences used to invoke function in the current keymap. 

=item rl-function-dumper( Int $i )

    Print the readline function names and the key sequences currently bound to them to rl_outstream. If readable is non-zero, the list is formatted in such a way that it can be made part of an inputrc file and re-read. 

=item rl-macro-dumper( Int $i )

    Print the key sequences bound to macros and their values, using the current keymap, to rl_outstream. If readable is non-zero, the list is formatted in such a way that it can be made part of an inputrc file and re-read. 

=item rl-variable-dumper( Int $i )

    Print the readline variable names and their current values to rl_outstream. If readable is non-zero, the list is formatted in such a way that it can be made part of an inputrc file and re-read. 

=item rl-read-init-file( Str $name )

    Read keybindings and variable assignments from filename (see section 1.3 Readline Init File). 

=item rl-parse-and-bind( Str $name ) returns Int

    Parse line as if it had been read from the inputrc file and perform any key bindings and variable assignments found (see section 1.3 Readline Init File). 

=item rl-add-funmap-entry( Str $name, rl_command_func_t $cb ) returns Int

    Add name to the list of bindable Readline command names, and make function the function to be called when name is invoked. 

=item rl-funmap-names( ) returns CArray[Str]

    Return a NULL terminated array of known function names. The array is sorted. The array itself is allocated, but not the strings inside. You should free the array, but not the pointers, using free or rl_free when you are done. 

=item rl-push-macro-input( Str $name )

    Cause macro to be inserted into the line, as if it had been invoked by a key bound to a macro. Not especially useful; use rl_insert_text() instead. 

=item rl-free-undo-list( )

    Free the existing undo list. 

=item rl-do-undo( ) returns Int

    Undo the first thing on the undo list. Returns 0 if there was nothing to undo, non-zero if something was undone. 

=item rl-begin-undo-group( ) returns Int

    Begins saving undo information in a group construct. The undo information usually comes from calls to rl_insert_text() and rl_delete_text(), but could be the result of calls to rl_add_undo(). 

=item rl-end-undo-group( ) returns Int

    Closes the current undo group started with rl_begin_undo_group (). There should be one call to rl_end_undo_group() for each call to rl_begin_undo_group(). 

=item rl-modifying( Int $i, Int $j ) returns Int

    Tell Readline to save the text between start and end as a single undo unit. It is assumed that you will subsequently modify that text. 

=item rl-redisplay( )

    Change what's displayed on the screen to reflect the current contents of rl_line_buffer. 

=item rl-on-new-line( ) returns Int

    Tell the update functions that we have moved onto a new (empty) line, usually after outputting a newline. 

=item rl-on-new-line-with-prompt( ) returns Int

    Tell the update functions that we have moved onto a new line, with rl_prompt already displayed. This could be used by applications that want to output the prompt string themselves, but still need Readline to know the prompt string length for redisplay. It should be used after setting rl_already_prompted. 

=item rl-forced-update-display( ) returns Int

    Force the line to be updated and redisplayed, whether or not Readline thinks the screen display is correct. 

=item rl-clear-message( ) returns Int

    Clear the message in the echo area. If the prompt was saved with a call to rl_save_prompt before the last call to rl_message, call rl_restore_prompt before calling this function. 

=item rl-reset-line-state( ) returns Int

    Reset the display state to a clean state and redisplay the current line starting on a new line. 

=item rl-crlf( ) returns Int

    Move the cursor to the start of the next screen line. 

=item rl-show-char( Int $c ) returns Int

    Display character c on rl_outstream. If Readline has not been set to display meta characters directly, this will convert meta characters to a meta-prefixed key sequence. This is intended for use by applications which wish to do their own redisplay. 

=item rl-save-prompt( )

    Save the local Readline prompt display state in preparation for displaying a new message in the message area with rl_message(). 

=item rl-restore-prompt( )

    Restore the local Readline prompt display state saved by the most recent call to rl_save_prompt. if rl_save_prompt was called to save the prompt before a call to rl_message, this function should be called before the corresponding call to rl_clear_message. 

=item rl-replace-line( Str $text, Int $i )

    Replace the contents of rl_line_buffer with text. The point and mark are preserved, if possible. If clear_undo is non-zero, the undo list associated with the current line is cleared. 

=item rl-insert-text( Str $text ) returns Int

    Insert text into the line at the current cursor position. Returns the number of characters inserted. 

=item rl-delete-text( Int $a, Int $b ) returns Int

    Delete the text between start and end in the current line. Returns the number of characters deleted. 

=item rl-kill-text( Int $a, Int $b ) returns Int

    Copy the text between start and end in the current line to the kill ring, appending or prepending to the last kill if the last command was a kill command. The text is deleted. If start is less than end, the text is appended, otherwise prepended. If the last command was not a kill, a new kill ring slot is used. 

=item rl-copy-text( Int $a, Int $b ) returns Str

    Return a copy of the text between start and end in the current line. 

=item rl-prep-terminal( Int $i )

    Modify the terminal settings for Readline's use, so readline() can read a single character at a time from the keyboard. The meta_flag argument should be non-zero if Readline should read eight-bit input. 

=item rl-deprep-terminal( )

    Undo the effects of rl_prep_terminal(), leaving the terminal in the state in which it was before the most recent call to rl_prep_terminal(). 

=item rl-tty-set-default-bindings( Keymap $k )

    Read the operating system's terminal editing characters (as would be displayed by stty) to their Readline equivalents. The bindings are performed in kmap. 

=item rl-tty-unset-default-bindings( Keymap $k )

    Reset the bindings manipulated by rl_tty_set_default_bindings so that the terminal editing characters are bound to rl_insert. The bindings are performed in kmap. 

=item rl-reset-terminal( Str $s ) returns Int

    Reinitialize Readline's idea of the terminal settings using terminal_name as the terminal type (e.g., vt100). If terminal_name is NULL, the value of the TERM environment variable is used. 

=item rl-resize-terminal( )

    Update Readline's internal screen size by reading values from the kernel. 

=item rl-set-screen-size( Int $r, Int $c )

    Set Readline's idea of the terminal size to rows rows and cols columns. If either rows or columns is less than or equal to 0, Readline's idea of that terminal dimension is unchanged. 

If an application does not want to install a SIGWINCH handler, but is still interested in the screen dimensions, Readline's idea of the screen size may be queried.

=item rl-get-screen-size( Pointer[Int] $r, Pointer[Int] $c )

    Return Readline's idea of the terminal's size in the variables pointed to by the arguments. 

=item rl-reset-screen-size( )

    Cause Readline to reobtain the screen size and recalculate its dimensions. 

=item rl-get-termcap( Str $c ) returns Str

    Retrieve the string value of the termcap capability cap. Readline fetches the termcap entry for the current terminal name and uses those capabilities to move around the screen line and perform other terminal-specific operations, like erasing a line. Readline does not use all of a terminal's capabilities, and this function will return values for only those capabilities Readline uses. 

=item rl-extend-line-buffer( Int $c )

    Ensure that rl_line_buffer has enough space to hold len characters, possibly reallocating it if necessary. 

=item rl-alphabetic( Int $c ) returns Int

    Return 1 if c is an alphabetic character. 

=item rl-free( Pointer $p )

    Deallocate the memory pointed to by mem. mem must have been allocated by malloc. 

=item rl-set-signals( ) returns Int

    Install Readline's signal handler for SIGINT, SIGQUIT, SIGTERM, SIGHUP, SIGALRM, SIGTSTP, SIGTTIN, SIGTTOU, and SIGWINCH, depending on the values of rl_catch_signals and rl_catch_sigwinch. 

=item rl-clear-signals( ) returns Int

    Remove all of the Readline signal handlers installed by rl_set_signals(). 

=item rl-cleanup-after-signal( )

    This function will reset the state of the terminal to what it was before readline() was called, and remove the Readline signal handlers for all signals, depending on the values of rl_catch_signals and rl_catch_sigwinch. 

=item rl-reset-after-signal( )

    This will reinitialize the terminal and reinstall any Readline signal handlers, depending on the values of rl_catch_signals and rl_catch_sigwinch. 

    If an application does not wish Readline to catch SIGWINCH, it may call rl_resize_terminal() or rl_set_screen_size() to force Readline to update its idea of the terminal size when a SIGWINCH is received.

=item rl-free-line-state( )

    This will free any partial state associated with the current input line (undo information, any partial history entry, any partially-entered keyboard macro, and any partially-entered numeric argument). This should be called before rl_cleanup_after_signal(). The Readline signal handler for SIGINT calls this to abort the current input line. 

=item rl-echo-signal( Int $c )

    If an application wishes to install its own signal handlers, but still have readline display characters that generate signals, calling this function with sig set to SIGINT, SIGQUIT, or SIGTSTP will display the character generating that signal. 

=item rl-set-paren-blink-timeout( Int $c ) returns Int

    Set the time interval (in microseconds) that Readline waits when showing a balancing character when blink-matching-paren has been enabled. 

=item rl-complete-internal( Int $i ) returns Int

    Complete the word at or before point. what_to_do says what to do with the completion. A value of `?' means list the possible completions. `TAB' means do standard completion. `*' means insert all of the possible completions. `!' means to display all of the possible completions, if there is more than one, as well as performing partial completion. `@' is similar to `!', but possible completions are not listed if the possible completions share a common prefix. 

=item rl-username-completion-function ( Str $s, Int $i ) returns Str

    A completion generator for usernames. text contains a partial username preceded by a random character (usually `~'). As with all completion generators, state is zero on the first call and non-zero for subsequent calls. 

=item rl-filename-completion-function ( Str $s, Int $i ) returns Str

    A generator function for filename completion in the general case. text is a partial filename. The Bash source is a useful reference for writing application-specific completion functions (the Bash completion functions call this and other Readline functions). 

=item rl-completion-mode( Pointer[rl_command_func_t] $cb ) returns Int

    Returns the appropriate value to pass to rl_complete_internal() depending on whether cfunc was called twice in succession and the values of the show-all-if-ambiguous and show-all-if-unmodified variables. Application-specific completion functions may use this function to present the same interface as rl_complete(). 

=item rl-save-state( readline_state $state ) returns Int

    Save a snapshot of Readline's internal state to sp. The contents of the readline_state structure are documented in `readline.h'. The caller is responsible for allocating the structure. 

=item rl-restore-state( readline_state $state ) returns Int

    Restore Readline's internal state to that stored in sp, which must have been saved by a call to rl_save_state. The contents of the readline_state structure are documented in `readline.h'. The caller is responsible for freeing the structure. 

=end METHODS

=end pod

class Readline {
  my constant LIB = 'libreadline.so.6';

  # Embedded typedefs here
  #
  my class histdata_t is repr('CPointer') { } # typedef char *histdata_t;
  my class time_t is repr('CPointer') { } # XXX probably already a native type.
  my class Keymap is repr('CPointer') { } # typedef KEYMAP_ENTRY *Keymap;
  my class rl_vcpfunc_t is repr('CPointer') { } # typedef void rl_vcpfunc_t (char *);

  my class rl_command_func_t is repr('CPointer') { } #typedef int rl_command_func_t (int, int);

  constant meta_character_threshold = 0x07f; # Larger than this is Meta.
  constant meta_character_bit       = 0x080; # x0000000, must be on.
  constant largest_char             = 255;   # Largest character value.

  sub META_CHAR( $c ) {
    ord( $c ) > meta_character_threshold && ord( $c ) <= largest_char
  }

  sub META( $c ) {
    ord( $c ) | meta_character_bit
  }

  sub UNMETA( $c ) {
    ord( $c ) & ~meta_character_bit
  }

  ############################################################################
  #
  # history.h -- the names of functions that you can call in history.
  #

  # The structure used to store a history entry.
  #
  my class HIST_ENTRY is repr('CStruct') {
    has Str $.line;        # char *line;
    has Str $.timestamp;   # char *timestamp;
    has histdata_t $.data; # histdata_t data;
  }

  # Size of the history-library-managed space in history entry HS.
  #
  sub HISTENT_BYTES( $hs ) {
    $hs.line.length + $hs.timestamp.length
  }

  # A structure used to pass the current state of the history stuff around.
  #
  my class HISTORY_STATE is repr('CStruct') {
    has Pointer $.entries; # Pointer to an array of HIST_ENTRY types.
    has int     $.offset;  # The location pointer within this array.
    has int     $.length;  # Number of elements within this array.
    has int     $.size;    # Number of slots allocated to this array.
    has int     $.flags;
  }

  # Flag values for the `flags' member of HISTORY_STATE.
  #
  constant HS_STIFLED = 0x01;

  # Initialization and state management.
  #
  # Begin a session in which the history functions might be used.  This
  # just initializes the interactive variables.
  #
  sub using_history( )
    is native( LIB ) { * }
  method using-history( ) {
    using_history() }

  # Return the current HISTORY_STATE of the history.
  #
  sub history_get_history_state( )
    returns HISTORY_STATE
    is native( LIB ) { * }
  method history-get-history-state( )
    returns HISTORY_STATE {
    history_get_history_state() }

  # Set the state of the current history array to STATE.
  #
  sub history_set_history_state( HISTORY_STATE )
    is native( LIB ) { * }
  method history-set-history-state( HISTORY_STATE $state ) {
    history_set_history_state( $state ) }

  # Manage the history list.
  #
  # Place STRING at the end of the history list.
  # The associated data field (if any) is set to NULL.
  #
  sub add_history( Str )
    is native( LIB ) { * }
  method add-history( Str $history ) {
    add_history( $history ) }

  # Change the timestamp associated with the most recent history entry to
  # STRING.
  #
  sub add_history_time( Str )
    is native( LIB ) { * }
  method add-history-time( Str $timestamp ) {
    add_history_time( $timestamp ) }

  # A reasonably useless function, only here for completeness.  WHICH
  # is the magic number that tells us which element to delete.  The
  # elements are numbered from 0.
  #
  sub remove_history( Int )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method remove-history( Int $which )
    returns HIST_ENTRY {
    remove_history( $which ) }

  # Free the history entry H and return any application-specific data
  # associated with it.
  #
  sub free_history_entry( HIST_ENTRY )
    returns histdata_t
    is native( LIB ) { * }
  method free-history-entry( HIST_ENTRY $entry )
    returns histdata_t {
    free_history_entry( $entry ) }

  # Make the history entry at WHICH have LINE and DATA.  This returns
  # the old entry so you can dispose of the data.  In the case of an
  # invalid WHICH, a NULL pointer is returned.
  #
  sub replace_history_entry( Int, Str, histdata_t )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method replace-history-entry( Int $which, Str $line, histdata_t $data )
    returns HIST_ENTRY {
      replace_history_entry( $which, $line, $data ) }

  # Clear the history list and start over.
  #
  sub clear_history( )
    is native( LIB ) { * }
  method clear-history( ) {
    clear_history() }

  # Stifle the history list, remembering only MAX number of entries.
  #
  sub stifle_history( Int )
    is native( LIB ) { * }
  method stifle-history( Int $max ) {
    stifle_history( $max ) }

  # Stop stifling the history.  This returns the previous amount the
  # history was stifled by.  The value is positive if the history was
  # stifled, negative if it wasn't.
  #
  sub unstifle_history( )
    is native( LIB ) { * }
  method unstifle-history( ) {
    unstifle_history() }

  # Return 1 if the history is stifled, 0 if it is not.
  #
  sub history_is_stifled( )
    returns Int
    is native( LIB ) { * }
  method history-is-stifled( )
    returns Bool {
    history_is_stifled() ?? True !! False }

  # Information about the history list.
  #
  # Return a NULL terminated array of HIST_ENTRY which is the current input
  # history.  Element 0 of this list is the beginning of time.  If there
  # is no history, return NULL.
  #
  sub history_list( )
    returns CArray[HIST_ENTRY]
    is native( LIB ) { * }
  method history-list( )
    returns CArray[HIST_ENTRY] {
    history_list() }

  # Returns the number which says what history element we are now
  # looking at.
  #  
  sub where_history( )
    returns Int
    is native( LIB ) { * }
  method where-history( )
    returns Int {
    where_history() }

  # Return the history entry at the current position, as determined by
  # history_offset.  If there is no entry there, return a NULL pointer.
  #
  sub current_history( Int )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method current-history( Int $which )
    returns HIST_ENTRY {
    current_history( $which ) }

  # Return the history entry which is logically at OFFSET in the history
  # array.  OFFSET is relative to history_base.
  #
  sub history_get( Int )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method history-get( Int $which )
    returns HIST_ENTRY {
    history_get( $which ) }

  # Return the timestamp associated with the HIST_ENTRY * passed as an
  # argument.
  #
  sub history_get_time( HIST_ENTRY )
    returns time_t
    is native( LIB ) { * }
  method history-get-time( HIST_ENTRY $h )
    returns time_t {
    history_get_time( $h ) }

  # Return the number of bytes that the primary history entries are using.
  # This just adds up the lengths of the_history->lines.
  #
  sub history_total_bytes( )
    returns Int
    is native( LIB ) { * }
  method history-total-bytes( )
    returns Int {
    history_total_bytes( ) }

  # Moving around the history list.
  #
  # Set the position in the history list to POS.
  #
  sub history_set_pos( Int )
    returns Int
    is native( LIB ) { * }
  method history-set-pos( Int $pos )
    returns Int {
    history_set_pos( $pos ) }

  # Back up history_offset to the previous history entry, and return
  # a pointer to that entry.  If there is no previous entry, return
  # a NULL pointer.
  #
  sub previous_history( )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method previous-history( )
    returns HIST_ENTRY {
    previous_history( ) }

  # Move history_offset forward to the next item in the input_history,
  # and return the a pointer to that entry.  If there is no next entry,
  # return a NULL pointer.
  #
  sub next_history( )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method next-history( )
    returns HIST_ENTRY {
    next_history( ) }

  # Searching the history list.
  #
  # Search the history for STRING, starting at history_offset.
  # If DIRECTION < 0, then the search is through previous entries,
  # else through subsequent.  If the string is found, then
  # current_history () is the history entry, and the value of this function
  # is the offset in the line of that history entry that the string was
  # found in.  Otherwise, nothing is changed, and a -1 is returned.
  #
  sub history_search( Str, Int )
    returns Int
    is native( LIB ) { * }
  method history-search( Str $text, Int $pos )
    returns Int {
    history_search( $text, $pos ) }

  # Search the history for STRING, starting at history_offset.
  # The search is anchored: matching lines must begin with string.
  # DIRECTION is as in history_search().
  #
  sub history_search_prefix( Str, Int )
    returns Int
    is native( LIB ) { * }
  method history-search-prefix( Str $text, Int $pos )
    returns Int {
    history_search_prefix( $text, $pos ) }

  # Search for STRING in the history list, starting at POS, an
  # absolute index into the list.  DIR, if negative, says to search
  # backwards from POS, else forwards.
  # Returns the absolute index of the history element where STRING
  # was found, or -1 otherwise.
  #
  sub history_search_pos( Str, Int, Int )
    returns Int
    is native( LIB ) { * }
  method history-search-pos( Str $text, Int $pos, Int $dir )
    returns Int {
    history_search_pos( $text, $pos, $dir ) }

  # Managing the history file.
  #
  # Add the contents of FILENAME to the history list, a line at a time.
  # If FILENAME is NULL, then read from ~/.history.  Returns 0 if
  # successful, or errno if not.
  #
  sub read_history( Str )
    returns Int
    is native( LIB ) { * }
  method read-history( Str $text )
    returns Int {
    my $rv = read_history( $text );
    $rv == 0 ?? True !! $rv }

  # Read a range of lines from FILENAME, adding them to the history list.
  # Start reading at the FROM'th line and end at the TO'th.  If FROM
  # is zero, start at the beginning.  If TO is less than FROM, read
  # until the end of the file.  If FILENAME is NULL, then read from
  # ~/.history.  Returns 0 if successful, or errno if not.
  #
  sub read_history_range( Str, Int, Int )
    returns Int
    is native( LIB ) { * }
  method read-history-range( Str $text, Int $from, Int $to )
    returns Int {
    read_history_range( $text, $from, $to ) }

  # Write the current history to FILENAME.  If FILENAME is NULL,
  # then write the history list to ~/.history.  Values returned
  # are as in read_history ().
  #
  sub write_history( Str )
    returns Int
    is native( LIB ) { * }
  method write-history( Str $filename )
    returns Int {
    my $rv = write_history( $filename );
    $rv == 0 ?? True !! $rv }

  # Append NELEMENT entries to FILENAME.  The entries appended are from
  # the end of the list minus NELEMENTs up to the end of the list.
  #
  sub append_history( Int, Str )
    returns Int
    is native( LIB ) { * }
  method append-history( Int $offset, Str $filename )
    returns Int {
    append_history( $offset, $filename ) }

  # Truncate the history file, leaving only the last NLINES lines.
  #
  sub history_truncate_file( Str, Int )
    returns Int
    is native( LIB ) { * }
  method history-truncate-file( Str $filename, Int $lines )
    returns Int {
    my $rv = history_truncate_file( $filename, $lines );
    $rv == 0 ?? True !! $rv }

  # History expansion.
  #
  # Expand the string STRING, placing the result into OUTPUT, a pointer
  # to a string.  Returns:
  #
  # 0) If no expansions took place (or, if the only change in
  #    the text was the de-slashifying of the history expansion
  #    character)
  # 1) If expansions did take place
  #-1) If there was an error in expansion.
  # 2) If the returned line should just be printed.
  #
  # If an error occurred in expansion, then OUTPUT contains a descriptive
  # error message.
  #

  sub history_expand( Str, Pointer[Str] )
    returns Int
    is native( LIB ) { * }
  method history-expand( Str $string, Pointer[Str] $output )
    returns Int {
    history_expand( $string, $output ) }

  # Extract a string segment consisting of the FIRST through LAST
  # arguments present in STRING.  Arguments are broken up as in
  # the shell.
  #
  sub history_arg_extract( Int, Int, Str )
    returns Str
    is native( LIB ) { * }
  method history-arg-extract( Int $first, Int $last, Str $string )
    returns Str {
    history_arg_extract( $first, $last, $string ) }

  # Return the text of the history event beginning at the current
  # offset into STRING.  Pass STRING with *INDEX equal to the
  # history_expansion_char that begins this specification.
  # DELIMITING_QUOTE is a character that is allowed to end the string
  # specification for what to search for in addition to the normal
  # characters `:', ` ', `\t', `\n', and sometimes `?'.
  #

  sub get_history_event( Str, Pointer[Int], Int )
    returns Str
    is native( LIB ) { * }
  method get-history-event( Str $string, Pointer[Int] $index, Int $delimiting-quote )
    returns Str {
    get_history_event( $string, $index, $delimiting-quote ) }


  # Return an array of tokens, much as the shell might.  The tokens are
  # parsed out of STRING.
  #
  sub history_tokenize( Str )
    returns CArray[Str]
    is native( LIB ) { * }
  method history-tokenize( Str $string )
    returns CArray[Str] {
    history_tokenize( $string ) }

  # Exported history variables.
  #extern int history_base;
  #extern int history_length;
  #extern int history_max_entries;
  #extern char history_expansion_char;
  #extern char history_subst_char;
  #extern char *history_word_delimiters;
  #extern char history_comment_char;
  #extern char *history_no_expand_chars;
  #extern char *history_search_delimiter_chars;
  #extern int history_quotes_inhibit_expansion;

  #extern int history_write_timestamps;

  # Backwards compatibility 
  #
  #extern int max_input_history;

  # If set, this function is called to decide whether or not a particular
  # history expansion should be treated as a special case for the calling
  # application and not expanded.
  #
  #extern rl_linebuf_func_t *history_inhibit_expansion_function;

  #############################################################################
  #
  # keymaps.h -- Manipulation of readline keymaps.
  #
  # A keymap contains one entry for each key in the ASCII set.
  # Each entry consists of a type and a pointer.
  # FUNCTION is the address of a function to run, or the
  # address of a keymap to indirect through.
  # TYPE says which kind of thing FUNCTION is.
  #

  my class KEYMAP_ENTRY is repr('CStruct') {
    has byte              $.type;     # char type;
    has rl_command_func_t $.function; # rl_command_func_t *function
  }

  # This must be large enough to hold bindings for all of the characters
  # in a desired character set (e.g, 128 for ASCII, 256 for ISO Latin-x,
  # and so on) plus one for subsequence matching.
  #
  constant KEYMAP_SIZE = 257;
  constant ANYOTHERKEY = KEYMAP_SIZE - 1;

  #typedef KEYMAP_ENTRY KEYMAP_ENTRY_ARRAY[KEYMAP_SIZE];
  #
  # The values that TYPE can have in a keymap entry.
  #
  constant ISFUNC = 0;
  constant ISKMAP = 1;
  constant ISMACR = 2;

  #extern KEYMAP_ENTRY_ARRAY emacs_standard_keymap, emacs_meta_keymap;
  #extern KEYMAP_ENTRY emacs_ctlx_keymap;
  #extern KEYMAP_ENTRY_ARRAY vi_insertion_keymap, vi_movement_keymap;

  # Return a new, empty keymap.
  # Free it with free() when you are done.
  #
  sub rl_make_bare_keymap( )
    returns Keymap
    is native( LIB ) { * }
  method rl-make-bare-keymap( )
    returns Keymap {
    rl_make_bare_keymap( ) }

  # Return a new keymap which is a copy of MAP.
  #
  sub rl_copy_keymap( Keymap )
    returns Keymap
    is native( LIB ) { * }
  method rl-copy-keymap( Keymap $k )
    returns Keymap {
    rl_copy_keymap( $k ) }

  # Return a new keymap with the printing characters bound to rl_insert,
  # the lowercase Meta characters bound to run their equivalents, and
  # the Meta digits bound to produce numeric arguments.
  #
  sub rl_make_keymap( )
    returns Keymap
    is native( LIB ) { * }
  method rl-make-keymap( )
    returns Keymap {
    rl_make_keymap( ) }

  # Free the storage associated with a keymap.
  #
  sub rl_discard_keymap( Keymap )
    is native( LIB ) { * }
  method rl-discard-keymap( Keymap $k ) {
    rl_discard_keymap( $k ) }

  sub rl_free_keymap( Keymap )
    is native( LIB ) { * }
  method rl-free-keymap( Keymap $k ) {
    rl_free_keymap( $k ) }

  # These functions actually appear in bind.c
  #
  # Return the keymap corresponding to a given name.  Names look like
  # `emacs' or `emacs-meta' or `vi-insert'.
  #
  sub rl_get_keymap_by_name( Str )
    returns Keymap
    is native( LIB ) { * }
  method rl-get-keymap-by-name( Str $name )
    returns Keymap {
    rl_get_keymap_by_name( $name ) }

  # Return the current keymap.
  #
  sub rl_get_keymap( )
    returns Keymap
    is native( LIB ) { * }
  method rl-get-keymap( )
    returns Keymap {
    rl_get_keymap( ) }

  # Get the name of an existing keymap
  #
  sub rl_get_keymap_name( Keymap )
    returns Str
    is native( LIB ) { * }
  method rl-get-keymap-name( Keymap $k )
    returns Str {
    rl_get_keymap_name( $k ) }

  # Set the current keymap to MAP.
  #
  sub rl_set_keymap( Keymap )
    is native( LIB ) { * }
  method rl-set-keymap( Keymap $k ) {
    rl_set_keymap( $k ) }

  #############################################################################
  #
  # Readline.h -- the names of functions callable from within readline.
  #
  # Readline data structures.
  #
  # Maintaining the state of undo.  We remember individual deletes and inserts
  # on a chain of things to do.
  #
  # The actions that undo knows how to undo.  Notice that UNDO_DELETE means
  # to insert some text, and UNDO_INSERT means to delete some text.   I.e.,
  # the code tells undo what to undo, not how to undo it.
  #
  #enum undo_code { UNDO_DELETE, UNDO_INSERT, UNDO_BEGIN, UNDO_END };

  constant UNDO_DELETE = 0;
  constant UNDO_INSERT = 1;
  constant UNDO_BEGIN  = 2;
  constant UNDO_END    = 3;

  # What an element of THE_UNDO_LIST looks like.
  #
  my class UNDO_LIST is repr('CStruct') {
    has UNDO_LIST $.next; # struct undo_list *next;
    has int $.start;      # int start; # Where the change took place.
    has int $.end;        # int end;
    has Str $.text;       # char *text; # The text to insert, if undoing a delete
    has byte $.what;      # enum undo_code what; # Delete, Insert, Begin, End.
  }

  # The current undo list for RL_LINE_BUFFER.
  #
  #extern UNDO_LIST *rl_undo_list;

  # The data structure for mapping textual names to code addresses.
  #
  my class FUNMAP is repr('CStruct') {
    has Str     $.name;     # const char *name;
    has Pointer $.function; # rl_command_func_t *function;
  }

  #extern FUNMAP **funmap;

  # Bindable commands for numeric arguments.
  #
  # These should only be passed as callbacks, I believe.
  #
  sub rl_digit_argument( Int, Int )
    returns Int
    is native( LIB ) { * }
  sub rl_universal_argument( Int, Int )
    returns Int is
    native( LIB ) { * }

  # Bindable commands for moving the cursor.
  #
  sub rl_forward_byte( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward_char( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_byte( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_char( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_beg_of_line( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_end_of_line( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_refresh_line( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_clear_screen( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_skip_csi_sequence( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_arrow_keys( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for inserting and deleting text.
  #
  sub rl_insert( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_quoted_insert( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_tab_insert( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_newline( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_do_lowercase_version( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_rubout( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_delete( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_rubout_or_delete( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_delete_horizontal_space( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_delete_or_show_completions( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_insert_comment( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for changing case.
  #
  sub rl_upcase_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_downcase_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_capitalize_word( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for transposing characters and words.
  #
  sub rl_transpose_words( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_transpose_chars( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for searching within a line.
  #
  sub rl_char_search( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_char_search( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for readline's interface to the command history.
  #
  sub rl_beginning_of_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_end_of_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_get_next_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_get_previous_history ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for managing the mark and region.
  #
  sub rl_set_mark ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_exchange_point_and_mark ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands to set the editing mode (emacs or vi).
  #
  sub rl_vi_editing_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_emacs_editing_mode ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands to change the insert mode (insert or overwrite)
  #
  sub rl_overwrite_mode ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for managing key bindings.
  #
  sub rl_re_read_init_file ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_dump_functions ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_dump_macros ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_dump_variables ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for word completion.
  #
  sub rl_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_possible_completions ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_insert_completions ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_old_menu_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_menu_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_menu_complete ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for killing and yanking text, and managing the kill ring.
  #
  sub rl_kill_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_kill_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_kill_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_kill_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_kill_full_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_unix_word_rubout ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_unix_filename_rubout ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_unix_line_discard ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_copy_region_to_kill ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_kill_region ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_copy_forward_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_copy_backward_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank_pop ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank_nth_arg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank_last_arg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_paste_from_clipboard ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for incremental searching.
  #
  sub rl_reverse_search_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward_search_history ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable keyboard macro commands.
  #
  sub rl_start_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_end_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_call_last_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_print_last_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  #
  # Bindable undo commands.
  #
  sub rl_revert_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_undo_command ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable tilde expansion commands.
  #
  sub rl_tilde_expand ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable terminal control commands.
  #
  sub rl_restart_output ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_stop_output ( Int, Int ) returns Int is native( LIB ) { * }

  # Miscellaneous bindable commands.
  #
  sub rl_abort ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_tty_status ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for incremental and non-incremental history searching.
  #
  sub rl_history_search_forward ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_history_search_backward ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_history_substr_search_forward ( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_history_substr_search_backward ( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_noninc_forward_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_noninc_reverse_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_noninc_forward_search_again ( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_noninc_reverse_search_again ( Int, Int ) returns Int
    is native( LIB ) { * }

  # Bindable command used when inserting a matching close character.
  #
  sub rl_insert_close ( Int, Int ) returns Int is native( LIB ) { * }

  # Not available unless READLINE_CALLBACKS is defined.
  #

  sub rl_callback_handler_install( Str, rl_vcpfunc_t )
    is native( LIB ) { * }
  method rl-callback-handler-install( Str $s, rl_vcpfunc_t $cb ) {
    rl_callback_handler_install( $s, $cb ) }

  sub rl_callback_read_char( )
    is native( LIB ) { * }
  method rl-callback-read-char( ) {
    rl_callback_read_char( ) }
 
  sub rl_callback_handler_remove( )
    is native( LIB ) { * }
  method rl-callback-handler-remove( ) {
    rl_callback_handler_remove( ) }

  # Things for vi mode. Not available unless readline is compiled -DVI_MODE.
  #
  # VI-mode bindable commands.
  #
  sub rl_vi_redo ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_undo ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_yank_arg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_fetch_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_search_again ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_tilde_expand ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_prev_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_next_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_end_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_insert_beg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_append_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_append_eol ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_eof_maybe ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_insertion_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_insert_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_movement_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_arg_digit ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_change_case ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_put ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_column ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_delete_to ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_change_to ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_yank_to ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_rubout ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_delete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_back_to_indent ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_first_print ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_char_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_match ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_change_char ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_subst ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_overstrike ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_overstrike_delete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_replace ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_set_mark ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_goto_mark ( Int, Int ) returns Int is native( LIB ) { * }

  # VI-mode utility functions.
  #
  sub rl_vi_check( ) returns Int is native( LIB ) { * }
  sub rl_vi_domove( Int, Pointer[Int] ) returns Int is native( LIB ) { * }
  sub rl_vi_bracktype( Int ) returns Int is native( LIB ) { * }

  sub rl_vi_start_inserting( Int, Int, Int ) returns Int is native( LIB ) { * }

  # VI-mode pseudo-bindable commands, used as utility functions.
  #
  sub rl_vi_fWord ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_bWord ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_eWord ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_fword ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_bword ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_eword ( Int, Int ) returns Int is native( LIB ) { * }

  ###################################################################
  #								    #
  #			Well Published Functions		    #
  #								    #
  ###################################################################
  #
  # Readline functions.
  #
  # Read a line of input.  Prompt with PROMPT.  A NULL PROMPT means none.
  #
  sub readline( Str )
    returns Str
    is native( LIB ) { * }
  method readline( Str $prompt )
    returns Str {
    readline( $prompt ) }

  sub rl_set_prompt( Str )
    returns Int
    is native( LIB ) { * }
  method rl-set-prompt( Str $prompt )
    returns Int {
    rl_set_prompt( $prompt ) }

  sub rl_expand_prompt( Str )
    returns Int
    is native( LIB ) { * }
  method rl-expand-prompt( Str $prompt )
    returns Int {
    rl_expand_prompt( $prompt ) }

  sub rl_initialize( )
    returns Int
    is native( LIB ) { * }
  method rl-initialize( )
    returns Int {
    rl_initialize( ) }

  # Utility functions to bind keys to readline commands.
  #
  sub rl_bind_key( Int, rl_command_func_t )
    returns Int
    is native( LIB ) { * }
  method rl-bind-key( Int $i, rl_command_func_t $cb )
    returns Int {
    rl_bind_key( $i, $cb ) }

  sub rl_bind_key_in_map( Int, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-bind-key-in-map( Int $i, rl_command_func_t $cb, Keymap $k )
   
    returns Int {
    rl_bind_key_in_map( $i, $cb, $k ) }

  sub rl_unbind_key( Int )
    returns Int
    is native( LIB ) { * }
  method rl-unbind-key( Int $i )
    returns Int {
    rl_unbind_key( $i ) }

  sub rl_unbind_key_in_map( Int, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-unbind-key-in-map( Int $i, Keymap $k )
    returns Int {
    rl_unbind_key_in_map( $i, $k ) }

  sub rl_bind_key_if_unbound( Int, rl_command_func_t )
    returns Int
    is native( LIB ) { * }
  method rl-bind-key-if-unbound( Int $i, rl_command_func_t $cb )
    returns Int {
    rl_bind_key_if_unbound( $i, $cb ) }

  sub rl_bind_key_if_unbound_in_map( Int, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-bind-key-if-unbound-in-map
    ( Int $i, rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_bind_key_if_unbound_in_map( $i, $cb, $k ) }

  sub rl_unbind_function_in_map( rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-unbind-function-in-map ( rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_unbind_function_in_map( $cb, $k ) }

  sub rl_bind_keyseq( Str, rl_command_func_t )
    returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq( Str $str, rl_command_func_t $cb )
    returns Int {
      rl_bind_keyseq( $str, $cb ) }

  sub rl_bind_keyseq_in_map( Str, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq-in-map( Str $str, rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_bind_keyseq_in_map( $str, $cb, $k ) }

  sub rl_bind_keyseq_if_unbound( Str, rl_command_func_t )
    returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq-if-unbound( Str $str, rl_command_func_t $cb )
   returns Int {
    rl_bind_keyseq_if_unbound( $str, $cb ) }

  sub rl_bind_keyseq_if_unbound_in_map( Str, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq-if-unbound-in-map
    ( Str $str, rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_bind_keyseq_if_unbound_in_map( $str, $cb, $k ) }

  sub rl_generic_bind( Int, Str, Str, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-generic-bind( Int $i, Str $s, Str $t, Keymap $k )
    returns Int {
    rl_generic_bind( $i, $s, $t, $k ) }


  sub rl_add_defun( Str, rl_command_func_t, Int )
    returns Int
    is native( LIB ) { * }
  method rl-add-defun( Str $str, rl_command_func_t $cb, Int $i )
    returns Int {
    rl_add_defun( $str, $cb, $i ) }

  sub rl_variable_value( Str )
    returns Str
    is native( LIB ) { * }
  method rl-variable-value( Str $s )
    returns Str {
    rl_variable_value( $s ) }

  sub rl_variable_bind( Str, Str )
    returns Int
    is native( LIB ) { * }
  method rl-variable-bind( Str $s, Str $t )
    returns Int {
    rl_variable_bind( $s, $t ) }

  # Backwards compatibility, use rl_bind_keyseq_in_map instead.
  #
  sub rl_set_key( Str, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-set-key( Str $str, rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_set_key( $str, $cb, $k ) }

  # Backwards compatibility, use rl_generic_bind instead.
  #
  sub rl_macro_bind( Str, Str, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-macro-bind( Str $str, Str $b, Keymap $k )
    returns Int {
    rl_macro_bind( $str, $b, $k ) }

  sub rl_translate_keyseq( Str, Str, Pointer[Int] )
    returns Int
    is native( LIB ) { * }
  method rl-translate-keyseq( Str $str, Str $b, Pointer[Int] $k )
    returns Int {
    rl_translate_keyseq( $str, $b, $k ) }

  sub rl_untranslate_keyseq( Int )
    returns Int
    is native( LIB ) { * }
  method rl-untranslate-keyseq( Int $i )
    returns Int {
    rl_untranslate_keyseq( $i ) }

  sub rl_named_function( Str )
    returns rl_command_func_t
    is native( LIB ) { * }
  method rl-named-function( Str $s )
    returns rl_command_func_t {
    rl_named_function( $s ) }

  sub rl_function_of_keyseq( Str, Keymap, Pointer[Int] )
    returns rl_command_func_t
    is native( LIB ) { * }
  method rl-function-of-keyseq( Str $s, Keymap $k, Pointer[Int] $p )
    returns rl_command_func_t {
      rl_function_of_keyseq( $s, $k, $p ) }

  sub rl_list_funmap_names( )
    is native( LIB ) { * }
  method rl-list-funmap-names( ) {
    rl_list_funmap_names( ) }

  sub rl_invoking_keyseqs_in_map( rl_command_func_t, Keymap )
    returns CArray[Str]
    is native( LIB ) { * }
  method rl-invoking-keyseqs-in-map( rl_command_func_t $cb, Keymap $k )
    returns CArray[Str] {
      rl_invoking_keyseqs_in_map( $cb, $k ) }

  sub rl_invoking_keyseqs( rl_command_func_t )
    returns CArray[Str]
    is native( LIB ) { * }
  method rl-invoking-keyseqs( rl_command_func_t $cb )
    returns CArray[Str] {
    rl_invoking_keyseqs( $cb ) }

  sub rl_function_dumper( Int )
    is native( LIB ) { * }
  method rl-function-dumper( Int $i ) {
    rl_function_dumper( $i ) }

  sub rl_macro_dumper( Int )
    is native( LIB ) { * }
  method rl-macro-dumper( Int $i ) {
    rl_macro_dumper( $i ) }

  sub rl_variable_dumper( Int )
    is native( LIB ) { * }
  method rl-variable-dumper( Int $i ) {
    rl_variable_dumper( $i ) }

  sub rl_read_init_file( Str )
    is native( LIB ) { * }
  method rl-read-init-file( Str $name ) {
    rl_read_init_file( $name ) }

  sub rl_parse_and_bind( Str )
    returns Int
    is native( LIB ) { * }
  method rl-parse-and-bind( Str $name )
    returns Int {
    rl_parse_and_bind( $name ) }

  # Functions for manipulating the funmap, which maps command names
  # to functions.
  #
  sub rl_add_funmap_entry( Str, rl_command_func_t )
    returns Int
    is native( LIB ) { * }
  method rl-add-funmap-entry( Str $name, rl_command_func_t $cb )
    returns Int {
    rl_add_funmap_entry( $name, $cb ) }

  sub rl_funmap_names( )
    returns CArray[Str]
    is native( LIB ) { * }
  method rl-funmap-names( )
    returns CArray[Str] {
    rl_funmap_names( ) }

  # Utility functions for managing keyboard macros.
  #
  sub rl_push_macro_input( Str )
    is native( LIB ) { * }
  method rl-push-macro-input( Str $name ) {
    rl_push_macro_input( $name ) }

  # Functions for undoing, from undo.c
  #
  #extern void rl_add_undo (enum undo_code, int, int, char *);

  sub rl_free_undo_list( )
    is native( LIB ) { * }
  method rl-free-undo-list( ) {
    rl_free_undo_list( ) }

  sub rl_do_undo( )
    returns Int
    is native( LIB ) { * }
  method rl-do-undo( )
    returns Int {
    rl_do_undo( ) }

  sub rl_begin_undo_group( )
    returns Int
    is native( LIB ) { * }
  method rl-begin-undo-group( )
    returns Int {
    rl_begin_undo_group( ) }

  sub rl_end_undo_group( )
    returns Int
    is native( LIB ) { * }
  method rl-end-undo-group( )
    returns Int {
    rl_end_undo_group( ) }

  sub rl_modifying( Int, Int )
    returns Int
    is native( LIB ) { * }
  method rl-modifying( Int $i, Int $j )
    returns Int {
    rl_modifying( $i, $j ) }

  # Functions for redisplay.
  #
  sub rl_redisplay( )
    is native( LIB ) { * }
  method rl-redisplay( ) {
    rl_redisplay( ) }

  sub rl_on_new_line( )
    returns Int
    is native( LIB ) { * }
  method rl-on-new-line( )
    returns Int {
    rl_on_new_line( ) }

  sub rl_on_new_line_with_prompt( )
    returns Int
    is native( LIB ) { * }
  method rl-on-new-line-with-prompt( )
    returns Int {
    rl_on_new_line_with_prompt( ) }

  sub rl_forced_update_display( )
    returns Int
    is native( LIB ) { * }
  method rl-forced-update-display( )
    returns Int {
    rl_forced_update_display( ) }

  sub rl_clear_message( )
    returns Int
    is native( LIB ) { * }
  method rl-clear-message( )
    returns Int {
    rl_clear_message( ) }

  sub rl_reset_line_state( )
    returns Int
    is native( LIB ) { * }
  method reset_line_state( )
    returns Int {
    rl_reset_line_state( ) }

  sub rl_crlf( )
    returns Int
    is native( LIB ) { * }
  method rl-crlf( )
    returns Int {
    rl_crlf( ) }

  #extern int rl_message (const char *, ...)  __rl_attribute__((__format__ (printf, 1, 2)); # XXX

  sub rl_show_char( Int )
    returns Int
    is native( LIB ) { * }
  method rl-show-char( Int $c )
    returns Int {
    rl_show_char( $c ) }

  # Undocumented in texinfo manual.
  #
  sub rl_character_len( Int, Int )
    returns Int
    is native( LIB ) { * }
  method rl-character-len( Int $c, Int $d )
    returns Int {
    rl_character_len( $c, $d ) }

  # Save and restore internal prompt redisplay information.
  #
  sub rl_save_prompt( )
    is native( LIB ) { * }
  method rl-save-prompt( ) {
    rl_save_prompt( ) }

  sub rl_restore_prompt( )
    is native( LIB ) { * }
  method rl-restore-prompt( ) {
    rl_restore_prompt( ) }

  # Modifying text.
  #
  sub rl_replace_line( Str, Int )
    is native( LIB ) { * }
  method rl-replace-line( Str $text, Int $i ) {
    rl_replace_line( $text, $i ) }

  sub rl_insert_text( Str )
    returns Int
    is native( LIB ) { * }
  method rl-insert-text( Str $text )
    returns Int {
    rl_insert_text( $text ) }

  sub rl_delete_text( Int, Int )
    returns Int
    is native( LIB ) { * }
  method rl-delete-text( Int $a, Int $b )
    returns Int {
    rl_delete_text( $a, $b ) }

  sub rl_kill_text( Int, Int )
    returns Int
    is native( LIB ) { * }
  method rl-kill-text( Int $a, Int $b )
    returns Int {
    rl_kill_text( $a, $b ) }

  sub rl_copy_text( Int, Int )
    returns Str
    is native( LIB ) { * }
  method rl-copy-text( Int $a, Int $b )
    returns Str {
    rl_copy_text( $a, $b ) }

  # Terminal and tty mode management.
  #
  sub rl_prep_terminal( Int )
    is native( LIB ) { * }
  method rl-prep-terminal( Int $i ) {
    rl_prep_terminal( $i ) }

  sub rl_deprep_terminal( )
    is native( LIB ) { * }
  method rl-deprep-terminal( ) {
    rl_deprep_terminal( ) }

  sub rl_tty_set_default_bindings( Keymap )
    is native( LIB ) { * }
  method rl-tty-set-default-bindings( Keymap $k ) {
    rl_tty_set_default_bindings ( $k ) }

  sub rl_tty_unset_default_bindings ( Keymap )
    is native( LIB ) { * }
  method rl-tty-unset-default-bindings( Keymap $k ) {
    rl_tty_unset_default_bindings ( $k ) }

  sub rl_reset_terminal( Str )
    returns Int
    is native( LIB ) { * }
  method rl-reset-terminal( Str $s )
    returns Int {
    rl_reset_terminal( $s ) }

  sub rl_resize_terminal( )
    is native( LIB ) { * }
  method rl-resize-terminal( ) {
    rl_resize_terminal( ) }

  sub rl_set_screen_size( Int, Int )
    is native( LIB ) { * }
  method rl-set-screen-size( Int $r, Int $c ) {
    rl_set_screen_size( $r, $c ) }

  sub rl_get_screen_size( Pointer[Int], Pointer[Int] )
    is native( LIB ) { * }
  method rl-get-screen-size( Pointer[Int] $r, Pointer[Int] $c ) {
    rl_get_screen_size( $r, $c ) }

  sub rl_reset_screen_size( )
    is native( LIB ) { * }
  method rl-reset-screen-size( ) {
    rl_reset_screen_size( ) }

  sub rl_get_termcap( Str )
    returns Str
    is native( LIB ) { * }
  method rl-get-termcap( Str $c )
    returns Str {
    rl_get_termcap( $c ) }

  # Functions for character input.
  #
  #extern int rl_stuff_char (int);
  #extern int rl_execute_next (int);
  #extern int rl_clear_pending_input (void);
  #extern int rl_read_key (void);
  #extern int rl_getc (FILE *);
  #extern int rl_set_keyboard_input_timeout (int);

  # `Public' utility functions.
  #
  sub rl_extend_line_buffer( Int )
    is native( LIB ) { * }
  method rl-extend-line-buffer( Int $c ) {
    rl_extend_line_buffer( $c ) }

  sub rl_ding( )
    returns Int
    is native( LIB ) { * }
  method rl-ding( )
    returns Int {
    rl_ding( ) }

  sub rl_alphabetic( Int )
    returns Int
    is native( LIB ) { * }
  method rl-alphabetic( Int $c )
    returns Int {
    rl_alphabetic( $c ) }

  sub rl_free( Pointer )
    is native( LIB ) { * }
  method rl-free( Pointer $p ) {
    rl_free( $p ) }

  # Readline signal handling, from signals.c
  #
  sub rl_set_signals( )
    returns Int
    is native( LIB ) { * }
  method rl-set-signals( )
    returns Int {
    rl_set_signals( ) }

  sub rl_clear_signals( )
    returns Int
    is native( LIB ) { * }
  method rl-clear-signals( )
    returns Int {
    rl_clear_signals( ) }

  sub rl_cleanup_after_signal( )
    is native( LIB ) { * }
  method rl-cleanup-after-signal( ) {
    rl_cleanup_after_signal( ) }

  sub rl_reset_after_signal( )
    is native( LIB ) { * }
  method rl-reset-after-signal( ) {
    rl_reset_after_signal( ) }

  sub rl_free_line_state( )
    is native( LIB ) { * }
  method rl-free-line-state( ) {
    rl_free_line_state( ) }

  sub rl_echo_signal( Int )
    is native( LIB ) { * }
  method rl-echo-signal( Int $c ) {
    rl_echo_signal( $c ) }

  sub rl_set_paren_blink_timeout( Int )
    returns Int
    is native( LIB ) { * }
  method rl-set-paren-blink-timeout( Int $c )
    returns Int {
    rl_set_paren_blink_timeout( $c ) }

  # Completion functions.
  #
  sub rl_complete_internal( Int ) returns Int
    is native( LIB ) { * }
  method rl-complete-internal( Int $i ) returns Int {
    rl_complete_internal( $i ) }

  #extern void rl_display_match_list (char **, int, int);

  #extern char **rl_completion_matches (const char *, rl_compentry_func_t *);

  sub rl_completion_mode( rl_command_func_t )
    returns Int
    is native( LIB ) { * }
  method rl-completion-mode( rl_command_func_t $cb )
    returns Int {
    rl_completion_mode( $cb ) }

  ############################################################
  #  							     #
  #  		Well Published Variables		     #
  #  							     #
  ############################################################
  #
  # The version of this incarnation of the readline library.
  #
  #extern const char *rl_library_version;	/* e.g., "4.2" */
  #extern int rl_readline_version;		/* e.g., 0x0402 */

  # True if this is real GNU readline.
  #
  #extern int rl_gnu_readline_p;

  # Flags word encapsulating the current readline state.
  #
  #extern int rl_readline_state;

  # Says which editing mode readline is currently using.  1 means emacs mode;
  # 0 means vi mode.
  #
  #extern int rl_editing_mode;

  # Insert or overwrite mode for emacs mode.  1 means insert mode; 0 means
  # overwrite mode.  Reset to insert mode on each input line.
  #
  #extern int rl_insert_mode;

  # The name of the calling program.  You should initialize this to
  # whatever was in argv[0].  It is used when parsing conditionals.
  #
  #extern const char *rl_readline_name;

  # The prompt readline uses.  This is set from the argument to
  # readline (), and should not be assigned to directly.
  #
  #extern char *rl_prompt;

  # The prompt string that is actually displayed by rl_redisplay.  Public so
  # applications can more easily supply their own redisplay functions.
  #
  #extern char *rl_display_prompt;

  # The line buffer that is in use.
  #
  #extern char *rl_line_buffer;

  # The location of point, and end.
  #
  #extern int rl_point;
  #extern int rl_end;

  # The mark, or saved cursor position.
  #
  #extern int rl_mark;

  # Flag to indicate that readline has finished with the current input
  # line and should return it.
  #
  #extern int rl_done;

  # If set to a character value, that will be the next keystroke read.
  #
  #extern int rl_pending_input;

  # Non-zero if we called this function from _rl_dispatch().  It's present
  # so functions can find out whether they were called from a key binding
  # or directly from an application.
  #
  #extern int rl_dispatching;

  # Non-zero if the user typed a numeric argument before executing the
  # current function.
  #
  #extern int rl_explicit_arg;

  # The current value of the numeric argument specified by the user.
  #
  #extern int rl_numeric_arg;

  # The address of the last command function Readline executed.
  #
  #extern rl_command_func_t *rl_last_func;

  # The name of the terminal to use.
  #
  #extern const char *rl_terminal_name;

  # The input and output streams.
  #
  #extern FILE *rl_instream;
  #extern FILE *rl_outstream;

  # If non-zero, Readline gives values of LINES and COLUMNS from the environment
  # greater precedence than values fetched from the kernel when computing the
  # screen dimensions.
  #
  #extern int rl_prefer_env_winsize;

  # If non-zero, then this is the address of a function to call just
  # before readline_internal () prints the first prompt.
  #
  #extern rl_hook_func_t *rl_startup_hook;

  # If non-zero, this is the address of a function to call just before
  # readline_internal_setup () returns and readline_internal starts
  # reading input characters.
  #
  #extern rl_hook_func_t *rl_pre_input_hook;

  # The address of a function to call periodically while Readline is
  # awaiting character input, or NULL, for no event handling.
  #
  #extern rl_hook_func_t *rl_event_hook;

  # The address of a function to call if a read is interrupted by a signal.
  #
  #extern rl_hook_func_t *rl_signal_event_hook;

  # The address of a function to call if Readline needs to know whether or not
  # there is data available from the current input source.
  #
  #extern rl_hook_func_t *rl_input_available_hook;

  # The address of the function to call to fetch a character from the current
  # Readline input stream.
  #
  #extern rl_getc_func_t *rl_getc_function;

  #extern rl_voidfunc_t *rl_redisplay_function;

  #extern rl_vintfunc_t *rl_prep_term_function;
  #extern rl_voidfunc_t *rl_deprep_term_function;

  # Dispatch variables.
  #
  #extern Keymap rl_executing_keymap;
  #extern Keymap rl_binding_keymap;

  #extern int rl_executing_key;
  #extern char *rl_executing_keyseq;
  #extern int rl_key_sequence_length;

  # Display variables.
  #
  # If non-zero, readline will erase the entire line, including any prompt,
  # if the only thing typed on an otherwise-blank line is something bound to
  # rl_newline.
  #
  #extern int rl_erase_empty_line;

  # If non-zero, the application has already printed the prompt (rl_prompt)
  # before calling readline, so readline should not output it the first time
  # redisplay is done.
  #
  #extern int rl_already_prompted;

  # A non-zero value means to read only this many characters rather than
  # up to a character bound to accept-line.
  #
  #extern int rl_num_chars_to_read;

  # The text of a currently-executing keyboard macro.
  #
  #extern char *rl_executing_macro;

  # Variables to control readline signal handling.
  #
  # If non-zero, readline will install its own signal handlers for
  # SIGINT, SIGTERM, SIGQUIT, SIGALRM, SIGTSTP, SIGTTIN, and SIGTTOU.
  #
  #extern int rl_catch_signals;

  # If non-zero, readline will install a signal handler for SIGWINCH
  # that also attempts to call any calling application's SIGWINCH signal
  # handler.  Note that the terminal is not cleaned up before the
  # application's signal handler is called; use rl_cleanup_after_signal()
  # to do that.
  #
  #extern int rl_catch_sigwinch;

  # If non-zero, the readline SIGWINCH handler will modify LINES and
  # COLUMNS in the environment.
  #
  #extern int rl_change_environment;

  # Completion variables.
  #
  # Pointer to the generator function for completion_matches ().
  # NULL means to use rl_filename_completion_function (), the default
  # filename completer.
  #
  #extern rl_compentry_func_t *rl_completion_entry_function;

  # Optional generator for menu completion.  Default is
  # rl_completion_entry_function (rl_filename_completion_function).
  #
  # extern rl_compentry_func_t *rl_menu_completion_entry_function;

  # If rl_ignore_some_completions_function is non-NULL it is the address
  # of a function to call after all of the possible matches have been
  # generated, but before the actual completion is done to the input line.
  # The function is called with one argument; a NULL terminated array
  # of (char *).  If your function removes any of the elements, they
  # must be free()'ed.
  #
  #extern rl_compignore_func_t *rl_ignore_some_completions_function;

  # Pointer to alternative function to create matches.
  # Function is called with TEXT, START, and END.
  # START and END are indices in RL_LINE_BUFFER saying what the boundaries
  # of TEXT are.
  # If this function exists and returns NULL then call the value of
  # rl_completion_entry_function to try to match, otherwise use the
  # array of strings returned.
  #
  #extern rl_completion_func_t *rl_attempted_completion_function;

  # The basic list of characters that signal a break between words for the
  # completer routine.  The initial contents of this variable is what
  # breaks words in the shell, i.e. "n\"\\'`@$>".
  #
  #extern const char *rl_basic_word_break_characters;

  # The list of characters that signal a break between words for
  # rl_complete_internal.  The default list is the contents of
  # rl_basic_word_break_characters.
  #
  #extern char *rl_completer_word_break_characters;

  # Hook function to allow an application to set the completion word
  # break characters before readline breaks up the line.  Allows
  # position-dependent word break characters.
  #
  #extern rl_cpvfunc_t *rl_completion_word_break_hook;

  # List of characters which can be used to quote a substring of the line.
  # Completion occurs on the entire substring, and within the substring   
  # rl_completer_word_break_characters are treated as any other character,
  # unless they also appear within this list.
  #
  #extern const char *rl_completer_quote_characters;

  # List of quote characters which cause a word break.
  #
  #extern const char *rl_basic_quote_characters;

  # List of characters that need to be quoted in filenames by the completer.
  #
  #extern const char *rl_filename_quote_characters;

  # List of characters that are word break characters, but should be left
  # in TEXT when it is passed to the completion function.  The shell uses
  # this to help determine what kind of completing to do.
  #
  #extern const char *rl_special_prefixes;

  # If non-zero, then this is the address of a function to call when
  # completing on a directory name.  The function is called with
  # the address of a string (the current directory name) as an arg.  It
  # changes what is displayed when the possible completions are printed
  # or inserted.  The directory completion hook should perform
  # any necessary dequoting.  This function should return 1 if it modifies
  # the directory name pointer passed as an argument.  If the directory
  # completion hook returns 0, it should not modify the directory name
  # pointer passed as an argument.
  #
  #extern rl_icppfunc_t *rl_directory_completion_hook;

  # If non-zero, this is the address of a function to call when completing
  # a directory name.  This function takes the address of the directory name
  # to be modified as an argument.  Unlike rl_directory_completion_hook, it
  # only modifies the directory name used in opendir(2), not what is displayed
  # when the possible completions are printed or inserted.  If set, it takes
  # precedence over rl_directory_completion_hook.  The directory rewrite
  # hook should perform any necessary dequoting.  This function has the same
  # return value properties as the directory_completion_hook.
  #
  # I'm not happy with how this works yet, so it's undocumented.  I'm trying
  # it in bash to see how well it goes.
  #
  #extern rl_icppfunc_t *rl_directory_rewrite_hook;

  # If non-zero, this is the address of a function for the completer to call
  # before deciding which character to append to a completed name.  It should
  # modify the directory name passed as an argument if appropriate, and return
  # non-zero if it modifies the name.  This should not worry about dequoting
  # the filename; that has already happened by the time it gets here. */
  #
  #extern rl_icppfunc_t *rl_filename_stat_hook;

  # If non-zero, this is the address of a function to call when reading
  # directory entries from the filesystem for completion and comparing
  # them to the partial word to be completed.  The function should
  # either return its first argument (if no conversion takes place) or
  # newly-allocated memory.  This can, for instance, convert filenames
  # between character sets for comparison against what's typed at the
  # keyboard.  The returned value is what is added to the list of
  # matches.  The second argument is the length of the filename to be
  # converted.
  #
  #extern rl_dequote_func_t *rl_filename_rewrite_hook;

  # If non-zero, then this is the address of a function to call when
  # completing a word would normally display the list of possible matches.
  # This function is called instead of actually doing the display.
  # It takes three arguments: (char **matches, int num_matches, int max_length)
  # where MATCHES is the array of strings that matched, NUM_MATCHES is the
  # number of strings in that array, and MAX_LENGTH is the length of the
  # longest string in that array.
  #
  #extern rl_compdisp_func_t *rl_completion_display_matches_hook;

  # Non-zero means that the results of the matches are to be treated
  # as filenames.  This is ALWAYS zero on entry, and can only be changed
  # within a completion entry finder function.
  #
  #extern int rl_filename_completion_desired;

  # Non-zero means that the results of the matches are to be quoted using
  # double quotes (or an application-specific quoting mechanism) if the
  # filename contains any characters in rl_word_break_chars.  This is
  # ALWAYS non-zero on entry, and can only be changed within a completion
  # entry finder function.
  #
  #extern int rl_filename_quoting_desired;

  # Set to a function to quote a filename in an application-specific fashion.
  # Called with the text to quote, the type of match found (single or multiple)
  # and a pointer to the quoting character to be used, which the function can
  # reset if desired.
  #
  #extern rl_quote_func_t *rl_filename_quoting_function;

  # Function to call to remove quoting characters from a filename.  Called
  # before completion is attempted, so the embedded quotes do not interfere
  # with matching names in the file system.
  #
  #extern rl_dequote_func_t *rl_filename_dequoting_function;

  # Function to call to decide whether or not a word break character is
  # quoted.  If a character is quoted, it does not break words for the
  # completer.
  #
  #extern rl_linebuf_func_t *rl_char_is_quoted_p;

  # Non-zero means to suppress normal filename completion after the
  # user-specified completion function has been called.
  #
  #extern int rl_attempted_completion_over;

  # Set to a character describing the type of completion being attempted by
  # rl_complete_internal; available for use by application completion
  # functions.
  #
  #extern int rl_completion_type;

  # Set to the last key used to invoke one of the completion functions.
  #
  #extern int rl_completion_invoking_key;

  # Up to this many items will be displayed in response to a
  # possible-completions call.  After that, we ask the user if she
  # is sure she wants to see them all.  The default value is 100.
  #
  #extern int rl_completion_query_items;

  # Character appended to completed words when at the end of the line.  The
  # default is a space.  Nothing is added if this is '\0'.
  #
  #extern int rl_completion_append_character;

  # If set to non-zero by an application completion function,
  # rl_completion_append_character will not be appended.
  #
  #extern int rl_completion_suppress_append;

  # Set to any quote character readline thinks it finds before any application
  # completion function is called.
  #
  #extern int rl_completion_quote_character;

  # Set to a non-zero value if readline found quoting anywhere in the word to
  # be completed; set before any application completion function is called.
  #
  #extern int rl_completion_found_quote;

  # If non-zero, the completion functions don't append any closing quote.
  # This is set to 0 by rl_complete_internal and may be changed by an
  # application-specific completion function.
  #
  #extern int rl_completion_suppress_quote;

  # If non-zero, readline will sort the completion matches.  On by default.
  #
  #extern int rl_sort_completion_matches;

  # If non-zero, a slash will be appended to completed filenames that are
  # symbolic links to directory names, subject to the value of the
  # mark-directories variable (which is user-settable).  This exists so
  # that application completion functions can override the user's preference
  # (set via the mark-symlinked-directories variable) if appropriate.
  # It's set to the value of _rl_complete_mark_symlink_dirs in
  # rl_complete_internal before any application-specific completion
  # function is called, so without that function doing anything, the user's
  # preferences are honored.
  #
  #extern int rl_completion_mark_symlink_dirs;

  # If non-zero, then disallow duplicates in the matches.
  #
  #extern int rl_ignore_completion_duplicates;

  # If this is non-zero, completion is (temporarily) inhibited, and the
  # completion character will be inserted as any other.
  #
  #extern int rl_inhibit_completion;

  # Input error; can be returned by (*rl_getc_function) if readline is reading
  # a top-level command (RL_ISSTATE (RL_STATE_READCMD)).

  constant READERR = -2;

  # Definitions available for use by readline clients.
  #
  constant RL_PROMPT_START_IGNORE = '\001';
  constant RL_PROMPT_END_IGNORE   = '\002';

  # Possible values for do_replace argument to rl_filename_quoting_function,
  # called by rl_complete_internal.
  #
  constant NO_MATCH     = 0;
  constant SINGLE_MATCH = 1;
  constant MULT_MATCH   = 2;

  # Possible state values for rl_readline_state
  #
  constant RL_STATE_NONE	 = 0x0000000; # no state; before first call 

  constant RL_STATE_INITIALIZING = 0x0000001; # initializing
  constant RL_STATE_INITIALIZED	 = 0x0000002; # initialization done
  constant RL_STATE_TERMPREPPED	 = 0x0000004; # terminal is prepped
  constant RL_STATE_READCMD	 = 0x0000008; # reading a command key
  constant RL_STATE_METANEXT	 = 0x0000010; # reading input after ESC
  constant RL_STATE_DISPATCHING	 = 0x0000020; # dispatching to a command
  constant RL_STATE_MOREINPUT	 = 0x0000040; # reading more input in a command function
  constant RL_STATE_ISEARCH	 = 0x0000080; # doing incremental search
  constant RL_STATE_NSEARCH	 = 0x0000100; # doing non-inc search
  constant RL_STATE_SEARCH	 = 0x0000200; # doing a history search
  constant RL_STATE_NUMERICARG	 = 0x0000400; # reading numeric argument
  constant RL_STATE_MACROINPUT	 = 0x0000800; # getting input from a macro
  constant RL_STATE_MACRODEF	 = 0x0001000; # defining keyboard macro
  constant RL_STATE_OVERWRITE	 = 0x0002000; # overwrite mode
  constant RL_STATE_COMPLETING	 = 0x0004000; # doing completion
  constant RL_STATE_SIGHANDLER	 = 0x0008000; # in readline sighandler
  constant RL_STATE_UNDOING	 = 0x0010000; # doing an undo
  constant RL_STATE_INPUTPENDING = 0x0020000; # rl_execute_next called 
  constant RL_STATE_TTYCSAVED	 = 0x0040000; # tty special chars saved
  constant RL_STATE_CALLBACK	 = 0x0080000; # using the callback interface
  constant RL_STATE_VIMOTION	 = 0x0100000; # reading vi motion arg
  constant RL_STATE_MULTIKEY	 = 0x0200000; # reading multiple-key command
  constant RL_STATE_VICMDONCE	 = 0x0400000; # entered vi command mode at least once
  constant RL_STATE_REDISPLAYING = 0x0800000; # updating terminal display

  constant RL_STATE_DONE	 = 0x1000000; # done; accepted line

  #define RL_SETSTATE(x)	(rl_readline_state |= (x))
  #define#RL_UNSETSTATE(x)	(rl_readline_state &= ~(x))
  #define RL_ISSTATE(x)		(rl_readline_state & (x))

  my class readline_state is repr('CStruct') {
    # line state
    has int $.point;  # int point;
    has int $.end;    # int end;
    has int $.mark;   # int mark;
    has Str $.buffer; # char *buffer;
    has int $.buflen; # int buflen;
    has Pointer $.ul; # UNDO_LIST *ul;
    has Str $.prompt; # char *prompt;

    # global state
    has int $.rlstate; # int rlstate;
    has int $.done; # int done;
    has Pointer $.keymap; # Keymap kmap;

    # input state
    has Pointer $.lastfunc; # rl_command_func_t *lastfunc;
    has int $.insmode;      # int insmode;
    has int $.edmode;       # int edmode;
    has int $.kseqlen;      # int kseqlen;
    has Pointer $.inf;      # FILE *inf;
    has Pointer $.outf;     # FILE *outf;
    has int $.pendingin;    # int pendingin;
    has Str $.macro;        # char *macro;

    # signal state
    has int $.catchsigs;     # int catchsigs;
    has int $.catchsigwinch; # int catchsigwinch;

    # search state

    # completion state

    # options state

    # reserved for future expansion, so the struct size doesn't change
    has int $.reserved; # char reserved[64]; # XXX
  }

  sub rl_save_state( readline_state )
    returns Int
    is native( LIB ) { * }
  method rl-save-state( readline_state $state )
    returns Int {
    rl_save_state( $state ) }

  sub rl_restore_state( readline_state )
    returns Int
    is native( LIB ) { * }
  method rl-restore-state( readline_state $state )
    returns Int {
    rl_restore_state( $state ) }

  ############################################################################
  #
  # rltypedefs.h -- Type declarations for readline functions. */
  #
  # Typedefs for the completion system
  #
  #typedef char *rl_compentry_func_t (const char *, int);
  #typedef char **rl_completion_func_t (const char *, int, int);

  #typedef char *rl_quote_func_t (char *, int, char *);
  #typedef char *rl_dequote_func_t (char *, int);

  #typedef int rl_compignore_func_t (char **);

  #typedef void rl_compdisp_func_t (char **, int, int);

  # Type for input and pre-read hook functions like rl_event_hook
  #
  #typedef int rl_hook_func_t (void);

  # Input function type
  #
  #typedef int rl_getc_func_t (FILE *);

  # Generic function that takes a character buffer (which could be the readline
  # line buffer) and an index into it (which could be rl_point) and returns
  # an int.
  #
  #typedef int rl_linebuf_func_t (char *, int);

  # `Generic' function pointer typedefs
  #
  #typedef int rl_intfunc_t (int);
  ##define rl_ivoidfunc_t rl_hook_func_t
  #typedef int rl_icpfunc_t (char *);
  #typedef int rl_icppfunc_t (char **);

  #typedef void rl_voidfunc_t (void);
  #typedef void rl_vintfunc_t (int);
  #typedef void rl_vcpfunc_t (char *);
  #typedef void rl_vcppfunc_t (char **);
  #
  #typedef char *rl_cpvfunc_t (void);
  #typedef char *rl_cpifunc_t (int);
  #typedef char *rl_cpcpfunc_t (char  *);
  #typedef char *rl_cpcppfunc_t (char  **);

  #############################################################################
  #
  # tilde.h: Externally available variables and function in libtilde.a.
  #
  #typedef char *tilde_hook_func_t (char *);

  # If non-null, this contains the address of a function that the application
  # wants called before trying the standard tilde expansions.  The function
  # is called with the text sans tilde, and returns a malloc()'ed string
  # which is the expansion, or a NULL pointer if the expansion fails.
  #
  #extern tilde_hook_func_t *tilde_expansion_preexpansion_hook;

  # If non-null, this contains the address of a function to call if the
  # standard meaning for expanding a tilde fails.  The function is called
  # with the text (sans tilde, as in "foo"), and returns a malloc()'ed string
  # which is the expansion, or a NULL pointer if there is no expansion.
  #
  #extern tilde_hook_func_t *tilde_expansion_failure_hook;

  # When non-null, this is a NULL terminated array of strings which
  # are duplicates for a tilde prefix.  Bash uses this to expand
  # `=~' and `:~'.
  #
  #extern char **tilde_additional_prefixes;

  # When non-null, this is a NULL terminated array of strings which match
  # the end of a username, instead of just "/".  Bash sets this to
  # `:' and `=~'.
  #
  #extern char **tilde_additional_suffixes;

  # Return a new string which is the result of tilde expanding STRING.
  #
  sub tilde_expand( Str )
    returns Str
    is native( LIB ) { * }
  method tilde-expand( Str $filename )
    returns Str {
    tilde_expand( $filename ) }

  # Do the work of tilde expansion on FILENAME.  FILENAME starts with a
  # tilde.  If there is no expansion, call tilde_expansion_failure_hook.
  #
  sub tilde_expand_word( Str )
    returns Str
    is native( LIB ) { * }
  method tilde-expand-word( Str $filename )
    returns Str {
    tilde_expand_word( $filename ) }

  # Find the portion of the string beginning with ~ that should be expanded.
  #
  sub tilde_find_word( Str, Int, Pointer[Int] ) returns Str
    is native( LIB ) { * }
  method tilde-find-word( Str $str, Int $offset, Pointer[Int] $p-offset )
    returns Str {
      tilde_find_word( $str, $offset, $p-offset ) }
}
