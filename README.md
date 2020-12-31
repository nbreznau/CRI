# The Reliability of Scientific Data-Analysis


### Research Design and Data Analysis

*Nate Breznau*
*Eike Mark Rinke*
*Alexander Wuttke*
*Hung H.V. Nguyen*

<details>
<summary>*Participant Co-Researchers*</summary>
Muna Adem, Jule Adriaans, Amalia Alvarez-Benjumea, Henrik Andersen, Daniel Auer, Flavio Azevedo, Oke Bahnsen, Dave Balzer, Paul C. Bauer, Gerrit Bauer, Markus Baumann, Sharon Baute, Verena Benoit, Julian Bernauer, Carl Berning, Anna Berthold, Felix S.Bethke, ThomasBiegert, KatharinaBlinzler, Johannes N. Blumenberg, Licia Bobzien, Andrea Bohman, Thijs Bol, AmieBostic, Zuzanna Brzozowska, Katharina Burgdorf, Kaspar Burger, Kathrin Busch, Juan Carlos-Castillo, Nathan Chan, Pablo Christmann, Roxanne Connelly, Christian Czymara, Elena Damian, Alejandro Ecker, Achim Edelmann, Maureen A.Eger, Simon Ellerbrock, Anna Forke, Andrea Forster, Chris Gaasendam, Konstantin Gavras, Vernon Gayle, Theresa Gessler, Timo Gnambs, Amélie Godefroidt, Alexander Greinert, Max Grömping, Martin Groß, Stefan Gruber, Tobias Gummer, Andreas Hadjar, Jan Paul Heisig, Sebastian Hellmeier, Stefanie Heyne, Magdalena Hirsch, Mikael Hjerm, Oshrat Hochman, Jan H. Höffler, Andreas Hövermann, Sophia Hunger, Christian Hunkler, NoraHuth, Zsofia Ignacz, LauraJacobs, Jannes Jacobsen, Bastian Jaeger, Sebastian Jungkunz, Nils Jungmann, Mathias Kauff, ManuelKleinert, Julia Klinger, Jan-Philipp Kolb, Marta Kołczyńska, John Kuk, Katharina Kunißen, Dafina Kurti, Philipp Lersch, Lea-Maria Löbel, Philipp Lutscher, Matthias Mader, Joan Madia, Natalia Malancu, Luis Maldonado, Helge Marahrens, Nicole Martin, Paul Martinez, Jochen Mayerl, Oscar J. Mayorga, Patricia McManus, Kyle McWagner, Cecil Meeusen, Daniel Meierrieks, Jonathan Mellon, Friedolin Merhout, Samuel Merk, Daniel Meyer, Jonathan Mijs, Cristobal Moya, Marcel Neunhoeffer, Daniel Nüst, Olav Nygård, Fabian Ochsenfeld, Gunnar Otte, Anna Pechenkina, Christopher Prosser, Louis Raes, Kevin Ralston, Miguel Ramos, Frank Reichert, Leticia Rettore Micheli, Arne Roets, Jonathan Rogers, Guido Ropers, Robin Samuel, Gregor Sand, Constanza Sanhueza Petrarca, Ariela Schachter, Merlin Schaeffer, David Schieferdecker, Elmar Schlueter, Katja Schmidt, Regine Schmidt, Alexander Schmidt-Catran, Claudia Schmiedeberg, Jürgen Schneider, Martijn Schoonvelde, Julia Schulte-Cloos, Sandy Schumann, Reinhard Schunck, Jürgen Schupp, Julian Seuring, Henning Silber, Willem Sleegers, Nico Sonntag, Alexander Staudt, Nadia Steiber, Nils Steiner, Sebastian Sternberg, Dieter Stiers, Dragana Stojmenovska, Nora Storz, Erich Striessnig, Anne-Kathrin Stroppe, Janna Teltemann, Andrey Tibajev, Brian Tung, Giacomo Vagni, Jasper Van Assche, Metavan der Linden, Jolanda van der Noll, Arno Van Hootegem, Stefan Vogtenhuber, Bogdan Voicu, Fieke Wagemans, Nadja Wehl, Hannah Werner, Brenton Wiernik, Fabian Winter, Christof Wolf, Nan Zhang, Conrad Ziller, Björn Zakula, Stefan Zins and Tomasz Żółtak
</details>


### Abstract

This R project Git presents the workflow for data obtained from the Crowdsourced Replication Initiative [Breznau, Rinke and Wuttke et al 2018](https://osf.io/preprints/socarxiv/6j9qb/) used to investigate variability in research results across researchers and their model specifications. Calls on a 'reliability crisis' in science suggest that researchers fail to produce consistent results, in particular to replicate previous studies, because of systematic bias. This bias comes in myriad formats, p-hacking, publication bias, unethical practices, etc. In this research we investigate how much of this bias is actually 'random' in the sense that it derives from idiosyncratic features of the researchers and their steps taken when conducting data analysis. We attempted to remove as many factors of systematic bias as possible to be able to observe researchers conducting real-world research and to test the same hypothesis with the same data. 

### Important Documents

[Current Working Paper Version](https://docs.google.com/document/d/1Mlf8QANbUKt9zLxhXnp0ODt57-551YmmQatmENXEK88/edit#heading=h.4jbwvgc9efg)

[Planned Empirical Analysis (gdoc)](https://docs.google.com/document/d/143S8WYJ0yP_8wWHU7BaFdwVs30COZEvCAx0bzAkKlIc/edit#heading=h.1524t8a4a16i)

### Workflow

All participating team codes are in the respective sub-folders by software type, for example /CRI/CRI_**Mplus** contains all teams using Mplus codes and likewise for **Stata**,**R** and **SPSS**. In the one case of **MLwiN**, the team's Stata code imports the results. 

The data preparation code is in the sub-folder CRI/data_prep. After the data prep files, all necessary data analysis files are in the CRI/data folder. These files are many because participants' code often requires special files to run properly. The data files needed to reproduce the data anlysis. These files are:




