---
---

$ ->
	'use strict'

	skipAnimations = ->
		$('.anim, #nav-music, #nav-story').addClass 'skip-anim'

	pageSetUp = ->
		$title.fitText 1, 
			maxFontSize: '80px'
		$whoAreWe.fitText 1, 
			maxFontSize: '80px'

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
	$window        = $(window)
	$headerBg      = $('#header-bg')
	$title         = $('#title')
	$whoAreWe      = $('#who-are-we')
	$canvas        = $('#canvas')

	# Since subsequent pages are loaded with AJAX (thanks to jquery.smoothStage.js)
	# we only need to check the document.location once
	if document.location.toString() == rootUrl
		introPageSetUp()

	introTitleFadeStart = 300
	introTitleFadeDist = 100

	titleFadeStart = 140
	titleFadeDist = 30

	whoAreWeFadeStart = 10
	whoAreWeFadeDist = 100

	getBgPos = (scrollTop, offset) ->
		parseInt(scrollTop / 5)

	recalcHeader = ->
		x = $window.scrollTop()
		bgPos = getBgPos(x)

		$headerBg.css 'background-position', 'center ' + bgPos + 'px'
		$title.css 'top', parseInt(x/2) + 'px'

		if $canvas.hasClass 'small-header'
			if x < titleFadeStart
				$title.css 'opacity', 1
			if x >= titleFadeStart and x <= titleFadeStart + titleFadeDist
				$title.css 'opacity', 1 - ((x - titleFadeStart) / titleFadeDist)
			if x > titleFadeStart + titleFadeDist
				$title.css 'opacity', 0
		else
			if x < introTitleFadeStart
				$title.css 'opacity', 1
			if x >= introTitleFadeStart and x <= introTitleFadeStart + introTitleFadeDist
				$title.css 'opacity', 1 - ((x - introTitleFadeStart) / introTitleFadeDist)
			if x > introTitleFadeStart + introTitleFadeDist
				$title.css 'opacity', 0

		x = $window.scrollTop()
		if x < whoAreWeFadeStart
			$whoAreWe.css 'opacity', 1
		if x >= whoAreWeFadeStart and x <= whoAreWeFadeStart + whoAreWeFadeDist
			$whoAreWe.css 'opacity', 1 - ((x - whoAreWeFadeStart) / whoAreWeFadeDist)
		if x > whoAreWeFadeStart + whoAreWeFadeDist
			$whoAreWe.css 'opacity', 0


	$window.scroll recalcHeader
	
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
				$headerBg = $('#header-bg')
				$title    = $('#title')
				$canvas   = $('#canvas')
				$whoAreWe = $('#who-are-we')

				# Ensure background position matches what currently exists
				$headerBg.css 'background-position', 'center ' + getBgPos($window.scrollTop()) + 'px'
					
		callback: (url, $container, $content) ->
			if url == rootUrl
				introPageSetUp()
				skipAnimations()
			pageSetUp()
			recalcHeader()
			prevUrl = url
	.data 'smoothState'

	pageSetUp()

	$descriptions = $('#listen .desc')
	$descriptions.resize ->
		maxHeight = -1
		height = -1

		$descriptions.each ->
			height = $(this).outerHeight()
			maxHeight = if maxHeight > height then maxHeight else height

		$descriptions.each ->
			$(this).height maxHeight
	.resize()

	highlight = (character) ->
		$lines = $('.lines .line')
		$lines.find('.highlightable').removeClass('highlight').filter('.character-' + character).addClass('highlight')

	capitalise = (string) ->
		string.charAt(0).toUpperCase() + string.slice(1)

	# Default highlighting
	highlight 'cinderella'

	# Enable line highlighting
	# $('.lines .line .line-character > .wrapper ').click ->
	# 	if not $(this).hasClass 'highlight'
	# 		highlight $(this).data('character')
	# 	else
	# 		$('.lines .line').find('.highlightable').removeClass('highlight')

	$('#lines .lines-characters a').click ->
		$this = $(this)
		$listItem = $this.closest('li')
		character = $this.data('character')
		$listItem.siblings('li').removeClass('active')
		$listItem.addClass('active')
		$('#lines .lines-group').fadeOut(200).delay(200).filter('[data-character="' + character + '"]').fadeIn(200)
		highlight character

		# Track this characters selection in Google Analytics
		ga('send', 'event', 'Audition Script', 'Select Character', capitalise(character));

		$('html, body').animate
			scrollTop: $('#lines-wrapper').offset().top - 40
		, 200
		false

	$('#scroll-to-lines').click ->
		$('html, body').animate
			scrollTop: $('#lines-wrapper').offset().top - 40
		, 200
		false
	$('#scroll-to-music').click ->
		$('html, body').animate
			scrollTop: $('#listen-wrapper').offset().top
		, 200
		false

	$('#toggle-lyrics a').click ->
		$lyrics = $('#lyrics')
		$lyrics.toggle()
		text = if $lyrics.is(':visible') then 'hide' else 'show'
		$(this).find('span').text(text)
		false


