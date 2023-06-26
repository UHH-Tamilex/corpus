import { iastToTamil, tamilToIast, tamilize } from './transliterate.mjs';
import hljs from './highlight.min.js';
import hlxml from './xml.min.js';
import JSONCrush from './JSONCrush.min.js';

hljs.registerLanguage('xml',hlxml);

const state = {
    textin: null,
    wordin: null,
    teiout: null,
    htmlout: null
};

const init = () => {
    state.textin = document.getElementById('text_input');
    state.wordin = document.getElementById('word_input');
    state.teiout = document.getElementById('tei_output');
    state.htmlout = document.getElementById('html_output');
    const searchParams = new URLSearchParams(window.location.search);
    if(searchParams.has('q')) {
        const data = JSON.parse(
            JSONCrush.uncrush(
                decodeURIComponent(searchParams.get('q'))
            )
        );
        state.textin.value = data.text?.replace(/&percnt;/g,'%') || '';
        state.wordin.value = data.words?.replace(/&percnt;/g, '%') || '';
    }
    else {
        state.textin.value = document.getElementById('default_text').textContent;
        state.wordin.value = document.getElementById('default_gloss').textContent;
    }
    for(const ta of [state.textin,state.wordin]) {
        ta.addEventListener('keyup',keyup);
        ta.addEventListener('blur',update);
    }
    document.getElementsByTagName('button')[0].addEventListener('click',update);
    state.htmlout.addEventListener('click',lookup);
    state.htmlout.addEventListener('mouseover',docMouseover);
};

const lookup = (e) => {
    if(e.target.nodeName === 'RT' || e.target.classList?.contains('word')) {
        const clean = e.target.dataset.norm.trim();
        window.open(`https://dsal.uchicago.edu/cgi-bin/app/tamil-lex_query.py?qs=${clean}&searchhws=yes&matchtype=exact`,'lexicon','height=400,width=400');
    }
};

const keyup = (e) => {
    if(e.keyCode === 13) update();
};

const update = async () => {
    const text = tamilToIast(state.textin.value);
    const words = tamilToIast(state.wordin.value);
    const result = collate(text,words);
    state.teiout.textContent = result.replace(/></g,'>​<').replace(/(\w)\s(\w)/g,'$1 $2');
    hljs.highlightElement(state.teiout);
    const out = await teitohtml(result);
    tamilize(out);
    state.htmlout.innerHTML = '';
    state.htmlout.append(out);
    const savedtext = state.textin.value.replace(/%/g,'&percnt;');
    const savedwords = state.wordin.value.replace(/%/g,'&percnt;');
    const qs = encodeURIComponent(
        JSONCrush.crush(
            JSON.stringify({text: savedtext, words: savedwords})
        )
    );
    window.history.replaceState(null,null,window.location.pathname+`?q=${qs}`);
};

const collate = (text, words) => {
    const salad = words.split('\n');
    const split = salad.map(s => s.split('-').map(w => w.trim()));
    let rem = text;
    let res = '';
    for(const cur of split) {
        const find = cur[0];
        const norm = cur[1];
        const found = ingest(rem,find);
        if(!found)
            return `Error at ${find}.`;

        const spacesmatch = found[0].match(/^[\s\n]+/);
        const spaces = spacesmatch ? spacesmatch[0] : '';
        const trimmed = found[0].trimStart();
        if(norm || trimmed !== find)
            res += `${spaces}<w norm="${norm || find}">${trimmed}</w>`.replace(/\n/,'<caesura/>');
        else
            res += `${spaces}<w>${trimmed}</w>`.replace(/\n/,'<caesura/>');
        rem = found[1];
    }
    return `<s>${res}</s>${rem}`;
};

const teitohtml = async (str) => {
    const teidoc = xml.parseString(`<?xml version="1.0" encoding="UTF-8"?><TEI xmlns="http://www.tei-c.org/ns/1.0">${str}</TEI>`);
    cleanup(teidoc);
    const res = await fetch('./tei-to-html.xsl');
    const restext = await res.text();
    const sheet = xml.parseString(restext);
    const out = await xml.XSLTransform(sheet,teidoc);
    const frag = document.createDocumentFragment();
    while(out.body.firstChild) frag.appendChild(out.body.firstChild);
    return frag;
};

