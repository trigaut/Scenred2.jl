using Scenred2

T = 3
S = 2
R = 4

s1 = Scenred2Scenario(0.6, round.(rand(T,R),3))

s2 = Scenred2Scenario(0.4, round.(rand(T,R),3))

fan = Scenred2Fan(T,2,R,[s1, s2])

prms = Scenred2Prms()

Scenred2Tree(fan, prms)
