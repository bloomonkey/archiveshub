/*
 * Copyright (c) 2009 Simo Kinnunen.
 * Licensed under the MIT license.
 *
 * @version 1.09
 */
var Cufon=(function(){var m=function(){return m.replace.apply(null,arguments)};var x=m.DOM={ready:(function(){var C=false,E={loaded:1,complete:1};var B=[],D=function(){if(C){return}C=true;for(var F;F=B.shift();F()){}};if(document.addEventListener){document.addEventListener("DOMContentLoaded",D,false);window.addEventListener("pageshow",D,false)}if(!window.opera&&document.readyState){(function(){E[document.readyState]?D():setTimeout(arguments.callee,10)})()}if(document.readyState&&document.createStyleSheet){(function(){try{document.body.doScroll("left");D()}catch(F){setTimeout(arguments.callee,1)}})()}q(window,"load",D);return function(F){if(!arguments.length){D()}else{C?F():B.push(F)}}})(),root:function(){return document.documentElement||document.body}};var n=m.CSS={Size:function(C,B){this.value=parseFloat(C);this.unit=String(C).match(/[a-z%]*$/)[0]||"px";this.convert=function(D){return D/B*this.value};this.convertFrom=function(D){return D/this.value*B};this.toString=function(){return this.value+this.unit}},addClass:function(C,B){var D=C.className;C.className=D+(D&&" ")+B;return C},color:j(function(C){var B={};B.color=C.replace(/^rgba\((.*?),\s*([\d.]+)\)/,function(E,D,F){B.opacity=parseFloat(F);return"rgb("+D+")"});return B}),fontStretch:j(function(B){if(typeof B=="number"){return B}if(/%$/.test(B)){return parseFloat(B)/100}return{"ultra-condensed":0.5,"extra-condensed":0.625,condensed:0.75,"semi-condensed":0.875,"semi-expanded":1.125,expanded:1.25,"extra-expanded":1.5,"ultra-expanded":2}[B]||1}),getStyle:function(C){var B=document.defaultView;if(B&&B.getComputedStyle){return new a(B.getComputedStyle(C,null))}if(C.currentStyle){return new a(C.currentStyle)}return new a(C.style)},gradient:j(function(F){var G={id:F,type:F.match(/^-([a-z]+)-gradient\(/)[1],stops:[]},C=F.substr(F.indexOf("(")).match(/([\d.]+=)?(#[a-f0-9]+|[a-z]+\(.*?\)|[a-z]+)/ig);for(var E=0,B=C.length,D;E<B;++E){D=C[E].split("=",2).reverse();G.stops.push([D[1]||E/(B-1),D[0]])}return G}),quotedList:j(function(E){var D=[],C=/\s*((["'])([\s\S]*?[^\\])\2|[^,]+)\s*/g,B;while(B=C.exec(E)){D.push(B[3]||B[1])}return D}),recognizesMedia:j(function(G){var E=document.createElement("style"),D,C,B;E.type="text/css";E.media=G;try{E.appendChild(document.createTextNode("/**/"))}catch(F){}C=g("head")[0];C.insertBefore(E,C.firstChild);D=(E.sheet||E.styleSheet);B=D&&!D.disabled;C.removeChild(E);return B}),removeClass:function(D,C){var B=RegExp("(?:^|\\s+)"+C+"(?=\\s|$)","g");D.className=D.className.replace(B,"");return D},supports:function(D,C){var B=document.createElement("span").style;if(B[D]===undefined){return false}B[D]=C;return B[D]===C},textAlign:function(E,D,B,C){if(D.get("textAlign")=="right"){if(B>0){E=" "+E}}else{if(B<C-1){E+=" "}}return E},textShadow:j(function(F){if(F=="none"){return null}var E=[],G={},B,C=0;var D=/(#[a-f0-9]+|[a-z]+\(.*?\)|[a-z]+)|(-?[\d.]+[a-z%]*)|,/ig;while(B=D.exec(F)){if(B[0]==","){E.push(G);G={};C=0}else{if(B[1]){G.color=B[1]}else{G[["offX","offY","blur"][C++]]=B[2]}}}E.push(G);return E}),textTransform:(function(){var B={uppercase:function(C){return C.toUpperCase()},lowercase:function(C){return C.toLowerCase()},capitalize:function(C){return C.replace(/\b./g,function(D){return D.toUpperCase()})}};return function(E,D){var C=B[D.get("textTransform")];return C?C(E):E}})(),whiteSpace:(function(){var D={inline:1,"inline-block":1,"run-in":1};var C=/^\s+/,B=/\s+$/;return function(H,F,G,E){if(E){if(E.nodeName.toLowerCase()=="br"){H=H.replace(C,"")}}if(D[F.get("display")]){return H}if(!G.previousSibling){H=H.replace(C,"")}if(!G.nextSibling){H=H.replace(B,"")}return H}})()};n.ready=(function(){var B=!n.recognizesMedia("all"),E=false;var D=[],H=function(){B=true;for(var K;K=D.shift();K()){}};var I=g("link"),J=g("style");function C(K){return K.disabled||G(K.sheet,K.media||"screen")}function G(M,P){if(!n.recognizesMedia(P||"all")){return true}if(!M||M.disabled){return false}try{var Q=M.cssRules,O;if(Q){search:for(var L=0,K=Q.length;O=Q[L],L<K;++L){switch(O.type){case 2:break;case 3:if(!G(O.styleSheet,O.media.mediaText)){return false}break;default:break search}}}}catch(N){}return true}function F(){if(document.createStyleSheet){return true}var L,K;for(K=0;L=I[K];++K){if(L.rel.toLowerCase()=="stylesheet"&&!C(L)){return false}}for(K=0;L=J[K];++K){if(!C(L)){return false}}return true}x.ready(function(){if(!E){E=n.getStyle(document.body).isUsable()}if(B||(E&&F())){H()}else{setTimeout(arguments.callee,10)}});return function(K){if(B){K()}else{D.push(K)}}})();function s(D){var C=this.face=D.face,B={"\u0020":1,"\u00a0":1,"\u3000":1};this.glyphs=D.glyphs;this.w=D.w;this.baseSize=parseInt(C["units-per-em"],10);this.family=C["font-family"].toLowerCase();this.weight=C["font-weight"];this.style=C["font-style"]||"normal";this.viewBox=(function(){var F=C.bbox.split(/\s+/);var E={minX:parseInt(F[0],10),minY:parseInt(F[1],10),maxX:parseInt(F[2],10),maxY:parseInt(F[3],10)};E.width=E.maxX-E.minX;E.height=E.maxY-E.minY;E.toString=function(){return[this.minX,this.minY,this.width,this.height].join(" ")};return E})();this.ascent=-parseInt(C.ascent,10);this.descent=-parseInt(C.descent,10);this.height=-this.ascent+this.descent;this.spacing=function(L,N,E){var O=this.glyphs,M,K,G,P=[],F=0,J=-1,I=-1,H;while(H=L[++J]){M=O[H]||this.missingGlyph;if(!M){continue}if(K){F-=G=K[H]||0;P[I]-=G}F+=P[++I]=~~(M.w||this.w)+N+(B[H]?E:0);K=M.k}P.total=F;return P}}function f(){var C={},B={oblique:"italic",italic:"oblique"};this.add=function(D){(C[D.style]||(C[D.style]={}))[D.weight]=D};this.get=function(H,I){var G=C[H]||C[B[H]]||C.normal||C.italic||C.oblique;if(!G){return null}I={normal:400,bold:700}[I]||parseInt(I,10);if(G[I]){return G[I]}var E={1:1,99:0}[I%100],K=[],F,D;if(E===undefined){E=I>400}if(I==500){I=400}for(var J in G){if(!k(G,J)){continue}J=parseInt(J,10);if(!F||J<F){F=J}if(!D||J>D){D=J}K.push(J)}if(I<F){I=F}if(I>D){I=D}K.sort(function(M,L){return(E?(M>=I&&L>=I)?M<L:M>L:(M<=I&&L<=I)?M>L:M<L)?-1:1});return G[K[0]]}}function r(){function D(F,G){if(F.contains){return F.contains(G)}return F.compareDocumentPosition(G)&16}function B(G){var F=G.relatedTarget;if(!F||D(this,F)){return}C(this,G.type=="mouseover")}function E(F){C(this,F.type=="mouseenter")}function C(F,G){setTimeout(function(){var H=d.get(F).options;m.replace(F,G?h(H,H.hover):H,true)},10)}this.attach=function(F){if(F.onmouseenter===undefined){q(F,"mouseover",B);q(F,"mouseout",B)}else{q(F,"mouseenter",E);q(F,"mouseleave",E)}}}function u(){var C=[],D={};function B(H){var E=[],G;for(var F=0;G=H[F];++F){E[F]=C[D[G]]}return E}this.add=function(F,E){D[F]=C.push(E)-1};this.repeat=function(){var E=arguments.length?B(arguments):C,F;for(var G=0;F=E[G++];){m.replace(F[0],F[1],true)}}}function A(){var D={},B=0;function C(E){return E.cufid||(E.cufid=++B)}this.get=function(E){var F=C(E);return D[F]||(D[F]={})}}function a(B){var D={},C={};this.extend=function(E){for(var F in E){if(k(E,F)){D[F]=E[F]}}return this};this.get=function(E){return D[E]!=undefined?D[E]:B[E]};this.getSize=function(F,E){return C[F]||(C[F]=new n.Size(this.get(F),E))};this.isUsable=function(){return !!B}}function q(C,B,D){if(C.addEventListener){C.addEventListener(B,D,false)}else{if(C.attachEvent){C.attachEvent("on"+B,function(){return D.call(C,window.event)})}}}function v(C,B){var D=d.get(C);if(D.options){return C}if(B.hover&&B.hoverables[C.nodeName.toLowerCase()]){b.attach(C)}D.options=B;return C}function j(B){var C={};return function(D){if(!k(C,D)){C[D]=B.apply(null,arguments)}return C[D]}}function c(F,E){var B=n.quotedList(E.get("fontFamily").toLowerCase()),D;for(var C=0;D=B[C];++C){if(i[D]){return i[D].get(E.get("fontStyle"),E.get("fontWeight"))}}return null}function g(B){return document.getElementsByTagName(B)}function k(C,B){return C.hasOwnProperty(B)}function h(){var C={},B,F;for(var E=0,D=arguments.length;B=arguments[E],E<D;++E){for(F in B){if(k(B,F)){C[F]=B[F]}}}return C}function o(E,M,C,N,F,D){var K=document.createDocumentFragment(),H;if(M===""){return K}var L=N.separate;var I=M.split(p[L]),B=(L=="words");if(B&&t){if(/^\s/.test(M)){I.unshift("")}if(/\s$/.test(M)){I.push("")}}for(var J=0,G=I.length;J<G;++J){H=z[N.engine](E,B?n.textAlign(I[J],C,J,G):I[J],C,N,F,D,J<G-1);if(H){K.appendChild(H)}}return K}function l(D,M){var C=D.nodeName.toLowerCase();if(M.ignore[C]){return}var E=!M.textless[C];var B=n.getStyle(v(D,M)).extend(M);var F=c(D,B),G,K,I,H,L,J;if(!F){return}for(G=D.firstChild;G;G=I){K=G.nodeType;I=G.nextSibling;if(E&&K==3){if(H){H.appendData(G.data);D.removeChild(G)}else{H=G}if(I){continue}}if(H){D.replaceChild(o(F,n.whiteSpace(H.data,B,H,J),B,M,G,D),H);H=null}if(K==1){if(G.firstChild){if(G.nodeName.toLowerCase()=="cufon"){z[M.engine](F,null,B,M,G,D)}else{arguments.callee(G,M)}}J=G}}}var t=" ".split(/\s+/).length==0;var d=new A();var b=new r();var y=new u();var e=false;var z={},i={},w={autoDetect:false,engine:null,forceHitArea:false,hover:false,hoverables:{a:true},ignore:{applet:1,canvas:1,col:1,colgroup:1,head:1,iframe:1,map:1,optgroup:1,option:1,script:1,select:1,style:1,textarea:1,title:1,pre:1},printable:true,selector:(window.Sizzle||(window.jQuery&&function(B){return jQuery(B)})||(window.dojo&&dojo.query)||(window.Ext&&Ext.query)||(window.YAHOO&&YAHOO.util&&YAHOO.util.Selector&&YAHOO.util.Selector.query)||(window.$$&&function(B){return $$(B)})||(window.$&&function(B){return $(B)})||(document.querySelectorAll&&function(B){return document.querySelectorAll(B)})||g),separate:"words",textless:{dl:1,html:1,ol:1,table:1,tbody:1,thead:1,tfoot:1,tr:1,ul:1},textShadow:"none"};var p={words:/\s/.test("\u00a0")?/[^\S\u00a0]+/:/\s+/,characters:"",none:/^/};m.now=function(){x.ready();return m};m.refresh=function(){y.repeat.apply(y,arguments);return m};m.registerEngine=function(C,B){if(!B){return m}z[C]=B;return m.set("engine",C)};m.registerFont=function(D){if(!D){return m}var B=new s(D),C=B.family;if(!i[C]){i[C]=new f()}i[C].add(B);return m.set("fontFamily",'"'+C+'"')};m.replace=function(D,C,B){C=h(w,C);if(!C.engine){return m}if(!e){n.addClass(x.root(),"cufon-active cufon-loading");n.ready(function(){n.addClass(n.removeClass(x.root(),"cufon-loading"),"cufon-ready")});e=true}if(C.hover){C.forceHitArea=true}if(C.autoDetect){delete C.fontFamily}if(typeof C.textShadow=="string"){C.textShadow=n.textShadow(C.textShadow)}if(typeof C.color=="string"&&/^-/.test(C.color)){C.textGradient=n.gradient(C.color)}else{delete C.textGradient}if(!B){y.add(D,arguments)}if(D.nodeType||typeof D=="string"){D=[D]}n.ready(function(){for(var F=0,E=D.length;F<E;++F){var G=D[F];if(typeof G=="string"){m.replace(C.selector(G),C,true)}else{l(G,C)}}});return m};m.set=function(B,C){w[B]=C;return m};return m})();Cufon.registerEngine("canvas",(function(){var b=document.createElement("canvas");if(!b||!b.getContext||!b.getContext.apply){return}b=null;var a=Cufon.CSS.supports("display","inline-block");var e=!a&&(document.compatMode=="BackCompat"||/frameset|transitional/i.test(document.doctype.publicId));var f=document.createElement("style");f.type="text/css";f.appendChild(document.createTextNode(("cufon{text-indent:0;}@media screen,projection{cufon{display:inline;display:inline-block;position:relative;vertical-align:middle;"+(e?"":"font-size:1px;line-height:1px;")+"}cufon cufontext{display:-moz-inline-box;display:inline-block;width:0;height:0;overflow:hidden;text-indent:-10000in;}"+(a?"cufon canvas{position:relative;}":"cufon canvas{position:absolute;}")+"}@media print{cufon{padding:0;}cufon canvas{display:none;}}").replace(/;/g,"!important;")));document.getElementsByTagName("head")[0].appendChild(f);function d(p,h){var n=0,m=0;var g=[],o=/([mrvxe])([^a-z]*)/g,k;generate:for(var j=0;k=o.exec(p);++j){var l=k[2].split(",");switch(k[1]){case"v":g[j]={m:"bezierCurveTo",a:[n+~~l[0],m+~~l[1],n+~~l[2],m+~~l[3],n+=~~l[4],m+=~~l[5]]};break;case"r":g[j]={m:"lineTo",a:[n+=~~l[0],m+=~~l[1]]};break;case"m":g[j]={m:"moveTo",a:[n=~~l[0],m=~~l[1]]};break;case"x":g[j]={m:"closePath"};break;case"e":break generate}h[g[j].m].apply(h,g[j].a)}return g}function c(m,k){for(var j=0,h=m.length;j<h;++j){var g=m[j];k[g.m].apply(k,g.a)}}return function(V,w,P,t,C,W){var k=(w===null);if(k){w=C.getAttribute("alt")}var A=V.viewBox;var m=P.getSize("fontSize",V.baseSize);var B=0,O=0,N=0,u=0;var z=t.textShadow,L=[];if(z){for(var U=z.length;U--;){var F=z[U];var K=m.convertFrom(parseFloat(F.offX));var I=m.convertFrom(parseFloat(F.offY));L[U]=[K,I];if(I<B){B=I}if(K>O){O=K}if(I>N){N=I}if(K<u){u=K}}}var Z=Cufon.CSS.textTransform(w,P).split("");var E=V.spacing(Z,~~m.convertFrom(parseFloat(P.get("letterSpacing"))||0),~~m.convertFrom(parseFloat(P.get("wordSpacing"))||0));if(!E.length){return null}var h=E.total;O+=A.width-E[E.length-1];u+=A.minX;var s,n;if(k){s=C;n=C.firstChild}else{s=document.createElement("cufon");s.className="cufon cufon-canvas";s.setAttribute("alt",w);n=document.createElement("canvas");s.appendChild(n);if(t.printable){var S=document.createElement("cufontext");S.appendChild(document.createTextNode(w));s.appendChild(S)}}var aa=s.style;var H=n.style;var j=m.convert(A.height);var Y=Math.ceil(j);var M=Y/j;var G=M*Cufon.CSS.fontStretch(P.get("fontStretch"));var J=h*G;var Q=Math.ceil(m.convert(J+O-u));var o=Math.ceil(m.convert(A.height-B+N));n.width=Q;n.height=o;H.width=Q+"px";H.height=o+"px";B+=A.minY;H.top=Math.round(m.convert(B-V.ascent))+"px";H.left=Math.round(m.convert(u))+"px";var r=Math.max(Math.ceil(m.convert(J)),0)+"px";if(a){aa.width=r;aa.height=m.convert(V.height)+"px"}else{aa.paddingLeft=r;aa.paddingBottom=(m.convert(V.height)-1)+"px"}var X=n.getContext("2d"),D=j/A.height;X.scale(D,D*M);X.translate(-u,-B);X.save();function T(){var x=V.glyphs,ab,l=-1,g=-1,y;X.scale(G,1);while(y=Z[++l]){var ab=x[Z[l]]||V.missingGlyph;if(!ab){continue}if(ab.d){X.beginPath();if(ab.code){c(ab.code,X)}else{ab.code=d("m"+ab.d,X)}X.fill()}X.translate(E[++g],0)}X.restore()}if(z){for(var U=z.length;U--;){var F=z[U];X.save();X.fillStyle=F.color;X.translate.apply(X,L[U]);T()}}var q=t.textGradient;if(q){var v=q.stops,p=X.createLinearGradient(0,A.minY,0,A.maxY);for(var U=0,R=v.length;U<R;++U){p.addColorStop.apply(p,v[U])}X.fillStyle=p}else{X.fillStyle=P.get("color")}T();return s}})());Cufon.registerEngine("vml",(function(){var e=document.namespaces;if(!e){return}e.add("cvml","urn:schemas-microsoft-com:vml");e=null;var b=document.createElement("cvml:shape");b.style.behavior="url(#default#VML)";if(!b.coordsize){return}b=null;var h=(document.documentMode||0)<8;document.write(('<style type="text/css">cufoncanvas{text-indent:0;}@media screen{cvml\\:shape,cvml\\:rect,cvml\\:fill,cvml\\:shadow{behavior:url(#default#VML);display:block;antialias:true;position:absolute;}cufoncanvas{position:absolute;text-align:left;}cufon{display:inline-block;position:relative;vertical-align:'+(h?"middle":"text-bottom")+";}cufon cufontext{position:absolute;left:-10000in;font-size:1px;}a cufon{cursor:pointer}}@media print{cufon cufoncanvas{display:none;}}</style>").replace(/;/g,"!important;"));function c(i,j){return a(i,/(?:em|ex|%)$|^[a-z-]+$/i.test(j)?"1em":j)}function a(l,m){if(m==="0"){return 0}if(/px$/i.test(m)){return parseFloat(m)}var k=l.style.left,j=l.runtimeStyle.left;l.runtimeStyle.left=l.currentStyle.left;l.style.left=m.replace("%","em");var i=l.style.pixelLeft;l.style.left=k;l.runtimeStyle.left=j;return i}function f(l,k,j,n){var i="computed"+n,m=k[i];if(isNaN(m)){m=k.get(n);k[i]=m=(m=="normal")?0:~~j.convertFrom(a(l,m))}return m}var g={};function d(p){var q=p.id;if(!g[q]){var n=p.stops,o=document.createElement("cvml:fill"),i=[];o.type="gradient";o.angle=180;o.focus="0";o.method="sigma";o.color=n[0][1];for(var m=1,l=n.length-1;m<l;++m){i.push(n[m][0]*100+"% "+n[m][1])}o.colors=i.join(",");o.color2=n[l][1];g[q]=o}return g[q]}return function(ac,G,Y,C,K,ad,W){var n=(G===null);if(n){G=K.alt}var I=ac.viewBox;var p=Y.computedFontSize||(Y.computedFontSize=new Cufon.CSS.Size(c(ad,Y.get("fontSize"))+"px",ac.baseSize));var y,q;if(n){y=K;q=K.firstChild}else{y=document.createElement("cufon");y.className="cufon cufon-vml";y.alt=G;q=document.createElement("cufoncanvas");y.appendChild(q);if(C.printable){var Z=document.createElement("cufontext");Z.appendChild(document.createTextNode(G));y.appendChild(Z)}if(!W){y.appendChild(document.createElement("cvml:shape"))}}var ai=y.style;var R=q.style;var l=p.convert(I.height),af=Math.ceil(l);var V=af/l;var P=V*Cufon.CSS.fontStretch(Y.get("fontStretch"));var U=I.minX,T=I.minY;R.height=af;R.top=Math.round(p.convert(T-ac.ascent));R.left=Math.round(p.convert(U));ai.height=p.convert(ac.height)+"px";var F=Y.get("color");var ag=Cufon.CSS.textTransform(G,Y).split("");var L=ac.spacing(ag,f(ad,Y,p,"letterSpacing"),f(ad,Y,p,"wordSpacing"));if(!L.length){return null}var k=L.total;var x=-U+k+(I.width-L[L.length-1]);var ah=p.convert(x*P),X=Math.round(ah);var O=x+","+I.height,m;var J="r"+O+"ns";var u=C.textGradient&&d(C.textGradient);var o=ac.glyphs,S=0;var H=C.textShadow;var ab=-1,aa=0,w;while(w=ag[++ab]){var D=o[ag[ab]]||ac.missingGlyph,v;if(!D){continue}if(n){v=q.childNodes[aa];while(v.firstChild){v.removeChild(v.firstChild)}}else{v=document.createElement("cvml:shape");q.appendChild(v)}v.stroked="f";v.coordsize=O;v.coordorigin=m=(U-S)+","+T;v.path=(D.d?"m"+D.d+"xe":"")+"m"+m+J;v.fillcolor=F;if(u){v.appendChild(u.cloneNode(false))}var ae=v.style;ae.width=X;ae.height=af;if(H){var s=H[0],r=H[1];var B=Cufon.CSS.color(s.color),z;var N=document.createElement("cvml:shadow");N.on="t";N.color=B.color;N.offset=s.offX+","+s.offY;if(r){z=Cufon.CSS.color(r.color);N.type="double";N.color2=z.color;N.offset2=r.offX+","+r.offY}N.opacity=B.opacity||(z&&z.opacity)||1;v.appendChild(N)}S+=L[aa++]}var M=v.nextSibling,t,A;if(C.forceHitArea){if(!M){M=document.createElement("cvml:rect");M.stroked="f";M.className="cufon-vml-cover";t=document.createElement("cvml:fill");t.opacity=0;M.appendChild(t);q.appendChild(M)}A=M.style;A.width=X;A.height=af}else{if(M){q.removeChild(M)}}ai.width=Math.max(Math.ceil(p.convert(k*P)),0);if(h){var Q=Y.computedYAdjust;if(Q===undefined){var E=Y.get("lineHeight");if(E=="normal"){E="1em"}else{if(!isNaN(E)){E+="em"}}Y.computedYAdjust=Q=0.5*(a(ad,E)-parseFloat(ai.height))}if(Q){ai.marginTop=Math.ceil(Q)+"px";ai.marginBottom=Q+"px"}}return y}})());
/*!
 * The following copyright notice may not be removed under any circumstances.
 * 
 * Copyright:
 * Copyright 1997 International Typeface Corporation. All rights reserved.
 * 
 * Trademark:
 * "Frankfurter" is a trademark of International Typeface Corporation and may be
 * registered in certain jurisdictions.
 * 
 * Full name:
 * FrankfurterMediumStd
 * 
 * Description:
 * Please review the description of this font at http://www.itcfonts.com.
 * 
 * Designer:
 * Alan Meeks
 * 
 * Vendor URL:
 * http://www.itcfonts.com
 */
Cufon.registerFont({"w":268,"face":{"font-family":"Frankfurter Medium Std","font-weight":400,"font-stretch":"normal","units-per-em":"360","panose-1":"2 0 5 3 3 0 0 2 0 4","ascent":"288","descent":"-72","x-height":"4","cap-height":"3","bbox":"-10.9883 -278.619 321 96","underline-thickness":"0","underline-position":"0","stemh":"50","stemv":"55","unicode-range":"U+0020-U+007E"},"glyphs":{" ":{"w":93},"!":{"d":"53,4v-17,0,-31,-15,-31,-32v0,-17,14,-31,31,-31v17,0,31,14,31,31v0,17,-14,32,-31,32xm78,-216r0,115v0,17,-10,28,-25,28v-17,0,-25,-14,-25,-34r0,-109v0,-17,10,-28,25,-28v15,0,25,11,25,28","w":105},"\"":{"d":"46,-152v-15,-12,-43,-93,1,-93v36,0,20,45,12,71v-4,16,-7,22,-13,22xm109,-152v-16,-11,-44,-93,0,-93v36,0,21,44,13,71v-5,16,-7,22,-13,22","w":155},"$":{"d":"69,-243v0,-38,55,-40,56,-1v26,7,51,20,51,44v0,14,-11,26,-24,26v-20,1,-32,-25,-55,-25v-25,0,-37,33,-13,39v49,13,102,32,102,83v0,36,-25,67,-60,75v0,23,-8,34,-27,35v-18,1,-29,-13,-28,-35v-30,-8,-59,-28,-60,-55v0,-16,10,-27,25,-27v22,0,52,40,66,32v16,0,29,-11,29,-26v0,-24,-42,-33,-68,-38v-29,-7,-47,-29,-47,-58v1,-35,22,-59,53,-69","w":197},"%":{"d":"71,-10v24,-76,65,-139,94,-210v8,-17,14,-23,23,-23v17,0,15,22,7,33r-91,196v-6,22,-29,22,-33,4xm199,-108v31,0,56,25,56,55v0,31,-25,55,-56,55v-30,0,-55,-24,-55,-55v0,-30,25,-55,55,-55xm72,-242v31,0,55,24,55,54v0,31,-25,56,-55,56v-31,0,-55,-25,-55,-55v0,-30,25,-55,55,-55xm199,-75v-12,0,-22,10,-22,22v0,13,9,22,22,22v12,0,22,-10,22,-22v0,-12,-9,-22,-22,-22xm72,-210v-12,0,-22,10,-22,22v0,13,10,23,22,23v12,0,22,-10,22,-22v0,-12,-10,-23,-22,-23","w":271},"&":{"d":"150,-159v-27,1,-19,-39,-48,-39v-27,0,-29,30,-14,45r59,59v5,-41,50,-31,50,4v1,10,-5,20,-10,34v8,9,23,20,24,33v0,31,-42,29,-52,8v-53,48,-148,7,-148,-66v0,-26,8,-44,29,-59v-35,-44,7,-106,61,-106v35,0,71,30,73,63v0,13,-11,24,-24,24xm72,-105v-25,21,-4,66,28,64v10,0,17,-3,25,-9","w":218},"(":{"d":"130,39v-61,-18,-107,-91,-104,-162v3,-66,43,-140,105,-155v27,1,35,39,6,52v-79,37,-80,176,1,214v29,13,19,50,-8,51","w":160},")":{"d":"30,-278v60,19,107,91,104,163v-3,66,-43,139,-104,154v-28,-1,-34,-38,-6,-51v78,-37,79,-176,-1,-214v-28,-13,-20,-50,7,-52","w":160},"*":{"d":"104,-176v11,10,30,39,3,44v-16,-1,-20,-19,-29,-28v-6,16,-35,44,-43,13v1,-12,12,-20,18,-29v-10,-6,-33,-8,-32,-22v0,-24,30,-12,43,-6v1,-17,-5,-40,14,-40v19,0,15,22,15,40v13,-5,42,-19,43,6v1,15,-22,16,-32,22","w":156},"+":{"d":"228,-85r-70,0r0,72r-47,0r0,-72r-70,0r0,-48r70,0r0,-73r47,0r0,73r70,0r0,48"},",":{"d":"41,4v-33,-10,-26,-63,10,-62v23,0,39,25,27,48v-7,15,-10,47,-28,47v-17,0,-18,-21,-9,-33","w":101},"-":{"d":"108,-95v1,24,-28,24,-55,24v-18,0,-29,-9,-29,-24v-1,-25,29,-26,57,-24v16,0,27,10,27,24","w":132,"k":{"y":7,"w":5,"v":5,"Y":46,"W":22,"V":26,"T":48,"A":3}},".":{"d":"50,4v-17,0,-31,-15,-31,-32v0,-17,14,-31,31,-31v17,0,32,14,32,31v0,17,-15,32,-32,32","w":100},"\/":{"d":"3,18r73,-277v4,-27,43,-23,44,2r-73,278v-5,27,-44,23,-44,-3","w":123},"0":{"d":"134,-244v69,0,124,56,124,124v0,68,-55,124,-123,124v-68,0,-124,-56,-124,-124v0,-68,55,-124,123,-124xm134,-189v-37,0,-69,31,-69,68v0,39,30,70,69,70v38,0,69,-31,69,-69v0,-38,-31,-69,-69,-69"},"1":{"d":"37,-189v-22,0,-42,-5,-42,-26v0,-29,35,-26,66,-25v21,0,31,13,31,37r0,175v0,19,-10,31,-27,31v-19,0,-28,-16,-28,-38r0,-154","w":118},"2":{"d":"105,-50v32,1,81,-8,78,25v-4,45,-91,24,-138,24v-25,0,-38,-27,-20,-45r91,-90v22,-17,7,-52,-20,-52v-19,1,-30,16,-30,38v0,15,-12,27,-27,27v-17,0,-28,-14,-28,-35v0,-47,38,-86,84,-86v72,0,115,95,63,144","w":193},"3":{"d":"24,-184v1,-28,38,-60,71,-60v54,0,98,62,59,105v65,36,19,143,-56,143v-47,0,-90,-40,-90,-84v0,-36,54,-42,56,-7v0,21,14,37,34,37v40,0,40,-55,6,-64v-28,-1,-19,-37,-1,-39v17,-8,13,-37,-7,-37v-21,-1,-18,36,-44,36v-17,0,-28,-13,-28,-30","w":197},"4":{"d":"119,-240v35,0,63,-5,63,32r0,108v20,-1,34,8,33,25v-1,16,-12,27,-33,26v2,28,-3,53,-28,52v-24,0,-29,-24,-27,-52v-54,-5,-134,22,-115,-55v12,-47,53,-78,77,-117v9,-13,17,-19,30,-19xm127,-100r0,-89r-63,89r63,0","w":218},"5":{"d":"35,-85v25,-1,29,35,56,35v19,0,35,-16,35,-35v0,-33,-44,-46,-85,-38v-43,-4,-15,-58,-15,-92v0,-42,73,-25,118,-25v17,0,27,10,27,25v1,37,-57,22,-93,25r-2,17v60,-8,104,33,105,87v0,49,-40,90,-90,90v-36,0,-83,-30,-83,-62v0,-15,12,-27,27,-27","w":191},"6":{"d":"121,-174v45,5,76,39,76,84v0,52,-42,94,-93,94v-75,0,-119,-90,-73,-151r64,-85v14,-24,52,-13,52,13v0,18,-18,31,-26,45xm104,-128v-21,0,-38,17,-38,38v0,21,17,39,38,39v21,0,38,-18,38,-39v0,-21,-17,-38,-38,-38","w":208},"7":{"d":"100,-190v-38,-4,-102,14,-102,-25v0,-45,87,-20,132,-25v32,-4,38,28,27,54r-67,169v-9,30,-54,24,-54,-6v16,-60,44,-111,64,-167","w":167},"8":{"d":"158,-139v60,43,11,143,-61,143v-72,0,-122,-98,-60,-143v-38,-45,7,-105,60,-105v51,-1,97,61,61,105xm97,-190v-10,0,-19,8,-19,18v0,11,9,19,19,19v10,0,19,-8,19,-18v0,-10,-9,-19,-19,-19xm97,-114v-17,0,-31,14,-31,32v0,17,15,32,32,32v17,0,31,-15,31,-32v0,-18,-14,-32,-32,-32","w":194},"9":{"d":"87,-66v-46,-6,-76,-38,-76,-84v0,-52,41,-94,93,-94v75,0,119,90,73,151r-59,78v-16,30,-54,19,-54,-9v0,-17,16,-29,23,-42xm104,-112v21,0,38,-17,38,-38v0,-21,-17,-39,-38,-39v-21,0,-38,18,-38,39v0,21,16,38,38,38","w":208},":":{"d":"50,-79v-17,0,-31,-15,-31,-32v0,-17,14,-30,31,-30v17,0,32,13,32,30v0,17,-15,32,-32,32xm50,4v-17,0,-31,-15,-31,-32v0,-17,14,-31,31,-31v17,0,32,14,32,31v0,17,-15,32,-32,32","w":100},";":{"d":"50,-79v-17,0,-31,-15,-31,-32v0,-17,14,-30,31,-30v17,0,32,13,32,30v0,17,-15,32,-32,32xm41,4v-33,-10,-26,-63,10,-62v23,0,39,25,27,48v-7,15,-10,47,-28,47v-17,0,-18,-21,-9,-33","w":101},"<":{"d":"226,-8r-183,-77r0,-48r183,-77r0,50r-129,52r129,50r0,50"},"=":{"d":"228,-130r-187,0r0,-47r187,0r0,47xm228,-41r-187,0r0,-48r187,0r0,48"},">":{"d":"226,-85r-183,77r0,-50r129,-51r-129,-51r0,-50r183,78r0,47"},"?":{"d":"98,4v-17,0,-31,-15,-31,-32v0,-17,14,-31,31,-31v17,0,32,14,32,31v0,17,-15,32,-32,32xm11,-166v2,-41,42,-78,85,-78v47,0,86,39,86,87v0,46,-39,84,-85,84v-18,0,-29,-9,-29,-24v0,-14,8,-23,26,-24v54,-3,48,-75,1,-75v-19,0,-31,12,-37,35v-3,13,-10,20,-23,20v-14,0,-24,-10,-24,-25","w":194},"A":{"d":"161,-41r-97,0v-6,18,-16,43,-37,42v-24,-1,-31,-25,-21,-47r80,-178v8,-22,42,-22,52,0r82,178v15,25,2,45,-22,48v-22,2,-29,-26,-37,-43xm141,-89r-29,-69r-28,69r57,0","w":226,"k":{"y":10,"w":5,"v":12,"u":3,"t":3,"q":-3,"o":-3,"e":-3,"d":-3,"c":-3,"Y":31,"W":22,"V":29,"U":5,"T":24,"Q":5,"O":5,"G":5,"C":5,"-":3}},"B":{"d":"58,-240v72,0,142,0,140,67v0,19,-6,32,-20,44v57,34,33,135,-41,129v-45,-4,-110,21,-110,-39r0,-169v0,-21,10,-32,31,-32xm82,-146v28,-1,64,7,64,-21v0,-28,-37,-22,-64,-22r0,43xm82,-50v32,0,72,5,72,-25v0,-31,-41,-25,-72,-25r0,50","w":220},"C":{"d":"235,-57v-5,38,-62,61,-100,61v-68,0,-124,-56,-124,-124v0,-68,56,-124,124,-124v38,0,94,26,98,60v3,28,-41,35,-53,12v-41,-39,-114,-6,-114,52v0,62,84,91,121,45v15,-19,51,-6,48,18","w":239,"k":{"A":-10}},"D":{"d":"240,-120v0,65,-50,124,-129,120v-40,-1,-85,11,-85,-39r0,-169v-3,-41,46,-31,85,-32v78,-4,129,55,129,120xm81,-50v64,6,103,-19,104,-70v1,-49,-44,-75,-104,-69r0,139","w":251,"k":{"Y":10,"W":4,"V":5,"A":3}},"E":{"d":"81,-190r0,45v33,3,86,-12,87,23v0,35,-53,20,-87,23r0,49v39,4,107,-15,107,25v0,44,-83,21,-130,25v-23,2,-32,-14,-32,-39r0,-169v0,-53,81,-32,132,-32v17,0,28,10,28,25v-1,39,-66,21,-105,25","w":192},"F":{"d":"81,-190r0,47v33,3,86,-12,87,23v0,34,-53,21,-87,23v-3,38,13,100,-27,100v-19,0,-28,-16,-28,-38r0,-173v1,-54,82,-32,134,-32v17,0,28,10,28,25v-1,40,-68,21,-107,25","w":192,"k":{"u":17,"r":19,"o":14,"i":3,"e":14,"a":24,"A":24,";":10,":":10,".":48,"-":17,",":48}},"G":{"d":"141,-50v28,0,41,-9,39,-39v-30,0,-67,5,-67,-25v0,-36,51,-24,89,-26v36,-2,33,34,32,69v-1,50,-50,75,-98,75v-68,0,-125,-56,-125,-124v0,-68,55,-124,124,-124v31,0,85,17,85,47v0,15,-12,27,-27,27v-12,0,-39,-20,-58,-20v-38,0,-69,32,-69,70v0,40,33,70,75,70","w":248,"k":{"Y":10}},"H":{"d":"81,-147r90,0v3,-37,-13,-96,27,-95v19,0,28,14,28,36r0,178v-1,19,-11,31,-28,31v-40,0,-24,-61,-27,-100r-90,0v-3,38,13,100,-27,100v-19,0,-28,-16,-28,-38r0,-177v0,-19,11,-30,28,-30v39,0,24,57,27,95","w":252},"I":{"d":"81,-212r0,184v0,19,-10,31,-27,31v-19,0,-28,-16,-28,-38r0,-177v0,-19,11,-30,28,-30v17,0,27,12,27,30","w":108},"J":{"d":"96,-51v58,-2,35,-100,35,-161v0,-19,11,-30,28,-30v18,0,27,14,27,36r0,113v3,59,-41,97,-90,97v-49,0,-90,-41,-90,-88v0,-37,52,-39,54,-6v1,22,14,40,36,39","w":205},"K":{"d":"132,-123r79,72v27,20,15,51,-13,54v-8,1,-19,-8,-25,-14r-92,-86v-3,38,13,100,-27,100v-19,0,-28,-16,-28,-38r0,-177v0,-19,11,-30,28,-30v39,0,24,56,27,94r85,-85v17,-20,49,-7,49,17v-13,38,-59,63,-83,93","w":230,"k":{"Q":12,"O":12,"G":12,"C":12}},"L":{"d":"81,-50v37,4,100,-14,100,25v0,43,-78,21,-123,25v-23,2,-32,-14,-32,-39r0,-173v0,-19,11,-30,28,-30v19,0,27,14,27,36r0,156","w":185,"k":{"y":19,"Y":48,"W":36,"V":50,"T":48}},"M":{"d":"147,-114r37,-104v8,-33,47,-31,54,0r46,194v0,31,-47,34,-55,2r-25,-102r-34,108v-9,26,-39,22,-48,-5r-32,-103r-24,102v-5,34,-55,30,-55,-3r45,-194v5,-29,42,-30,52,-2","w":294},"N":{"d":"26,-210v-2,-33,32,-41,52,-16r101,127r0,-113v0,-19,12,-30,28,-30v19,0,27,14,27,36r0,173v4,39,-33,47,-55,19r-98,-125r0,111v0,19,-10,31,-27,31v-19,0,-28,-16,-28,-38r0,-175","w":260},"O":{"d":"134,-244v65,0,125,57,125,124v0,68,-56,124,-124,124v-69,0,-124,-56,-124,-124v0,-68,55,-124,123,-124xm135,-189v-38,0,-69,31,-69,69v0,38,31,69,69,69v38,0,69,-31,69,-69v0,-38,-31,-69,-69,-69","w":269,"k":{"Y":10,"X":5,"W":5,"V":7,"J":-4,"A":5}},"P":{"d":"203,-152v0,56,-45,97,-121,87v1,32,3,70,-28,68v-19,0,-27,-16,-27,-38r0,-173v-3,-39,41,-31,78,-32v57,-2,98,34,98,88xm149,-151v0,-30,-28,-41,-67,-37r0,72v39,3,67,-4,67,-35","w":207,"k":{"o":4,"e":4,"a":7,"Y":-6,"A":12,";":3,":":3,".":31,"-":-1,",":33}},"Q":{"d":"244,-59v26,10,41,60,0,63v-15,1,-26,-15,-36,-22v-83,58,-197,-6,-197,-102v0,-68,56,-124,124,-124v90,0,157,100,109,185xm136,-189v-38,0,-70,31,-70,69v0,39,31,69,70,69v38,0,68,-31,68,-69v0,-38,-31,-69,-68,-69","w":274,"k":{"u":3,"U":3}},"R":{"d":"58,-240v85,0,145,20,145,87v0,33,-20,60,-55,72v18,16,54,27,56,55v2,23,-27,36,-46,20r-77,-63v0,32,5,73,-27,72v-19,0,-28,-16,-28,-38r0,-173v0,-21,11,-32,32,-32xm150,-152v0,-31,-28,-40,-69,-36r0,72v39,2,69,-4,69,-36","w":214,"k":{"y":-5,"u":3,"o":3,"e":3,"a":-3,"Y":5,"W":3,"V":3}},"S":{"d":"152,-172v-20,0,-33,-26,-54,-26v-15,0,-27,10,-27,22v0,26,64,27,77,39v70,33,37,141,-49,141v-47,0,-88,-28,-88,-59v0,-14,12,-26,25,-26v20,0,47,37,67,32v16,0,28,-11,28,-26v-2,-33,-72,-33,-92,-50v-48,-41,-12,-119,61,-119v42,0,76,21,76,47v0,14,-11,25,-24,25","w":197},"T":{"d":"128,-190r0,162v0,19,-11,31,-28,31v-18,0,-27,-16,-27,-38r0,-155v-31,0,-74,7,-73,-25v0,-17,13,-25,33,-25r139,0v17,0,29,10,29,25v1,31,-41,25,-73,25","w":200,"k":{"y":43,"w":43,"s":48,"o":48,"e":48,"c":48,"a":43,"A":24,";":46,":":46,".":46,"-":46,",":46}},"U":{"d":"117,-50v63,0,42,-99,42,-162v0,-19,11,-30,27,-30v19,0,28,14,28,36r0,111v0,56,-42,99,-97,99v-55,0,-98,-44,-98,-98r0,-118v0,-19,11,-30,28,-30v19,0,28,14,28,36v0,61,-21,156,42,156","w":232},"V":{"d":"114,-85r54,-132v9,-38,52,-31,56,1v-23,70,-56,130,-83,196v-10,28,-44,28,-54,0v-26,-66,-60,-125,-82,-196v0,-14,12,-27,27,-27v14,0,21,7,29,26","w":228,"k":{"y":14,"u":22,"o":26,"e":29,"a":29,"O":7,"A":29,";":19,":":19,".":53,"-":24,",":53}},"W":{"d":"231,-101r34,-114v5,-41,54,-33,56,-1v-17,69,-43,130,-61,197v-8,28,-43,28,-52,2r-45,-126r-44,126v-7,26,-44,27,-52,-2v-17,-67,-47,-125,-62,-197v0,-14,12,-26,27,-26v15,0,22,7,28,28r35,113r40,-122v6,-24,46,-25,54,-2","w":325,"k":{"y":7,"u":17,"o":22,"e":22,"a":22,"O":3,"A":22,";":14,":":14,".":36,"-":14,",":36}},"X":{"d":"141,-123v21,32,55,60,68,99v-3,28,-36,37,-56,9r-46,-62r-45,61v-16,31,-53,21,-56,-8v10,-38,47,-67,66,-99v-19,-29,-52,-58,-63,-92v3,-29,35,-37,56,-9r42,55v23,-23,36,-64,71,-74v28,1,34,31,17,53","w":214,"k":{"y":15,"e":5,"a":1,"O":7,"C":7}},"Y":{"d":"104,-160r47,-68v13,-26,52,-14,52,12v-15,44,-50,75,-72,113v-3,40,14,106,-27,106v-42,0,-25,-65,-28,-106v-22,-37,-57,-71,-71,-113v0,-32,46,-35,55,-7","w":207,"k":{"v":19,"u":24,"o":39,"e":39,"a":39,"O":10,"G":12,"C":12,"A":29,";":41,":":41,".":50,"-":46,",":50}},"Z":{"d":"159,-240v35,-4,47,25,30,48r-103,142v41,5,115,-17,115,25v0,17,-14,25,-34,25r-127,0v-28,2,-41,-26,-26,-46r105,-144v-40,-5,-112,16,-112,-25v0,-17,14,-25,34,-25r118,0","w":207},"[":{"d":"100,39v-38,-1,-67,5,-67,-38r0,-247v-1,-33,30,-34,65,-32v17,0,28,11,28,26v0,21,-20,28,-45,25r0,216v25,-2,48,3,47,25v0,15,-11,25,-28,25","w":128},"\\":{"d":"76,21r-73,-278v0,-26,37,-28,44,-2r73,278v0,26,-37,28,-44,2","w":123},"]":{"d":"95,1v4,43,-28,37,-67,38v-17,0,-28,-10,-28,-25v-1,-22,21,-27,47,-25r0,-216v-24,2,-45,-4,-45,-25v0,-27,31,-26,61,-26v24,0,32,14,32,39r0,240","w":128},"^":{"d":"244,-108r-60,0r-50,-96r-49,96r-59,0r85,-148r46,0"},"_":{"d":"0,96r0,-48r180,0r0,48r-180,0","w":180},"a":{"d":"157,-103v-3,43,13,103,-25,106v-10,0,-18,-5,-23,-15v-39,35,-100,6,-100,-46v0,-50,55,-80,99,-53v2,-56,-80,13,-80,-36v0,-19,24,-30,58,-30v47,0,74,19,71,74xm108,-60v0,-14,-10,-25,-24,-25v-13,0,-24,12,-24,25v0,14,11,24,25,24v13,0,23,-11,23,-24","w":177,"k":{"y":7,"w":5,"v":5}},"b":{"d":"67,-15v-9,27,-45,23,-45,-14r0,-184v0,-16,10,-27,24,-27v33,0,21,50,23,83v53,-44,130,2,130,72v0,71,-80,117,-132,70xm109,-126v-22,0,-41,19,-41,41v0,23,19,40,41,40v23,0,40,-18,40,-41v0,-22,-18,-40,-40,-40","w":209},"c":{"d":"99,-45v21,0,27,-17,46,-18v13,0,24,11,24,24v0,21,-36,43,-70,43v-49,0,-89,-41,-89,-90v0,-48,40,-88,88,-88v26,-1,69,17,69,42v0,13,-10,23,-24,23v-15,0,-28,-20,-43,-17v-23,0,-42,19,-42,41v0,23,18,40,41,40","w":176},"d":{"d":"188,-29v6,36,-38,42,-46,14v-51,47,-132,2,-132,-70v0,-70,76,-116,130,-72v2,-32,-10,-83,23,-83v16,0,25,13,25,32r0,179xm100,-126v-22,0,-40,18,-40,40v0,23,17,41,40,41v22,0,41,-18,41,-40v0,-22,-19,-41,-41,-41","w":209},"e":{"d":"166,-38v0,24,-40,43,-67,42v-48,0,-89,-42,-89,-90v0,-48,40,-88,88,-88v48,0,108,59,55,83r-80,36v23,21,48,0,69,-7v14,0,24,11,24,24xm120,-117v-19,-23,-61,-3,-61,26","w":180,"k":{"y":1,"x":-1,"w":-1,"v":-1}},"f":{"d":"27,-170v-3,-48,14,-70,51,-70v25,0,45,15,45,34v1,23,-24,30,-41,18v-7,0,-8,10,-7,18v40,-11,51,42,13,43r-13,0v-6,45,20,130,-25,130v-16,0,-23,-14,-23,-33r0,-97v-17,-1,-26,-9,-26,-22v0,-14,11,-22,26,-21","w":110,"k":{"o":1,"i":-7,"g":-1,"f":3,"e":1,"d":1,"c":1,"a":4}},"g":{"d":"44,-4v15,0,34,24,50,20v23,0,35,-15,34,-42v-50,37,-118,-3,-118,-65v0,-66,69,-108,121,-67v10,-25,45,-16,45,14r0,118v3,61,-35,87,-84,87v-39,0,-71,-20,-71,-42v0,-13,10,-23,23,-23xm95,-128v-19,0,-35,16,-35,35v0,20,16,35,35,35v19,0,35,-16,35,-35v0,-19,-16,-35,-35,-35","w":196},"h":{"d":"99,-126v-41,0,-28,59,-30,102v0,16,-9,27,-23,27v-16,0,-24,-13,-24,-33r0,-183v0,-16,10,-27,24,-27v31,0,22,44,23,75v51,-26,111,9,106,71v-3,36,13,97,-24,97v-54,0,8,-129,-52,-129","w":195,"k":{"y":7}},"i":{"d":"70,-146r0,122v0,16,-10,27,-24,27v-16,0,-24,-13,-24,-33r0,-116v0,-16,10,-27,24,-27v14,0,24,11,24,27xm46,-240v16,0,29,12,29,28v0,16,-14,29,-30,29v-15,0,-28,-13,-28,-28v0,-17,12,-29,29,-29","w":91},"j":{"d":"47,-240v16,0,29,12,29,28v0,16,-13,29,-29,29v-16,0,-29,-13,-29,-28v0,-17,12,-29,29,-29xm69,-146v-5,83,23,203,-52,206v-28,2,-38,-32,-16,-44v38,-20,21,-107,21,-162v0,-16,10,-27,24,-27v14,0,23,11,23,27","w":92},"k":{"d":"69,-117v28,-18,47,-47,82,-57v22,0,32,33,11,45v-15,14,-34,24,-50,37v19,22,53,41,62,70v0,27,-36,32,-48,11r-57,-60v-1,30,8,74,-23,74v-16,0,-24,-13,-24,-33r0,-183v0,-16,10,-27,24,-27v41,0,17,81,23,123","w":178,"k":{"u":5,"o":4,"e":4,"c":4}},"l":{"d":"22,-24r0,-189v0,-16,10,-27,24,-27v15,0,24,12,23,30r0,184v0,18,-8,29,-23,29v-14,0,-24,-11,-24,-27","w":91},"m":{"d":"95,-127v-40,0,-27,62,-27,103v0,16,-10,27,-24,27v-38,-2,-21,-67,-23,-105v-3,-60,79,-96,125,-52v46,-45,129,-6,125,56v-2,37,14,100,-24,101v-54,1,8,-130,-51,-130v-39,0,-26,62,-26,103v0,16,-10,27,-24,27v-55,0,9,-130,-51,-130","w":291},"n":{"d":"97,-174v42,0,81,31,78,85v-3,35,12,92,-24,92v-54,0,8,-129,-53,-129v-42,1,-28,58,-30,102v0,16,-10,27,-24,27v-35,-1,-20,-58,-23,-93v-3,-50,33,-84,76,-84","w":195,"k":{"y":11,"w":7,"v":7}},"o":{"d":"100,-174v49,0,89,39,89,89v0,48,-41,89,-90,89v-49,0,-89,-40,-89,-88v0,-51,40,-90,90,-90xm100,-126v-23,0,-41,18,-41,42v0,21,18,39,40,39v22,0,41,-18,41,-40v0,-23,-18,-41,-40,-41","w":198,"k":{"y":5,"x":3,"w":3,"v":3}},"p":{"d":"22,-142v-7,-36,38,-41,45,-14v52,-45,132,0,132,71v0,70,-76,116,-130,72v-2,32,10,83,-23,82v-16,0,-24,-12,-24,-32r0,-179xm109,-45v22,0,40,-18,40,-40v0,-23,-17,-41,-40,-41v-22,0,-41,18,-41,41v0,22,19,40,41,40","w":209,"k":{"y":3,"w":3}},"q":{"d":"142,-156v9,-27,46,-21,46,14r0,185v0,17,-11,26,-25,26v-33,1,-21,-49,-23,-82v-53,44,-130,-2,-130,-72v0,-71,79,-116,132,-71xm100,-45v22,0,41,-18,41,-40v0,-23,-19,-41,-41,-41v-23,0,-40,18,-40,41v0,22,18,40,40,40","w":209},"r":{"d":"22,-138v-6,-37,32,-45,45,-21v21,-23,68,-19,68,15v0,31,-35,33,-55,19v-8,0,-11,6,-11,22v0,38,15,106,-23,106v-16,0,-24,-13,-24,-33r0,-108","w":135,"k":{"q":1,"o":1,"g":1,"f":-12,"e":1,"d":1,"c":1,"a":7,".":46,"-":14,",":46}},"s":{"d":"45,-80v-48,-24,-26,-94,36,-94v31,0,58,16,58,34v0,36,-49,13,-62,5v-5,0,-9,5,-9,9v-5,14,51,20,59,28v48,29,18,102,-45,102v-37,0,-72,-24,-72,-48v0,-13,10,-24,22,-24v16,0,41,31,53,27v19,-1,25,-21,1,-25v-13,-2,-31,-9,-41,-14","w":160,"k":{"y":6}},"t":{"d":"30,-170v-1,-27,-2,-58,24,-58v25,0,26,30,24,58v19,-2,34,4,34,21v0,16,-14,24,-34,22r0,103v0,16,-10,27,-24,27v-43,0,-17,-86,-24,-130v-17,1,-27,-8,-27,-22v0,-14,9,-21,27,-21","w":110,"k":{"h":-1}},"u":{"d":"98,4v-42,0,-80,-32,-77,-85v2,-34,-12,-92,23,-92v54,0,-8,129,54,129v41,0,27,-59,29,-102v0,-16,10,-27,24,-27v36,0,22,57,24,93v3,49,-35,84,-77,84","w":195},"v":{"d":"86,-72r34,-80v8,-33,47,-24,49,2v-16,48,-40,89,-59,135v-8,23,-37,25,-47,0v-18,-46,-45,-85,-60,-135v0,-12,10,-23,23,-23v13,0,17,4,25,21","w":171,"k":{"o":1,"e":1,"a":7,".":29,"-":-1,",":29}},"w":{"d":"124,-88r-27,71v-7,29,-40,24,-47,0v-13,-46,-36,-86,-48,-135v0,-26,39,-29,47,-3r24,75r27,-73v7,-26,39,-29,48,-3r28,76r22,-74v6,-29,48,-24,48,4v-12,47,-31,88,-45,133v-8,27,-37,26,-48,0","w":248,"k":{"o":1,"e":1,"a":7,".":19,"-":3,",":19}},"x":{"d":"87,-126v16,-14,30,-47,53,-47v24,0,32,26,13,47r-34,37v14,21,43,41,49,67v-2,26,-34,36,-48,9r-33,-40v-17,17,-33,51,-58,56v-24,-2,-32,-27,-14,-47r40,-45v-13,-18,-38,-38,-43,-61v1,-24,31,-30,48,-9","w":172,"k":{"o":1,"e":1,"c":1}},"y":{"d":"91,-73r34,-82v8,-27,48,-21,49,6v-25,65,-57,132,-89,189v-17,29,-81,22,-82,-12v0,-25,24,-27,45,-19v9,0,16,-18,19,-28v-20,-44,-45,-83,-61,-131v0,-25,36,-31,47,-6","w":176,"k":{"s":4,"o":1,"e":1,"a":7,".":29,"-":5,",":29}},"z":{"d":"126,0v-50,-1,-152,11,-108,-46r62,-80v-28,-1,-70,7,-68,-22v2,-38,70,-18,108,-22v25,-2,37,23,23,40r-66,86v29,2,74,-9,73,22v0,13,-10,22,-24,22","w":157},"|":{"d":"85,85r-48,0r0,-360r48,0r0,360","w":141},"~":{"d":"91,-142v32,0,55,20,85,22v16,0,28,-14,35,-24r31,37v-18,24,-37,35,-65,35v-27,0,-57,-21,-84,-22v-17,0,-28,17,-34,25r-32,-38v16,-20,33,-35,64,-35"},"'":{"d":"47,-152v-16,-11,-44,-93,0,-93v35,0,20,46,12,71v-5,16,-7,22,-12,22","w":92},"`":{"d":"45,-250v18,5,33,22,39,40v1,17,-24,29,-35,15v-9,-11,-25,-19,-25,-35v0,-12,9,-20,21,-20","w":107},"\u00a0":{"w":93}}});