// This Javascript is written by Peter Velichkov (www.creonfx.com)
// and is distributed under the following license : http://creativecommons.org/licenses/by-sa/3.0/
// Use and modify all you want just keep this comment. Thanks
// http://blog.creonfx.com/examples/internet-explorer/ie6-png-transparency-fix.html

function fixPNG(){
	$$('*').each(function(el){
		var imgURL = el.getStyle('background-image');
		var imgURLLength = imgURL.length;
		if ( imgURL != 'none' && imgURL.substring(imgURLLength  - 5, imgURLLength  - 2) == 'png'){
			el.setStyles({
				background: '',
				filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true', sizingMethod='crop', src='" + imgURL.substring(5,imgURLLength  - 2) + "')"
			});
		};

		if(el.getTag() == 'img' && el.getProperty('src').substring(el.getProperty('src').length  - 3) == 'png'){
			var imgReplacer = new Element('input', {
				'styles': {
					'filter': "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true', sizingMethod='crop', src='" + el.getProperty('src') + "')",
					'position': 'relative',
					'background': 'transparent'
				},
				'title': el.getProperty('alt')
			});

			imgReplacer.setStyles(el.getStyles('padding','margin','border','height','width'));
			imgReplacer.setProperties(el.getProperties('id','class'));
			imgReplacer.disabled = true;
			el.replaceWith(imgReplacer);
		};
	});
}

if(window.ie6){
	window.addEvent('domready', fixPNG);
}
