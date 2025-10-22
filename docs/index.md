--- 
title: "High-resolution ecogeographical variables for species distribution modelling describing Latvia, 2024"
author: "Andris Avotiņš"
date: "2025-10-22"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib, refs.bib]
csl: elsevier-harvard.csl
# cover-image: path to the social sharing image like images/cover.jpg
description: |
  Description of the geodata used and the geoprocessing workflows employed to 
  create ecogeographical variables (EGVs) for species distribution modelling 
  describing Latvia, 2024.
link-citations: yes
github-repo: aavotins/HiQBioDiv_EGVs
url: https://aavotins.github.io/HiQBioDiv_EGVs/
---







# Preface {-}

Welcome! This book documents the geodata and processing workflows used to create
ecogeographical variables (EGVs) for species distribution modelling in Latvia (2024).

This material has been developed to present the results of three projects 
implemented at the University of Latvia, which are deeply rooted in species 
distribution modeling, and, more importantly, to demonstrate and explain the 
work process and decisions made in order to ensure their repeatability and 
reproducibility. These projects are:

- The project "Preparation of a geospatial data layer covering existing 
protected areas for the implementation of the EU Biodiversity Strategy 
2030" (No. 1-08/73/2023), funded by the Latvian Environmental Protection Fund 
Administration;

- Scientific research service project commissioned by AS "Latvijas valsts 
meži" (Latvian State Forests) "Improvement of the monitoring of the northern 
goshawk *Accipiter gentilis* and creation of a spatial model of habitat 
suitability" (Latvian State Forests document No. 5-5.5.1_000r_101_23_27_6);

- State research program "Development of research specified in the Biodiversity 
Priority Action Program" project "High-resolution quantification of biodiversity 
for nature conservation and management: HiQBioDiv" (VPP-VARAM-DABA-2024/1-0002).

The material was developed in R using {bookdown}. The data processing and analysis 
described in the content was mainly performed in R, and one of the main reasons 
for creating this material was to transfer the information necessary for 
reproducing the work using verified command lines. A desirable side effect 
is to promote openness and reproducibility in scientific practice and practical 
science.

- Repo: [aavotins/HiQBioDiv_EGVs](https://github.com/aavotins/HiQBioDiv_EGVs)
- Cite as needed using `book/book.bib`.


## About this material {.unnumbered}

This material **is not**:

* *an introduction to R or other programming languages*. On the contrary, it will 
be most useful to those who already understand how to use command lines. 
However, it will also be informative for other users regarding the approaches used;

* *a tutorial on geoprocessing*. This material summarizes the approaches that, 
at the time of its development, were known to the authors as the most 
effective (in terms of processing time, RAM and hard disk space, performance 
guarantees, and reliability), but they are certainly not the only ones possible;

* *copy/paste ready product*. Although the use and publication of command lines 
tends to be intended for these purposes, in a situation where large amounts of 
data and, at least in part, restricted access data are used for the work, this 
is simply not possible. However, by ensuring data availability and placement in 
accordance with the file structure of this project (availabe at `root/Data` or 
by forking [template repository](https://github.com/aavotins/HiQBioDiv_FileTree)), the 
command lines will be repeatable without changes and will produce the same results.

This material **has been** prepared to provide a reproducible workflow, describing 
the decisions made and solutions implemented in the preparation of ecogeographical 
variables for species distribution (habitat suitability) modeling for biodiversity 
conservation planning. 

For the most part, this material consists of:

* *explanatory text*, which is recognizable as text;

* *command lines*, which are hidden by default to make the text easier to read. 
The locations of the command lines can be identified by the "|> Code" visible 
on the left side of the page, just below this paragraph. Clicking on it will open 
the code area, where the text on a gray background is command lines, for example:


``` r
object=function(arguments1,arguments2,
path="./path/file/tree/object.extension")
# comment
```


In the example above, the first line creates an object ("object") that is 
the result of a function ("function()"). The function has three 
arguments ("arguments1", "arguments2" and "path") separated by commas (as with all 
function arguments in R). The third argument is the path in the file tree (it is 
on a new line but is a continuation of the function on the previous line, because 
the parentheses are not closed), which is indicated by an equal sign (and quotation 
marks) followed by this path (note the beginning "./", which indicates a relative 
path - the location in the file tree is relative to the project location).

The second line of the example above is a comment - everything after "#" is a 
comment. Anything in a command line before "#" must be an executable function or 
object. A comment can contain anything and be on the same line as an executable 
function (at the end of it).

Command lines are the most important part of this material for reproducibility. 
However, the person using them must ensure the availability of input data and 
maintain correct paths in the file tree.

Command lines can also be found in text, for example, `# comment as a command line in text`.

Sometimes I will refer to R packages in the text, I will put them in curly 
brackets, for example, {package}.

* *graphics* - occasional diagrams that describe the workflow or data 
characteristics and maps;

* *links to other resources*, especially to higher-level products and results 
created within the project, but also to input data, if it is publicly 
available. The results are intended for practical use.

Within reason, the material describes all data sets used and provides metadata 
related to ensuring reproducibility. Since not all data sets are freely available, 
they are not published as such, but in all cases information is provided on how 
they were obtained for the development of this project.

## Outline {.unnumbered}

1. [Terminology and acronyms](#Ch01)

2. [Utilities](#Ch02)

3. [Template files](#Ch03)

4. [Raw geodata](#Ch04)

5. [Geodata products](#Ch05)

6. [Ecogeographical variables](#Ch06)

7. [Data access](#Ch07)




