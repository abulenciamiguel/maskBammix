process GETFLAGPRIMER {

	tag "flagging primer pairs"

	publishDir (
	path: "${params.out_dir}",
	mode: "copy",
	overwrite: "true"
	)


	output:
	path "flag_primerpair.bed", emit:flaggedPrimer_out


	script:
	"""
	bash get_flag_primerPair.sh \
	--file $params.in_dir \
	--bed $params.bed
	"""
}



process LISTFASTA {
	
	tag "listing fasta files"

	publishDir (
	path: "${params.out_dir}",
	mode: "copy",
	overwrite: "true"
	)


	output:
	path "consensus_list.csv", emit:fastaList_out


	script:
	"""
	bash getList.sh $params.in_dir/articNcovNanopore_prepRedcap_renameFasta/
	"""
}
