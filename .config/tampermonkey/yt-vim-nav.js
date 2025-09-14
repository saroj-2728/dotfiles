// ==UserScript==
// @name         YouTube Vim Navigation
// @namespace    https://saroj27.com.np
// @version      3.3
// @description  Simple vim-style hjkl navigation for YouTube with miniplayer fix (optimized)
// @author       SP
// @match        https://www.youtube.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    let videos = [];
    let currentIndex = 0;
    let lastPath = '';
    let videosCache = new Map();
    let cacheTime = 0;
    const CACHE_DURATION = 2000; // 2 seconds

    function getVideos() {
        const path = window.location.pathname;
        const now = Date.now();

        // Check cache first
        if (path === lastPath && videosCache.has(path) && (now - cacheTime) < CACHE_DURATION) {
            return videosCache.get(path);
        }

        let selectors = [];
        if (path === '/' || path === '/home') {
            selectors = ['ytd-rich-item-renderer', 'ytd-video-renderer'];
        } else if (path === '/results') {
            selectors = ['ytd-video-renderer', 'ytd-playlist-renderer', 'ytd-channel-renderer'];
        } else if (path.startsWith('/watch')) {
            selectors = ['ytd-compact-video-renderer'];
        }

        if (selectors.length === 0) {
            videosCache.set(path, []);
            return [];
        }

        // Use single query with combined selectors
        const elements = document.querySelectorAll(selectors.join(', '));
        const result = [];

        // Filter in single loop instead of chaining
        for (const el of elements) {
            if (el.querySelector('a#video-title-link, a#video-title')) {
                result.push(el);
            }
        }

        // Cache result
        videosCache.set(path, result);
        cacheTime = now;
        lastPath = path;

        return result;
    }

    function updateVideos() {
        videos = getVideos();
        if (currentIndex >= videos.length) {
            currentIndex = Math.max(0, videos.length - 1);
        }
    }

    function clearHighlight() {
        // More efficient: only clear if there's something to clear
        const selected = document.querySelector('[data-vim-selected]');
        if (selected) {
            selected.style.outline = '';
            selected.style.background = '';
            selected.style.borderRadius = '';
            selected.removeAttribute('data-vim-selected');
        }
    }

    function highlight() {
        clearHighlight();
        if (videos.length === 0) return;

        const video = videos[currentIndex];
        if (video) {
            video.style.outline = '3px solid #4285f4';
            video.style.background = 'rgba(66, 133, 244, 0.1)';
            video.style.borderRadius = '12px';
            video.setAttribute('data-vim-selected', 'true');
            video.scrollIntoView({behavior: 'smooth', block: 'center'});
        }
    }

    function move(direction) {
        if (videos.length === 0) return;

        const oldIndex = currentIndex;

        switch(direction) {
            case 'down':
                currentIndex = Math.min(currentIndex + 1, videos.length - 1);
                break;
            case 'up':
                currentIndex = Math.max(currentIndex - 1, 0);
                break;
            case 'left':
                currentIndex = Math.max(currentIndex - 1, 0);
                break;
            case 'right':
                currentIndex = Math.min(currentIndex + 1, videos.length - 1);
                break;
        }

        // Only highlight if index actually changed
        if (oldIndex !== currentIndex) {
            highlight();
        }
    }

    function playSelected() {
        if (videos.length === 0) return;

        const video = videos[currentIndex];
        if (!video) return;

        const link = video.querySelector('a#video-title-link, a#video-title, a.ytd-channel-name');
        if (link) {
            link.click();
        }
    }

    function isMiniplayer() {
        return window.location.pathname !== '/watch';
    }

    function init() {
        updateVideos();
        if (videos.length > 0) {
            currentIndex = 0;
            highlight();
        }
    }

    function reset() {
        clearHighlight();
        currentIndex = 0;
        // Clear cache on page change
        videosCache.clear();
        cacheTime = 0;
        lastPath = '';
        setTimeout(init, 200);
    }

    // Throttle function for performance
    function throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        }
    }

    // Key event handler with capture phase
    document.addEventListener('keydown', e => {
        const active = document.activeElement;

        // Handle escape key for any input field (including search bar)
        if (e.key === 'Escape') {
            if (active && (
                active.tagName === 'INPUT' ||
                active.tagName === 'TEXTAREA' ||
                active.isContentEditable
            )) {
                active.blur();
                e.preventDefault();
                e.stopPropagation();
                return;
            }
        }

        // Skip if typing in input fields
        if (active && (
            active.tagName === 'INPUT' ||
            active.tagName === 'TEXTAREA' ||
            active.isContentEditable
        )) return;

        // Check if we're on the watch page
        const isWatchPage = window.location.pathname.startsWith('/watch');

        // If on watch page and NOT in miniplayer mode, let YouTube handle the keys
        if (isWatchPage && !isMiniplayer()) {
            // Only handle navigation keys if there are videos to navigate (sidebar)
            if (!['j', 'k', 'h', 'l', 'p'].includes(e.key)) {
                switch(e.key) {
                    case 'b':
                        window.history.back();
                        e.preventDefault();
                        e.stopPropagation();
                        break;
                    case 'n':
                        window.history.forward();
                        e.preventDefault();
                        e.stopPropagation();
                        break;
                }
            }
            return; // Let YouTube handle j,k,l keys normally
        }

        // Handle vim navigation keys
        switch(e.key) {
            case 'j':
                move('down');
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
            case 'k':
                move('up');
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
            case 'h':
                move('left');
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
            case 'l':
                move('right');
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
            case 'p':
                playSelected();
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
            case 'b':
                window.history.back();
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
            case 'n':
                window.history.forward();
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                break;
        }
    }, true); // Use capture phase to catch events before YouTube does

    // Handle page changes with throttling
    let lastUrl = location.href;
    const throttledReset = throttle(reset, 100);

    const observer = new MutationObserver(() => {
        if (location.href !== lastUrl) {
            lastUrl = location.href;
            throttledReset();
        }
    });

    observer.observe(document.body, {childList: true, subtree: true});

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Optimized periodic check - only run if no videos found and not too frequently
    let lastCheck = 0;
    const checkInterval = setInterval(() => {
        const now = Date.now();
        if (videos.length === 0 && (now - lastCheck) > 3000) { // Check every 3 seconds instead of 1
            lastCheck = now;
            init();
        }
    }, 3000);

    // Cleanup interval on page unload
    window.addEventListener('beforeunload', () => {
        clearInterval(checkInterval);
    });
})();
