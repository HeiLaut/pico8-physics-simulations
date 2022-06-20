pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
	cls()
 g = 0.1--gravity
 create_kugel()
 --arrays to plot the data
 x,x2={},{}
 y,y2={},{}
 t=0
 lineplot = true
 play = false
end

function _update()
	--t+=1
 update_kugel()
end

function _draw()
 draw_kugel()
end
-->8
function create_kugel()
 k = {
 x = 10,
 y = 100,
 v = 5,
 w = 45,
 c=0.05,
 ddx = 0,
 ddy = 0
}
	k.dx = cos(k.w/360)*k.v
	k.dy = sin(k.w/360)*k.v
	
end



function draw_kugel()
		cls()
		local sp = 1
		plot(x,y,20,30,107,25,12,
							"","vx",false)
		plot(x2,y2,20,60,107,25,12,
							"t","y",false)
		if (k.x>128/5) sp =2
		if (k.x>128*2/5) sp =3
		if (k.x>128*3/5) sp =4
		if (k.x>128*4/5) sp =5
 	spr(sp,k.x,k.y)
end

function update_kugel()
 if (btnp(❎)) and not play then 
  _init()
  play = true
 end
 
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
	 k.ddy = g-diry* k.c*abs(k.dy)--^2
	 k.ddx = dirx* k.c*abs(k.dx)--^2
	 k.dy += k.ddy
	 k.dx -= k.ddx
	
		-- adding data to the plot arrays
		add(x,t)
	 add(y,k.dx)
	
		add(x2,t)
		add(y2,-k.y)
		if k.y>128 then
			play = false
		end
	end

	
 
	
	
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
  rectfill(_x2,_y2-1,_x2+_w-1,_y2-_h-1,7)
	 local x_max=max_list(_x)[1]
	 local y_max=max_list(_y)[1]
	 local x_min=max_list(_x)[2]
	 local y_min=max_list(_y)[2]
	 
	 --make sure to plot also a plot with slope = 0
	 if y_max == y_min then
	 	y_max +=2
	 	y_min -=2
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
		if scale then
		 print(flr(x_min*10)/10,_x2,_y2+2,7)
			print(flr(x_max*10)/10,_x2+_w-16,_y2+2)
			print(flr(y_min*10)/10,_x2-20,_y2-5)
			print(flr(y_max*10)/10,_x2-20,_y2-_h)
		end
	end
		
	print(_lx,_x2+_w/2,_y2+2,7)
 print(_ly,_x2-10,_y2-_h/2,7)
	rect(_x2,_y2,_x2+_w,_y2-_h-1,8)

 
 
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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aa770000aa7a0000a77a0000a7aa000077aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070009aaaaa00aaaaaa00aaaaaa00aaaaaa00aaaaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000099aaaa00aaaaaa00aaaaaa00aaaaaa00aaaa99000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000499aaa0099aaaa009aaaa900aaaa9900aaa994000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700044999900499999009999990099999400999944000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004444000044440000444400004444000044440000000000000000000000000000000000000000000000000000000000000000000000000000000000
