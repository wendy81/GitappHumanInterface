"use strict";function _classCallCheck(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}var _createClass=function(){function e(e,t){for(var n=0;n<t.length;n++){var i=t[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}return function(t,n,i){return n&&e(t.prototype,n),i&&e(t,i),t}}(),PusherEnquireAnalytics=function(){function e(t,n){_classCallCheck(this,e),this._cookieDomain=".pusher.com",this._segmentIoKey=t,this._currentPageTitle=n,this._cookie=""}return _createClass(e,[{key:"generateRandomString",value:function(){for(var e=[],t="abcdefghijklmnopqrstuvwxyz0123456789-",n=0;37>n;n++)e.push(t.charAt(Math.floor(Math.random()*t.length)));return e.join("")}},{key:"getCookies",value:function(){this._cookie=(document.cookie||"").split(/;\s*/).reduce(function(e,t){var n=t.match(/([^=]+)=(.*)/);return n&&(e[n[1]]=unescape(n[2])),e},{})}},{key:"setCookie",value:function(e,t){var n=new Date;n.setTime(n.getTime()+31536e6);var i="expires="+n.toUTCString();document.cookie=e+"="+t+"; "+i+"; domain="+this.cookieDomain+"; path=/"}},{key:"deleteCookie",value:function(e){document.cookie=e+"=deleted; expires="+new Date(0).toUTCString()+"; domain="+this.cookieDomain+"; path=/"}},{key:"trackEvent",value:function(e,t){window.analytics.track(e,t)}},{key:"trackPage",value:function(){window.analytics.page("View "+this.currentPageTitle+" Page",{source:"splash"}),this.trackEvent("View "+this.currentPageTitle+" Page")}},{key:"init",value:function(){window.analytics.load(this._segmentIoKey),this.getCookies(),this.listen(),this.trackPage()}},{key:"listen",value:function(){for(var e=this,t=document.getElementsByClassName("js-track-click"),n=0,i=t.length;i>n;n++)t[n].addEventListener("click",function(t){var n="Button Click",i={category:"Interaction",label:t.srcElement.getAttribute("data-enquire-label"),value:8,button_copy:t.srcElement.innerText};e.trackEvent(n,i)},!1)}},{key:"cookieDomain",get:function(){return this._cookieDomain}},{key:"currentPageTitle",get:function(){return this._currentPageTitle}},{key:"cookie",get:function(){return this._cookie}}]),e}();