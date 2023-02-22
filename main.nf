// enable dsl2
nextflow.enable.dsl=2


// import subworkflows
include {GETFLAGPRIMER} from './modules/getFastaPrimer.nf'
include {LISTFASTA} from './modules/getFastaPrimer.nf'
include {MASK} from './modules/maskPosition.nf'

workflow {
	



	main:
		GETFLAGPRIMER()
		LISTFASTA()
		LISTFASTA.out.fastaList_out.splitCsv(header:true, sep:',').map{ row -> tuple(row.sample, file(row.directory))}.set{ch_sample}
		MASK(ch_sample, GETFLAGPRIMER.out.flaggedPrimer_out)

}
