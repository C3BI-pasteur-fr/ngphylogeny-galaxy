# -*- coding: utf-8 -*-
#!/usr/bin/env python
import argparse
from ete3 import Tree, TreeStyle,NodeStyle
from ete3.tools import ete_view

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-i', nargs='?', type=str, action="store", default="", help="Input fasta file")
    parser.add_argument('-o', nargs='?', type=str, action="store", default="", help="Output image file")
    parser.add_argument('--ext', nargs='?', type=str, action="store", default="", help="Set extension, by default use output extension name")
    parser.add_argument('--colorleaf', nargs='?', type=str, action="store", default="", help="map label and background color")
    parser.add_argument('--noleaf', action='store_true', default="", help="Hide leaf name")
    parser.add_argument('--nolength', action='store_true', default="", help="Hide branch length")
    parser.add_argument('--nosupport', action='store_true', default="", help="Hide branch support")
    parser.add_argument('-c',dest='circular', action='store_true', default="", help="Draw a circular tree ")
    
    args, unknown = parser.parse_known_args()
    
    t = Tree(args.i)
    ts = TreeStyle()
    
    if args.colorleaf:
        
        with open(args.colorleaf,'rU') as file_map:
            for line in file_map:
                if line:
                    leaf_color = list(map(str.strip,line.split('\t')))
                    print leaf_color
                    for leaf in t.get_leaves_by_name(leaf_color[0]):
                        leaf.set_style(NodeStyle())
                        
                        if leaf.name == leaf_color[0]:
                            leaf.img_style["bgcolor"] = leaf_color[1]
                        
    ts.show_leaf_name = not args.noleaf
    ts.show_branch_length = not args.nolength
    ts.show_branch_support = not args.nosupport

    if args.circular:
        ts.mode = "c"
        
    ext="svg"
    if args.ext:
       ext = args.ext
       
    t.render(args.o+ext, w=183, tree_style=ts, units="mm")