const cleanup = (doc) => {
    const breakup = doc.querySelectorAll('w caesura');
    for(const b of breakup) {
        const next = b.nextSibling;
        const par = b.closest('w');
        par.after(b);
        if(next) b.after(next);
    }
};

const xml = {
    parseString(str) {
        const parser = new DOMParser();
        const newd = parser.parseFromString(str,'text/xml');
        if(newd.documentElement.nodeName === 'parsererror')
            alert(`The XML file could not be loaded. Please contact your friendly local system administrator. Error: ${newd.documentElement.textContent}`);
        else
            return newd;
    },
    async XSLTransform(xslsheet,doc) {
        // compile all xsl:imports to avoid browser incompatibilities
        
        for(const x of xslsheet.querySelectorAll('import')) {
            const resp = await fetch(x.getAttribute('href'));
            const i = xml.parseString(await resp.text());

            while(i.documentElement.firstChild)
                x.before(i.documentElement.firstChild);
            x.remove();
        }
        const xproc = new XSLTProcessor();
        xproc.importStylesheet(xslsheet);
        return xproc.transformToDocument(doc);
    }
};

const ingest = (text,str) => {
    let rem = text;
    let ret = '';
    for(let i=0;i<str.length;i++) {
        const spacesmatch = rem.match(/^[\s\n]+/);
        const spaces = spacesmatch ? spacesmatch[0] : '';
        const trimmed = rem.substring(spaces.length);
        if(trimmed[0] !== str[i])
            return false;
        else {
            ret += spaces + str[i];
            rem = trimmed.substring(1);
        }
    }
    return [ret,rem];
};

const docMouseover = (e) => {
    var targ = e.target.closest('[data-anno]');
    while(targ && targ.hasAttribute('data-anno')) {
       
        //ignore if apparatus is already on the side
        if(document.getElementById('record-fat') && 
           targ.classList.contains('app-inline') &&
           !targ.closest('.teitext').querySelector('.diplo') ) {
            targ = targ.parentNode;
            continue;
        }

        toolTip.make(e,targ);
        targ = targ.parentNode;
    }
};

const toolTip = {
    make: function(e,targ) {
        const toolText = targ.dataset.anno || targ.querySelector(':scope > .anno-inline')?.cloneNode(true);
        if(!toolText) return;

        var tBox = document.getElementById('tooltip');
        const tBoxDiv = document.createElement('div');

        if(tBox) {
            for(const kid of tBox.childNodes) {
                if(kid.myTarget === targ)
                    return;
            }
            tBoxDiv.appendChild(document.createElement('hr'));
        }
        else {
            tBox = document.createElement('div');
            tBox.id = 'tooltip';
            //tBox.style.opacity = 0;
            //tBox.style.transition = 'opacity 0.2s ease-in';
            document.body.appendChild(tBox);
            tBoxDiv.myTarget = targ;
        }

        tBox.style.top = (e.clientY + 10) + 'px';
        tBox.style.left = e.clientX + 'px';
        tBoxDiv.append(toolText);
        tBoxDiv.myTarget = targ;
        tBox.appendChild(tBoxDiv);
        targ.addEventListener('mouseleave',toolTip.remove,{once: true});
        document.addEventListener('click',toolTip.remove,{once: true});
        //window.getComputedStyle(tBox).opacity;
        //tBox.style.opacity = 1;
        tBox.animate([
            {opacity: 0 },
            {opacity: 1, easing: 'ease-in'}
            ], 200);
    },
    remove: function(e) {
        const tBox = document.getElementById('tooltip');
        if(!tBox) return;

        if(tBox.children.length === 1) {
            tBox.remove();
            return;
        }

        const targ = e.target;
        for(const kid of tBox.childNodes) {
            if(kid.myTarget === targ) {
                kid.remove();
                break;
            }
        }
        if(tBox.children.length === 1) {
            const kid = tBox.firstChild.firstChild;
            if(kid.tagName === 'HR')
                kid.remove();
        }
    },
};

document.addEventListener('DOMContentLoaded',init);
