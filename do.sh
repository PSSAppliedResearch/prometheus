t_start=`date +%s`

folder_name="$(basename $(pwd))"
image_file=prom.tar
zip_file=prom.tar.gz

case $1 in
  save)
    echo "Saving"
    echo "  saving images..."
    docker save $(docker-compose config|grep image:|awk '{print $2}') -o "${image_file}"
    echo "  zipping..."
    (cd .. && tar --exclude=docker-compose.override.yml --exclude=.* --exclude=.DS_Store -zcvf "${zip_file}" "${folder_name}")
    echo ""
    echo "  done - see: ../${zip_file}"
    echo "  to unzip with folder creation run:  tar -zxvf ${zip_file##*/}"
    ;;
  load)
    echo "Loading"
    echo ""
    echo "  loading images..."
    docker load -i "${image_file}"
    echo "  starting..."
    docker-compose up -d
    echo ""
    echo "done"
    ;;
  *)
    echo "Usage:"
    echo "  $0 export"
    echo "  $0 import"
    exit
    ;;
esac

t_end=`date +%s`
echo "Runtime: $((t_end-t_start)) sec"
