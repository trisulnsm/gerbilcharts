var SVGDocument = null;
var SVGRoot = null;
var SVGViewBox = null;
var svgns = 'http://www.w3.org/2000/svg';
var xlinkns = 'http://www.w3.org/1999/xlink';
var toolTip = null;
var TrueCoords = null;
var tipBox = null;
var tipText = null;
var tipTitle = null;
var tipDesc = null;
var ajaxPE = null;
var lastElement = null;
var titleText = '';
var titleDesc = '';
   
function OpacityDown(mouseover_evt)
{
	var obj=mouseover_evt.target;
	obj.style.setProperty("opacity","0.5","");
}


function OpacityUp(mouseout_evt)
{
	var obj=mouseout_evt.target;
	obj.style.setProperty("opacity","1.0","");
}

function GerbilNavigate()
{
	window.top.location='/dashboard/show';
}

function parseXMLFromString(text) 
{
    if (typeof DOMParser != "undefined") 
	{ 
        // Mozilla, Firefox, and related browsers 
        return (new DOMParser()).parseFromString(text, "application/xml"); 
    } 
    else if (typeof ActiveXObject != "undefined") 
	{ 
        // Internet Explorer. 
		var xmlDOM = new ActiveXObject("Microsoft.XMLDOM"); 
        var doc = xmlDOM.newDocument();  
        doc.loadXML(text);            
        return doc.documentElement;                   
    } 
	return null;
}
	

function TestUpdates1(evt)
{
	var tnode=SVGDocument.getElementById("graphtitle");
	tnode.firstChild.nodeValue="Changed by Ajax2";
}

// Switch between detailed and mini legend panels
function showMiniLegend()
{
	var l_hide = SVGDocument.getElementById("legendpanel_detail");
	if (l_hide)
	{
	 	l_hide.setAttributeNS(null, 'visibility', 'hidden');
	}
	var l_show = SVGDocument.getElementById("legendpanel_mini");
	if (l_show)
	{
	 	l_show.setAttributeNS(null, 'visibility', 'visible');
	}
}

// Switch between detailed and mini legend panels
function showDetailedLegend()
{
	var l_hide = SVGDocument.getElementById("legendpanel_mini");
	if (l_hide)
	{
	 	l_hide.setAttributeNS(null, 'visibility', 'hidden');
	}
	var l_show = SVGDocument.getElementById("legendpanel_detail");
	if (l_show)
	{
	 	l_show.setAttributeNS(null, 'visibility', 'visible');
	}
}

// The chart needs to fill in the following options 
// axurl , response will either do noop/full/delta replacement
function SvgAjaxUpdate()
{
	var gerbilAjaxBlock=SVGDocument.getElementById("GerbilAjaxBlock");
	var gerbilAjaxOptions=SVGDocument.getElementById("GerbilAjaxOptions");
	var gerbilAjaxContext=SVGDocument.getElementById("GerbilAjaxContext");

	// extract the URL & other ajax options from the Gerbil Ajax Block
	var url   = gerbilAjaxOptions.attributes.getNamedItem('axurl').nodeValue;
	var freq  = gerbilAjaxOptions.attributes.getNamedItem('axfrequency').nodeValue;
	var decay = gerbilAjaxOptions.attributes.getNamedItem('axdecay').nodeValue;

	// return the entire ajax context in request
	var	aa = $A(gerbilAjaxContext.attributes);
	var hContext = $H();
	aa.each(function (at){
		hContext[at.localName]=at.nodeValue;
	});
	hContext.unset('_object');
	
	// console.log ("URL =  "+ url );
	new Ajax.Request(url, {
	  method: 'post',
	  parameters: { 'resource': hContext['resource'] },
	  onSuccess: function(transport) {
          		updateSVG(transport.responseXML)
		     }
	});

}
// For WebTrisul 1.0, we don't yet support delta replace,
// full replace seems to be fast enough (caching on server side)
function updateSVG(node)
{
  var cmd = '';
  cmd = node.documentElement.getAttribute("command")
  
  if (cmd == "noop")
  {
	// do nothing (we got a noop ajax response)
  }
  else if (cmd=="full_replace")
  {
  	// replace the old node with the new one
    var newnode = node.documentElement.childNodes[1];
 	var currnode = SVGDocument.getElementById('GerbilSVGGraph');
 	var par = currnode.parentNode;
 	var newLayer = SVGDocument.importNode(newnode,true);
 	par.appendChild(newLayer); 
 	par.removeChild(currnode);
	
	// move tooltip to top of rendering stack
	par.removeChild(toolTip);
	par.appendChild(toolTip);
  }
  else if (cmd=="delta_replace")
  {
  	// delta svg replace not yet supported 
  }

}

