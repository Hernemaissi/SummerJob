$(function(){
  
if ($('.secret').length) {
  $(window).keydown(function(e){
      var key = e.which;
      if (key === 65) {
        attack();
      }
        
      

        
});

var goblin = {
    hp: 10,
    attack: 2
}

var user = {
   hp: 20,
   attack: 3
}


function updateStatus() {
  $(".status").html("<p> Your hp: " + user.hp + "</p><p> Goblin hp: " + goblin.hp);
}

updateStatus();

function attack() {
  goblin.hp -= user.attack;
  updateStatus();
}

}
})