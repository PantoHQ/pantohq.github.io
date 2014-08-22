---
---

$ ->
	'use strict'

	skipAnimations = ->
		$('.anim, #nav-music, #nav-story').addClass 'skip-anim'

	introPageSetUp = ->
		$(window).click ->
			skipAnimations()

	introPageTearDown = ->
		$(window).unbind 'click'

	prevUrl        = document.location.toString()
	rootPath       = $('base').attr 'href'
	rootUrl        = document.location.protocol + '//' + document.location.host + rootPath
	$body          = $('html, body')
	$site          = $('#site')

	# Since subsequent pages are loaded with AJAX (thanks to jquery.smoothStage.js)
	# we only need to check the document.location once
	if document.location.toString() == rootUrl
		introPageSetUp()
	
	content = $site.smoothState
		prefetch: true
		pageCacheSize: 4
		onStart:
			duration: 250
			render: (url, $container) ->
				$site.removeClass 'not-from-intro from-intro to-intro not-to-intro not-from-page'
				$site.addClass 'from-page'
				$('#canvas').addClass 'exiting' 

				if prevUrl == rootUrl
					$site.addClass 'from-intro'
					introPageTearDown()
				else
					$site.addClass 'not-from-intro'

				if url == rootUrl
					$site.addClass 'to-intro'
				else
					$site.addClass 'not-to-intro'

				$body.animate
					scrollTop: 0
		onEnd:
			duration: 0,
			render: (url, $container, $content) ->
				$site.removeClass 'intro to-intro not-to-intro'
				if url == rootUrl
					$site.addClass 'intro'
				$container.html($content)
					
		callback: (url, $container, $content) ->
			if url == rootUrl
				introPageSetUp()
				skipAnimations()
			prevUrl = url
	.data 'smoothState'

