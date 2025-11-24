echo "commit and push to new repo"
git add -A
git commit -am "first commit"
git remote add origin git@github.com:andrewgbliss/$1.git
git push -u origin main