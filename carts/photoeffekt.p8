pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--simulation photoeffect
--by heinrich lauterbach

function _init()
 init_menu()
 _upd=upd_menu
 _drw=draw_menu
end

function _update60()
	_upd()
end

function _draw()
	_drw()
end

-->8
function init_menu()

end

function upd_menu()
	if btn(❎) then
		init_ani()
		_upd=upd_ani
		_drw=drw_ani
	end
	
end


function draw_menu()
		cls(20)
end
-->8
function init_ani()
	ele={}
	charge=0
	wa=1.92
	--wellenlange in nm
	--wl={578, 546,  436, 493, 405}
-- frequenz in 10^14 hz
	f={5.2,5.5,6.1,6.9,7.4}
	intpat={0b1111101111111111.1,
									0b1111101111111110.1,
									0b1111101111111010.1,
									0b1111101011111010.1,
									0b111101011111010.1,
									0b101101011111010.1,
									0b101101001111010.1,
									0b101101001011010.1,
									0b1101001011010.1,
									0b101001011010.1,
									0b1001011010.1,
									0b1011010.1,
									0b11010.1,
									0b1010.1,
									0b10.1,
									0b0.1,
									}
									
	wl_i=0
	col={9,3,12,1,2} --colors
	int=16 --intensity
	tmr=1 --timer
	u=0 --voltage against
	ang=0 --angle amperemeter
end

function upd_ani()
	if (rnd(1)>1-int/10)make_el(1)
	tmr+=1
	int=int%17
	u=u%2
	if btnp(❎) then 
		wl_i+=1
		wl_i=wl_i%5
	end
	if(btnp(🅾️))ang+=0.1--int+=1
	if(btnp(⬆️))u+=0.01
	if(btnp(⬇️))u-=0.01
	foreach(ele,upd_ele)

end

function drw_ani()
 cls(0)
 color(8)
 
 print("frequenz:")
--	print(wl[wl_i+1])
	print(f[wl_i+1])
 print((int))
 print("gegenspannung:")
 print(u/0.5)
 --print((sqrt(6.6*f[wl_i+1]-wa*16)))
	if (int>0) then
  color(col[wl_i+1])
 	fillp(intpat[int])
		rectfill(20,30,109,80)
	 fillp(0b0.0)
	end	
	map()
 foreach(ele,drw_ele)
 drw_amp()
end
-->8
-- elektrons

function make_el(n)
		local l
	 for i=1,n do
	 local v=(sqrt(6.6*f[wl_i+1]-wa*16))/5
		if(v==0) then 
				l =  0
		else
		  l = 30
		end
	 local ang=rnd(0.3)+0.1
	  local c={
	   x=110-rnd(2),
	   y=rnd(50)+30,
	   dx=v*sin(ang),
	   dy=v*cos(ang),
	   l=l,
	  }
	  add(ele,c)
	 end
end

function drw_ele(obj)
	 pset(obj.x,obj.y,7)
	 
end

function upd_ele(obj)
	obj.l-=0.1
	obj.x+=obj.dx
	obj.y+=obj.dy
	if obj.l<0 or obj.x>110 or obj.x<5*8+4 
		or obj.y<25 or obj.y >85 then
		del(ele,obj)
	end
	obj.dx -= -u/100
end

function drw_amp()
	line(80,100,80+sin(u)*5,100-cos(u)*5,1)
end
__gfx__
0000000000060000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000060000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000060000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000060000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000060000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000000000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000000000000000000000000066666000000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000000000000000000000000600000600000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000000006000000000000006000700060000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000006006000000000000060007070006000000000000000000000000000000000000000000000000000000000000000000
00000000000600000000000600000000006006000000000000060007070006000000000000000000000000000000000000000000000000000000000000000000
00000000000666666666666600000000666006660000000066660007770006660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000006006000000000000060007070006000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000006006000000000000060007070006000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000006000000000000006000000060000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000600000600000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000066666000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010000000000000002030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110000140016170012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000212222242226272222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
