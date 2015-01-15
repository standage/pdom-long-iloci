#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
PdomDataStore=/iplant/home/standage/Polistes_dominula/r1.2
NrDb=/scratch/standage/ncbi/nr
NumThreads=32

LongIlocusIds=pdom-loci-r1.2-10longest-ids.txt
AllIlocusSeqs=pdom-loci-r1.2-masked.fa
LongIlocusSeqs=pdom-loci-r1.2-masked-10longest.fa
LongIlocusPreds=pdom-loci-r1.2-masked-10longest-preds.gff3
LongIlocusPeps=pdom-loci-r1.2-masked-10longest-pred-peps.fa
PepsVsNrBlastp=pdom-loci-r1.2-masked-10longest-preds-vs-nr.blastp
PepsVsNrMsb=pdom-loci-r1.2-masked-10longest-preds-vs-nr.msb
CufflinksTransAll=pdom-annot-r1.2-tuxedo.gff3
CufflinksTransLong=pdom-annot-r1.2-tuxedo-10longest-iloci.gff3
CuffIntronsLong=pdom-annot-r1.2-tuxedo-10longest-introns.txt
CufflinksPeps=pdom-annot-r1.2-tuxedo-10longest-iloci-peps.fa


#-------------------------------------------------------------------------------
# Workflow definition
#-------------------------------------------------------------------------------

all:			$(CufflinksPeps) $(CuffIntronsLong) \
			$(CufflinksTransLong) $(CufflinksTransAll) \
			$(PepsVsNrMsb) $(PepsVsNrBlast) $(LongIlocusPeps) \
			$(LongIlocusPreds) $(LongIlocusSeqs) $(AllIlocusSeqs)

clean:			
			rm -f $(CufflinksPeps) $(CuffIntronsLong) \
			      $(CufflinksTransLong) $(CufflinksTransAll) \
			      $(PepsVsNrMsb) $(PepsVsNrBlast) \
			      $(LongIlocusPeps) $(LongIlocusPreds) \
			      $(LongIlocusSeqs) $(AllIlocusSeqs)

$(CufflinksPeps):	$(CufflinksTransLong) $(AllIlocusSeqs)
			gt extractfeat -matchdescstart -join -retainids \
			     -translate -seqfile $(AllIlocusSeqs) -type exon \
			     $(CufflinksTransLong) > $@ || true

$(CuffIntronsLong):	$(CufflinksTransLong) intron-lengths.py
			./intron-lengths.py < $(CufflinksTransLong) \
			    | sort -rn -k1,1 > $@

$(CufflinksTransLong):	$(LongIlocusIds) $(CufflinksTransAll) selex.pl
			./selex.pl $(LongIlocusIds) $(CufflinksTransAll) \
			    | gt gff3 -retainids -sort -tidy -addintrons > $@

$(CufflinksTransAll):	
			iget -V $(PdomDataStore)/splicing/$@

$(PepsVsNrMsb):		crtfile $(PepsVsNrBlastp)
			which MuSeqBox
			MuSeqBox -i $(PepsVsNrBlastp) -c crtfile -o $@ \
			         -L 120 -l 24

$(PepsVsNrBlastp):	$(LongIlocusPeps)
			which blastp
			blastp -query $(LongIlocusPeps) -db $(NrDb) \
			       -num_threads $(NumThreads) -evalue 1e-8 \
			       > $@

$(LongIlocusPeps):	$(LongIlocusPreds) aug-get-prot.py
			./aug-get-prot.py < $< > $@

$(LongIlocusPreds):	$(LongIlocusSeqs)
			which augustus
			augustus --species=arabidopsis --gff3=on $< > $@
			

$(LongIlocusSeqs):	$(LongIlocusIds) $(AllIlocusSeqs) select-seq.pl
			./select-seq.pl $(LongIlocusIds) $(AllIlocusSeqs) > $@

$(AllIlocusSeqs):	
			which iget
			iget -V $(PdomDataStore)/interval-loci/$@


