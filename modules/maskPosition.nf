process MASK {
	container 'manoj6/python-pandas:latest'
	tag "masking flagged positions in $sample"

	publishDir (
	path: "${params.out_dir}/masked",
	mode: "copy",
	overwrite: "true"
	)

	input:
	tuple val(sample), path(fasta)
	file(flaggedPrimer)


	output:
	path "*_masked.fasta"


	script:
	"""
	pip3 install biopython

	cp $flaggedPrimer flag_primerpair_edited.bed

	sed -i 's/MN908947.3/$sample/g' flag_primerpair_edited.bed

	fa-mask.py --regions flag_primerpair_edited.bed --fasta $fasta --out ${sample}_masked.fasta
	"""
}

