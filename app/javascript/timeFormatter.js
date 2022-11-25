function secondsToString(seconds, firm_format){ 
if (firm_format == 2){	
	return Math.abs(seconds / 3600).toFixed(2)
}
else if(firm_format == 1){
if (seconds < 60){
  return "0:00" 
}else{
  var numhours = Math.floor(seconds / 3600);
  var numminutes = Math.floor((seconds  % 3600) / 60);
  
  if (numminutes < 10){
    var minutes = "0" + numminutes
  }else if(numminutes == 0)
  {
    var minutes = "00" 
  }else{
    var minutes = numminutes
  }
  return numhours + ":" + minutes;
  }
};
}
