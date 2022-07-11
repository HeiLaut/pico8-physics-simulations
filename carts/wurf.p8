pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
	cls()
	c=1
 g = 0.1--gravity
 --arrays to plot the data
	reset_dia_data()
 t=0
 lineplot = true
 play =false
 res=true
 
 --x0,y0,v0,w0=0,115,5,50
	create_kugel(0,114,3,45,0,5) 
	dia1 = {}
	d1c = 1
	d2c = 4
	--x-axis value
	diax = "t"
	
	sp_p={17,19,21,23}
	sp_p_n=1
	t_pc=30
	parachute=false
end
	
function _update()
	--t+=1
 update_kugel()
end

function _draw()
 draw_kugel()
end
-->8
function create_kugel(_x,_y,_v,_w,_c,_m)
 k = {
 x = _x,
 y = _y,
 v = _v,
 w = _w,
 c=_c,
 m=_m
}
	calc_vel()
	
end



function draw_kugel()
		cls()
		local sp = 1
		plot(x,y,15,35,107,25,12,
					"",dia1[d1c][1],false)
		
							
		plot(x2,y2,15,65,107,25,12,
							diax,dia1[d2c][1],false)
		if (k.x>128/5) sp =2
		if (k.x>128*2/5) sp =3
		if (k.x>128*3/5) sp =4
		if (k.x>128*4/5) sp =5

		--draw vel-vector
		if not (play) then
	 	line(k.x+3,k.y+3,k.x+3+3*k.dx,k.y+3+3*k.dy,12)

	 end
	 	
 	--draw ball
 	spr(sp,k.x,k.y)
 	if not play and not res and k.dy==0 then
 		print("press c/🅾️ to reset",25,80,7)
 	elseif not play and t==0 then
 		print("press x/❎ to start",25,80,7)
		end
		if parachute and t>t_pc then
			spr(sp_p[sp_p_n],k.x-5,k.y-15,2,2)
		end
		draw_controls()
		print("t:"..flr(t/30*10)/10,105,110,12)

end

function update_kugel()

 dia1 = {{"x",k.x},{"vx",k.dx},{"ax",k.ddx},{"y",-k.y},{"vy",-k.dy},{"ay",-k.ddy}}
 if play then
 	t+=1
  -- direction for calulating the friction
	 local dirx,diry = 1,1
	 -- calculating speed
	 k.x += k.dx
	 k.y += k.dy
	 if k.dy>0 then
	  diry = 1
	 else diry = -1
	 end
	 
	 if k.dx>0 then
	 	dirx = 1
	 else
	  dirx = -1
	 end
	 
	--acceleration
	 k.ddy = g-diry*k.c/k.m*abs(k.dy)^2
	 k.ddx = dirx*k.c/k.m*abs(k.dx)^2
	 k.dy += k.ddy
	 k.dx -= k.ddx
	
		-- adding data to the plot arrays
		if diax=="x" then
			add(x,k.x)
			add(x2,k.x)
		else
			add(x,t)
			add(x2,t)
		end
		
	 add(y,dia1[d1c][2])
	
		add(y2,dia1[d2c][2])
		if k.y>114 then
		 k.y=114
		 k.dy=0
		 k.dx=0
			play = false
		end
		if k.x>121 or k.x<0 then
			k.dx=-k.dx
		end
		if k.y<6 then
		 k.y=7
		 k.dy=-k.dy
		end
	end
	
	if parachute then
 	if t>t_pc and k.c < 2 then
 		k.c+=0.15
 		if(k.c<0.6) sp_p_n=1
 		if(k.c>0.6) sp_p_n=2
 		if(k.c>1.2) sp_p_n=3
 		if(k.c>1.9) sp_p_n=4
	 end
	end
	
	controls()	
end

