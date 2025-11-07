# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a test repository for Saxon-JS 2, designed to reproduce and test event handling and various XSLT transformations in a browser environment. It demonstrates interactive XSLT (IXSL) capabilities including event listeners, asynchronous operations, promises, and DOM manipulation.

## Build Commands

### Compile XSLT to SEF (Stylesheet Export Format)

Run the shell script to compile all XSLT stylesheets to SEF JSON format:

```bash
./generate-sef.sh
```

This script uses `xslt3-he` (via npx) to compile:
- `client.xsl` → `client.xsl.sef.json`
- `test-pi.xsl` → `test-pi.xsl.sef.json`

Individual compilation:
```bash
npx xslt3-he -t -xsl:./client.xsl -export:./client.xsl.sef.json -nogo -ns:##html5 -relocate:on
```

### Run Local Server

Start the Python test server (serves with custom headers for testing multi-valued headers):

```bash
python server/server.py
```

This runs on port 8000 and serves files from the parent directory with proper Content-Type headers.

## Architecture

### Core Files

- **SaxonJS3.js / SaxonJS3.rt.js**: Saxon-JS 3 runtime libraries (production and development builds)
- **client.xsl**: Main XSLT stylesheet with extensive IXSL event handlers and test cases
- **client.js**: JavaScript helper functions (`customFetch`, `ixslTemplateListener`) that work with Saxon-JS
- **index.html**: Main test page that initializes Saxon-JS with document pool and stylesheet parameters

### XSLT Structure (client.xsl)

The main stylesheet demonstrates Saxon-JS capabilities:

1. **Event Handling Modes**: Uses IXSL event modes like `ixsl:onclick`, `ixsl:onblur`, `ixsl:onsubmit`, `ixsl:ondrop`, `ixsl:ondragstart`, etc.

2. **Asynchronous Operations**:
   - `<ixsl:schedule-action>` for HTTP requests and delayed operations
   - `<ixsl:promise>` for promise-based asynchronous flows
   - Promise chaining with `ixsl:then()` and updating functions

3. **DOM Manipulation**:
   - `<xsl:result-document>` with IXSL methods (`ixsl:replace-content`, `ixsl:append-content`, `ixsl:replace-element`)
   - Dynamic element creation and lookup using `id()` and `key()` functions

4. **JavaScript Interop**:
   - `ixsl:call()` for calling JavaScript functions
   - `ixsl:get()` for accessing JavaScript object properties
   - `js:` namespace for direct JavaScript function invocation
   - `ixsl:eval()` for evaluating JavaScript expressions

5. **Document Pool**: The initialization in index.html demonstrates URL mapping (e.g., mapping W3C RDF namespace URL to local test.xml)

### Test Cases by ID

The test buttons in index.html exercise specific Saxon-JS features:
- `test-function`: Tests function invocation from HTTP response callbacks
- `custom-handler`: Custom event dispatching and handling
- `push-state`: Browser history API integration
- `class-key`: XSL key and id() lookup after DOM modifications
- `next-match`: Template matching priority and `<xsl:next-match>`
- `load-mapped-doc`: Document pool URL mapping
- `add-listener`, `onclick-listener`: Dynamic event listener registration
- `look-up-created-element`: Element lookup after dynamic creation
- `nested-promise`, `return-promise`: Promise handling patterns
- `test-svg`: SVG namespace preservation during DOM operations

### Key XSLT Patterns

- **Context-item templates**: Many templates use `<xsl:context-item as="map(*)" use="required"/>` to process HTTP response maps
- **Updating functions**: Functions marked with `ixsl:updating="yes"` can use `<xsl:result-document>`
- **Schedule actions**: HTTP requests wrapped in `<ixsl:schedule-action>` with response callback templates
- **Global parameters**: `$global-param` passed during transformation initialization

## Development Workflow

1. Edit XSLT files (client.xsl, test-pi.xsl)
2. Run `./generate-sef.sh` to recompile to SEF format
3. Open index.html in a browser (or use the Python server for header testing)
4. Check browser console for `<xsl:message>` output
5. Test various button interactions to verify IXSL event handling
