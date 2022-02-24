from Bio import SeqIO
import pandas as pd
import os, argparse, csv


def parse_args():
	parser = argparse.ArgumentParser(description='')

	requiredArgs = parser.add_argument_group("Required Arguments")

	requiredArgs.add_argument('-a', '--annot_table',
							   dest='annot_table',
							   required=True,
							   help=''
							   )
	requiredArgs.add_argument('-f', '--prots_bins_faa',
							   dest='prots_bins_faa',
							   required=True,
							   help=''
							   )
	requiredArgs.add_argument('-o', '--out_bins_terl_faa',
							   dest='out_bins_terl_faa',
							   required=True,
							   help=''
							   )

	return parser.parse_args()


def main():

	args = parse_args()

	# parse annotation table from day3
	annot_df = pd.read_csv(args.annot_table, header=0, sep="\t")
	# keep terminase clusters
	prots_terls = annot_df[(annot_df["protein"].str.contains("_NODE_")) &
							annot_df["annot"].str.contains("terminase") &
							~annot_df["annot"].str.contains("terminase small", na=False)]


	# read proteins from day3
	records = {record.id:record for record in SeqIO.parse(args.prots_bins_faa, "fasta")}

	to_write = [records[prot_terl] for prot_terl in prots_terls["protein"]]
	for record in to_write:
		print(record.id, len(record.seq))

	with open(args.out_bins_terl_faa, "w") as fout:
		SeqIO.write(to_write, fout, "fasta")


if __name__ == "__main__":
	main()
