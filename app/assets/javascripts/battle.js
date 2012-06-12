$(function(){
if ($('.secret').length) {
  $(window).keydown(function(e){
      var key = e.which;
      if (key === 65) {
        $(".enemy").slideUp("slow", function(){});
        $(".desc").html("<p> You have defeated the evil goblin. Congratulations!")
      }
        
      

        
});
}
})