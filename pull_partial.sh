remoteurl=$1
repolocalname="$2"
folder_desired="$2"
mkdir $repolocalname
pushd $repolocalname/
git init
echo "Adding remote. This will process the remote but not actually download the files..."
git remote add -f origin $remoteurl
git config core.sparseCheckout true
echo $folder_desired > .git/info/sparse-checkout
git pull origin master
echo "Moving $folder_desired/* to $repolocalname..."
popd
echo "Done."
