pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

function _init()
	init_menu()
	_upd=upd_menu
	_drw=drw_menu
	
 t=0
end


function _update()
 if _upd!=upd_menu then
	 if(btnp(❎)) then
	  if(play) then
	  	play=false
	  	m.a.x=0
	  	m.a.y=0
	  	m.v.x=0
	  	m.v.y=0
	 	else 
	 	 play = true
	 	 t=0
	 	 reset_data()
	 	end
	 end
	 dia1 = { {"x",m.p.x},
	 								{"y",m.p.y},
	 								{"vx",m.v.x},
	 								{"vy",m.v.y},
	 								{"ax",m.a.x},
	 								{"ay",m.a.y}}
	 controls()
 end
 
 if play or _upd==upd_menu then
 t+=1
 	_upd()
 	
 end
 
 
end


function _draw()
 		_drw()

	if _drw!=drw_menu then
		draw_controls()
		plot(x,y,50,62,70,50,9,"t",dia1[d1c][1],false)
		plot(x2,y2,50,112,70,50,9,"t",dia1[d2c][1],false)
 	print("t:"..flr(t/30*10)/10,2,110,12)
 end

end


function init_menu()
 s=1
	y=50

end

function drw_menu()
	cls()
	if s==1 then
		x=11

	--	line(f.p.x-5,f.p.y,f.p.x+5,f.p.y,9)
		--circfill(m.p.x,m.p.y,3+m.m/5,8)
 	--rectfill(f.a.x-5,f.a.y,f.a.x+5,f.a.y-2,10)
	end
	if s==0 then
		x=70
	end
	 
 draw_spring(28,55,30,8,5,11)
 circfill(28+2,85,4,8)
 rectfill(27,53,35,55,8)
 
 line(95,55,83,87,11)
 circfill(83,85,4,8)
 rectfill(90,53,100,55,8)

	print("harmonic oszilator",64-9.5*4,20,8)
 print("choose simulation",64-9*4,30,9)	
 rect(x,y,x+40,y+50,7)
end

function upd_menu()
 if btnp(➡️) or btnp(⬅️) then
 	s+=1
 	s=s%2
 end
	if btnp(❎) then
			 init_oszi()
	 
	 if s==1 then
	 		_upd=upd_spring
				_drw=drw_spring
  else
    init_pendulum()
    _upd=upd_pendulum
    _drw=drw_pendulum
  end
	end
end

function init_oszi()
	reset_data()
 c=1
	m={
	 p={x=20,y=40},
	 v={x=0,y=0},
	 a={x=0,y=0},
		m=2
		}
	
	--spring or pendulum
	f={
		p={x=20,y=50},
		d=0.5,
		a={x=0,y=0}, --anker
		l=60
		}
		f.a.x=f.p.x
		f.a.y=10
		m.p.y=f.a.y+f.l
		
	g={
			x=0,
			y=1
			}
	
	cw=0.0
	lineplot=true
	play=true
	d1c=2
	d2c=4

	n=150
	play=false
	
	dia1 = { {"x",m.p.x},
	 								{"y",m.p.y},
	 								{"vx",m.v.x},
	 								{"vy",m.v.y},
	 								{"ax",m.a.x},
	 								{"ay",m.a.y}}
	 								

 	
end
-->8
--spring

function init_spring()

end

function upd_spring()
		m.v=v_addv(m.v,m.a)
		m.p=v_addv(m.p,m.v)
	
	 local frc = v_mults(v_subv(m.p,f.p),-f.d/m.m)
	 frc = v_addv(frc,g)
	 frc = v_addv(frc,calc_fr(m.v))
	 
		apply_force(m,frc)
	
	
	 if m.p.y<f.a.y+10 then
	 	m.v.y=-0.7*m.v.y
  end
		add_data()
end

function drw_spring()
		cls()
--		line(f.a.x,f.a.y,m.p.x,m.p.y,7)
		draw_spring(f.a.x-2.5,f.a.y,(m.p.y+2-f.a.y),8,5,11)
		
	 line(f.p.x-5,f.p.y,f.p.x+5,f.p.y,9)
		circfill(m.p.x,m.p.y,3+m.m/5,8)
 	rectfill(f.a.x-5,f.a.y,f.a.x+5,f.a.y-2,10)

