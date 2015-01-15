# Gene content in long geneless iLoci

## Motivation

The *P. dominula* genome assembly includes 10 stretches >350kb in length with no annotated genes.
These regions are laden with many repeats (although not necessarily at a higher density than the rest of the genome), and few transcript spliced alignments (most of which single-exon/ungapped).

## Methods

This workflow performs a simple check on these regions to investigate whether we may be missing *bona fide* genes in these regions.
  * First, the workflow uses AUGUSTUS to predict genes and compare their translation products to a database of known proteins.
  * Second, the workflow analyzes Cufflinks transcript assemblies in these regions, calculates the length of each intron in the Cufflinks transcripts, and attempts to translate the Cufflinks transcripts.

## Results

AUGUSTUS reported 36 gene predictions for these 10 regions, and at least 1 prediction was reported for each of the 10.
Most predictions have very short translation products, and many contain stretches of Xs.
Only 3 predictions have translation products >80aa, only 2 have hits against NR with >75% reciprocal coverage, and only 1 prediction meets both criteria.

Cufflinks assembled 34 isoforms (grouped into 13 gene models), and 8 of the 10 regions contain at least 1 Cufflinks transcript.
Some of these transcripts indeed contain long introns: there are 7 introns >100kb in length, the longest being about 185kb.
However, no reasonable open reading frames could be identified in these gene models.

## Conclusion

These analyses add support to the original Maker annotation suggesting that these regions contain no reliable gene models.
