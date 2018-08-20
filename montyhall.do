/*------------------------------------------------------------------montyhall.do
A numerical proof of the monty hall problem

Stuart Craig
20180819
*/

// Set up the game: 3 doors, one car per lottery (N=10,000)
	set seed 12345
	clear
	set obs 10000
	gen rand = runiform()
	gen door1 = rand<1/3
	gen door2 = inrange(rand,1/3,2/3)
	gen door3 = rand>2/3
	drop rand
	
// Choose a door at random
	gen rand = runiform()
	gen ch1 = rand<1/3
	gen ch2 = inrange(rand,1/3,2/3)
	gen ch3 = rand>2/3
	drop rand	
	
// Take away an option
	gen i=_n
	rename door* car*
	reshape long car ch, i(i) j(door)
	rename ch ch1
	qui gen gotit = ch1==1&car==1
	// can't take away the one you chose or the winning option
	// conditional on that, take one away at random
	gen rand = runiform()
	sort i ch1 car rand 
	by i: gen temp_n=_n
	drop if temp_n==1
	tab temp_n gotit
	drop temp_n gotit	
	
// Simulate two choices:
	gen stay = ch1==1
	gen switch = ch1==0
	gen gotit_stay = stay==1&car==1
	gen gotit_switch = switch==1&car==1
	
// Which choice won for each lottery?
	collapse (max) gotit_*, by(i) fast
	
// We're at about 2:1 in favor in switching	
	summ
	
/*
    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           i |     10,000      5000.5    2886.896          1      10000
  gotit_stay |     10,000        .329    .4698735          0          1
gotit_switch |     10,000        .671    .4698735          0          1

*/	
	
exit