end
-->8
--pendulum
function init_pendulum()
	m.p.x = 5
	--m.p.y = 60
	f.a.x = 20
	f.a.y = 10
	f.vecl={x=m.p.x-f.a.x,
 									y=m.p.y-f.a.y
 									}
 --f.l=v_mag(f.vecl)
	m.p.y=f.a.y+sqrt(f.l^2-(m.p.x-f.a.x)^2)
	f_rk={x,y}
	d1c=1
	d2c=3
	play=false

end

function upd_pendulum()
		m.v=v_addv(m.v,m.a)
		m.p=v_addv(m.p,m.v)
		
 	f.vecl={x=m.p.x-f.a.x,
 									y=m.p.y-f.a.y
 									}
 									
 	f_rk=-g.y*f.vecl.y/f.l
 	f_rk=v_mults(v_normalize(f.vecl),f_rk)
 	frc=v_addv(f_rk,g)
 	
	 frc = v_addv(frc,calc_fr(m.v))

		apply_force(m,frc)
 	--correct position of the mass
		m.p.y=f.a.y+sqrt(f.l^2-(m.p.x-f.a.x)^2)
 	add_data()
 	
	
end

function drw_pendulum()
	cls()
	line(m.p.x,m.p.y,f.a.x,f.a.y,7)
	circfill(m.p.x,m.p.y,3+m.m/5,8)
	rectfill(f.a.x-5,f.a.y,f.a.x+5,f.a.y-2,5)
	
-- local amp=200
--	line(m.p.x+frc.x*amp,	m.p.y+frc.y*amp,
		--				m.p.x,
				--		m.p.y,9)
--	line(m.p.x+g.x*amp,
		--				m.p.y+g.y*amp,
				--		m.p.x,
					--	m.p.y,9)
	--line(m.p.x+f_rk.x*amp,
		--				m.p.y+f_rk.y*amp,
			--			m.p.x,
				--		m.p.y,9)
 --line(m.p.x-f.vecl.x,
			--			m.p.y-f.vecl.y,
					--	m.p.x,
						--m.p.y,9)						
  --print(f.l,20,20,8)
end
-->8
-- controls

function draw_controls()
	
	local pos=
	 {3,33,63,93}
 local pos2={30,55,80,105}

	rectfill(0,0,128,6,8)
	rectfill(0,121,128,128,8)
	if not play then
	 if c<5 then
				rectfill(pos[c]-1,0,pos[c]+23,6,7)
		 else if c<6 then
		 	rectfill(pos[c-4]-1,121,pos[c-4]+25,128,7)
		 else
				rectfill(pos2[c-5]-1,121,pos2[c-5]+20,128,7)
			end
	 end
	end
	print("x:"..flr(m.p.x),pos[1],1,2)
 print("y:"..flr(m.p.y),pos[2],1,2)
 if _upd==upd_pendulum then
		print("l:"..f.l,pos[3],1,2)
	else 
		print("d:"..f.d,pos[3],1,2)
 end
	
	print("m:"..m.m,pos[4],1,2)

	print("c:"..cw,pos[1],122,2)
	print("g:"..g.y,pos2[1],122,2)
	print("d1:"..dia1[d1c][1],pos2[2],122,2)
	print("d2:"..dia1[d2c][1],pos2[3],122,2)
	print("n:"..n,pos2[4],122,2)

end

