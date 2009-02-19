var MCM = {
'ANIME' : '1',
'BOOKS' : '2',
'GAMES' : '3',
'MOVIES' : '4',
'MUSIC' : '5',
'PICTURES' : '6',
'SOFTWARE' : '7',
'TV SHOWS' : '8',
'OTHER' : '9'
};

var MininovaCategories = [
'Anime',
'Books',
'Games',
'Movies',
'Music',
'Pictures',
'Software',
'TV shows',
'Other'
];

var noun_type_mincats= new CmdUtils.NounType( "Category", MininovaCategories );

CmdUtils.CreateCommand({
  name: "mininova",
  author: { name: "Gary Hodgson", homepage : "http://www.garyhodgson.com/", email : "contact@garyhodgson.com"},
  icon: "http://static.mininova.org/images/favicon.ico",
  homepage: "http://garyhodgson/ubiquity",
  license: "MPL",
  releaseinfo: {2:"(01 Sep 2008) Replaced openUrl with Utils.openUrlInBrowser.",
  				1:"(29 Aug 2008) Initial Release." },
  description: "Performs a search on mininova.",
  help: "A category can be defined to limit the result set, e.g. 'in Books'",

  takes: {"torrent" : noun_arb_text},
  modifiers: {"in" : noun_type_mincats},
  
  preview: function( pblock, searchText, mods ) {
    pblock.innerHTML = "";
    var msg = 'Search Mininova for : ${search} in ${category}, and sort by most seeders.';
    var subs = {search: searchText.text, category: (mods.in.text||'')};
    
   pblock.innerHTML = CmdUtils.renderTemplate( msg, subs ); 
 
  },
  
execute: function( searchText, mods ) {
  
  h='www.mininova.org';
  var category = mods.in.text||'';
  var catid = ( MCM[category.toUpperCase()] ? '/'+MCM[category.toUpperCase()] : '');
  p='/search/'+encodeURIComponent(searchText.text) + catid + '/seeds';
  
  cp='http://'+h+p;
  Utils.openUrlInBrowser(cp,null);
}
  
});

CmdUtils.CreateCommand({
  name: "mininova-imdb",
  author: { name: "Gary Hodgson", homepage : "http://www.garyhodgson.com/", email : "contact@garyhodgson.com"},
  icon: "http://static.mininova.org/images/favicon.ico",
  homepage: "http://garyhodgson/ubiquity",
  license: "MPL",
  releaseinfo: {2:"(01 Sep 2008) Replaced openUrl with Utils.openUrlInBrowser.",
  			 	1:"(29 Aug 2008) Initial Release."},
  description: "Searches mininova for torrents associated with the given IMDB reference.",
  help: "IMDB references can include the tt prefix or not.",
  takes: {"imdbid" : noun_arb_text},
  
  preview: function( pblock, searchText, mods ) {
    pblock.innerHTML = "";
    var msg = 'Search Mininova for : ${imdbid} , using an IMDB reference.';
    var subs = {imdbid: searchText.text};
    
   pblock.innerHTML = CmdUtils.renderTemplate( msg, subs ); 
 
  },
  
execute: function( searchText, mods ) {
  
  h='www.mininova.org';
  var imdbid = ( (! searchText.text.indexOf("tt")) ? searchText.text.slice(2) : searchText.text);
  p='/imdb/?imdb='+imdbid;
  cp='http://'+h+p;
  Utils.openUrlInBrowser(cp,null);
}
  
});

CmdUtils.CreateCommand({
  name: "myebook",
  author: { name: "David Ruan", homepage : "http://sogoumap2pdf.rubyforge.org/", email : "ruanwz@gmail.com"},
  icon: "http://static.mininova.org/images/favicon.ico",
  homepage: "http://sogoumap2pdf.rubyforge.org/",
  license: "MPL",
  releaseinfo: {2:"(04 Sep 2008) Fix bugs.",
  			 	1:"(29 Aug 2008) Initial Release."},
  description: "Searches ebook on ITPUB,then finds comments on douban.",
  help: "Pass the book name.",
  takes: {"book_name" : noun_arb_text},
  
  preview: function( pblock, searchText, mods ) {
    pblock.innerHTML = "";
    var msg = 'Search ITPUB for : ${book_name} , using a book name.';
    var subs = {book_name: searchText.text};
    debugger 
    pblock.innerHTML = CmdUtils.renderTemplate( msg, subs ); 
 
  },
  
execute: function( searchText, mods ) {
  var head='www.itpub.net/search.php';
  var book_name = searchText.text;
  var parms = {srchfid: 61, srchtext: book_name};
  debugger 
  jQuery.post(head,parms,function(resp){
  CmdUtils.setSelection(resp.text);
  })
}
  
});
