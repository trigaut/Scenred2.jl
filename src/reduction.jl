function construct_tree(fan::Scenred2Fan, prms::Scenred2Prms; runtime_limit = -1, 
                        report_level = -1)

    fanfile = write_fan(fan)
    prmsfile = write_prms(prms)
    outfile = "$(scenred2tmpdir)/scenred2Out.dat"
    cmdfile = write_cmd("tree_con", fanfile, prmsfile, outfile, runtime_limit, 
                        report_level)

    run_scenred(cmdfile, fanfile, prmsfile, outfile)
end

function reduce_tree(tree::Scenred2Tree, prms::Scenred2Prms; runtime_limit = -1, 
                        report_level = -1)

    prms.construction_method = -1
    treefile = write_tree(tree)
    prmsfile = write_prms(prms)
    outfile = "$(scenred2tmpdir)/scenred2Out.dat"
    cmdfile = write_cmd("scen_red", treefile, prmsfile, outfile, runtime_limit, 
                        report_level)

    run_scenred(cmdfile, treefile, prmsfile, outfile)
end