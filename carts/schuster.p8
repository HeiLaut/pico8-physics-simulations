pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
 dauerfeuer=false
 skala=true
 f=0
	t={}
	f1={
		x1=25,
		y1=25,
		x2=105,
		y2=105,
		b=0
		}
	v0=1
	w=0
	c={2,0}--,0,65,120-20} --v,b,alph
	 i_c=1 --kontrolle der einstellbaren groesse
 
end

function _update60()
 if (dauerfeuer) then
 f+=1
 if(f%5==0) create()
 end
 
	foreach(t,update)
	controls()
end

function _draw()
 cls(15)
 if (skala) draw_skala()
 draw_b()
 -- rahmen b-feld
 rect(f1.x1,f1.y1,f1.x2,f1.y2,13)
 foreach(t,draw)
 draw_controls()
 -- quelle
 rect(65-2,100-2,65+2,100+2,1)
-- circ(65,65,40)


end

function create()
 v0 = sqrt(c[1])
 w = 0
 local o={
		x=65,
		y=100,
		lt=500,
		dx=cos(w/360)*v0/5,
		dy=sin(w/360)*v0/5,
		--w=atan2(vx,vy)*360,
		r=1,
		draw=function(self)
--		 pset(self.x,self.y,12)
				 pset(self.x,self.y,1)
		 end,
		dead=function(self)
		 self.lt-=1
		 if (self.lt<0) then return true
		 	else return false
		 	end
		 end
		}
  o.vw=atan2(o.dx,o.dy)*360, --winkelgeschwindigkeit
		 add(t,o)
end
-->8
--updates
function update(obj)
 f1.b=c[2]
 obj.x+=obj.dx
	obj.y+=obj.dy
 local v=sqrt(obj.dx^2+obj.dy^2)
	if(		obj.x > f1.x1 and obj.x < f1.x2
		and obj.y > f1.y1 and obj.y < f1.y2) then
		obj.vw+=f1.b/10
		obj.dx=v*cos(obj.vw/360)
		obj.dy=v*sin(obj.vw/360)
	else
  obj.vw=atan2(obj.dx,obj.dy)*360 
	end
	if (obj:dead()) del(t,obj)
end
-->8
--draws
function draw(obj)
	obj:draw()
end

function draw_b()
 local sprite = 3
	local sp=flr(70/abs(c[2]))
	sp=max(sp,4)
	if c[2]>0 then
		 sprite=2
	elseif c[2]<0 then
		 sprite=1
	end
	for x=f1.x1,f1.x2-6,sp do
	for y=f1.y1,f1.y2-6,sp do
		spr(sprite,x,y)
	end 
	end
end

function draw_skala()
	 -- messraster
 for i=25,105,5 do
 		line(i,25,i,105,7)
 		line(25,i,105,i,7)
	end
