import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart'; // For clipboard
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech

class InAppBrowserPage extends StatelessWidget {
  final String url;
  const InAppBrowserPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _InAppBrowserWeb(url: url);
    } else {
      return _InAppBrowserMobile(url: url);
    }
  }
}

/// ----------------- Web Implementation -----------------
class _InAppBrowserWeb extends StatelessWidget {
  final String url;
  const _InAppBrowserWeb({required this.url});

  void _openInNewTab(String url) {
    print('Would open: $url in new tab (web implementation)');
  }

  void _openInSameTab(String url) {
    print('Would open: $url in same tab (web implementation)');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.web, size: 64),
            const SizedBox(height: 16),
            Text('Web URL: $url', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _openInNewTab(url);
                  },
                  child: const Text('Open in New Tab'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _openInSameTab(url);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Open in Same Tab'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------- Mobile Implementation -----------------
class _InAppBrowserMobile extends StatefulWidget {
  final String url;
  const _InAppBrowserMobile({required this.url});

  @override
  State<_InAppBrowserMobile> createState() => __InAppBrowserMobileState();
}

class __InAppBrowserMobileState extends State<_InAppBrowserMobile> {
  late WebViewController controller;
  bool isLoading = true;
  bool hasError = false;
  int loadingProgress = 0;
  String? errorMessage;
  String? pageTitle;
  bool isDesktopMode = false;
  double desktopZoomLevel = 1.0;
  double desktopWidth = 1200;
  bool showDesktopControls = false;

  // Minimize state variables
  bool _isMinimized = false;
  Offset _miniWindowPosition = Offset.zero;
  bool _isDragging = false;

  // Track current page type
  String _currentPageType =
      'unknown'; // 'search_home', 'search_results', 'unknown'

  // New feature state variables
  bool _isWhiteScreenMode = false;
  bool _isListening = false;
  bool _isFindingInPage = false;
  String _findText = '';
  int _currentFindIndex = 0;
  int _totalFindMatches = 0;
  final TextEditingController _findTextController = TextEditingController();
  final FlutterTts _tts = FlutterTts();
  bool _isTamil =
      false; // Track current language (false = English, true = Tamil)

  // Desktop user agent strings for different platforms
  static const String desktopUserAgentWindows =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';
  static const String desktopUserAgentMac =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';
  static const String desktopUserAgentLinux =
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    _initializeTts();
    // Initialize mini window position to bottom right
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _miniWindowPosition = Offset(
          MediaQuery.of(context).size.width - 150,
          MediaQuery.of(context).size.height - 150,
        );
      });
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _findTextController.dispose();
    super.dispose();
  }

  void _initializeTts() {
    _tts.setStartHandler(() {
      setState(() {
        _isListening = true;
      });
    });

    _tts.setCompletionHandler(() {
      setState(() {
        _isListening = false;
      });
    });

    _tts.setErrorHandler((message) {
      setState(() {
        _isListening = false;
      });
    });
  }

  void _initializeWebViewController() {
    String formattedUrl = widget.url;
    if (!formattedUrl.startsWith('http://') &&
        !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
              hasError = false;
              errorMessage = null;
              pageTitle = null;
              _currentPageType = 'unknown';
              _isFindingInPage = false;
              _findText = '';
              _currentFindIndex = 0;
              _totalFindMatches = 0;
              _isTamil = false; // Reset to English on new page
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
              loadingProgress = 100;
            });
            controller.getTitle().then((title) {
              setState(() {
                pageTitle = title ?? 'Untitled';
              });
            });

            // Detect page type based on URL or content
            _detectPageType(url);

            // If in desktop mode, inject CSS to simulate desktop viewport
            if (isDesktopMode) {
              _injectDesktopViewportCSS();
            }
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              hasError = true;
              errorMessage = 'Error: ${error.errorCode} - ${error.description}';
            });
          },
          onNavigationRequest: (request) {
            // Detect page type when navigating to new URLs
            _detectPageType(request.url);
            return NavigationDecision.navigate;
          },
        ),
      );

    // Set user agent based on current mode
    if (isDesktopMode) {
      controller.setUserAgent(desktopUserAgentWindows);
    }

    controller.loadRequest(Uri.parse(formattedUrl));
  }

  void _detectPageType(String url) {
    if (url.contains('search') || url.contains('query') || url.contains('q=')) {
      setState(() {
        _currentPageType = 'search_results';
      });
    } else if (url.endsWith('/') ||
        url.contains('home') ||
        url.contains('index') ||
        pageTitle?.toLowerCase().contains('home') == true) {
      setState(() {
        _currentPageType = 'search_home';
      });
    } else {
      setState(() {
        _currentPageType = 'unknown';
      });
    }

    print('Detected page type: $_currentPageType for URL: $url');
  }

  void _injectDesktopViewportCSS() {
    final css =
        '''
    <style>
      body {
        min-width: ${desktopWidth}px !important;
        zoom: ${desktopZoomLevel} !important;
        -webkit-text-size-adjust: ${desktopZoomLevel * 100}% !important;
        transform: scale(${desktopZoomLevel}) !important;
        transform-origin: top left !important;
        width: ${desktopWidth}px !important;
      }
      .container, .wrapper, .main, .content {
        width: 100% !important;
        max-width: ${desktopWidth}px !important;
        margin: 0 auto !important;
      }
      header, footer, nav, section, article {
        width: 100% !important;
      }
      img, video, iframe {
        max-width: 100% !important;
        height: auto !important;
      }
      nav ul, .navigation ul, .menu ul {
        display: flex !important;
        flex-wrap: wrap !important;
      }
      nav li, .navigation li, .menu li {
        display: inline-block !important;
        white-space: nowrap !important;
      }
      .grid, .row, .columns {
        display: flex !important;
        flex-wrap: wrap !important;
      }
      input, textarea, select {
        font-size: 16px !important;
      }
    </style>
    ''';

    final js =
        '''
    (function() {
      var existingMeta = document.querySelector('meta[name="viewport"]');
      if (existingMeta) {
        existingMeta.remove();
      }
      var meta = document.createElement('meta');
      meta.name = "viewport";
      meta.content = "width=${desktopWidth}, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes";
      document.head.appendChild(meta);
      var style = document.createElement('style');
      style.innerHTML = \'''$css\''';
      document.head.appendChild(style);
      document.body.style.display = 'none';
      document.body.offsetHeight;
      document.body.style.display = 'block';
      console.log('Desktop mode activated with viewport width ${desktopWidth} and zoom ${desktopZoomLevel}');
    })();
    ''';

    controller.runJavaScript(js);
  }

  void _toggleDesktopMode() {
    setState(() {
      isDesktopMode = !isDesktopMode;
      if (isDesktopMode) {
        desktopZoomLevel = 0.8;
        desktopWidth = 1200;
      }
    });
    _initializeWebViewController();
  }

  void _adjustDesktopZoom(double zoomChange) {
    setState(() {
      desktopZoomLevel = (desktopZoomLevel + zoomChange).clamp(0.5, 1.5);
    });
    _injectDesktopViewportCSS();
  }

  void _adjustDesktopWidth(double widthChange) {
    setState(() {
      desktopWidth = (desktopWidth + widthChange).clamp(800, 2000).toDouble();
    });
    _injectDesktopViewportCSS();
  }

  void _reloadWebView() {
    setState(() {
      isLoading = true;
      hasError = false;
      loadingProgress = 0;
      errorMessage = null;
    });
    controller.reload();
  }

  void _shareUrl() {
    print('Share URL: ${widget.url}');
  }

  void _bookmarkUrl() {
    print('Bookmark URL: ${widget.url}');
  }

  void _openInBrowser() {
    print('Open in external browser: ${widget.url}');
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: widget.url));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copied to clipboard')));
  }

  void _removeResult() {
    setState(() {
      _isWhiteScreenMode = true;
    });
  }

  void _listenToPage() async {
    try {
      if (_isListening) {
        await _tts.stop();
        setState(() {
          _isListening = false;
        });
        return;
      }

      final String? pageContent =
          await controller.runJavaScriptReturningResult(
                "document.body.innerText",
              )
              as String?;

      if (pageContent != null && pageContent.isNotEmpty) {
        await _tts.speak(pageContent);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No content to read')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error reading page: $e')));
    }
  }

  void _findInPage() {
    setState(() {
      _isFindingInPage = true;
      _findText = '';
      _currentFindIndex = 0;
      _totalFindMatches = 0;
      _findTextController.clear();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Find in Page'),
              Text(
                _totalFindMatches > 0
                    ? '${_currentFindIndex + 1}/$_totalFindMatches'
                    : '0/0',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          content: TextField(
            controller: _findTextController,
            decoration: InputDecoration(
              hintText: 'Enter text to find',
              border: const OutlineInputBorder(),
              suffixIcon: _findText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _findTextController.clear();
                        setState(() {
                          _findText = '';
                          _currentFindIndex = 0;
                          _totalFindMatches = 0;
                        });
                        _clearFindHighlight();
                      },
                    )
                  : null,
            ),
            autofocus: true,
            onChanged: (value) {
              setState(() {
                _findText = value;
              });
              if (value.isNotEmpty) {
                _executeFind(value);
              } else {
                _clearFindHighlight();
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _findNext();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: _findText.isEmpty ? null : _findPrevious,
              tooltip: 'Previous match',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: _findText.isEmpty ? null : _findNext,
              tooltip: 'Next match',
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isFindingInPage = false;
                });
                _clearFindHighlight();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isFindingInPage = false;
      });
      _clearFindHighlight();
    });
  }

  void _executeFind(String text) async {
    try {
      await _clearFindHighlight();

      final safeText = text.replaceAll("'", "\\'");

      final String result =
          await controller.runJavaScriptReturningResult('''
        (function() {
          // Clear previous highlights
          const prevHighlights = document.querySelectorAll('.find-highlight, .find-highlight-active');
          prevHighlights.forEach(el => {
            el.replaceWith(el.textContent);
          });

          window.findMatches = [];
          window.currentFindIndex = -1;

          if (!'$safeText') return JSON.stringify({count: 0, current: -1});

          // Function to escape regex special characters
          function escapeRegex(s) {
            return s.replace(/[.*+?^=!:{}()|[\\]\\\\]/g, '\\\\\$&');
          }

          // Walk through DOM to find text nodes
          const regex = new RegExp(escapeRegex('$safeText'), 'gi');
          const walker = document.createTreeWalker(
            document.body,
            NodeFilter.SHOW_TEXT,
            {
              acceptNode: function(node) {
                return node.parentElement.tagName !== 'SCRIPT' &&
                       node.parentElement.tagName !== 'STYLE' &&
                       node.nodeValue.trim() !== ''
                  ? NodeFilter.FILTER_ACCEPT
                  : NodeFilter.FILTER_REJECT;
              }
            }
          );

          const nodesToProcess = [];
          let node;
          while (node = walker.nextNode()) {
            if (regex.test(node.nodeValue)) {
              nodesToProcess.push(node);
            }
          }

          // Process each text node
          nodesToProcess.forEach(node => {
            const parent = node.parentElement;
            if (!parent) return;

            const fragment = document.createDocumentFragment();
            const matches = node.nodeValue.matchAll(regex);
            let lastIndex = 0;

            for (const match of matches) {
              const matchIndex = match.index;
              const matchText = match[0];

              // Add text before match
              if (matchIndex > lastIndex) {
                fragment.appendChild(document.createTextNode(
                  node.nodeValue.slice(lastIndex, matchIndex)
                ));
              }

              // Add highlighted match
              const mark = document.createElement('mark');
              mark.className = 'find-highlight';
              mark.style.backgroundColor = 'yellow';
              mark.style.color = 'black';
              mark.textContent = matchText;
              fragment.appendChild(mark);

              lastIndex = matchIndex + matchText.length;
            }

            // Add remaining text
            if (lastIndex < node.nodeValue.length) {
              fragment.appendChild(document.createTextNode(
                node.nodeValue.slice(lastIndex)
              ));
            }

            // Replace original node
            parent.replaceChild(fragment, node);
          });

          // Collect all matches
          const matches = document.querySelectorAll('.find-highlight');
          window.findMatches = Array.from(matches);
          window.currentFindIndex = matches.length > 0 ? 0 : -1;

          // Highlight first match if exists
          if (window.currentFindIndex >= 0) {
            const firstMatch = window.findMatches[0];
            firstMatch.classList.add('find-highlight-active');
            firstMatch.style.backgroundColor = 'orange';
            firstMatch.scrollIntoView({ behavior: 'smooth', block: 'center' });
          }

          return JSON.stringify({
            count: matches.length,
            current: window.currentFindIndex
          });
        })();
      ''')
              as String;

      final Map<String, dynamic> resultData = {'count': 0, 'current': -1};
      try {
        final parsed = json.decode(result);
        if (parsed is Map<String, dynamic>) {
          resultData['count'] = parsed['count'] ?? 0;
          resultData['current'] = parsed['current'] ?? -1;
        }
      } catch (e) {
        print('Error parsing find result: $e');
      }

      setState(() {
        _totalFindMatches = resultData['count'];
        _currentFindIndex = resultData['current'];
      });
    } catch (e) {
      print('Error finding text: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error finding text: $e')));
    }
  }

  void _findNext() async {
    if (_totalFindMatches == 0) return;

    try {
      final String result =
          await controller.runJavaScriptReturningResult('''
        (function() {
          if (!window.findMatches || window.findMatches.length === 0) {
            return JSON.stringify({count: 0, current: -1});
          }

          // Remove previous active highlight
          const active = document.querySelector('.find-highlight-active');
          if (active) {
            active.style.backgroundColor = 'yellow';
            active.classList.remove('find-highlight-active');
          }

          // Move to next match
          window.currentFindIndex = (window.currentFindIndex + 1) % window.findMatches.length;
          const currentMatch = window.findMatches[window.currentFindIndex];

          // Highlight active match
          currentMatch.classList.add('find-highlight-active');
          currentMatch.style.backgroundColor = 'orange';

          // Scroll to match with offset to ensure visibility
          const rect = currentMatch.getBoundingClientRect();
          const scrollY = window.scrollY + rect.top - (window.innerHeight / 2) + (rect.height / 2);
          window.scrollTo({ top: scrollY, behavior: 'smooth' });

          return JSON.stringify({
            count: window.findMatches.length,
            current: window.currentFindIndex
          });
        })();
      ''')
              as String;

      final Map<String, dynamic> resultData = {
        'count': _totalFindMatches,
        'current': _currentFindIndex,
      };
      try {
        final parsed = json.decode(result);
        if (parsed is Map<String, dynamic>) {
          resultData['count'] = parsed['count'] ?? _totalFindMatches;
          resultData['current'] = parsed['current'] ?? _currentFindIndex;
        }
      } catch (e) {
        print('Error parsing find next result: $e');
      }

      setState(() {
        _totalFindMatches = resultData['count'];
        _currentFindIndex = resultData['current'];
      });
    } catch (e) {
      print('Error finding next: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error finding next: $e')));
    }
  }

  void _findPrevious() async {
    if (_totalFindMatches == 0) return;

    try {
      final String result =
          await controller.runJavaScriptReturningResult('''
        (function() {
          if (!window.findMatches || window.findMatches.length === 0) {
            return JSON.stringify({count: 0, current: -1});
          }

          // Remove previous active highlight
          const active = document.querySelector('.find-highlight-active');
          if (active) {
            active.style.backgroundColor = 'yellow';
            active.classList.remove('find-highlight-active');
          }

          // Move to previous match
          window.currentFindIndex = (window.currentFindIndex - 1 + window.findMatches.length) % window.findMatches.length;
          const currentMatch = window.findMatches[window.currentFindIndex];

          // Highlight active match
          currentMatch.classList.add('find-highlight-active');
          currentMatch.style.backgroundColor = 'orange';

          // Scroll to match with offset to ensure visibility
          const rect = currentMatch.getBoundingClientRect();
          const scrollY = window.scrollY + rect.top - (window.innerHeight / 2) + (rect.height / 2);
          window.scrollTo({ top: scrollY, behavior: 'smooth' });

          return JSON.stringify({
            count: window.findMatches.length,
            current: window.currentFindIndex
          });
        })();
      ''')
              as String;

      final Map<String, dynamic> resultData = {
        'count': _totalFindMatches,
        'current': _currentFindIndex,
      };
      try {
        final parsed = json.decode(result);
        if (parsed is Map<String, dynamic>) {
          resultData['count'] = parsed['count'] ?? _totalFindMatches;
          resultData['current'] = parsed['current'] ?? _currentFindIndex;
        }
      } catch (e) {
        print('Error parsing find previous result: $e');
      }

      setState(() {
        _totalFindMatches = resultData['count'];
        _currentFindIndex = resultData['current'];
      });
    } catch (e) {
      print('Error finding previous: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error finding previous: $e')));
    }
  }

  Future<void> _clearFindHighlight() async {
    try {
      await controller.runJavaScript('''
        (function() {
          const highlights = document.querySelectorAll('.find-highlight, .find-highlight-active');
          highlights.forEach(el => {
            el.replaceWith(el.textContent);
          });
          window.findMatches = [];
          window.currentFindIndex = -1;
        })();
      ''');
      setState(() {
        _totalFindMatches = 0;
        _currentFindIndex = -1;
      });
    } catch (e) {
      print('Error clearing find highlight: $e');
    }
  }

  void _translatePage() async {
    try {
      setState(() {
        _isTamil = !_isTamil;
      });

      final String targetLang = _isTamil ? 'ta' : 'en';

      await controller.runJavaScript('''
        (function() {
          // Remove previous translations if any
          const translated = document.querySelectorAll('[data-translated]');
          translated.forEach(el => {
            el.textContent = el.getAttribute('data-original') || el.textContent;
            el.removeAttribute('data-translated');
            el.removeAttribute('data-original');
          });

          if ('$targetLang' === 'en') return;

          // Function to translate text to Tamil
          async function translateText(text) {
            try {
              // Simple dictionary-based translation (replace with actual translation logic or API)
              const translations = {
                // Add more translations as needed
                'hello': 'வணக்கம்',
                'world': 'உலகம்',
                'welcome': 'வரவேற்கிறோம்',
                'home': 'வீடு',
                'about': 'பற்றி',
                'contact': 'தொடர்பு'
              };
              return translations[text.toLowerCase()] || text;
            } catch (e) {
              console.error('Translation error:', e);
              return text;
            }
          }

          // Walk through DOM to find text nodes
          const walker = document.createTreeWalker(
            document.body,
            NodeFilter.SHOW_TEXT,
            {
              acceptNode: function(node) {
                return node.parentElement.tagName !== 'SCRIPT' &&
                       node.parentElement.tagName !== 'STYLE' &&
                       node.nodeValue.trim() !== ''
                  ? NodeFilter.FILTER_ACCEPT
                  : NodeFilter.FILTER_REJECT;
              }
            }
          );

          const nodesToProcess = [];
          let node;
          while (node = walker.nextNode()) {
            nodesToProcess.push(node);
          }

          // Process each text node
          for (const node of nodesToProcess) {
            const text = node.nodeValue.trim();
            if (text) {
              const parent = node.parentElement;
              if (!parent) continue;
              const translatedText = '$targetLang' === 'ta' ? 
                await translateText(text) : text;
              if (translatedText !== text) {
                parent.setAttribute('data-original', text);
                parent.setAttribute('data-translated', 'true');
                node.nodeValue = translatedText;
              }
            }
          }
        })();
      ''');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Page translated to ${_isTamil ? 'Tamil' : 'English'}'),
        ),
      );
    } catch (e) {
      print('Translation error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Translation error: $e')));
    }
  }

  Future<void> _handleMinimizeAction() async {
    final canGoBack = await controller.canGoBack();
    if (canGoBack) {
      controller.goBack();
      return;
    }
    _minimizeWebView();
  }

  void _minimizeWebView() {
    setState(() {
      _isMinimized = true;
    });
  }

  void _restoreWebView() {
    setState(() {
      _isMinimized = false;
    });
  }

  void _closeMiniWindow() {
    Navigator.of(context).pop();
  }

  void _handleBackgroundTap() {
    if (_currentPageType == 'search_home') {
      print('Navigating to SearchHomePage');
      Navigator.pushReplacementNamed(context, '/search_home');
    } else if (_currentPageType == 'search_results') {
      print('Navigating to SearchResultsPage');
      Navigator.pushReplacementNamed(context, '/search_results');
    } else {
      print('Unknown page type, restoring WebView');
      _restoreWebView();
    }
  }

  Widget _buildMiniWindow() {
    return Positioned(
      left: _miniWindowPosition.dx,
      top: _miniWindowPosition.dy,
      child: GestureDetector(
        onTap: _restoreWebView,
        onPanUpdate: (details) {
          setState(() {
            _miniWindowPosition = Offset(
              _miniWindowPosition.dx + details.delta.dx,
              _miniWindowPosition.dy + details.delta.dy,
            );
          });
        },
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanEnd: (_) => setState(() => _isDragging = false),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Transform.scale(
                  scale: 0.3,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: WebViewWidget(controller: controller),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () {
                    print('Settings tapped');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: _closeMiniWindow,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_isDragging)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.open_with,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    if (_isWhiteScreenMode) {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          setState(() {
            _isWhiteScreenMode = false;
          });
        },
        onVerticalDragEnd: (details) {
          setState(() {
            _isWhiteScreenMode = false;
          });
        },
        child: Container(
          color: Colors.white,
          child: const Center(
            child: Text(
              'Swipe to restore',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      );
    }

    if (_isMinimized) {
      return Stack(
        children: [
          GestureDetector(
            onTap: _handleBackgroundTap,
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          _buildMiniWindow(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        leadingWidth: 96,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 26,
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 30,
              onPressed: _handleMinimizeAction,
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pageTitle ?? 'Loading...',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              widget.url,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          if (_isListening)
            IconButton(
              icon: const Icon(Icons.stop),
              color: Colors.red,
              onPressed: _listenToPage,
            ),
          if (isDesktopMode)
            IconButton(
              icon: Icon(
                showDesktopControls ? Icons.lock : Icons.tune,
                color: textColor,
              ),
              onPressed: () {
                setState(() {
                  showDesktopControls = !showDesktopControls;
                });
              },
            ),
          if (isDesktopMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                label: Text(
                  '${desktopWidth.toInt()}px',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue.withOpacity(0.2),
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareUrl,
            color: textColor,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: _bookmarkUrl,
            color: textColor,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textColor),
            onSelected: (value) {
              switch (value) {
                case 'copy_link':
                  _copyLink();
                  break;
                case 'view_saved':
                  print("View saved");
                  break;
                case 'remove_result':
                  _removeResult();
                  break;
                case 'listen':
                  _listenToPage();
                  break;
                case 'find_in_page':
                  _findInPage();
                  break;
                case 'add_home':
                  print("Add to home screen");
                  break;
                case 'desktop_site':
                  _toggleDesktopMode();
                  break;
                case 'translate':
                  _translatePage();
                  break;
                case 'open_browser':
                  _openInBrowser();
                  break;
                case 'refresh':
                  _reloadWebView();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: const [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 12),
                    Text('Refresh'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'copy_link',
                child: Row(
                  children: const [
                    Icon(Icons.link, size: 20),
                    SizedBox(width: 12),
                    Text('Copy link'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'view_saved',
                child: Row(
                  children: const [
                    Icon(Icons.bookmark, size: 20),
                    SizedBox(width: 12),
                    Text('View saved'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'remove_result',
                child: Row(
                  children: const [
                    Icon(Icons.delete, size: 20),
                    SizedBox(width: 12),
                    Text('Remove result'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'listen',
                child: Row(
                  children: [
                    Icon(
                      Icons.volume_up,
                      size: 20,
                      color: _isListening ? Colors.red : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isListening ? 'Stop listening' : 'Listen to this page',
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'find_in_page',
                child: Row(
                  children: const [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 12),
                    Text('Find in page'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'add_home',
                child: Row(
                  children: const [
                    Icon(Icons.home, size: 20),
                    SizedBox(width: 12),
                    Text('Add to home screen'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'desktop_site',
                child: Row(
                  children: [
                    Icon(
                      Icons.desktop_windows,
                      size: 20,
                      color: isDesktopMode ? Colors.blue : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Desktop site',
                      style: TextStyle(
                        fontWeight: isDesktopMode
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isDesktopMode ? Colors.blue : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'translate',
                child: Row(
                  children: [
                    Icon(
                      Icons.translate,
                      size: 20,
                      color: _isTamil ? Colors.blue : null,
                    ),
                    const SizedBox(width: 12),
                    Text(_isTamil ? 'Switch to English' : 'Switch to Tamil'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'open_browser',
                child: Row(
                  children: const [
                    Icon(Icons.open_in_browser, size: 20),
                    SizedBox(width: 12),
                    Text('Open in browser'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          isDesktopMode
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: desktopWidth,
                      height: MediaQuery.of(context).size.height,
                      child: Transform.scale(
                        scale: desktopZoomLevel,
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: desktopWidth / desktopZoomLevel,
                          height:
                              MediaQuery.of(context).size.height /
                              desktopZoomLevel,
                          child: WebViewWidget(controller: controller),
                        ),
                      ),
                    ),
                  ),
                )
              : WebViewWidget(controller: controller),
          if (isDesktopMode && showDesktopControls)
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Desktop Mode Controls',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _adjustDesktopZoom(-0.1),
                        ),
                        Text('Zoom: ${(desktopZoomLevel * 100).toInt()}%'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _adjustDesktopZoom(0.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _adjustDesktopWidth(-100),
                        ),
                        Text('Width: ${desktopWidth.toInt()}px'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _adjustDesktopWidth(100),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showDesktopControls = false;
                        });
                      },
                      child: const Text('Close Controls'),
                    ),
                  ],
                ),
              ),
            ),
          if (isLoading && loadingProgress < 100)
            Container(
              color: backgroundColor?.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress / 100,
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Loading... $loadingProgress%',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.url,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          if (hasError)
            Container(
              color: backgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Failed to Load',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        errorMessage ?? 'Unable to load the webpage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.url,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _reloadWebView,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
