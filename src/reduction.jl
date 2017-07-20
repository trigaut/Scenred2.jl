function reduce_tree(tree::Scenred2Tree, prms::Scenred2Prms; runtime_limit = -1, 
                        report_level = -1)

    cmd_file = write_cmd("scen_red", runtime_limit, report_level)
    treefile = write_tree(f)
    prmsfile = write_prms(prms)
    outfile = "$(scenred2tmpdir)/scenred2Out.dat"

    run(`scenred2 $(cmdfile) -nogams`)

    raw_tree = readdlm(outfile)

    rm(cmdfile)
    rm(fanfile)
    rm(prmsfile)
    rm(outfile)

    n_nodes = raw_tree[find(x->x=="NODES",raw_tree[:,1])[1],2]
    n_vars = raw_tree[find(x->x=="RANDOM",raw_tree[:,1])[1],2]

    ind_first_node = find(x->x==1,raw_tree[:,1])[1]
    data = raw_tree[ind_first_node:ind_first_node+n_nodes-1, 1:n_vars+2]

    Scenred2Tree(n_nodes, n_vars, data)
end