// releases any server side ajax resources held by this document
function Uninit(evt)
{
	 var gerbilAjaxContext=SVGDocument.getElementById("GerbilAjaxContext");
	 if (gerbilAjaxContext!=null)
	 {
		var	aa = $A(gerbilAjaxContext.attributes);
		var hContext = $H();
		aa.each(function (at){
			hContext[at.localName]=at.nodeValue;
		});
	
		// console.log ("URL =  "+ url );
		new Ajax.Request("/axupdate/gerbilUnload", {
	  		method: 'post',
	  		parameters: { 'resource': hContext['resource'] },
		});
	 }

}

function Init(evt)
{
	 SVGDocument = evt.target.ownerDocument;
	 SVGRoot = SVGDocument.documentElement;
	 TrueCoords = SVGRoot.createSVGPoint();
	
	 toolTip = SVGDocument.getElementById('ToolTip');
	 tipBox = SVGDocument.getElementById('tipbox');
	 tipText = SVGDocument.getElementById('tipText');
	 tipTitle = SVGDocument.getElementById('tipTitle');
	 tipDesc = SVGDocument.getElementById('tipDesc');
	 //window.status = (TrueCoords);
	
	 //create event for object
	 SVGRoot.addEventListener('mousemove', ShowTooltip, false);
	 SVGRoot.addEventListener('mouseout', HideTooltip, false);
	 
	 // periodical executor
  	 var gerbilAjaxOptions=SVGDocument.getElementById("GerbilAjaxOptions");
	 if (gerbilAjaxOptions!=null)
	 {
	 	var ajaxInterval = gerbilAjaxOptions.getAttribute('axfrequency');
	 	ajaxPE = new PeriodicalExecuter(SvgAjaxUpdate,parseInt(ajaxInterval));

   		// for Adobe SVG later 
		// setTimeout("SvgAjaxUpdate()",parseInt(ajaxInterval));
	 }
};


function GetTrueCoords(evt)
{
	 // zoom / pan adjustment
	 var newScale = SVGRoot.currentScale;
	 var translation = SVGRoot.currentTranslate;
	 TrueCoords.x = (evt.clientX - translation.x)/newScale;
	 TrueCoords.y = (evt.clientY - translation.y)/newScale;
};


function HideTooltip( evt )
{
	 toolTip.setAttributeNS(null, 'visibility', 'hidden');
};


function ShowTooltip( evt )
{
	// bail out early, if same target
	var targetElement = evt.target;
	if ( lastElement == targetElement )
	{
		return
	}
	
	// bail out early, if no 'gerbiltooltipX' tags
	// tooltip1 is the heading  (appears in bold face)
	// tooltip2 is the tip text 
	var tooltip1 = '';
	var tooltip2 = '';
	tooltip1 = targetElement.getAttributeNS(null, 'gerbiltooltip1');
	tooltip2 = targetElement.getAttributeNS(null, 'gerbiltooltip2');
	if (tooltip1=='' && tooltip2 == '')		
	{
		return;
	}

	// Positon the tooltip box relative to the mouse pos
	GetTrueCoords( evt );
	var tipScale = 1/SVGRoot.currentScale;
	var textWidth = 0;
	var tspanWidth = 0;
	var boxHeight = 20;
	tipBox.setAttributeNS(null, 'transform', 'scale(' + tipScale + ',' + tipScale + ')' );
	tipText.setAttributeNS(null, 'transform', 'scale(' + tipScale + ',' + tipScale + ')' );

	// Values for tooltip text
	tipTitle.firstChild.nodeValue = tooltip1;
	tipTitle.setAttributeNS(null, 'display', 'inline' );
	tipDesc.firstChild.nodeValue = tooltip2;
	tipDesc.setAttributeNS(null, 'display', 'inline' );


	// Box size
    var outline = tipText.getBBox();
    tipBox.setAttributeNS(null, 'width', Number(outline.width) + 10);
    tipBox.setAttributeNS(null, 'height', Number(outline.height));
	

    // Update position (keep tooltip inside client area ! )
 	var yPos = TrueCoords.y + (10 * tipScale);
 	if (yPos+Number(outline.height)>SVGRoot.height.baseVal.value)
	{
		yPos = SVGRoot.height.baseVal.value - Number(outline.height)
	}
    var xPos = TrueCoords.x + (10 * tipScale);
	if (xPos+Number(outline.width)>SVGRoot.width.baseVal.value)
	{
		xPos = SVGRoot.width.baseVal.value - Number(outline.width)
	}
	
    toolTip.setAttributeNS(null, 'transform', 'translate(' + xPos + ',' + yPos + ')');
    toolTip.setAttributeNS(null, 'visibility', 'visible');
}



