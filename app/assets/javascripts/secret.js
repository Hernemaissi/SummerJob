$(function(){
var keys = [38,38,40,40,37,39,37,39,66,65];

var nextKey = 0;
$(window).keydown(function(e){
    var key = e.which;
    if (key === keys[nextKey])
        nextKey++;
    else
        nextKey = 0;

    if (nextKey >= keys.length)
        window.location.replace("/secret");
});
})