---
---

isInternalReferrer = ->
	document.referrer.indexOf(location.protocol + "//" + location.host) == 0;

skipAnimations = ->
	$('.anim, #nav-music, #nav-story').addClass 'skip-anim'
	console.log('skip')

$ ->
	# Finish animations instantly on interaction
	$(window).click ->
		skipAnimations()

	# Skip animations if one of our links sent the user here
	if isInternalReferrer()
		skipAnimations()
