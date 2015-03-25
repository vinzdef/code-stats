./scripts/cloc-coherent.sh > ./results/raw/stats.txt
./scripts/scraper.sh

git add . 
TOT_LINES=$(cat ./results/raw/past.txt)
git commit -m "$TOT_LINES"
git push origin master