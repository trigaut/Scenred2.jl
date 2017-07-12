using Scenred2, LightGraphs

T = 3
S = 3
R = 2

probas = round.(rand(S),2)
probas = probas./sum(probas)

scenarios = [Scenred2Scenario(p, round.(rand(T,R),3)) for p in probas ]

fan = Scenred2Fan(T,2,R,scenarios)

prms = Scenred2Prms(red_percentage = 0.8)

tree = Scenred2Tree(fan, prms)

gg = Graph(tree)
