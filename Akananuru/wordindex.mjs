import { Transliterate } from './lib/js/transliterate.mjs';

const displayTree = (app) => {
    if(app.querySelector('.treebox svg')) {
        const lemma = app.querySelector('.dict-lemma');
        lemma.style.display = 'inline';

        const rdgs = app.querySelectorAll('.dict-rdg');
        for(const rdg of rdgs) rdg.classList.add('detailed');

        const witlists = app.querySelectorAll('.witlist');
        for(const witlist of witlists) witlist.style.display= 'inline';
        return;
    }

    if(document.getElementById('transbutton').lang === 'en') {
        Transliterate.revert(app);
    }

    const width = '800';
    const height = '600';
    const box = app.querySelector('.treebox');
    box.id = `tree${Date.now()}`;
    Smits.PhyloCanvas.Render.Style.line.stroke = 'rgb(162,164,170)';
    const jsphylo = new Smits.PhyloCanvas(
        {nexml: document.getElementById('nexml').firstChild, 
         fileSource: true},
        box.id, width, height,
        // 'circular'
    );
    for(const txt of box.firstChild.querySelectorAll('text')) {
        const newEl = document.createElement('div');
        newEl.setAttribute('class','treediv');
        const offleft = parseInt(txt.getAttribute('x') - 5);
        const offtop = parseInt(txt.getAttribute('y')) - 15;
        newEl.style.left = offleft + 'px';
        newEl.style.top = offtop + 'px';
        const key = txt.textContent.trim();//.replace(/[-_]/g,'');
        const wit = document.getElementById(key);
        if(wit) {
            const rdg = app.querySelector(`.dict-rdg[data-wit~="${key}"], .dict-lemma[data-wit~="${key}"]`);
            newEl.innerHTML =
`<span class="msid" data-key="${key}" lang="en" data-anno><span class="anno-inline" lang="en">${wit.querySelector('.expan').innerHTML}</span>${wit.querySelector('.abbr').innerHTML}</span><span class="treelemma" lang="ta">${rdg ? rdg.innerHTML : ''}</span>`;
        }
        txt.parentElement.removeChild(txt);
        box.appendChild(newEl);
    }

    const lemma = app.querySelector('.dict-lemma');
    const rdgs = app.querySelectorAll('.dict-rdg');
    lemma.style.display = 'inline';

    const allrdgs = [lemma,...rdgs];
    for(let n=0; n<allrdgs.length;n++) {
        const rdg = allrdgs[n];
        const wits = rdg.dataset.wit.split(' ');
        const witlist = document.createElement('span');
        witlist.className = 'witlist';
        let witliststr = '';
        for(const key of wits) {
            const wit = document.getElementById(key);
            const frag = wit ? 
                `<span class="msid" data-key="${key}" lang="en" data-anno><span class="anno-inline" lang="en">${wit.querySelector('.expan').innerHTML}</span>${wit.querySelector('.abbr').innerHTML}</span>` :
                `<span class="msid" data-key="${key}" lang="en">${key}</span>`;
            witliststr = witliststr + frag;
        }
        witlist.innerHTML = witliststr;
        rdg.after(witlist);
        rdg.classList.add('detailed');
        if(n === allrdgs.length-1) rdg.classList.add('last');
    }

    Transliterate.refreshCache(app);
    if(document.getElementById('transbutton').lang === 'en') {
        Transliterate.activate(app);
    }

    app.addEventListener('mouseover',highlightReadings);
};

const highlightReadings = (e) => {
    const lemma = e.target.closest('.dict-lemma, .dict-rdg, .treelemma');
    if(!lemma) return;
    const app = e.target.closest('.dict-app');
    if(!app.open) return;

    const text = lemma.textContent;
    for(const rdg of app.querySelectorAll('.dict-lemma, .dict-rdg, .treelemma'))
        if(rdg.textContent === text) rdg.classList.add('highlit');
    lemma.addEventListener('mouseout',unhighlightReadings, {once: true});
};

const unhighlightReadings = (e) => {
    const app = e.target.closest('.dict-app');
    for(const rdg of app.querySelectorAll('.highlit'))
        rdg.classList.remove('highlit');
};

const hideTree = (app) => {
    const lemma = app.querySelector('.dict-lemma');
    lemma.style.display = 'none';

    const rdgs = app.querySelectorAll('.dict-rdg');
    for(const rdg of rdgs) rdg.classList.remove('detailed');

    const witlists = app.querySelectorAll('.witlist');
    for(const witlist of witlists) witlist.style.display =  'none';
};

const treeToggle = (e) => {
    if(e.target.open) displayTree(e.target);
    else hideTree(e.target);
};

const init = () => {
    const lineview = document.querySelector('.line-view-icon');
    
    lineview.style.display = 'none';

    const recordcontainer = document.getElementById('recordcontainer');
    Transliterate.init(recordcontainer);

    document.querySelectorAll('details.dict-app').forEach(el => 
        el.addEventListener('toggle',treeToggle)
    );
    
    const loc = window.location.hash;
    if(loc) {
        const word = decodeURI(loc.replace(/^#/,''));
        const detail = document.getElementById(word);
        detail.scrollIntoView({behavior: 'smooth', block: 'center'});
        detail.open = true;
    }
};

window.addEventListener('load',init);
