
jQuery(document).ready(function($){
	
	/* ---------- Add class .active to current link  ---------- */
	$('ul.main-menu li a').each(function(){

			console.log($($(this))[0].href);
		
			if($($(this))[0].href==window.location.origin+'/stocks') {
				console.log('true!');
				$(this).parent().addClass('active');
				
			}
	
	});
	
	$('ul.main-menu li ul li a').each(function(){
		
			if($($(this))[0].href==window.location.origin+'/stocks') {
				
				$(this).parent().addClass('active');
				$(this).parent().parent().parent().addClass('active');
				$(this).parent().parent().show();
				
			}
	
	});

	/* ---------- Submenu  ---------- */

	$('.dropmenu').click(function(e){

		e.preventDefault();

		$(this).parent().find('ul').slideToggle();

	});

});