(function () {
  CanvasRenderingContext2D.prototype.drawString=function(s, f, x, y){
  y=Math.round(y);
  var z=x=Math.round(x),t,i,j;
  if(!f.f){
    f.f=[t=0],i=0,j=f.w.length;
    while(++i<j)f.f[i]=t+=f.w[i-1];
  }
  s=s.split(''),i=0,j=s.length;
  while(i<j)if((t=f.c.indexOf(s[i++]))>=0)
    this.drawImage(f,f.f[t],0,f.w[t],f.height,x,y,f.w[t],f.height),x+=f.w[t];
    else if(s[i-1]=='\n')x=z,y+=f.h;
}
  return function () {};
}());
