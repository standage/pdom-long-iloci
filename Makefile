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



all:			$(PepsVsNrMsb) $(PepsVsNrBlast) $(LongIlocusPeps) \
			$(LongIlocusPreds) $(LongIlocusSeqs) $(AllIlocusSeqs)

clean:			
			rm -f $(PepsVsNrMsb) $(PepsVsNrBlast) \
			      $(LongIlocusPeps) $(LongIlocusPreds) \
			      $(LongIlocusSeqs) $(AllIlocusSeqs)

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
			

$(LongIlocusSeqs):	$(LongIlocusIds) $(AllIlocusSeqs)
			./select-seq.pl $^ > $@

$(AllIlocusSeqs):	
			which iget
			iget -V $(PdomDataStore)/interval-loci/$@


