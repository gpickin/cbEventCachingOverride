//cacheOverrideTimeout

/**
* An eventCachingOverride module for ColdBox
*/
component {

	// Module Properties
	this.title 				= "cbEventCachingOverride";
	this.author 			= "Gavin Pickin - Ortus Solutions";
	this.webURL 			= "www.ortussolutions.com";
	this.description 		= "eventCachingOverride module for ColdBox";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbEventCachingOverride";
	// Model Namespace
	this.modelNamespace		= "cbEventCachingOverride";
	// CF Mapping
	this.cfmapping			= "cbEventCachingOverride";
	// Auto-map models
	this.autoMapModels		= false;
	// Module Dependencies
	this.dependencies 		= [];

	function configure( ){
	}

	/**
     * @event
     * @interceptData
     * @buffer
     * @rc
     * @prc
     */
    function preRender( event, interceptData, buffer, rc, prc ) {
		if( structKeyExists( prc, "cbox_eventCacheableEntry" ) ){
			var cacheMeta = prc.cbox_eventCacheableEntry;
			if( structKeyExists( cacheMeta, "cacheable" ) && cacheMeta.cacheable ){
				var cacheOverrideTimeout = getCacheOverrideTimeout( arguments.event );
				if( len( cacheOverrideTimeout ) and cacheOverrideTimeout == 'midnight' ){
					cacheMeta[ "timeout" ] = getMinutesUntilMidnight();
				}
			}
		}
	}

	private function getCacheOverrideTimeout( event ) {
		var ehbean = controller.getHandlerService().getHandlerBean( event.getCurrentEvent() );
		var oEventHandler = controller.getHandlerService().newHandler( ehBean.getRunnable() );
		ehBean.setActionMetadata( oEventHandler._actionMetadata( ehBean.getMethod() ) );
		return ehBean.getActionMetadata( "cacheOverrideTimeout", "" );
	}

	/**
     * Returns the number minutes from the given date (now) to midnight for a given timezone (America/Los_Angeles)
	 * @dateTime A UTC datetime to be used to calculate mins from
	 * @timezone The timezone of the application, to ensure all calculations are based on midnight of the right timezone.
     */
    private function getMinutesUntilMidnight( datetime start = dateConvert( "local2Utc", now() ), string timezone = "America/Los_Angeles" ) {
        var tomorrow = dateAdd( "d", 1, arguments.start );
        var utcMidnight = createDateTime( year( tomorrow ), month( tomorrow ), day( tomorrow ), 0, 0, 0 );
        var timeZoneInfo = getTimeZoneInfo( arguments.timezone );
		var timezoneMidnight = dateAdd( "s", timeZoneInfo.utcTotalOffset, utcMidnight );
        return dateDiff( "n", arguments.start, timezoneMidnight );
    }

}