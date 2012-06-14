$(function(){
  
if ($('.secret').length) {
  $(window).keydown(function(e){
      var key = e.which;
      if (battle_mode) {
        if (key === 65 || key === 66) {
          attack(key);
        }
        if (key === 68) {
          drink_potion();
        }
      } else {
        if (key === 65) {
          updateDesc("You are currently in " + current_area.name + ". " + current_area.desc);
        }
        if (key === 37 || key === 39 || key === 38 || key === 40) {
          move(key);
        }
      }
      

        
});

var goblin = {
    hp: 30,
    attack: 2
}

var user = {
   hp: 50,
   attack: 3,
   potions: 3
}

function area(name,desc,left,right, up, down)
{
this.name=name;
this.desc=desc;
this.left=left;
this.right=right;
this.up = up;
this.down = down;
}

var forest = new area("Dark Forest", "You are in a dark and forebonding forest. It is full of goblins");
var start_area = new area("Grass Plains", "It is a beautiful grassy plain continuing endlessly in all directions. You can go left.", forest);
var current_area = start_area;
forest.right = start_area;

var battle_mode = true

var rand = 0;
var user_damage = 0;
var goblin_damage = 0;

function move(key) {
  if (key === 37) {
    if (current_area.left !== undefined) {
      current_area = current_area.left;
      updateDesc("You are currently in " + current_area.name + ". " + current_area.desc);
    } else {
      updateDesc("You can't move that way");
    }
  } else if (key === 39) {
    if (current_area.right !== undefined) {
      current_area = current_area.right;
      updateDesc("You are currently in " + current_area.name + ". " + current_area.desc);
    } else {
      updateDesc("You can't move that way");
    }
  } else if (key == 38) {
    if (current_area.up !== undefined) {
      current_area = current_area.up;
      updateDesc("You are currently in " + current_area.name + ". " + current_area.desc);
    } else {
      updateDesc("You can't move that way");
    }
  } else {
    if (current_area.down !== undefined) {
      current_area = current_area.down;
      updateDesc("You are currently in " + current_area.name + ". " + current_area.desc);
    } else {
      updateDesc("You can't move that way");
    }
  }
}

function updateStatus() {
  $(".status").html("<p> Your hp: " + user.hp + "    Potions left: " + user.potions + "</p><p> Goblin hp: " + goblin.hp);
}

function updateDesc(text, was_attack) {
  was_attack = typeof was_attack !== 'undefined' ? was_attack : false;
  hit = "";
  if (user_damage === 0 && was_attack) {
    hit = "You miss! "
  }
  $(".desc").html("<p>" + hit + text + "</p>");
}

function normal_attack() {
  rand = Math.floor(Math.random()*5);
  user_damage = user.attack + rand;
  rand = Math.floor(Math.random()*5);
  goblin_damage = goblin.attack + rand;
}

function heavy_attack() {
  hit = Math.floor(Math.random()*2);
  if (hit === 0) {
    user_damage = 0;
    rand = Math.floor(Math.random()*5);
    goblin_damage = goblin.attack + rand;
  } else {
    rand = Math.floor(Math.random()*10);
    user_damage = user.attack + rand;
    rand = Math.floor(Math.random()*5);
    goblin_damage = goblin.attack + rand;
  }
}

function drink_potion() {
  if (user.potions > 0) {
    healing = Math.floor(Math.random()*5);
    user.hp += healing;
    user.potions -= 1;
    updateDesc("You drink a potion. You are healed " + healing + " hit points");
    updateStatus();
  } else {
    updateDesc("No potions left!");
  }
}

updateStatus();

function attack(key) {
  if (key == 65) {
    normal_attack();
  } else {
    heavy_attack();
  }
  goblin.hp -= user_damage;
  if (goblin.hp > 0) {
    user.hp -= goblin_damage;
    updateDesc("You strike the goblin for " + user_damage + " damage. The goblin strikes you for " + goblin_damage + " damage!", true);
    updateStatus();
  } else {
    $(".enemy").slideUp("slow", function(){});
    updateDesc("You are victorious! Press a to continue");
    $(".status").html("<p> Your hp: " + user.hp);
    battle_mode = false;
  }
  
}

}
})