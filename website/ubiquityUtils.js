/*
GSH
Blatently lifted, with thanks, from http://dietrich.ganx4.com/mozilla/ubiquity.html
*/


/*
some mock objects that allow ubiquity commands to be gathered for later inspection
*/
var noun_arb_text = {};

var CmdUtils = {
  commands: [],
  CreateCommand: function(aCommand) {
    this.commands.push(aCommand);
  }  
};

CmdUtils.NounType = function() {
  this.prototype = {};
};