function controls()
 if not play then
		if(btnp(➡️)) c+=1
		if(btnp(⬅️)) c-=1

		if(btnp(⬆️))then
		 if _upd==upd_pendulum then
				if(c==1)m.p.x+=1
			else		if(c==2)m.p.y+=1
		 end
			if(c==3) then 
				if _upd==upd_pendulum then
						f.l+=1
				else
				  f.d+=0.1
				end
			end
			if(c==4)m.m+=1
			if(c==5)cw+=0.01
			if(c==6)g.y+=0.5
			if(c==7)d1c+=1
			if(c==8)d2c+=1
			if(c==9)n+=10

		end
		
		if(btnp(⬇️))then
		if _upd==upd_pendulum then
				if(c==1)m.p.x-=1
		else		if(c==2)m.p.y-=1
		end
		--	if(c==1)m.p.x-=1
	--		if(c==2)m.p.y+=1
			if(c==3)then
				if _upd==upd_pendulum then
						f.l-=1
				else
				  f.d-=0.1
				end
			end
			if(c==4)m.m-=1
			if(c==5)cw-=0.01
			if(c==6)g.y-=0.5
			if(c==7)d1c-=1
			if(c==8)d2c-=1
			if(c==9)n-=10
		end

		c=mid(1,c,9)	
		m.p.x=mid(0,m.p.x,30)
		m.p.y=mid(20,m.p.y,114)
		f.l=mid(20,f.l,100)
		f.d=mid(0.1,f.d,1)
		m.m=mid(1,m.m,15)
		cw=mid(0,cw,0.5)
		g.y=mid(0,g.y,5)
		d1c=mid(1,d1c,6)
		d2c=mid(1,d2c,6)
		n=mid(20,n,300)
	end
	if _upd==upd_pendulum then
		m.p.y=f.a.y+sqrt(f.l^2-(m.p.x-f.a.x)^2)
 end
end


menuitem(1,"spring/pendulum",function()
 reset_data()
	init_oszi()

 if _upd==upd_pendulum then
 	_upd=upd_spring
		_drw=drw_spring
 else
 	_upd=upd_pendulum
	 _drw=drw_pendulum
  init_pendulum()
 end
end)
	 
-->8
-- calculations

--friction
function calc_fr(_v)
	local fx=cw*_v.x^2/m.m
	local fy=cw*_v.y^2/m.m
	if _v.x>0 then
		fx=-1*fx
	end
	if _v.y>0 then
	 fy=-1*fy
	end
	return {x=fx,y=fy}
end


--drawing a spring
function draw_spring(_x,_y,_l,_n,_b,_c)
	for i=0,_n-1 do
	 local prop = _l/_n
		local p1=_y+prop*i
		local p2=_y+prop*i+prop/2
	 if i>0 then
			local p3=_y+prop*(i-1)+prop/2
			line(_x,p1,_x+_b,p3,_c)
		end
	--	pset(_x,p1,8)
		--pset(_x+_b,p2,8)
		if i==0 then
	 	line(_x+_b/2,p1,_x+_b,p2,_c)
	 	else if i==_n-1 then
	 		line(_x,p1,_x+_b/2,p2,_c)
			else line(_x,p1,_x+_b,p2,_c)
			end
	 end
	 
	end
end


function apply_force(obj,force)
	 obj.a.x, obj.a.y = 0,0
	 obj.a=v_addv(obj.a,force)
end


-->8
-- plt
function reset_data()
		x,y,x2,y2={},{},{},{}
end


