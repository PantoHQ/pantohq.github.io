---
---

$ ->
	'use strict'

	isInternalReferrer = ->
		document.referrer.indexOf(location.protocol + "//" + location.host) == 0;

	skipAnimations = ->
		$('.anim, #nav-music, #nav-story').addClass 'skip-anim'

	isIntroPage = (url = $('base').attr 'href') ->
		return document.location.pathname.toLowerCase() == url or document.location.toString() == url

	introPageInit = ->
		$(window).click ->
			skipAnimations()

		# Skip animations if one of our links sent the user here
		if isInternalReferrer()
			skipAnimations()

	generalInit = ->
		$('#nav-global li:has(ul)').doubleTapToGo()

	generalInit()

	$body   = $('html, body')
	$header = $('article header')
	$body   = $('article .body')
	content = $('#canvas').smoothState
		prefetch: true
		pageCacheSize: 4
		onStart:
			duration: 0
			render: ->
				content.toggleAnimationClass 'is-exiting'
				$body.animate
					scrollTop: 0
		callback: (url, $container, $content) ->
			if isIntroPage(url)
				skipAnimations()
			generalInit()

	.data 'smoothState'

	if isIntroPage()
		introPageInit()

