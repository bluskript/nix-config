/**
 * @template T
 * @param {T[]} arr
 * @param {(v: T) => boolean} predicate
 */
function removeFirst(arr, predicate) {
    const idx = arr.findIndex(predicate);
    if (idx !== -1) arr.splice(idx, 1);
}

// Discord fixes
browser.webRequest.onHeadersReceived.addListener(
    ({ responseHeaders, type, url }) => {
        if (!responseHeaders) return;

        if (type === "main_frame") {
            // In main frame requests, the CSP needs to be removed to enable fetching of custom css
            // as desired by the user
            removeFirst(responseHeaders, h => h.name.toLowerCase() === "content-security-policy");
        } else if (type === "stylesheet" && url.startsWith("https://raw.githubusercontent.com/")) {
            // Most users will load css from GitHub, but GitHub doesn't set the correct content type,
            // so we fix it here
            removeFirst(responseHeaders, h => h.name.toLowerCase() === "content-type");
            responseHeaders.push({
                name: "Content-Type",
                value: "text/css"
            });
        }
        return { responseHeaders };
    },
    { urls: ["https://raw.githubusercontent.com/*", "*://*.discord.com/*", "https://ws.audioscrobbler.com/*"], types: ["main_frame", "stylesheet"] },
    ["blocking", "responseHeaders"]
);

browser.webRequest.onBeforeSendHeaders.addListener(
    ({requestHeaders}) => {
        if (!requestHeaders) return;
        removeFirst(requestHeaders, h => ["if-none-match", "if-modified-since"].includes(h.name.toLowerCase()))
        return { requestHeaders }
    },
    { urls: ["*://*/*"] },
    ["blocking", "requestHeaders"]
)

browser.webRequest.onHeadersReceived.addListener(
    ({ responseHeaders }) => {
        if (!responseHeaders) return;
        removeFirst(responseHeaders, h => h.name.toLowerCase() === "etag")
        return { responseHeaders }
    },
    { urls: ["*://*/*"] },
    ["blocking", "responseHeaders"]
)