end
-->8
function controls()
		local f=1
		if (btnp(➡️) and i_c<#c) i_c+=1
		if (btnp(⬅️) and i_c>1) i_c-=1
		if (i_c==2) f=1
	
		if (btnp(⬆️)) c[i_c]+=f
	 if (btnp(⬇️)) c[i_c]-=f
  if (btnp(❎)) create(1)
  if (btnp(🅾️)) then
	  if dauerfeuer then dauerfeuer=false
	  else dauerfeuer=true
	  end
	 end
  c[1]=mid(0,c[1],100)
  c[2]=mid(-20,c[2],50)

end

function draw_controls()
 local _u=9.1/(2*1.6)*c[1]
 rectfill(0,0,128,7,8)
 rectfill(0,120,128,128,8)
 if (i_c == 1) rectfill(6,0,13,7,10)
 if (i_c == 2) rectfill(49,0,56,7,10)
 
 print("u:"..round(_u*4,1).."v",7,1,2)
 print("b:"..(round(c[2],1)/10).."Mt",50,1,2)
 
 if drawcontrols then
  print("quelle", 65,105-15,8)
	 print("⬅️➡️ - groesse wechseln",14,10,8)
	 print("⬆️⬇️ - groesse einstellen",14,17,8)
	 print("c/🅾️ - elektronenstrahl ein/aus",2.5,107,8)
	 print("x/❎ - einzelelektron start",2.5,113,8)
	end
end
-->8
--helper

function round(a,d)
 return	flr(a*d)/d
end


menuitem(1,"hilfe an/aus",
	function()
 print(drawcontrols,20,20)
	if drawcontrols then 
		drawcontrols=false
	else 
	 drawcontrols=true
	end
end)

menuitem(2,"skala an/aus",
	function()
 --print(drawcontrols,20,20)
	if skala then 
		skala=false
	else 
	 skala=true
	end
end)
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000d0000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
8888888888888888888888888888888888888888888888888aaaaaaaa88888888888888888888888888888888888888888888888888888888888888888888888
8888888282888882828222828888888888888288888888888a222aaaa82228888828288888222888888888282822282288282822282888888822288888888888
8888888282882882828288828888888222882888228888888a2a2aa2a82828888828282228828888888888282882882828282828882888828828288888888888
8888888282888882228228822288888222882882888888888a22aaaaa82828888822282228828888888888282882882828228822882888888828288888888888
8888888222882888828288828288888282882888828888888a2a2aa2a82828888888282828828888888888222882882828282828882888828828288888888888
8888888828888888828222822288888282828882288888888a222aaaa82228828888282828828888888888222822282828282822282228888822288888888888
8888888888888888888888888888888888888888888888888aaaaaaaa88888888888888888888888888888888888888888888888888888888888888888888888
8888888888888888888888888888888888888888888888888aaaaaaaa88888888888888888888888888888888888888888888888888888888888888888888888
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1fffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1fffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1fffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffdddddddddddddddddddddddddddddddddddddddddddddd1ddddddddddddddddddddddddddddddddddffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff71fff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffdf7ffff7ffff7ffffdffff7ffff7ffff7fdff7ffff7ffff7fffd7ffff7ffff7ffff7dfff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777771777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff71fff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777771777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff1ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7fff17ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ff1f7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7f1ff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd77d7777777777777777d7777777777777777d7771777777777777d7777777777777777d77777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff1ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7fff17ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777177777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff71fff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7fff17ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ff1f7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777771777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff1ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ff1f7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff71fff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7fff17ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777717177777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7fff17ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffdf7ffff7ffff1f1ffdffff7ffff7ffff7fdff7ffff7ffff7fffd7ffff7ffff7ffff7dfff7ffffdffffffffffffffffffffff
ffffffff11111ffffffffffffdffff7ffff71f1f7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
ffffffff1fff1ffffffffffffd1f1f1f1f17ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
ffffffff1f1f1f1f1f1f1f1f1d7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
ffffffff1fff1ffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
ffffffff11111ffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffdf7ffff7ffff7ffffdffff7ffff7ffff7fdff7ffff7ffff7fffd7ffff7ffff7ffff7dfff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffdf7ffff7ffff7ffffdffff7ffff7ffff7fdff7ffff7ffff7fffd7ffff7ffff7ffff7dfff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffd7777777777777777777777777777777777777777777777777777777777777777777777777777777dffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffff7ffffdffffffffffffffffffffff
fffffffffffffffffffffffffdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888822288228822822282228222882282288888882882828222828882888222888888282888882228888888888888888888282888882828222888888888888
88888828282828288882888288828828282828888828282828288828882888288888888282882882828222822288888888888282882882828288822282228888
88888822282828222882888288828828282828888828282828228828882888228888888828888882828222822288888888888222888882228222822282228888
88888828882828882882888288828828282828888822882828288828882888288888888282882882828282828288888888888882882888828882828282828888
88888828882288228822288288222822882828888882288228222822282228222888888282888882228282828288888888888222888888828222828282828888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__map__
0000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