function plot(_x,_y,_x2,_y2,_w,_h,_col,_lx,_ly,_sca)
 -- x,y datatabel
 -- x2,y2 leftd, down edge of plot
 -- w - width of plot
 -- h - height of plot
 -- c - color of plot
 -- lx,ly - label
 -- sca - scale on/off
 
 --if (#_x != #_y) return print("lenght of data not equal")
 if (#x > 0) then
  rectfill(_x2,_y2-1,_x2+_w-1,_y2-_h-1,0)
	 local x_max=max_list(_x)[1]
	 local y_max=max_list(_y)[1]
	 local x_min=max_list(_x)[2]
	 local y_min=max_list(_y)[2]
	 
	 --make sure to plot also a plot with slope = 0
	 if y_max == y_min and y_min>0 then
	 	y_max +=2
	 	y_min -=1
  end
	 
	 --resizeing the data
	 local x_r=_w/(x_max-x_min)
	 local y_r=_h/(y_max-y_min)
	 
	 for i=1,#_x do
	  local px=_x2+(-x_min+_x[i])*x_r
	  local py=_y2-(-y_min+_y[i])*y_r
	  
	  pset(px,py,_col)
	  
	  if i>1 and lineplot then
		  local px2=_x2+(-x_min+_x[i-1])*x_r
		  local py2=_y2-(-y_min+_y[i-1])*y_r
	   line(px,py,px2,py2)
	  end
			
		end
		--axis values
		if _sca then
		 print(flr(x_min),_x2,_y2,7)
			print(flr(x_max),_x2+_w-16,_y2+2)
			print(flr(y_min),_x2-10,_y2-5)
			print(flr(y_max),_x2-10,_y2-_h)
		end
--		 print("0",_
		
		
	end
		
	print(_lx,_x2+_w-5,_y2+3,7)
 print(_ly,_x2-8,_y2-_h,7)
	rect(_x2,_y2+1,_x2+_w,_y2-_h-1,8)

 
 
end

function max_list(_l)
	local _ma=_l[1]
	local _mi=_l[1]
 for i=1,#_l-1 do
  if _l[i+1] > _ma then 
   _ma=_l[i+1]
  elseif _l[i+1] < _mi then
   _mi=_l[i+1]
  end
	end

 return {_ma,_mi}

end
-->8
--controls
function draw_controls()
	
	local pos=
	 {3,33,63,93}
	rectfill(0,0,128,6,8)
	rectfill(0,121,128,128,8)
	
	if res then
	 if c<5 then
			rectfill(pos[c]-1,0,pos[c]+23,6,7)
	 else
	 	rectfill(pos[c-4]-1,121,pos[c-4]+25,128,7)
  end
	end
	
	print("x:"..flr(k.x)/100,pos[1],1,2)
	print("y:"..flr(114-k.y)/100,pos[2],1,2)
	print("v:"..round(k.v,3),pos[3],1,2)
	print("w:"..round(k.w,1),pos[4],1,2)

	print("c:"..round(k.c,2),pos[1],122,2)
	print("m:"..k.m,pos[2],122,2)
	print("d1:"..dia1[d1c][1],pos[3],122,2)
	print("d2:"..dia1[d2c][1],pos[4],122,2)

end

function controls()
	if btnp(❎) then
 	if play==false
	 	and res==true then
	 	--calculate start vel
	 		calc_vel()
	  
	  	x0,y0,v0,w0,c0,m0=k.x,k.y,k.v,k.w,k.c,k.m
	  	play = true
	  	res = false
  	elseif play then
   	play = false
   elseif k.dy!=0 then
  		play = true
  end
  
 end
 
 if btnp(🅾️) and not(play or res) then
		create_kugel(x0,y0,v0,w0,c0,m0)
		reset_dia_data()
		res = true 
		t=0
	end
	if res then
		if(btnp(➡️)) c+=1
		if(btnp(⬅️)) c-=1
		
		if(btnp(⬆️))then
			if(c==1)k.x+=1
			if(c==2)k.y-=1
			if(c==3)k.v+=0.5
			if(c==4)k.w+=1
			if(c==5)k.c+=0.011
			if(c==6)k.m+=1
			if(c==7)d1c+=1
			if(c==8)d2c+=1
		end
		
		if(btnp(⬇️))then
			if(c==1)k.x-=1
			if(c==2)k.y+=1
			if(c==3)k.v-=0.5
			if(c==4)k.w-=1
			if(c==5)k.c-=0.011
			if(c==6)k.m-=1
			if(c==7)d1c-=1
			if(c==8)d2c-=1
		end
		calc_vel()
		c=mid(1,c,8)	
		k.x=mid(0,k.x,30)
		k.y=mid(20,k.y,114)
		k.v=mid(0,k.v,15)
		k.w=mid(-90,k.w,90)
		k.c=mid(0,k.c,0.5)
		k.m=mid(1,k.m,20)
		d1c=mid(1,d1c,6)
		d2c=mid(1,d2c,6)
	end
end


-->8
-- helper
function round(z,d)
 local dig = 10^d
 return flr((z)*dig)/dig
end

function reset_dia_data()
	x,x2={},{}
 y,y2={},{}
end

function calc_vel()
	k.dx = cos(k.w/360)*k.v
	k.dy = sin(k.w/360)*k.v
	k.ddy = g-k.c/k.m*abs(k.dy)^2
 k.ddx = k.c/k.m*abs(k.dx)^2
end


-->8
--menu
menuitem(1,"parachute on/off",function()
 parachutejump()
end)

menuitem(2,"x-data t/x",function()
	if diax=="t" then
		diax="x"
	else
		diax="t"
	end
end)	

function  parachutejump()
 if not parachute then
		k.y=10
		k.v=0
		k.c=0.05
		k.x=5
		k.w=0
		parachute = true
		res=true
		play=false
		t=0
		reset_dia_data()
		d1c = 4
		d2c = 5
		diax="t"
	else _init()
	end
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aa770000aa7a0000a77a0000a7aa000077aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070009aaaaa00aaaaaa00aaaaaa00aaaaaa00aaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000099aaaa00aaaaaa00aaaaaa00aaaaaa00aaaa99000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000499aaa0099aaaa009aaaa900aaaa9900aaa994000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700044999900499999009999990099999400999944000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004444000044440000444400004444000044440000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000989890000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088989899800000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000089889880000000889929289280000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000008899888988800008899289289928000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000088898888988880088892889288928000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000088888000000028000080000880888992289288992800000000000000000000000000000000000000000000000000000000
00000000000000000000000000000899899000000008000080000800288920009000892800000000000000000000000000000000000000000000000000000000
00000000000000000000000000002880808880000002800080008800028000008000008000000000000000000000000000000000000000000000000000000000
00000000000000098000000000028800800088000000800080008000002800008000028000000000000000000000000000000000000000000000000000000000
00000000000000888800000000228800800888000000280080088000000880008000880000000000000000000000000000000000000000000000000000000000
00000000000000880000000000000800800808000000080080080000000080008002800000000000000000000000000000000000000000000000000000000000
00000000000000080000000000000280808800000000028080880000000028008028000000000000000000000000000000000000000000000000000000000000
00000000000000080000000000000080808000000000008080800000000002808028000000000000000000000000000000000000000000000000000000000000
00000000000000080000000000000080808000000000002080800000000000888880000000000000000000000000000000000000000000000000000000000000
00000000000000080000000000000028888000000000002888800000000000028800000000000000000000000000000000000000000000000000000000000000
00000000000000080000000000000002280000000000000228000000000000022800000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88828288888222822288888888888888828288888228822288888888888888828288888222888888888888888888828288888282822288888888888888888888
88828288288882888288888888888888828288288828888288888888888888828288288882888888888888888888828288288282828888888888888888888888
88882888888222882288888888888888822288888828888288888888888888828288888822888888888888888888828288888222822288888888888888888888
88828288288288888288888888888888888288288828888288888888888888822288288882888888888888888888822288288882888288888888888888888888
88828288888222822288888888888888822288888222888288888888888888882888888222888888888888888888822288888882822288888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888800000
00000007070000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccc800000
000000070700000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccc000800000
00000000700000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc00000000800000
0000000707000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc000000000000800000
000000070700000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc0000000000000000800000
00000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000cccc00000000000000000000800000
00000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000cccccc000000000000000000000000800000
0000000000000008000000000000000000000000000000000000000000000000000000000000000000000000cccc000000000000000000000000000000800000
000000000000000800000000000000000000000000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000800000
000000000000000800000000000000000000000000000000000000000000000000000000000000000ccc00000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000000000000000000000000000000cccc00000000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000000000000000000000000cccccc000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000000000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000800000
000000000000000800000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000000000000cccc00000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000ccccc0000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000800000
000000000000000800000000000000000000000000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
000000000000000800000000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000088888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888800000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888800000
00000007070000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccc800000
0000000707000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccc000000800000
0000000777000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccc0000000000000800000
00000000070000080000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccc0000000000000000000800000
00000007770000080000000000000000000000000000000000000000000000000000000000000000000000000000cccccc000000000000000000000000800000
0000000000000008000000000000000000000000000000000000000000000000000000000000000000000000cccc000000000000000000000000000000800000
000000000000000800000000000000000000000000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000800000
000000000000000800000000000000000000000000000000000000000000000000000000000000000ccc00000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000000000000000000000000000000cccc00000000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000000000000000000000000cccccc000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000000000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000800000
000000000000000800000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000000000000cccc00000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000000000000000000ccccc0000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000800000
000000000000000800000000000000000000000000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080000000000000000000ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
000000000000000800000000000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
000000000000000800000000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000000cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000080cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
0000000000000008c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000
00000000000000088888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888800000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077700000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000aa77000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000009aaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000099aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000499aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000044999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000004444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88882288888222888888888888888888822288888222888888888888888888822882288888828288888888888888822882228888828288888888888888888888
88828888288282888888888888888888822288288288888888888888888888828288288828828288888888888888828288828828828288888888888888888888
88828888888282888888888888888888828288888222888888888888888888828288288888882888888888888888828282228888822288888888888888888888
88828888288282888888888888888888828288288882888888888888888888828288288828828288888888888888828282888828888288888888888888888888
88882288888222888888888888888888828288888222888888888888888888822282228888828288888888888888822282228888822288888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

