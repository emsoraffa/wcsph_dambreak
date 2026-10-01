#!/bin/bash
#SBATCH --account=share-ie-idi
#SBATCH --job-name=dambreak
#SBATCH --time=0-00:45:00

#SBATCH --partition=CPUQ
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

OUTPUT_DIR="$SLURM_SUBMIT_DIR/runs/$SLURM_JOB_ID"
mkdir -p "$OUTPUT_DIR/data"

exec >"$OUTPUT_DIR/output.log" 2>"$OUTPUT_DIR/error.log"

echo "Running from this directory: $SLURM_SUBMIT_DIR"
echo "Name of job: $SLURM_JOB_NAME"
echo "ID of job: $SLURM_JOB_ID"
echo "The job was run on these nodes: $SLURM_JOB_NODELIST"

module purge
module load intel-compilers/2024.2.0
module list

make -B CC=icx CFLAGS="-qopenmp -O2"
export OMP_NUM_THREADS="$SLURM_CPUS_PER_TASK"
export OMP_PLACES=cores
export OMP_PROC_BIND=spread

cd "$OUTPUT_DIR"
srun "$SLURM_SUBMIT_DIR/wcsph_dambreak"
