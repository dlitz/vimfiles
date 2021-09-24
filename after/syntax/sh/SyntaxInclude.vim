" dlitz 2021

" Match embedded nftables in a shell script
" e.g.
"
"   nft -f - <<'EOF'
"   create table inet foo
"   # ...
"   EOF
"

call SyntaxRange#IncludeEx("matchgroup=shHereDoc01 start=\"nft -f - <<\\s*\\z([^ \\t|>]\\+\\)\" matchgroup=shHereDoc01 end=\"^\\z1\\s*$\"", 'nftables', '@shDblQuoteList')
call SyntaxRange#IncludeEx("matchgroup=shHereDoc05 start=\"nft -f - <<\\s*'\\z([^']\\+\\)'\" matchgroup=shHereDoc05 end=\"^\\z1\\s*$\"", 'nftables')