//////////////////////////////////////
// Tracker - for SVG
var fTracking=0;
var nTrackBegin=0;
var nTrackEnd=0;
var nTrackCurrent=0;
var pGTrackingRect=null;    
var pTrackingRect=null;
var pTrackFromTS=null;
var nTrackScale=0;
var pTrackTextFromTS=null;
var pTrackTextInterval=null;
var pTrackerData=null;

function TrackerMouseDown( evt )
{
    fTracking=1;
    nTrackBegin=evt.clientX;
    nTrackCurrent=evt.clientX;
    
    SVGDocument = evt.target.ownerDocument;

    pGTrackingRect= SVGDocument.getElementById('gtrackerrect');
    pTrackingRect= SVGDocument.getElementById('trackerrect');
    pTrackingRect.setAttributeNS(null,"x",nTrackCurrent);
    pTrackingRect.setAttributeNS(null,"width",1);
    
    pTrackingText= SVGDocument.getElementById('gtrackertext');
    pTrackingText.setAttributeNS(null,"transform","translate(" + nTrackBegin + ',' + 150 + ')');
    
    // compute begin state
    pTrackerData = SVGDocument.getElementById('gtrackerdata');
    nTrackScale =  parseInt(pTrackerData.getAttributeNS(null,"gerb_scale"));
    var from_secs = parseInt(pTrackerData.getAttributeNS(null,"gerb_fromts"));
    
    // clicked to time delta
    var xbegin = parseInt(SVGDocument.getElementById('trackerpanel').getAttributeNS(null,"x"));
    pTrackFromTS = new Date();
    pTrackFromTS.setTime(1000* (from_secs + (nTrackBegin-xbegin)*nTrackScale));
            
    // text svg elements
    pTrackTextFromTS=SVGDocument.getElementById('trackertextfromts');
    pTrackTextInterval=SVGDocument.getElementById('trackertextinterval');
    
    // visibility off (move 5-10 pixels to turn it on)
    pGTrackingRect.setAttributeNS(null,"visibility","hidden");
    pTrackingText.setAttributeNS(null,"visibility","hidden");

}

function TrackerMouseMove(evt)
{
    if (fTracking==2 && evt.clientX > nTrackBegin)
    {
        var delta = nTrackCurrent-nTrackBegin;
        var mid = nTrackBegin+(delta)/2;
        nTrackCurrent=evt.clientX;
        pTrackingRect.setAttributeNS(null,"width",delta);
        pTrackingText.setAttributeNS(null,"transform","translate(" + mid + ')');
        
        // text box
        var szwin = FormatSecs(delta*nTrackScale)
        var szbegin = "Starting : " + pTrackFromTS.toLocaleString();
        pTrackTextInterval.firstChild.nodeValue = szwin;
        pTrackTextFromTS.firstChild.nodeValue = szbegin;
    }
    else if (fTracking==1 && (evt.clientX-nTrackBegin) > 5 )
    {
        // we need to move atleast 5 pixels to turn on tracking
        fTracking=2;
        
        // visibility on 
        pGTrackingRect.setAttributeNS(null,"visibility","visible");
        pTrackingText.setAttributeNS(null,"visibility","visible");
    }
}
function TrackerMouseUp(evt)
{
    if (fTracking==2)
    {
        pTrackingRect=null;
        nTrackEnd=evt.clientX;
        
        pTrackerData.setAttributeNS(null,"gerb_selsecs",(nTrackEnd-nTrackBegin)*nTrackScale);
        pTrackerData.setAttributeNS(null,"gerb_selts", pTrackFromTS.getTime()/1000);

    }
    fTracking=0;
}

function FormatSecs(secs)
{
    if (secs>86400) {
        return "" + Math.floor(secs/86400) + " Days" + Math.floor((secs%86400)/3600) + " Hrs" + Math.round((secs%3600)/60) + " Mins";    
    } else if (secs>3600) {
        return "" + Math.floor(secs/3600) + " Hrs  " + Math.round((secs%3600)/60) + " Mins";    
    } else if (secs>60) {
        return "" + Math.floor(secs/60) + " Mins  " + secs%60 + " Secs";    
    }
    return "" + secs + " Secs";
}
