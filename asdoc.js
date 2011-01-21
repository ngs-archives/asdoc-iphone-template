;/** =======================================================
 *
 *	Licensed under the Apache License, Version 2.0 (the "License");
 *	you may not use this file except in compliance with the License.
 *	You may obtain a copy of the License at
 *	
 *	http://www.apache.org/licenses/LICENSE-2.0
 *	
 *	Unless required by applicable law or agreed to in writing, software
 *	distributed under the License is distributed on an "AS IS" BASIS,
 *	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 *	either express or implied. See the License for the specific language
 *	governing permissions and limitations under the License.
 *
 *
 ======================================================= */

function findObject(objId) {
	var ele = document.getElementById(objId) || {
		getElementsByTagName :function() {
			return [];
		}
	};
	function classExp(v) {
		return new RegExp(" "+v+"|"+v+" |"+v,"g");
	}
	ele.addClass = function(v) {
		if(!this.hasClass(v)) this.className = this.className ? this.className+" "+v : v;
	}
	ele.removeClass = function(v) {
		if(this.hasClass(v)) this.className = this.className.replace(classExp(v),"");
	}
	ele.toggleClass = function(v) {
		if(this.hasClass(v)) this.removeClass(v);
		else this.addClass(v);
	}
	ele.hasClass = function(v){
		var cls = this && this.className ? this.className : false;
		return cls ? (cls.match(classExp(v)) ? true : false) : false;
	}
	return ele;
}

function setMXMLOnly() {
	if (getCookie("showMXML") == "false") toggleMXMLOnly();
}
function toggleMXMLOnly() {
	var obj = findObject("mxmlSyntax");
	obj.toggleClass("hiddenBlock");
	setCookie("showMXML",obj.hasClass("hiddenBlock")?"false":"true", new Date(3000,1,1,1,1), "/", document.location.domain);
}

function showHideInherited()
{	
	setInheritedVisible(getCookie("showInheritedConstant") == "true", "Constant");
	setInheritedVisible(getCookie("showInheritedProtectedConstant") == "true", "ProtectedConstant");
	setInheritedVisible(getCookie("showInheritedProperty") == "true", "Property");
	setInheritedVisible(getCookie("showInheritedProtectedProperty") == "true", "ProtectedProperty");
	setInheritedVisible(getCookie("showInheritedMethod") == "true", "Method");
	setInheritedVisible(getCookie("showInheritedProtectedMethod") == "true", "ProtectedMethod");
	setInheritedVisible(getCookie("showInheritedEvent") == "true", "Event");
	setInheritedVisible(getCookie("showInheritedStyle") == "true", "Style");
	setInheritedVisible(getCookie("showInheritedEffect") == "true", "Effect");
}
function setInheritedVisible(show, id) {
	var obj = findObject("summaryTable"+id);
	if(!obj) return;
	if(show) obj.removeClass("hiddenBlock");
	else obj.addClass("hiddenBlock");
	setCookie("showInherited" + id, show ? "true" : "false", new Date(3000,1,1,1,1), "/", document.location.domain);
}

/** =======================================================
 *
 *	iWebKit v4.01
 *	http://iwebkit.net/
 *
 ======================================================= */
function addListener(o,e,f){if(o.addEventListener){o.addEventListener(e,f,false)}else{o.attachEvent("on"+e,f)}}
//function bindAnchors(){try{var a=findObject("leftnav").getElementsByTagName("a");for(i=0;i<=a.length-1;++i){var b=a.item(i);if(b.className!="noeffect"){addListener(b,"click",changeClass2)}}}catch(e){}try{var c=findObject("content").getElementsByTagName("a");for(i=0;i<=c.length-1;++i){var b=c.item(i);if(b.className!="noeffect"){addListener(b,"click",changeClass1)}}}catch(e){}try{var d=findObject("footer").getElementsByTagName("a");for(i=0;i<=d.length-1;++i){var b=d.item(i);if(b.className!="noeffect"){addListener(b,"click",changeClass1)}}}catch(e){}try{var f=findObject("frame").getElementsByTagName("a");for(i=0;i<=f.length-1;++i){var b=f.item(i);if(b.className!=""){addListener(b,"click",closepopup)}}}catch(e){}try{var g=findObject("rightnav").getElementsByTagName("a");for(i=0;i<=g.length-1;++i){var b=g.item(i);if(b.className!="noeffect"){addListener(b,"click",changeClass1)}}}catch(e){}try{var h=findObject("rightbutton").getElementsByTagName("a");for(i=0;i<=h.length-1;++i){var b=h.item(i);if(b.className!="noeffect"){addListener(b,"click",changeClass1)}}}catch(e){}try{var j=findObject("leftbutton").getElementsByTagName("a");for(i=0;i<=j.length-1;++i){var b=j.item(i);if(b.className!="noeffect"){addListener(b,"click",changeClass2)}}}catch(e){}}addListener(window,"load",bindAnchors);
window.onload=url;
function url(){var a=document.getElementsByTagName("a");for(var i=0;i<a.length;i++){if(a[i].className.match("nofullscreen")){}if(a[i].className.match("noeffect")){}else{a[i].onclick=function(){window.location=this.getAttribute("href");return false}}}}if(navigator.userAgent.indexOf("iPhone")!=-1&&!document.location.hash){addEventListener("load",function(){setTimeout(hideURLbar,0)},false)}
function hideURLbar(){window.scrollTo(0,0.9)}
function addListener(o,e,f){if(o.addEventListener){o.addEventListener(e,f,false)}else{o.attachEvent("on"+e,f)}}
function popup(){window.scrollTo(0,9999);var a=findObject("#iwebkit-frame");a.className="confirm_screenopen";var b=findObject("iwebkit-cover");b.className="cover";var b=findObject("iwebkit-fullscreenfix");b.className="fullscreenfixopen"}
function closepopup(){var a=findObject("iwebkit-frame");a.className="confirm_screenclose";var b=findObject("iwebkit-cover");b.className="nocover";var b=findObject("iwebkit-fullscreenfix");b.className="fullscreenfixclosed"}
//Delete to disable sliding:
//function changeClass1(){findObject("content").className="slideleft";findObject("footer").className="slideleft"}function changeClass2(){findObject("content").className="slideright";findObject("footer").className="slideright"}