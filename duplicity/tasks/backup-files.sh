DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get settings
source ${DIR}/conf/settings.sh

# Usage backup-files incremental|full

for client_dir in ${source_dir}/*/; do
    client_name=$(basename ${client_dir})
    echo "Found client ${client_name}..."

    for project_dir in ${client_dir}/*/; do
        project_name=$(basename ${project_dir})
        bucket_dest=${bucket}/${client_name}/${project_name}
        echo "> ${project_name} -> ${bucket_dest}..."

        docker run --rm --user $UID \
                      -e "PASSPHRASE=${passphrase}" \
                      -v "${DIR}/../volumes/duplicity:/home/duplicity" \
                      -v ${source_dir}:/data:ro \
                      --name pixelcloud-duplicity \
                      pixelfordinner/duplicity \
                      duplicity $1 --allow-source-mismatch /data/${client_name}/${project_name} ${bucket_dest}

        echo "> ${project_name} -> ${bucket_dest} = Done."
    done
done
