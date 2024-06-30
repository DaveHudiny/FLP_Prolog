# FLP projekt 2 - logický projekt

autor(david_hudak).
login(xhudak03).

Akademický rok -- 2022/2023

## Základní princip řešení
Veškerá implementace projektu je v souboru db.pl.

Princip je následující:
* 1. Načte se kostka (s pomocí kódu, který je převzat a upraven z e-learningu), a to do reprezentace, která je ve fórmátu 1:1 víceméně jako zápis kostky, tj. 9 seznamů reprezentující řádky, přičemž každá stěna  má v daném seznamu další vlastní seznam. Ukázka reprezentace vyřešené kostky je pro ukázku na řádku 106 souboru db.pl jako result (predikát myslím nikde nepoužívám, slouží pouze pro debugging a experimenty, například pro generování zrotovaných kostek v interaktivním prostředí).
* 2. Zbaví se vstupního bince (mezery, entery navíc apod.) s pomocí cube_damn_line_remover(). Na výstup se tiskne první iterace kostky (zadání).
* 3. Používám predikát solve_caller. Ten předpokládá, že Prolog funguje jako DFS, a tak omezuje pro volání solvu a volá solve pro danou hloubku. Pokud splní predikát do dané hloubky, tiskne výstup (kostky, kterými došel k řešení). Pokud ne, pak "volá" sebe sama s hloubkou o jedna větší. Volání solvu v tomto případě znamená provedení omezeného počtu otočení kostky v libovolném směru.

Co se týká implementace rotací, pak ty fungují v ose X jako predikáty rotate_right and rotate_left, kdy rotate_left je pouze inverzí rotate_right a rotate_right umožňuje vybrat, který řádek se otočí. Ostatní rotace (na osách Y a Z (doufám, že se jedná o správné označení)) jsou z poloviny ručně vypsány, z poloviny prováděny jako opačné operace již vypsaných rotací.

## Zdroje
Zpracování vstupu s úpravami přebírám ze vzoru v e-learningu.

## Prostředí
Projekt byl testován ve Swipl ve WSL a na Merlinovi.

## Testy a použití
Lehčí testy jsou hotové v řádu vteřin, obsahují pouze kratší vstupy (žádná, jedna a tři rotace). Horší (pet_rotaci.txt) kolem minuty.

Spouštění se předpokládá jako:
$ make
$ ./flp22-log < ./vstupy/jmeno_testu.txt > ./vystupy/jmeno_testu.txt

## Omezení
Žádné výrazné omezení by být v projektu nemělo (pokud není nějaká rotace blbě, snad ne), pouze nepoužívám rotace o 2 (3), a to z důvodu omezení možností, kudy prozkoumávat stavový prostor (vím, jak bych řešil, ale považuji to za nerozumné). Moje řešení tak obsahuje 18 rotací. 

