#!/bin/bash
#SBATCH --job-name=eOldFor			 # Job name
#SBATCH --partition=regular			 # Partition name
#SBATCH --ntasks=1				 # Number of tasks
#SBATCH --cpus-per-task=12
#SBATCH --mem=240G				 # Kopējā atmiņa
#SBATCH --time=50:00:00			 # Time limit, hrs:min:sec
#SBATCH --output=hpc_io/Outfiles/2024/EGVs/Egde_OldForests.out			 # Standard output and error log



set -euo pipefail

# Absolute paths (avoid ../ relative surprises)
PROJECT_ROOT="/home/hiqbiodiv"
IMG="${PROJECT_ROOT}/hiqbiodiv-container_20251016.sif"
WORKDIR="${PROJECT_ROOT}"
SCRIPT="${WORKDIR}/RScripts_final/egvs06_Edges_OldForests.R"

echo "Starting job"
echo "Date = $(date)"
echo "Node hostname = $(hostname -s)"
echo "Submit dir  = $(pwd)"

module load singularity

echo "Host check:"
ls -l "$SCRIPT" || { echo "Script not found on host: $SCRIPT"; exit 1; }

# ▼ Bind the project into the container and set the PWD inside the container
#   Bind to the same path to keep file references identical.
echo "Running in container..."
srun singularity exec \
  -B "${PROJECT_ROOT}:${PROJECT_ROOT}" \
  --pwd "${WORKDIR}" \
  "${IMG}" \
  Rscript --vanilla "${SCRIPT}"

echo "All done on $(date)"