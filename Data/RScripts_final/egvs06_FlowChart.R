library(tidyverse)  # for %>% pipes
library(DiagrammeR)
library(DiagrammeRsvg)  # for conversion to svg
library(rsvg)  # for saving svg

diagrammai="digraph flowchart {
  rankdir = LR


  # node type pamatainavas
  node [fontname = Helvetica, shape = none,style=none,fontface=bold,fontsize=6,fontcolor=white];{
    node [label='Pamatainavas']; level0;
    node [label='Level 1']; level1;
    node [label='Level 2']; level2;
    node [label='Level 3']; level3;
    node [label='Level 4']; level4;
    node [label='Level 5']; level5;
    node [label='Level 6']; level6;
  }


  # node type 0: landscapes
  node [fontname = Helvetica, shape = rectangle,style=rounded,fontface=bold,fontsize=30,fontcolor=black];{
    node [label='Climate\n(69 quantities)']; lsc1;
    node [label='HydroClimate\n(19 quantities)']; lsc2;
    node [label='LULC & Habitat\n(9 Euclidean distances,\n18 quantities,\n14 sets of edge lengths,\n3 sets of diversity indices,\n57 sets of coverage fractions)']; lsc3;
    node [label='Satelite indices\n(21 quantities)']; lsc4;
    node [label='Soil chemistry\n(6 quantities)']; lsc5;
    node [label='Soil texture\n(4 sets of coverage fractions)']; lsc6;
    node [label='Terrain\n(8 quantities,\n1 set of coverage fractions)']; lsc7;
  }

  # node type: diversity
  node [fontname = Helvetica, shape = rectangle,style=\"rounded,filled\",fontface=bold,fontsize=30,fontcolor=black,fillcolor=AliceBlue];{
    node [label='Diversity_*\n(Farmland_*\nForest_\nTotal_*)']; div;
  }
  

  # node type: mezi
  node [fontname = Helvetica, shape = rectangle,style=\"rounded,filled\",fontface=bold,fontsize=30,fontcolor=black,fillcolor=grey];{
    node [label='Forests with inventory']; l0_c08x;
  }



  # node type 1: distance
  node [fontname = Helvetica, shape = rectangle,style=\"rounded,filled\",fontcolor=black,fillcolor=Seashell]; {
    node [label='Distance_Sea_cell']; l1_d01;
    node [label='Distance_Landfill_cell']; l1_d02;
    node [label='Distance_Waste_cell']; l1_d03;
    node [label='Distance_Builtup_cell']; l1_d04;
    node [label='Distance_ForestInside_cell']; l2_d08;
    node [label='Distance_GrasslandPermanent_cell']; l5_d09;
    node [label='Distance_Water_cell']; l1_m08;
    node [label='Distance_WaterInside_cell']; l1_m09;
    node [label='Distance_Trees_cell']; l1_m01;

  }

  # node type 2: quantity
  node [fontname = Helvetica, shape = rectangle,style=\"rounded,filled\",fontcolor=black,fillcolor=LavenderBlush]; {
    node [label='ForestsQuant_*\n(AgeProp-average_cell,\nDominantDiameter-max_cell,\nLargestDiameter-max_cell,\nTimeSinceDisturbance-average_cell)']; l1_q01;
    node [label='ForestsQuant_VolumeTotal-sum_cell']; l1_q05;
    node [label='ForestsQuant_VolumeBorealDeciduousTotal-sum_cell']; l2_q06;
    node [label='ForestsQuant_VolumeConiferous-sum_cell']; l2_q07;
    node [label='ForestsQuant_VolumeTemperateDeciduousTotal-sum_cell']; l2_q08;
    node [label='ForestsQuant_*\n(VolumeAspen-sum_cell,\nVolumeBirch-sum_cell,\nVolumeBlackAlder-sum_cell,\nVolumeBorealDeciduousOther-sum_cell)']; l3_q09;
    node [label='ForestsQuant_*\n(VolumeOak-sum_cell,\nVolumeTemperateWithoutOak-sum_cell,\nVolumeOakMaple-sum_cell,\nVolumeTemperateWithoutOakMaple-sum_cell)']; l3_q13;
    node [label='ForestsQuant_*\n(VolumePine-sum_cell,\nVolumeSpruce-sum_cell)']; l3_q15;
    node [label='Climate_*_cell']; climate;
    node [label='HydroClim_*_cell']; hydroclim;
    node [label='EO_*_cell']; earthobs;
    node [label='SoilChemistry_*_cell']; soilchem;
    node [label='Terrain_*_cell']; terrquant;
  }

  # node type 3: edge
  node [fontname = Helvetica, shape = rectangle,style=\"rounded,filled\",fontcolor=black,fillcolor=Ivory]; {
    node [label='Edges_Roads_*']; l1_e01;
    node [label='Edges_Farmland-Builtup_*']; l1_e02;
    node [label='Edges_Trees-Builtup_*']; l1_e03;
    node [label='Edges_Water-Farmland_*']; l1_e06;
    node [label='Edges_ReedSedgeRushBeds-Water_*']; l2_e07;
    node [label='Edges_OldForests_*']; l2_e08;
    node [label='Edges_FarmlandShrubs-Trees_*']; l2_e09;
    node [label='Edges_Bogs-Water_*']; l2_e10;
    node [label='Edges_Bogs-Trees_*']; l2_e11;
    node [label='Edges_CropsFallow_*']; l4_e12;
    node [label='Edges_Grasslands_*']; l4_e13;
    node [label='Edges_Water_*']; l1_m02;
    node [label='Edges_Trees_*']; l1_m05;
    node [label='Edges_Water-Grassland_*']; l4_e14;
  }
  

  # node type 4: coverage
  node [fontname = Helvetica, shape = rectangle,style=\"rounded,filled\",fontcolor=black,fillcolor=Azure]; {
    node [label='FarmlandSubsidies_BiologicalSubsidies_*']; l1_m03;
    node [label='FarmlandParcels_FieldsActive_*']; l1_m04;
    node [label='General_ForestsWithoutInventory_*']; l1_m06;
    node [label='General_TreesOutsideForests_*']; l1_m07;
    node [label='General_BareSoilQuarry_*']; l1_c01;
    node [label='General_Builtup_*']; l0_c02;
    node [label='General_Farmland_*']; l0_c03;
    node [label='General_Roads_cell']; l0_c04;
    node [label='General_ShrubsOrchardsGardens_*']; l0_c05;
    node [label='General_SwampsMiresBogsHelophytes_*']; l0_c06;
    node [label='General_Trees_*']; l0_c07;
    node [label='General_Water_*']; l0_c08;
    node [label='FarmlandPloughed_CropsFallowTempGrass_*']; l1_c09;
    node [label='ForestsAge_*\n(ClearcutsLowStands_*,\nYoungTallStandsShrubs_*,\nMiddle_*,\nOld_*)']; l2_c10;
    node [label='ForestsSoil_*\n(EutrophicDrained_*,\nEutrophicMineral_*,\nEutrophicOrganic_*,\nMesotrophicMineral_*,\nOligotrophicDrained_*,\nOligotrophicMineral_*,\nOligotrophicOrganic_*)']; l2_c11;
    node [label='ForestsTrees_*\n(BorealDeciduous_*,\nTemperateDeciduous_*,\nConiferous_*,\nMixed_*)']; l2_c12;
    node [label='General_GardensOrchards_*']; l1_c14;
    node [label='General_ShrubsOrchards_*']; l1_c15;
    node [label='Wetlands_*\n(Bogs_*,\nMires_*,\nReedSedgeRushBeds_*)']; l1_c17;
    node [label='ForestsTreesAge_*\n(BorealDeciduousYoung_*,\nBorealDeciduousOld_*,\nTemperateDeciduousYoung_*,\nTemperateDeciduousOld_*,\nConiferousYoung_*,\nConiferousOld_*,\nMixedYoung_*,\nMixedOld_*)']; l3_c18
    node [label='FarmlandPloughed_CropsFallow_*']; l2_c19;
    node [label='FarmlandCrops_CropsAll_*']; l3_c20;
    node [label='FarmlandPloughed_Fallow_*']; l3_c21;
    node [label='FarmlandGrassland_GrasslandsAll_*']; l3_c22;
    node [label='General_AllotmentGardens_*']; l2_c23;
    node [label='FarmlandCrops_*\n(CropsHoed_*,\nCropsSpring_*,\nCropsWinter_*,\nRapeseedsSpring_*,\nRapeseedsWinter_*,\nCropsOther_*)']; l4_c24;
    node [label='FarmlandGrassland_Grasslands*\n(Abandoned_*,\nPermanent_*,\nTemporary_*)']; l4_c25;
    node [label='FarmlandTrees_PermanentCrops_*']; l2_c26;
    node [label='FarmlandTrees_ShortRotationCoppice_*']; l2_c27;
    node [label='SoilTexture_*\n(Clay_*,\nSilt_*,\nSand_*,\nOrganic_*)']; soiltxt;
    node [label='Terrain_DiS-area_*']; sinkarea;
  }
  
    # specify which nodes are of the same 'rank' so that they'll be drawn at the same level
      {rank = same; level0 lsc1 lsc2 lsc3 lsc4 lsc5 lsc6 lsc7 div}
      {rank = same; level1 climate hydroclim earthobs soilchem soiltxt sinkarea terrquant l1_c01 l0_c02 l0_c03 l0_c04 l0_c05 l0_c06 l0_c07 l0_c08 l1_d01 l1_d02 l1_d03}
      {rank = same; level2 l1_m04 l1_m03 l2_e09 l0_c08x l1_d04 l1_m01 l1_e01 l1_e02 l1_e03 l1_e06 l1_c09 l1_c14 l1_c15 l1_c17 l1_m05 l1_m06 l1_m07 l1_m02 l1_m08 l1_m09}
      {rank = same; level3 l1_q05 l1_q01 l2_d08 l2_e07 l2_e10 l2_e11 l2_c19 l2_c23 l2_c26 l2_c27 l2_c10 l2_c11 l2_c12}
      {rank = same; level4 l2_q06 l2_q07 l2_q08 l4_e12 l3_c20 l3_c21 l3_c22 l3_c18 l2_e08}
      {rank = same; level5 l3_q09 l3_q13 l3_q15 l4_e13 l4_e14 l4_c24 l4_c25}
      {rank = same; level6 l5_d09}

    edge[tailclip = true, headclip = true,color=white,arrowhead=none];
      level0 -> level1
      level1 -> level2
      level2 -> level3
      level3 -> level4
      level4 -> level5
      level5 -> level6
      
    edge[tailclip = true, headclip = true,color=black,arrowhead=none];
      lsc3 -> div
      lsc3 -> l1_c01
      lsc3 -> l0_c02
      lsc3 -> l0_c03
      lsc3 -> l0_c04
      lsc3 -> l0_c05
      lsc3 -> l0_c06
      lsc3 -> l0_c07
      lsc3 -> l0_c08
      lsc3 -> l1_d01
      lsc3 -> l1_d02
      lsc3 -> l1_d03
      lsc1 -> climate
      lsc2 -> hydroclim
      lsc4 -> earthobs
      lsc5 -> soilchem
      lsc6 -> soiltxt
      lsc7 -> sinkarea
      lsc7 -> terrquant


    edge[tailclip = true, headclip = true,color=black,arrowhead=none];
      l1_c09 -> l0_c03
      l1_e01 -> l0_c04
      l1_c15 -> l0_c05
      l1_c14 -> l0_c05
      l2_c23 -> l1_c14
      l2_c26 -> l1_c14
      l2_c26 -> l1_c15
      l2_c27 -> l1_c15
      l1_c17 -> l0_c06
      l0_c08x -> l0_c07
      l2_d08 -> l1_m06
      l2_d08 -> l0_c08x
      l2_c10 -> l0_c08x
      l2_c11 -> l0_c08x
      l2_c12 -> l0_c08x
      l3_c18 -> l2_c10
      l3_c18 -> l2_c12
      l2_c19 -> l1_c09
      l3_c21 -> l2_c19
      l3_c20 -> l2_c19
      l3_c22 -> l0_c03
      l4_c25 -> l3_c22
      l4_c24 -> l3_c20
      l5_d09 -> l4_c25
      l4_e13 -> l3_c22
      l4_e12 -> l2_c19
      l1_e06 -> l0_c08
      l1_e06 -> l0_c03
      l4_e14 -> l0_c08
      l4_e14 -> l3_c22
      l1_m03 -> l0_c03
      l1_m04 -> l0_c03
      l1_q01 -> l0_c08x
      l1_q05 -> l0_c08x
      l2_q06 -> l1_q05
      l2_q07 -> l1_q05
      l2_q08 -> l1_q05
      l3_q09 -> l2_q06
      l3_q15 -> l2_q07
      l3_q13 -> l2_q08
      l2_e07 -> l1_c17
      l2_e07 -> l0_c08
      l2_e08 -> l2_c10
      l2_e09 -> l0_c03
      l2_e09 -> l0_c07
      l2_e09 -> l0_c05
      l2_e10 -> l1_c17
      l2_e10 -> l0_c08
      l2_e11 -> l1_c17
      l2_e11 -> l0_c07
      l1_e02 -> l0_c02
      l1_e02 -> l0_c03
      l1_e03 -> l0_c02
      l1_e03 -> l0_c07
      l1_m01 -> l0_c07
      l1_m05 -> l0_c07
      l1_m06 -> l0_c07
      l1_m07 -> l0_c07
      l1_d04 -> l0_c02
      l1_m02 -> l0_c08
      l1_m08 -> l0_c08
      l1_m09 -> l0_c08
      l1_c09 -> l3_c22

}"

grViz(diagrammai)

DiagrammeRsvg::export_svg(grViz(diagrammai)) |>
  charToRaw() |>
  rsvg::rsvg_png("EGV_FlowChartZ.png", width = 2000)


DiagrammeRsvg::export_svg(grViz(diagrammai)) |>
  charToRaw() |>
  rsvg::rsvg_pdf("EGV_FlowChartZ.pdf", width = 2000)


DiagrammeRsvg::export_svg(grViz(diagrammai)) |>
  charToRaw() |>
  rsvg::rsvg_svg("EGV_FlowChartZ.svg", width = 2000)


DiagrammeRsvg::export_svg(grViz(diagrammai)) |>
  charToRaw() |>
  rsvg::rsvg_eps("EGV_FlowChartZ.eps", width = 2000)
