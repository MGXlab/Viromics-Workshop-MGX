from Bio import SeqIO
import numpy
import argparse
import os


def parse_args():
	parser = argparse.ArgumentParser(description='')

	requiredArgs = parser.add_argument_group("Required Arguments")

	requiredArgs.add_argument('-b', '--binning_file',
	dest='binning_file',
	required=True,
	help='bins_0.8-0.3-0.4.csv file from coconet'
	)
	
	requiredArgs.add_argument('-r', '--repr_fasta',
	dest='repr_fasta',
	required=True,
	help='fasta file with the representative scaffolds'
	)
	requiredArgs.add_argument('-o', '--out_dir',
	dest='out_dir',
	required=True,
	help='directory to store the fasta file for each bin '
	)






	return parser.parse_args()


def main():

	args = parse_args()

	# read bins .csv file
	csv = args.binning_file
	print(csv)

	with open(csv, "r") as fin:
		lines = [line.strip().split(",") for line in fin.readlines()]


	# store each bin_id with its contigs
	# first, init the dict
	bins_contigs = {line[1]:list() for line in lines}
	# the iterate the csv
	for line in lines:
		bins_contigs[line[1]].append(line[0])


	# read cross_assembly fasta
	cross_records = SeqIO.to_dict(SeqIO.parse(args.repr_fasta, "fasta"))


	# prepare the final list to write
	to_write = [["bin_id", "n_contigs", "total_len", "contigs"]]
	# get the largest n_bin. Used for padding with 0s
	pad_len = max([len(bin_id) for bin_id in bins_contigs])

	# set fasta outdir

	fasta_outdir = args.out_dir
	os.makedirs(args.out_dir, exist_ok=True)


	# iterate the bins and contigs while writing to .fasta file and the stats
	for bin_id, contigs in bins_contigs.items():
		# get contigs' records
		to_write_fasta = [cross_records[contig] for contig in contigs]


		# add bin_id at the beginning of the contig header
		for record in to_write_fasta:
			record.id = f"bin_{bin_id.zfill(pad_len)}||{record.id}"
			record.description = ""

		# get total length of the bin
		total_len = 0
		for contig in to_write_fasta:
			total_len += len(contig.seq)

		# add stats
		to_write.append([f"bin_{bin_id.zfill(pad_len)}", str(len(contigs)), str(total_len), ",".join(contigs)])

		# write bin .fasta file
		outfile = f"{fasta_outdir}/bin_{bin_id.zfill(pad_len)}.fasta"
		with open(outfile, "w") as fout:
			SeqIO.write(to_write_fasta, fout, "fasta")



	# write stats file
	with open(f"{fasta_outdir}/bin_stats.txt", "w") as fout:
		for line in to_write:
			fout.write("\t".join(line) + "\n")


if __name__ == "__main__":
	main()