function add_data()
	add(x,t)
	add(y,dia1[d1c][2])
	add(x2,t)
	add(y2,dia1[d2c][2])
	if(#x>n)then
		 del(x,x[1])
			del(y,y[1])
			del(x2,x2[1])
			del(y2,y2[1])
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
  rectfill(_x2,_y2-1,_x2+_w-1,_y2-_h-1,0)
	 local x_max=max_list(_x)[1]
	 local y_max=max_list(_y)[1]
	 local x_min=max_list(_x)[2]
	 local y_min=max_list(_y)[2]
	 
	 --make sure to plot also a graph with slope = 0
	 if y_max == y_min and y_min>0 then
	 	y_max +=2
	 	y_min -=1
  end
	 
	 --resizeing the data
	 -- no resizing for x_r.. = 1
	 local x_r=_w/(n)--_w/(x_max-x_min)
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
		
		
	end
		
	print(_lx,_x2+_w-5,_y2+3,7)
 print(_ly,_x2-8,_y2-_h,7)
	rect(_x2,_y2+1,_x2+_w,_y2-_h-1,8)
 -- rect zo hide data bigger than dia,
 -- when rescaling n
 rectfill(_x2+_w+1,_y2-1-_h,_x2+_w+30,_y2,0)
 
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
--methods for handling math between 2d vectors
-- vectors are tables with x,y variables inside

-- contributors: warrenm

-- add v1 to v2

function v_addv( v1, v2 )
  return { x = v1.x + v2.x, y = v1.y + v2.y }
end

-- subtract v2 from v1
function v_subv( v1, v2 )
  return { x = v1.x - v2.x, y = v1.y - v2.y }
end

-- multiply v by scalar n
function v_mults( v, n )
  return { x = v.x * n, y = v.y * n }
end

-- divide v by scalar n
function v_divs( v, n )
  return { x = v.x / n, y = v.y / n }
end

-- gets magnitude of v, squared (faster than v_mag)
function v_magsqr( v )
  return ( v.x * v.x ) + ( v.y * v.y )
end

-- compute magnitude of v
function v_mag( v )
  return sqrt( ( v.x * v.x ) + ( v.y * v.y ) )
end

-- normalizes v into a unit vector
function v_normalize( v )
  local len = v_mag( v )
  return { x = v.x / len, y = v.y / len }
end

-- computes dot product between v1 and v2
function v_dot( v1, v2 )
   return ( v1.x * v2.x ) + ( v1.y * v2.y )
end

-- computes the reflection vector between vector v and normal n
-- note : assumes v and n are normalized
function v_reflect( v, n )
  local dot = v_dot( v, n )
  local wdnv = v_mults( v_mults( n, dot ), 2.0 )
  local refv = v_subv( v, wdnv )
  return refv
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88828288888222822288888888888888828288888288822288888888888888822888888222888882228888888888822288888222888888888888888888888888
88828288288882828288888888888888828288288288888288888888888888828288288282888882888888888888822288288882888888888888888888888888
88882888888222828288888888888888822288888222882288888888888888828288888282888882228888888888828288888222888888888888888888888888
88828288288288828288888888888888888288288282888288888888888888828288288282888888828888888888828288288288888888888888888888888888
88828288888222822288888888888888822288888222822288888888888888822288888222882882228888888888828288888222888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000b0000000000000000000000000000888888888888888888888888888888888888888888888888888888888888888888888880000000
000000000000000000000b0000000000000000000070700000800099000000000000000000000000000000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000070700000800099000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000077700000800090900000000000000000000000000000000000000000000000000000000000000080000000
000000000000000000bb000000000000000000000000700000800090900000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000077700000800900900000009000000000000000000000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000800900900000009900000000000000000000000000000000000000000000000000000080000000
0000000000000000000bb00000000000000000000000000000800900900000090900000000000000000000000000000000000000000000000000000080000000
000000000000000000000b0000000000000000000000000000800900900000090900000000900000000000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000000000000800900900000090900000000900000000000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000000000000800900900000090900000000900000000000000000000000000000000000000000000080000000
000000000000000000bb000000000000000000000000000000800900900000090090000009090000000000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000000000000800900900000090090000009090000000000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000800900900000090090000009090000000000000000000000000000000000000000000080000000
0000000000000000000bb00000000000000000000000000000800900900000090090000009090000000000000000000000000000000000000000000080000000
000000000000000000000b0000000000000000000000000000800900900000090090000009090000009000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000000000000800900900000090090000090090000009000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000000000000800900900000090090000090009000009000000000000000000000000000000000000080000000
000000000000000000bb000000000000000000000000000000800900900000090090000090009000009000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000000000000800900900000090009000090009000090000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000800900900000900009000090009000090000000000000000000000000000000000000080000000
0000000000000000000bb00000000000000000000000000000800900090000900009000090009000090000000000000000000000000000000000000080000000
000000000000000000000b0000000000000000000000000000800900090000900009000090009000090000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000000000000800900090000900009000900009000090000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000000000000800900090000900009000900000900090000000000000000000000000000000000000080000000
000000000000000000bb000000000000000000000000000000800900090000900009000900000900090000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000000000000800900090000900009000900000900090000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000809000090000900009000900000900090000000000000000000000000000000000000080000000
0000000000000000000bb00000000000000000000000000000809000090000900009000900000900090000000000000000000000000000000000000080000000
000000000000000000000b0000000000000000000000000000809000090000900009000900000900090000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000000000000809000090009000009000900000900090000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000000000000809000090009000009000900000900090000000000000000000000000000000000000080000000
000000000000000000bb000000000000000000000000000000809000009009000009009000000900090000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000000000000809000009009000009009000000900900000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000809000009009000009009000000900900000000000000000000000000000000000000080000000
0000000000000000000bb00000000000000000000000000000809000009009000009009000000900900000000000000000000000000000000000000080000000
000000000000000000000b0000000000000000000000000000809000009009000000909000000900900000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000000000000809000009009000000909000000090900000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000000000000809000009009000000909000000099000000000000000000000000000000000000000080000000
00000000000000099999999999000000000000000000000000890000009090000000909000000099000000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000000000000890000009090000000909000000000000000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000890000000990000000099000000000000000000000000000000000000000000000000080000000
0000000000000000000bb00000000000000000000000000000890000000990000000090000000000000000000000000000000000000000000000000080000000
000000000000000000000b0000000000000000000000000000890000000990000000000000000000000000000000000000000000000000000000000080000000
0000000000000000000000b000000000000000000000000000890000000990000000000000000000000000000000000000000000000000000000000080000000
00000000000000000000bb0000000000000000000000000000890000000090000000000000000000000000000000000000000000000000000000000080000000
000000000000000000bb000000000000000000000000000000890000000090000000000000000000000000000000000000000000000000000000000080000000
00000000000000000b00000000000000000000000000000000890000000000000000000000000000000000000000000000000000000000000000000080000000
000000000000000000b0000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000008880000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000088888000000000000000000000000000888888888888888888888888888888888888888888888888888888888888888888888880000000
00000000000000000888888800000000000000000070707070800900000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000888888800000000000000000070707070800900000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000888888800000000000000000070707770809900000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000088888000000000000000000077700070809900000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000008880000000000000000000007007770809900000000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000809900000000900000000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000809900000000990000000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000809900000000990000000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000809090000009090000000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000009090000000090000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000009090000000990000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000009090000000909000000090000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000009090000000909000000099000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000009090000009009000000099000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000009090000009009000000090000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000090090000009009000000090000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000090090000009000900000090000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000090009000009000900000900000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890090000090009000009000900000900000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000890009000090009000009000900000900000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900000900000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900000900000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900000900000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090009000009000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090000900009000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090000900090000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090000900090000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800009000090000900090000900009000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900090000900090000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900090000900090000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900090000900090000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900090000900090000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900090000900090000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090090000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090900000090090000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090900000090900000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090900000009900000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090900000009900000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090900000009900000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000090900000000900000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000900900000009000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000909000000009000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000909000000009000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000909000000000000000000000000000000000000000000000000000000000000080000000
00000000000000000000000000000000000000000000000000800000909000000000000000000000000000000000000000000000000000000000000080000000
00ccc00000cc00000000000000000000000000000000000000800000099000000000000000000000000000000000000000000000000000000000000080000000
000c000c000c00000000000000000000000000000000000000800000090000000000000000000000000000000000000000000000000000000000000080000000
000c0000000c00000000000000000000000000000000000000800000090000000000000000000000000000000000000000000000000000000000000080000000
000c000c000c00000000000000000000000000000000000000888888888888888888888888888888888888888888888888888888888888888888888880000000
000c000000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007770000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88882288888222888882228228888882288888228888888888888882288228888882828888888888228822288888282828288888822888888222822288888888
88828888288282888882828828888828888288828888888888888882828828882882828888888888282888288288282828288888828288288282828288888888
88828888888282888882828828888828888888828888888888888882828828888882228888888888282822288888282822288888828288888222828288888888
88828888288282888882828828888828288288828888888888888882828828882888828888888888282828888288222888288888828288288882828288888888
88882288888222882882228222888822288888222888888888888882228222888882228888888888222822288888828822288888828288888882822288888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

