DIR=/gpfs/data/im-lab/nas40t2/natasha/rat_genomics/GEMMA/Il
mv $DIR/output $DIR/GRMs
mkdir completed_jobs
cd /gpfs/data/im-lab/nas40t2/Github/badger
/gpfs/data/im-lab/nas40t2/lab_software/miniconda/envs/ukb_env/bin/python src/badger.py \
-yaml_configuration_file $DIR/GEMMA_submission.yaml \
-parsimony 9
cd $DIR
for job in jobs/gemma*; do
    if  (($(qstat | wc -l) > 10000)); then
        sleep 10m
    fi
    qsub $job
    mv $job completed_jobs
done