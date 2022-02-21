import argparse, glob, os
from Bio import SeqIO


def parse_args():
    parser = argparse.ArgumentParser(description='')

    requiredArgs = parser.add_argument_group("Required Arguments")

    requiredArgs.add_argument('-d', '--directory',
                               dest='directory',
                               required=True,
                               help='directory containing per sample assemblies. '
                               'It is important that each assembly folder is named '
                               'after the sample'
                               )

    return parser.parse_args()


def main():

    args = parse_args()

    # list all the assemblies
    assemblies = sorted(glob.glob(f"{args.directory}/F*/scaffolds.fasta"))

    # For each assembly, parse scaffolds.fasta
    for assembly in assemblies:
        sample_id = os.path.basename(os.path.dirname(assembly))

        # modify names of the scaffols and store in to_write list
        to_write = list()
        with open(assembly) as handle:
            for record in SeqIO.parse(handle, "fasta"):
                record.id = f"{sample_id}_{record.id}"
                to_write.append(record)

        # write records in to_write to .fasta file
        out_fasta = assembly.replace(".fasta", "_renamed.fasta")
        with open(out_fasta, "w") as fout:
            SeqIO.write(to_write, fout, "fasta")


if __name__ == "__main__":
    main()
