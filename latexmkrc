$go_mode = 1;
$cleanup_fdb = 1;
$pdf_mode = 1;
# make a copy of the resulting PDF file (mainly for inspecting intermediate results)
$pdflatex = 'pdflatex -shell-escape %O %S && cp %D %B-copy.pdf';
$makeindex  = 'makeindex -s thesis-index.ist %O -o %D %S';
$preview_continuous_mode = 0;
$max_repeat = 9;
if($^O eq 'linux') {
	$pdf_previewer = 'okular `basename %S .pdf`-copy.pdf &';
	$pdf_update_method = 0;
} else {
	$pdf_previewer = 'open -a Skim %S';
	$pdf_update_method = 0;
}
@default_files = ("thesis.tex");

$recorder = 1;
$hash_calc_ignore_pattern{'xmpi'} = '^.*$';

$ENV{'TEXMFHOME'} = "$ENV{PWD}/texmf";
$ENV{'TEXMFVAR'} = "$ENV{PWD}/texmf";
$ENV{'TEXMFCONFIG'} = "$ENV{PWD}/texmf";

# next two lines should be done by make
#system("mktexlsr ./texmf");
#system("updmap");

# Make glossaries
add_cus_dep('glo', 'gls', 0, 'makeglo2gls');
sub makeglo2gls {
    system("makeindex -s '$_[0]'.ist -t '$_[0]'.glg -o '$_[0]'.gls '$_[0]'.glo");
}
add_cus_dep('acn', 'acr', 0, 'makeacn2acr');
sub makeacn2acr {
	system("makeindex -s '$_[0]'.ist -t '$_[0]'.alg -o '$_[0]'.acr '$_[0]'.acn");
}
add_cus_dep('acr', 'acn', 0, 'makeacr2acn');
sub makeacr2acn {
	system("makeindex -s '$_[0]'.ist -t '$_[0]'.alg -o '$_[0]'.acn '$_[0]'.acr");
}

push @generated_exts, 'glo';
push @generated_exts, 'gls';
push @generated_exts, 'glg';
push @generated_exts, 'acn';
push @generated_exts, 'acr';
push @generated_exts, 'ist';
push @generated_exts, 'alg';
push @generated_exts, 'bbl';
push @generated_exts, 'glono';
push @generated_exts, 'glsno';
