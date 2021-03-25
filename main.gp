g = Mod(6, 682492462409094395392022581537473179285250139967739310024802121913471471);
A = 245036439927702828116237663546936021015004354074422410966568949608523157;



\\ Sur les bons conseils de Marc, on utilise plutot une map qu'un tableau
baby_giant(A,g,n) = {
  if(A==1,return(0));
  B = sqrtint(n)+1;
  my(baby);
  baby = Map();
  gp=g;
  \\ On créé la liste des puissances de g
  mapput( baby, 1, 0);
  mapput( baby, g, 1);
  for(i = 2 , B-1 , gp=gp*g; mapput(baby, gp, i));
  G = ( g^B )^(-1);
  retour=0;
  \\Puis on cherche les colisions 
  for(i=0, B+1,
  	   power = A*(G)^i;
  	   test = mapisdefined(baby, power, &retour);
  	   \\ Si la valeur est présente dans la liste, elle a été mise
	   \\ dans la variable retour.
 	   if( test == 1 , return( i*B + retour )));
}



\\ fonction auxiliaire appelée pour traiter le cas de chaque
\\ diviseur de n-1, un par un
inside_lemme_chinois(g, p, e, a)={
	somme=0;
	gi = g^(p^(e-1));
	for(i=0 , e-1 ,
		ai = (a*g^(-somme))^(p^(e-i-1));
		tmp = baby_giant(ai, gi, p);
		somme = somme + tmp*(p^i));
	somme;
}


\\ On utilise la décomposition de Pohlig Hellman vue en cours et le
\\ lemme chinois sur l'ordre du groupe
lemme_chinois(A,g,n,m)={
	m=factor(682492462409094395392022581537473179285250139967739310024802121913471471-1);
	k=0;
	tab=vector(4);
	mi=0;
	for(i=1, 4, \\ nombre de facteurs premiers de n
	pi=m[i,1]^m[i,2];
	mi=n/pi;
	apow=A^mi;
	gpow=g^mi;
	tab[i]=Mod(inside_lemme_chinois(gpow,m[i,1],m[i,2],lift(apow)),pi)
	);
	\\ chinese résout le système de lemme chinois contenu dans le
	\\ tableau tab
	\\ Ici c'est n+1, car l'appel se fait avec n-1
	sol=lift(Mod(lift(chinese(tab)),n+1));
	sol;
}



n=682492462409094395392022581537473179285250139967739310024802121913471471 ;
\\ n est premier
\\ On récupère la factorisation de n-1, qui est l'ordre du groupe:
\\m=factor(682492462409094395392022581537473179285250139967739310024802121913471471-1)
\\ On le fait finalement dans la fonction lemme_chinois, car sinon
\\ cela provoque l'affichage de la matrice des facteurs eet invalide le résultat.

\\ On prend A modulo n pour éviter de trop gros calculs
A=Mod(A,n);

a=lemme_chinois(A,g,n-1,m);
print(a);







