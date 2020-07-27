%% %% phdthesis.cls
%%
%%
%% Authors         : Philip Hölzenspies, Timon ter Braak, Jochem Rutgers
%% Created On      : Jun 17 2009
%% Version         : v0.03
%% 
%% Options :
%% - (final) , draft : change the layout of the text. Draft makes it easier to review the thesis and include comments.
%% 
%% Acknowledgment :
%% This class was derived largely from wolkotte_thesis_class.cls by Pascal Wolkotte
%%
%% Changes :
%% 17-06-09 (v0.01): Initial version
%% 26-02-13 (v0.02): Added subtitle option

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{src/template/phdthesis}[2013/06/04 v0.03]

\pdfminorversion=4% or 4 or 6...
\pdfcompresslevel=9% which is really slooow
\expandafter\global\expandafter\pdfpageattr\expandafter{\the\pdfpageattr /Group <</S /Transparency /I true /CS /DeviceRGB>>}
% if pfdminorversion > 4, then:
%\pdfobjcompresslevel=2% maybe reduce to 2; 3 might not be supported by all readers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Document class options
%%
\newif\ifdiscussion\discussiontrue
\newif\ifpublication\publicationfalse
\newif\ifabstractonly\abstractonlyfalse
\newif\ifdigital\digitalfalse
\newif\ifsinglechap\singlechapfalse
\newif\ifpress\pressfalse
\DeclareOption{digital}{\digitaltrue}
\DeclareOption{printable}{\digitalfalse}
\DeclareOption{discussion}{\discussiontrue\publicationfalse\abstractonlyfalse\digitalfalse}
\DeclareOption{publication}{\discussionfalse\publicationtrue\abstractonlyfalse\digitaltrue}
\DeclareOption{abstractonly}{\discussionfalse\publicationfalse\abstractonlytrue\digitalfalse}
\DeclareOption{press}{\presstrue\discussionfalse\publicationtrue\abstractonlyfalse\digitalfalse}
\DeclareOption{singlechap}{\singlechaptrue\digitaltrue}
\ProcessOptions

\ifdiscussion
	\PassOptionsToClass{showtrims,10pt,twoside,openright,draft}{memoir}
\fi
\ifpublication
	\PassOptionsToClass{10pt,twoside,openright,final}{memoir}
\fi
\ifabstractonly
	\PassOptionsToClass{11pt,oneside,final}{memoir}
	\PassOptionsToPackage{disable}{roomforthought}
\fi
\ifdigital
	\PassOptionsToPackage{digital}{flippage}
\fi
%\ifpress
%	\PassOptionsToPackage{gray}{xcolor}% converts all tikz colors to gray (but not included graphics)
%\else
	\PassOptionsToPackage{rgb}{xcolor}
%\fi

\LoadClass[onecolumn]{memoir}  % The grounding by this layout get to report

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paper size
%%
\def\golden{1.61803399}

\ifdiscussion
	\setstocksize{297mm}{210mm}
	\quarkmarks
\fi
\ifpublication
	\setstocksize{240mm}{170mm}
	\trimNone
	\showtrimsoff
\fi
\ifabstractonly
	\setstocksize{297mm}{210mm}
	\settrimmedsize{297mm}{210mm}{*}
	\trimNone
	\showtrimsoff
	\settypeblocksize{650pt}{32pc}{*}
	\setulmargins{*}{*}{\golden}        % lowermargin = 1.618 * topmargin
	\setlrmargins{*}{*}{1}
\else
	\settypeblocksize{538pt}{27pc}{*} % Includes 10pt correction (45 lines in total)
	\settrimmedsize{240mm}{170mm}{*}
	\setulmargins{*}{*}{\golden}        % lowermargin = 1.618 * topmargin
	\setlrmargins{*}{\lowermargin}{*} % foremargin = lowermargin, spinemargin approx topmargin
\fi

\setlength{\trimtop}{\stockheight}
\addtolength{\trimtop}{-\paperheight}
\setlength{\trimedge}{\stockwidth}
\addtolength{\trimedge}{-\paperwidth}
\settrims{.5\trimtop}{.5\trimedge}
\checkandfixthelayout

% Check vertical & horizontal alignment of left en right page

\newlength\gsab
\setlength\gsab{\foremargin}
\newlength\gsa
\setlength\gsa{\topmargin}
\newlength\gsb
\setlength\gsb{\gsab}
\addtolength\gsb{-\gsa}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Document properties and contents
%%

\RequirePackage[file=src/info]{thesisinfo}

\def\maketitle{\input{src/front/front-cover}}

\ifdiscussion\fi
\ifpublication\fi
\ifabstractonly
	\AtBeginDocument{\maketitle}
	\includeonly{src/front/abstract}
	\global\def\p@rt*#1{}
	\global\def\part{\@ifnextchar*\p@rt{\p@rt*}}
	\global\def\frontmatter{}
	\global\def\mainmatter{}
	\global\def\backmatter{}
\else
	\ifsinglechap\else
		\gappto\frontmatter{\maketitle\clearpage}
		\gappto\appendix{\setaachaptext[300]{appendix}}
	\fi
\fi

% assumes a \clearpage before, so current page is not outputted when nothing is written on it
\def\cleartofour{%
	\ifnumequal{((\value{sheetsequence}-1)/4)*4-(\value{sheetsequence}-1)}{0}{%
		% got actual sheet count
		\newwrite\sheetfile%
		\immediate\openout\sheetfile=sheetcount.aux%
		\pgfmathparse{int(\value{sheetsequence}-1)}%
		\immediate\write\sheetfile{\string\def\string\thesheetcount{\pgfmathresult}}%
		\immediate\closeout\sheetfile%
	}{%
		% add empty page
		\thispagestyle{empty}\mbox{}\clearpage%
		\cleartofour%
	}%
}
\def\insertart#1{%
	\IfFileExists{figures/art/art_#1.png}{%
		\thispagestyle{empty}%
		\tikz[overlay,remember picture]{
			\node[anchor=center,inner sep=0,outer sep=0] at ($(current page.center)+(\trimedge,\trimtop)$) {%
				\includegraphics[width=\paperwidth]{figures/art/art_#1.png}%
			};
		}\index{So long}%
		\clearpage%
	}{}%
}
\AtEndDocument{%
	\ifpress%
		\insertart{press}%
		% fill pages up to multiple of 4
		\expandafter\cleartofour%
	\else%
		\ifabstractonly\else%
			\ifsinglechap\else%
				\insertart{digital}%
				\include{src/back/back-cover}%
			\fi%
		\fi%
	\fi%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load packages
%%

\RequirePackage{fixltx2e}[2006/09/13]
\RequirePackage{etex}             	% Extended register set
\RequirePackage{etoolbox}
\RequirePackage[dutch,english]{babel}
\RequirePackage[utf8x]{inputenc}  	% Typing accented characters explicitly
\RequirePackage{xkeyval}          	% Pass options to commands
\RequirePackage[table]{xcolor}
\RequirePackage{colortbl,booktabs,multicol,longtable,collcell,ctable,multirow}
\RequirePackage{url,color,calc,graphicx,ccicons,rotating}
\RequirePackage{ifthen,ragged2e,textcase,environ,lipsum,ifempty,xth}
\RequirePackage{pdfpages}
\RequirePackage{flippage}
%\RequirePackage{amsfonts,amssymb,stmaryrd,amsmath}
\RequirePackage{varioref}% don't use without cleveref
\RequirePackage{roomforthought}

\ifdiscussion
	\RequirePackage[colorinlistoftodos,textsize=footnotesize]{todonotes}
\else
	\RequirePackage[disable]{todonotes}
\fi
\apptocmd{\listoftodos}{\clearpage}{}{}
\ifsinglechap\renewcommand{\listoftodos}[1][]{}\fi
\renewcommand{\todo}[2][]{\@bsphack\@todo[#1]{#2}\@esphack\xspace}

\RequirePackage{datetime}
\def\thedate\@date

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Symbols and Units
% Note: siunitx also provides table formatting options
% \begin{tabular}{S[table-format=XX.YY]}
%%

\RequirePackage{pgf}
\RequirePackage[binary-units]{siunitx}
\sisetup{
	detect-all=true,
	per-mode=symbol,
	group-digits=true,
    group-separator={\,},
	exponent-product=\cdot,
}
\DeclareSIPrefix\Kilo{K}{3}
%\DeclareSIUnit\Hertz{Hz}
\SendSettingsToPgf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonts and micro typography
%%

\RequirePackage[protrusion=true,expansion=true,stretch=10,shrink=10,babel]{microtype}
%\def\microtypesetup#1{}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern,stmaryrd,textcomp}\def\mathds{\mathbb}%,dsfont}
\RequirePackage{MyriadPro}
\RequirePackage[fullfamily,textosf,mathlf,minionint,footnotefigures]{MinionPro}
\renewcommand\sfdefault{MyriadPro-LF}
%\RequirePackage{tgcursor}% courier-like
\RequirePackage[scaled=.84]{luximono}% another type writer font

\let\oldnormalfont\normalfont
\def\normalfont{\oldnormalfont\figureversion{text,prop}}
\def\bodyfont{\normalfont\normalsize}
\bodyfont

%\RequirePackage{pifont}
\input glyphtounicode
\pdfgentounicode=1
\allowdisplaybreaks[1]
\PreloadUnicodePage{0}

\urlstyle{tt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bibliography
% - redefine the labels for multibib (http://www.helgefjell.de/latexitem.php?name=bibtex&language=en)
% - load before hyperref
%%

\RequirePackage[sort&compress,numbers,square,comma]{natbib}
\RequirePackage[resetlabels]{multibib}

\def\NAT@spacechar{~}% prevent break in \citet's Author~[1]

\newcites{pub}{List of Publications}
\nocitepub{*}
\def\citenumfont{\figureversion{text,prop}}
\def\bibfont{\small}

\newcommand\biblabelprefix{}
\newdimen\b@belwidth
\newdimen\b@b@lwidth
\newcommand\setbabelwidth[1]{{%
	\newbox\tmp
	\setbox\tmp=\hbox{#1}%
	\global\b@belwidth=\wd\tmp
}}
\renewcommand\@biblabel[1]{{%
	\newbox\tmp
	\setbox\tmp=\hbox{#1}%
	\@tempdima=\wd\tmp%
	\@tempdimb=\m@ne\@tempdima
	\advance\@tempdimb by \b@belwidth
	\rule{\@tempdimb}{0pt}[\biblabelprefix#1]%
}}
\def\@bibitem#1{%
	\item\if@filesw
		\immediate\write\@auxout{\string\bibcite{#1}{\biblabelprefix\the\value{\@listctr}}}%
	\fi\ignorespaces}

\providecommand*{\BibTeX}{\textsc{Bib}\TeX{}\xspace}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup hyperref for PDF files
%%

\PassOptionsToPackage{pagebackref}{hyperref}

\ifpress
	\PassOptionsToPackage{x}{mypdfx}
	\PassOptionsToPackage{
		pdfdisplaydoctitle=true,
		pdfpagelayout=TwoColumnRight,
		pdfstartview=FitH,
		}{hyperref}
\else
	\PassOptionsToPackage{
		final,
		bookmarks=true,
		bookmarksnumbered=true,
		bookmarksopen=true,
		bookmarksopenlevel=1,
		pdfusetitle,
		hypertexnames=true,
		breaklinks=true,
		pdfdisplaydoctitle=true,
		pdfduplex=DuplexFlipLongEdge,
		}{hyperref}
	\ifabstractonly
		\PassOptionsToPackage{
			pdfpagemode=UseNone,
			pdfstartview=FitH,
%			pdfremotestartview=Fit,
			pdfpagelayout=OneColumn,
		}{hyperref}
	\else
		\PassOptionsToPackage{
			pdfpagemode=UseOutlines,
			pdfstartview=FitH,
%			pdfremotestartview=Fit,
		}{hyperref}
		\ifdiscussion
			\PassOptionsToPackage{
				pdfpagelayout=TwoColumnRight,
			}{hyperref}
		\else
			\PassOptionsToPackage{
				pdfpagelayout=OneColumn,
			}{hyperref}
		\fi
	\fi
\fi

\RequirePackage{mypdfx,everyshi}
\ifdiscussion\AfterPreamble{\EveryShipout{\pdfsetpagebox{TrimBox}{\the\trimedge}{\the\trimtop}{\the\paperwidth}{\the\paperheight}}}\fi
\RequirePackage{refcount}
\RequirePackage{hyperref}
\RequirePackage{bookmark}

% back reference format
\renewcommand*{\backref}[1]{}
\renewcommand*{\backrefalt}[4]{%
\ifcase #1 %
	% case: not cited
	(Not cited).
\or
	% case: cited on exactly one page
	(Cited on page~#2).%
\else
	% case: cited on multiple pages
	(Cited on pages~#2).
\fi}

\hypersetup{
	pdfborder={0 0 0},
	colorlinks=false,
%	linkbordercolor={0.46 0.55 0.67},	% cover blue
%	urlbordercolor={0.58 0.50 0.35},	% cover brown
%	citebordercolor ={0.86 0.84 0.12}	% cover yellow
	%linkbordercolor={0.7 0.7 1},
	%urlbordercolor ={0.6 0.6 1},
	%citebordercolor={0.5 0.5 1}
}

\newcommand*{\doi}[1]{\href{http://dx.doi.org/\detokenize{#1}}{doi: \detokenize{#1}}}

%% ?
\let\figref\fref % use \figref for memoirs \fref
\let\fref\relax  % "undefine" \fref

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Glossaries
% - Load after hyperref
%%
\RequirePackage{needspace}
\let\printglossary\relax
\RequirePackage[toc,acronym,smallcaps,nonumberlist,hyperfirst=false,shortcuts]{glossaries}
\RequirePackage{wordfonts}

\newcommand{\ndim}[1]{{\figureversion{text,prop}#1\textsc{d}}}

\ifdef{\setglossarystyle}{}{\def\setglossarystyle{\glossarystyle}}

\newglossarystyle{mylistgroup}{
	\setglossarystyle{listgroup}
	\appto\glossaryheader{\itemsep0pt\parskip0pt\parsep0pt}
	\appto\glossarypreamble{\small}
	\renewcommand*{\glsgroupskip}{\vspace{-.5em \@plus 3em}}
	\newcommand*{\glsgrouptitleitem}[1]{\raisebox{-\baselinestretch\baselineskip}[0pt][0pt]{\parbox{1.2em}{\centering\strut\normalsize\bfseries\color{nicegray}\glsgetgrouptitle{##1}}}}
	\renewcommand*{\glsgroupheading}[1]{\needspace{2\baselineskip}\item[\glsgrouptitleitem{##1}]{}}
	\renewcommand*{\glssymbolsgroupname}{*}
	% TeXLive 2012
	\renewcommand*{\glossaryentryfield}[5]{%
		\item[\mdseries\hspace{3em}\parbox{10ex}{\strut\glsentryitem{##1}\glstarget{##1}{##2}\hfill}] ##3%
			\hfill{\color{niceblack}\textit{\glsentryuseri{##1}}}}
	\ifdef{\glossentry}{
		% TeXLive 2013
		\renewcommand*{\glossentry}[2]{\glossaryentryfield{##1}{\glossentryname{##1}}{\glossentrydesc{##1}}{\glossentrysymbol{##1}}{##2}}
	}{}
}
\setglossarystyle{mylistgroup}

%\renewcommand{\glspostdescription}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graphics & Figures
% - load after hyperref (clickable at least)
%%

\RequirePackage{tikz,pgfplots,pgfplotstable,tikzcontour}
\usetikzlibrary{positioning,plotmarks,patterns,petri,fit,arrows,shadows,calc,shapes,matrix}
\ifdigital
	\usepgfplotslibrary{clickable}
	\pgfplotsset{
		every axis/.append style={
			clickable coords,
		},
	}
\fi
\pgfdeclarelayer{deepground}
\pgfdeclarelayer{background}
\pgfdeclarelayer{foreground}
\RequirePackage{pgf-umlsd,pgfplots}
\pgfplotsset{compat=1.5.1}% TeXLive 2012's version

\providecommand*{\TikZ}{Ti\textit{k}Z\xspace}

\RequirePackage{ean13isbn}

\setupctable{
	captionskip=-1ex,
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithms and listings and math
% - load after hyperref
%%

\newtheorem{definition}{Definition}[chapter]
\newtheorem{ruledef}{Rule}[chapter]

\RequirePackage[ruled,vlined,linesnumbered,inoutnumbered]{algorithm2e}%\dontprintsemicolon
%\SetDataSty{textit}
%\SetKwSty{textsc}
%\SetCommentSty{textrm}
%\def\textfs#1{{\texorpdfstring{\fontsize{9pt}{9.9pt}\selectfont\sffamily #1}{#1}}}
%\SetFuncSty{textfs}
%\SetProcNameSty{texttt}
\SetFuncSty{funfont}
\SetArgSty{textup}
\def\phdalgnlfont#1{\tiny\figureversion{text,tab}#1}
\SetNlSty{phdalgnlfont}{}{}
\SetAlgoNlRelativeSize{0}

\RequirePackage{listings}
\RequirePackage[frame,depgraph]{parcodes}
\lstloadlanguages{C++}
\lstset{
	frame=tb,captionpos=b,
	language={},breaklines=true,tabsize=4,
	numbers=left,numberstyle=\tiny\figureversion{text,tab},numbersep=6pt,xleftmargin=12pt,firstnumber=1,
	escapechar=\$,
	basicstyle=\ttfamily,
}
\@ifpackageloaded{tgcursor}{\lstset{basewidth=1.5ex}}{}

% standard language: C++
\lstdefinestyle{code}{
	language=C++,
	morekeywords={typeof},
	stringstyle={\color{lst string color}},
	% special functions
	morekeywords=[2]{acquire,release,fence,FENCE,flush,FLUSH,entry_x,exit_x,entry_ro,exit_ro,entry_w,exit_w},
	keywordstyle=[2]\itshape,
	% constants/macro/template arguments
	directivestyle=\bfseries\color{lst macro color},%\color{blue!40!black},
	morekeywords=[3]{NULL},
	keywordstyle=[3]\bfseries\color{lst macro color},%\color{blue!40!black},
	% variables
	keywordstyle=[4]\color{lst variable color},%\color{red!40!blue!90!black},
	% types
	keywordstyle=[5]\color{lst type color},%\color{red!50!black},
}
\pgfkeys{
	lst/.cd,
	special/.code={\lstset{morekeywords=[2]{#1}}},
	macro/.code={\lstset{morekeywords=[3]{#1}}},
	template/.code={\lstset{morekeywords=[3]{#1}}},
	constant/.code={\lstset{morekeywords=[3]{#1}}},
	variable/.code={\lstset{morekeywords=[4]{#1}}},
	type/.code={\lstset{morekeywords=[5]{#1}}},
	float/.code={\lstset{float}},
	caption/.code={\lstset{caption={#1}}},
	label/.code={\lstset{label={#1}}},
	lst/.code={\lstset{#1}},
}
\newcommand{\lstid}[1]{\pgfkeys{lst/.cd,#1}}
% nice inline formatted code, starred version allows setting keyword types and keeps lst settings for subsequent \lstinlines
\protected\def\lsticode{\@ifstar\lsticode@@\lsticode@}
\newcommand{\lsticode@}[1][]{\lstinline[style=code,#1]}
\newcommand{\lsticode@@}[1][]{\lstid{lst={style=code},#1}\lstinline}
% nice formatted code environment
\lstnewenvironment{lstcode}[1][]{%
	\lstset{%
		style=code,%
		basicstyle=\footnotesize\ttfamily,%
		commentstyle=\itshape\color{lst comment color},%\color{green!50!black},%
	}%
	\lstid{#1}%
}{}

%Aligning math stuff in environments that don't like align(*) environments (like algorithm):
%Usage: \withphantom{foo}{bar} will set bar (in mm) with the width of foo.
\def\withphantom#1#2{\ensuremath{%
	\newdimen\phantomwidth
	\setbox\z@\hbox{\ensuremath{#2}}%
	\phantomwidth=-\wd\z@%
	\ensuremath{#2\hspace{\phantomwidth}\hphantom{#1}}%
}}
\def\lnref#1#2{lines \ref{#1}--\ref{#2}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include water mark
%%
\ifdigital
  \RequirePackage{eso-pic}
%  \usepackage[absolute]{textpos}
%  \setlength{\TPHorizModule}{1cm}
%  \setlength{\TPVertModule}{1cm}
\fi

\def\everypage@{}
\newcommand{\EveryPage}[1]{\appto\everypage@{#1}}
\ifdiscussion
%	\EveryPage{\outlinetextblock}% see portablefig package
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Index
%%

\makeindex
\twocolindex
\indexintoc
\hideindexmarks

% use in text and add to index
\newcommand{\ix}[2][]{#2{\edef\ixtext{\ifstrempty{#1}{#2}{#1}}\expandafter\index\expandafter{\ixtext}}}
% add long acr -> see short acr
\newcommand*{\ixseeac}[2][]{
	\edef\ixtext{%
		\ifstrempty{#1}{%
			\glsentrylong{#2}@\acl{#2}|see\string{\acs{#2}\string}%
		}{%
			#1%
		}%
	}
	\expandafter\index\expandafter{\ixtext}%
}
% use acronym in text and add to index
\newcommand*{\acix}[2][]{%
	\ifglsused{#2}{%
		% used before, add index
		\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\ac{#2}}%
	}{%
		% not used before, this will trigger the full format, which adds the index automatically
		\ac{#2}%
	}%
}
% add a sub-entry to an index entry, which was previously added to the index using \acix
% \subacix[optional formatting of subentry]{identifier of previously used \acix{...} parent entry}{subentry text}
\newcommand*{\subacix}[3][]{%
	\edef\ixtext{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}!\ifstrempty{#1}{#3}{#1}}%
	\expandafter\ix\expandafter[\ixtext]{#3}%
}
\newcommand*{\acpix}[2][]{\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\acp{#2}}}
\newcommand*{\acfix}[2][]{\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\acf{#2}}}
\newcommand*{\aclix}[2][]{\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\acl{#2}}}
\newcommand*{\aclpix}[2][]{\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\aclp{#2}}}
\newcommand*{\acsix}[2][]{\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\acs{#2}}}
\newcommand*{\acspix}[2][]{\edef\ixtext{\ifstrempty{#1}{\glsentryshort{#2}@\acronymfont{\glsentryshort{#2}}}{#1}}\expandafter\ix\expandafter[\ixtext]{\acsp{#2}}}

\newcommand{\indexheading}[1]{\vspace{0pt \@plus 2.5em}\parbox{.7639\linewidth}{\centering\normalsize\bfseries\color{nicegray}#1}\nopagebreak\vspace{1ex plus .5ex minus .25ex}\small}
\newcommand{\keyinsight}[1]{\index{key insight}\emph{#1}\xspace}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Page Heading
%%
\copypagestyle{thesis}{headings}
\makeheadposition{thesis}{flushright}{flushleft}{flushright}{flushleft}
\makerunningwidth{thesis}{1.235\textwidth}
\makeoddhead{thesis}{}{}{\ifabstractonly\else\everypage@\input{src/template/recto-head}\fi}
\makeevenhead{thesis}{\ifabstractonly\else\everypage@\input{src/template/verso-head}\fi}{}{}
\makeoddfoot{thesis}{}{}{}
\makeevenfoot{thesis}{}{}{}
\makepsmarks{thesis}{
	\nouppercaseheads
	\createmark{chapter}{both}{shownumber}{\@chapapp\ }{\ --\ }
	\createmark{section}{right}{shownumber}{}{\ --\ }
	\createmark{subsection}{right}{shownumber}{}{\ --\ }
	\createplainmark{toc}{both}{\contentsname}
	\createplainmark{lof}{both}{\listfigurename}
	\createplainmark{lot}{both}{\listtablename}
	\createplainmark{bib}{both}{\bibname}
	\createplainmark{index}{both}{\indexname}
	\createplainmark{acronym}{both}{\glossaryname} %% Fix with glossaries
}
\AtBeginDocument{\pagestyle{thesis}}

\copypagestyle{onlynum}{thesis}
\makeevenhead{onlynum}{}{}{\def\leftmark{}\everypage@\input{src/template/verso-head}}
\makeoddhead{onlynum}{}{}{\def\rightmark{}\everypage@\input{src/template/recto-head}}
\def\thoughtspagestyle{onlynum}

\appto\frontmatter{%
	\aliaspagestyle{cleared}{onlynum}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Page number in middle of page
%%%
\makeevenfoot{plain}{}{%
%	\begin{tikzpicture}[inner sep=0pt,niceblack,line cap=round]
%		\figureversion{lining,proportional}
%		\path[use as bounding box] (.5pt,0) rectangle ++(-1pt,-12pt);
%		\draw[semithick] (-8pt,-\gsb+4pt) -- ++(16pt,0);
%		\node[anchor=north] at (0,-\gsb) {\textbf\thepage};
%	\end{tikzpicture}
}{}
\makeoddfoot{plain}{}{%
%	\begin{tikzpicture}[inner sep=0pt,niceblack,line cap=round]
%		\figureversion{lining,proportional}
%		\path[use as bounding box] (.5pt,0) rectangle ++(-1pt,-12pt);
%		\draw[semithick] (-8pt,-\gsb+4pt) -- ++(16pt,0);
%		\node[anchor=north] at (0,-\gsb) {\textbf\thepage};
%	\end{tikzpicture}
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chapter style
%%
\newenvironment{custommargins}[2]%
  {\addtolength{\leftskip}{#1}\addtolength{\rightskip}{#2}}{\par}

\makechapterstyle{thesis}{
  \setlength{\beforechapskip}{15pt}
  \setlength{\midchapskip}{2cm}
  \renewcommand\chaptitlefont{\normalfont\Huge\bfseries\scshape\color{niceblack}}
  \renewcommand\chapternamenum{}
  \renewcommand\printchaptername{}
  \renewcommand*{\printchapternum}{\everypage@\input{src/template/chaptermark}\suppressfloats}
  \renewcommand*{\printchapternonum}{\def\nonumchap{}\everypage@\input{src/template/chaptermark}\def\nonumchap{\undefined}}
  \renewcommand\afterchapternum{\par\vskip\midchapskip}
  \renewcommand\printchaptertitle[1]{\chaptitlefont\nohyphenation\Centering\sloppy ##1\par}
}
\chapterstyle{thesis}

\newcommand{\setaachaptext}[2][100]{%
	\def\aachaptextrepeat{#1}%
	\def\aachaptext{#2}%
}
\setaachaptext[300]{chapter}

%\makechapterstyle{nochapter}{
%  \setlength{\beforechapskip}{15pt}
%  \renewcommand\chaptitlefont{\normalfont\Huge\bfseries\scshape\color{niceblack}}
%  \renewcommand\chapternamenum{}
%  \renewcommand\printchaptername{}
%  \renewcommand*{\printchapternum}{\input{src/template/chaptermark}}
%%    \marginpar{
%%    \resizebox{2.5cm}{!}{\input{chaptermark}}%
%%    }%
%%    \vspace*{4.75cm}%
%%  }
%  \renewcommand\afterchapternum{\par\vskip\midchapskip}
%  \renewcommand\printchaptertitle[1]{\chaptitlefont\RaggedLeft ##1\par}
%}

\def\startchapterhook{}
\appto\startchapterhook{\gdef\includedchapter{did include}}
\appto\startchapterhook{\bodyfont}
\preto\chapter{\startchapterhook}

\newcounter{includedchapters}

\def\ifpageisodd{%
	\strictpagecheck%
	\checkoddpage%
	\ifoddpage%
		\expandafter\@firstoftwo%
	\else%
		\expandafter\@secondoftwo%
	\fi%
}
\def\ifpageisoddlazy#1#2{%
	\ifnumodd{\value{page}}{#1}{#2}%
}

% does not clear when we are already on recto/verso (regardless whether there is already something on the current page)
\def\cleartillrecto{\ifpageisoddlazy{}{\cleartorecto}}
\def\cleartillverso{\ifpageisoddlazy{\cleartoverso}{}}

% assumes \clearpage before
\def\fillchaptertillverso{\ifpageisoddlazy{\roomforthought\clearpage}{}}

\ifabstractonly\else
	% assumes \clearpage before
	\preto\mainmatter{\cleartillverso\thispagestyle{cleared}\mbox{}}
\fi
\ifsinglechap
	% this is page 1, but all other aux files end on an even page
	\appto\@memmain{\thispagestyle{cleared}(dummy page)}
\fi

% like \include, but specifically tailored to including chapter files
% Most important feature: defines \AtEndChapter{} to execute something at the end of the file inclusion,
% and \AtEndChapter*{} to add something when the file is not included at all (because of \includeonly).
% \chapdef is like \gdef (without additional arguments), but also puts the def in the aux file.
% NB: during the first pdflatex run, the \chapdef'ed command might not be available yet in successive chapters.
\newcommand{\includechapter}[1]{%
	\begingroup%
		\stepcounter{includedchapters}
		\ifnumless{\value{checkoddpage}}{\value{includedchapters}*1000}{
			\setcounter{checkoddpage}{\value{includedchapters}*1000}}{}
		% hooks
		\gdef\atendchapterhook{}%
		\gdef\atendchapterauxhook{}%
		\ifcsdef{atendchapterauxhook@#1}{}{\csgdef{atendchapterauxhook@#1}{}}%
		\def\AtEndChapter@##1{\gappto\atendchapterhook{##1}}%
		\immediate\write\@auxout{\string\csgdef{atendchapterauxhook@#1}{}}%
		\def\AtEndChapter@aux##1{%
			\immediate\write\@auxout{%
				\string\csgappto{atendchapterauxhook@#1}{##1}
			}}%
		\def\AtEndChapter{\@ifstar\AtEndChapter@aux\AtEndChapter@}%
		\def\chapdef##1##2{%
			\gdef##1{##2}%
			\AtEndChapter*{\string\gdef\string##1\string{##1\string}}%
		}%
		% detect whether chapter was included
		\global\undef\includedchapter%
		% fix for ifoddpage package: counter value is not saved during \include
%		\ifdef{\checkoddpage}{\appto\checkoddpage{\AtEndChapter*{\string\setcounter{checkoddpage}{\thecheckoddpage}}}}{}%
		% make sure chapter ends in writing something in odd page (but only for main matter and appendices)
		\if@mainmatter%
			\pretocmd{\@writeckpt}{\fillchaptertillverso}{}{\ClassError{phdthesis}{Cannot add hook to \string\include...}{}}%
		\fi%
		% included chapter
		\bodyfont%
		\include{#1}%
		% execute hooks
		\ifdef{\includedchapter}{%
			\atendchapterhook%
		}{%
			\csname atendchapterauxhook@#1\endcsname%
		}%
		\ifnumless{\value{checkoddpage}}{\value{includedchapters}*1000+900}{
			\setcounter{checkoddpage}{\value{includedchapters}*1000+900}}{}
	\endgroup%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paragraph dimensions
%%
\setlength\parindent{0ex}
\abnormalparskip{.5\baselineskip \@plus.1\baselineskip \@minus.1\baselineskip}

%Use one of the three commands to change the underfull/overfull behaviour
% (controls the allowed spacing between words, see memoir manual)
%\sloppy
%\midsloppy 
%\fussy

\newlength\specialparindent
\setlength\specialparindent{10mm}

\newenvironment{spacious}{%
	\vspace{0pt \@plus.2\baselineskip}\par\noindent%
}{%
	\vspace{0pt \@plus.2\baselineskip}%
}

\newenvironment{describe}[1]{%
	\needspace{2\baselineskip}%
	\begin{spacious}%
		\emph{\ix[#1|hyperbold]{#1}}
		\vspace{-\parskip}\begin{adjustwidth}{\specialparindent}{}%
		\itshape%
}{%
	\end{adjustwidth}%
	\end{spacious}%
}

\newenvironment{emphasize}{%
	\begin{spacious}%
	\begin{adjustwidth}{\specialparindent}{}%
	\begin{em}%
}{%
	\end{em}%
	\end{adjustwidth}%
	\end{spacious}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chapter's abstract style
%%

\abstractrunin % Places the abstract word before the text else it is place above and aligned with \absnamepos

% 'Abstract' same formatting as float caption
\setlength{\abstitleskip}{0pt}
\renewcommand{\abstractnamefont}{\normalfont\small\scshape}
\abslabeldelim{\;--\;}

\setlength{\absleftindent}{\specialparindent}
\setlength{\absrightindent}{\specialparindent}
\renewcommand{\abstracttextfont}{\normalfont\small\itshape}

\let\oldendabstract\endabstract
\def\endabstract{%
  \oldendabstract
	\fancybreak{\rule{0pt}{2.5\onelineskip}\textcolor{nicegray}{\rule[1.5\onelineskip]{.618\textwidth}{0.5pt}}}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sections style
%%
\setsecheadstyle{\RaggedRight\Large\scshape}
\setsubsecheadstyle{\RaggedRight\scshape}
\setsubsubsecheadstyle{\sethangfrom{\noindent ##1}\RaggedRight\itshape}
\def\secnumformat#1{\parbox[b]{.75\specialparindent}{\csname the#1\endcsname\hfill}\hspace{.25\specialparindent}}
\setsecnumformat{\secnumformat{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Footnote style

\def\selfcite#1{{\ignorespaces\setcitestyle{open={[\thesisauthorinitials:}}\citepub{#1}\ignorespaces\setcitestyle{open={[}}}}

%Instead of footnote overruns (page 275 Memoir manual)
%\renewcommand*{\footfudgefiddle}{70}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Caption style
%%
\captionnamefont{\scshape\small}
\captiontitlefont{\small}
%\captionstyle{\centerlastline}
%\captionwidth{\linewidth}
%\normalcaptionwidth
%\normalcaption
\captiondelim{\;--\;}
%\newcommand{\conditions}[1]{\emph{Measurement conditions:} #1}

%\addtolength\textfloatsep{-\onelineskip} %TODO check this 

\loosesubcaptions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures
%%
\newsubfloat{figure}
\ifpress\else
	% Make sure that the hyperlink to a figure with the caption at the bottom refers to the top of the float.
	\RequirePackage[figure]{hypcap}
\fi
\RequirePackage{portablefig}

%\colorlet{chart color 1}{niceblue}			
\definecolor{chart color 1}{hsb}{0.59,1.00,0.70}	% soft blue
\colorlet{niceblue}{chart color 1}
\definecolor{chart color 2}{hsb}{0.29,1.00,0.60}	% light green
\definecolor{chart color 3}{hsb}{0.12,1.00,0.90}	% dark yellow
\definecolor{chart color 4}{hsb}{0.03,1.00,0.85}	% soft red
\definecolor{chart color 5}{hsb}{0.76,0.90,0.95}	% purple
\pgfplotscreateplotcyclelist{thesis}{%
	chart color 1,solid,mark=+\\%
	chart color 2,solid,mark=x\\%
	chart color 3,solid,mark=triangle\\%
	chart color 4,solid,mark=o\\%
	chart color 5,solid,mark=square,mark options={scale=.75}\\%
}

\definecolor{bar color 1}{hsb}{0.57,1.00,0.50}
\definecolor{bar color 2}{hsb}{0.28,0.85,0.74}
\definecolor{bar color 3}{hsb}{0.15,0.70,1.00}
\definecolor{bar color 4}{hsb}{0.05,1.00,0.70}
\definecolor{bar color 5}{hsb}{0.77,0.50,1.00}
\tikzset{
	bar style 1/.style={fill=bar color 1,draw},
	bar style 2/.style={fill=bar color 2,draw},
	bar style 3/.style={fill=bar color 3,draw},
	bar style 4/.style={fill=bar color 4,draw},
	bar style 5/.style={fill=bar color 5,draw},
}
\colorlet{lst comment color}{chart color 2}
\colorlet{lst string color}{chart color 3!50!black}
\colorlet{lst macro color}{chart color 1}
\colorlet{lst variable color}{chart color 5}
\colorlet{lst type color}{chart color 4}

\pgfplotsset{
	/pgf/number format/set thousands separator={\,}, % corresponds to siunitx
	every axis/.append style={
		axis x line=bottom,
		axis y line=left,
		enlarge x limits={value=0.05,upper},
		enlarge y limits={value=0.05,upper},
		grid style={dash pattern=on \pgflinewidth off \golden\pgflinewidth},
		ticks=both,
		cycle list name=thesis,
		every tick label/.append style={inner sep=.3333em},
	},
	ylabel near ticks,
	ylabel style={inner sep=0,outer sep=0,yshift=.5ex},
}

\tikzset{
	>=latex,
}

\portablefigset{
	every portable fig/.append style={
		fontA=\small,
		pgfplots={
			every axis/.append style={
				tick label style={font=\portablefigfontB\figureversion{tab,lining}},
				axis line style={->},
				max space between ticks=25,
			},
			every axis legend/.append style={
				draw=nicegray,
			}
		},
	},
}

\let\oldfigure\figure
\def\figure{%
	\begingroup%
	\sisetup{group-minimum-digits=4}%
	\figureversion{text,tab}%
	\oldfigure%
}
\let\oldendfigure\endfigure
\def\endfigure{\oldendfigure\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tables
% - Use small font and correct figure style for numbers
%%
\newsubfloat{table}
\RequirePackage{tabbars}

\let\phd@oldtabular\tabular
\let\phd@oldendtabular\endtabular
\def\tabular{%
	\begingroup%
		\small%
		\sisetup{group-minimum-digits=4,detect-none=true,table-alignment=center}%
		\figureversion{lining,tabular}%
		\DeclareRobustCommand{\hdrR}[2][\linewidth]{%
			\hfil\tikz[baseline=0]{\node[text ragged left,max text width=##1,inner sep=0,outer sep=0,anchor=center] at (0,.5ex) {##2};}}%
		\DeclareRobustCommand{\hdr}[2][\linewidth]{%
			\hfil\tikz[baseline=0]{\node[wrap text,max text width=##1,inner sep=0,outer sep=0,anchor=center] (n) at (0,.5ex) {##2};}\hfil}%
		\DeclareRobustCommand{\hdrL}[2][\linewidth]{%
			\tikz[baseline=0]{\node[text ragged right,max text width=##1,inner sep=0,outer sep=0,anchor=center] (n) at (0,.5ex) {##2};}\hfil}%
		\ifdef{\tmark}{%
			% ctables's default \tmark, wrapped inside a 0-height raisebox
			\renewcommand{\tmark}[1][a]{\raisebox{0pt}[0pt]{\hbox{\textsuperscript{\normalfont\textit{##1}}}}}%
		}{}%
		\phd@oldtabular%
}
\def\endtabular{%
		\phd@oldendtabular%
	\endgroup%
}

\newcommand{\tbl}[2]{\caption{#1}\begin{center}#2\end{center}}

\settabbarstyle{1}{bar style 5/.try}
\settabbarstyle{2}{bar style 4/.try}
\settabbarstyle{3}{bar style 3/.try}
\settabbarstyle{4}{bar style 2/.try}
\settabbarstyle{5}{bar style 1/.try}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List style
%%
\firmlists     % Reduced spacing in lists
%\tightlists   % No spacing in lists
%\defaultlists % Latex default spacing in lists

\preto{\labelenumi}{\figureversion{text,tab}}
\preto{\labelenumii}{\figureversion{text,tab}}
\preto{\labelenumiii}{\figureversion{text,tab}}
\preto{\labelenumiv}{\figureversion{text,tab}}

\renewcommand{\labelitemi}{\guillemotright}
\setlength{\leftmargini}{\specialparindent}

% for adjustwidth environment
\RequirePackage{changepage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8. Section style
%%
\setsecnumdepth{subsection}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table of contents
%%

\settocdepth{subsection}
\setlength{\cftbeforechapterskip}{2.25em \@plus 1.5em}
\setlength{\cftchapternumwidth}{2em}
\renewcommand{\cftchapterbreak}{\needspace{3\baselineskip}}
\renewcommand{\cftchapterfont}{\normalfont\scshape\bfseries\large}
\renewcommand{\cftchapterpagefont}{\normalfont\bfseries\large\figureversion{tab}}

\setlength{\cftbeforesectionskip}{0.75ex \@plus .5ex \@minus .2ex}
\setlength{\cftsectionindent}{\cftchapternumwidth}
\renewcommand{\cftsectionfont}{\normalfont\normalsize\figureversion{tab}}
\renewcommand{\cftsectionpagefont}{\normalfont\figureversion{tab}}

\setlength{\cftbeforesubsectionskip}{0ex}
\setlength{\cftsubsectionindent}{\cftchapternumwidth}
\addtolength{\cftsubsectionindent}{\cftsectionnumwidth}
\renewcommand{\cftsubsectionfont}{\normalfont\small\itshape\figureversion{tab}}
\renewcommand{\cftsubsectionpagefont}{\normalfont\figureversion{tab}}

\renewcommand{\@pnumwidth}{4ex}
\renewcommand{\@tocrmarg}{5ex}
\renewcommand{\cftdot}{{\color{nicegray}.}}

%\cftsetindents{chapter}{0em}{2em}
%\cftsetindents{section}{0em}{2em}
%\cftsetindents{subsection}{0em}{2em}
%\cftsetindents{subsubsection}{0em}{2em}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOC and Bibliography
%%
\newcommand\formattedTOC{%
	\ifabstractonly\else
		\clearforchapter%
		\microtypesetup{protrusion=false}%
		\pdfbookmark{\contentsname}{contents}
		\tableofcontents* %Add table of contents itself not to list
		\microtypesetup{protrusion=true}%
		\clearpage%
	\fi
}

\newcommand\formattedLOF{%
	\ifabstractonly\else
		\clearforchapter%
		\pdfbookmark{\listfigurename}{lof}
		\microtypesetup{protrusion=false}%
		\listoffigures*%
		\microtypesetup{protrusion=true}%
		\clearpage%
	\fi
}

\newcommand\formattedLOT{%
	\ifabstractonly\else
		\clearforchapter%
		\pdfbookmark{\listtablename}{lot}
		\microtypesetup{protrusion=false}%
		\listoftables*%
		\microtypesetup{protrusion=true}%
		\clearpage%
	\fi
}

\newcommand\formattedindex{%
	\ifabstractonly\else%
		\clearforchapter%
		\printindex%
	\fi%
}

\newcommand\listofacronyms{{%
	\ifabstractonly\else
		\microtypesetup{protrusion=false}%
		\printglossaries
	\fi
}}
\newcommand\listofreferences{{%
	\ifabstractonly\else
		\setbabelwidth{000}
		\microtypesetup{protrusion=true}%
		\bibliographystyle{abbrvnat}%
		\bibliography{src/library}%
	\fi
}}
\newcommand\listofpublications{{%
	\renewcommand*{\backrefalt}[4]{}% no backrefs in the publications
	\def\@noincbib##1{}
	\let\@doincbib\input
	\ifsinglechap%
		\let\@doincbib\@noincbib%
	\else%
		\setbabelwidth{10}%
		\microtypesetup{protrusion=true}%
		\renewcommand{\biblabelprefix}{\thesisauthorinitials:}% Add prefix to biblabel for publications
		\bibliographystylepub{unsrtnat}%
		\bibliographypub{src/publications}%
	\fi%
	\ifabstractonly%
		\let\@doincbib\@noincbib%
	\fi%
	\@doincbib{src/back/thesisbib}%
}}
\newcommand\includestellingen{%
	\ifpress\else%
	\ifsinglechap\else%
		\AtEndDocument{%
			\pdfbookmark{Stellingen}{stellingen}%
			\ifdiscussion%
				\settrimmedsize{229mm}{162mm}{*} % C5
				\setheadfoot{0pt}{0pt}%
				\setheaderspaces{*}{0pt}{*}%
				\setulmarginsandblock{0pt}{0pt}{*}%
				\setlrmarginsandblock{0pt}{0pt}{*}%
				\setlength{\trimtop}{\stockheight}%
				\addtolength{\trimtop}{-\paperheight}%
				\setlength{\trimedge}{\stockwidth}%
				\addtolength{\trimedge}{-\paperwidth}%
				\settrims{.5\trimtop}{.5\trimedge}%
				\checkandfixthelayout[fixed]%
				\includepdf[pages={-},noautoscale=true]{stellingen.pdf}%
			\else%
				\includepdf[pages={-},fitpaper=true]{stellingen.pdf}%
			\fi%
		}%
	\fi\fi%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Special purpose markup
%%

\newwordfont[command]{cmd}{\texttt}
\newcommand{\funcfont}[1]{\ensuremath{\operatorname{#1}}}
\newwordfont[function]{func}{\funcfont}
\newwordfont[application]{app}{\texttt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Misc
%%

\def\numleaves{224}%\thelastsheet}
\def\leaf{\thesheetsequence}

% adds a \vfill, where the rubber lengths (e.g., \fillgolden1 vs \fillgolden2) have a strength-ratio of about 1.618
\def\fillratio#1{\null\vskip 0pt \@plus #1fill\null}
\def\fillgolden#1{%
	\pgfmathsetmacro{\goldenratio}{\golden^#1}%
	\fillratio{\goldenratio}%
}

% creates an environment that fills a page
\NewEnviron{fullpage}[1][]{\thispagestyle{empty}\tikz[overlay,remember picture]{
	\node[inner sep=0,outer sep=0,anchor=center,#1] at ($(current page.center)+(\trimedge,\trimtop)$)
		{\begin{minipage}[c][\paperheight][c]{\paperwidth}\Centering\strut\ignorespaces\BODY\strut\end{minipage}};
}\ignorespaces}

% adds a footnote, without the footnotemark
\newcommand{\nofootnote}[1]{%
\begingroup%
\renewcommand\thefootnote{}\footnote{#1}%
\addtocounter{footnote}{-1}%
\endgroup%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cross referencing
% - Load after all other packages
%%

\RequirePackage{cleveref}%
\newcommand{\creflinkformats}[1]{
	\crefformat{#1}{##2\fixedspaceword{\csname cref@#1@name\endcsname~##1}##3}
	\Crefformat{#1}{##2\fixedspaceword{\csname Cref@#1@name\endcsname~##1}##3}
}

\creflinkformats{page}
\creflinkformats{line}
\creflinkformats{chapter}
\creflinkformats{section}
\creflinkformats{subsection}
\crefname{figure}{figure}{figures}%
\Crefname{figure}{Figure}{Figures}%
\creflinkformats{figure}
\crefname{subtable}{table}{tables}%
\Crefname{subtable}{Table}{Tables}%
\creflinkformats{table}
\crefname{algocf}{algorithm}{algorithms}%
\Crefname{algocf}{Algorithm}{Algorithms}%
\creflinkformats{algocf}
\crefname{subfigure}{figure}{figures}%
\Crefname{subfigure}{Figure}{Figures}%
\creflinkformats{subfigure}
\crefname{lemma}{lemma}{lemmas}%
\Crefname{lemma}{Lemma}{Lemmas}
\creflinkformats{lemma}
\crefname{definition}{definition}{definitions}
\Crefname{definition}{Definition}{Definitions}
\creflinkformats{definition}
%\crefname{equation}{eq.\@}{eq.\@}
%\Crefname{equation}{Eq.\@}{Eq.\@}
\crefname{equation}{equation}{equations}
\Crefname{equation}{Equation}{Equations}
\creflinkformats{equation}
\crefname{rule}{rule}{rules}
\Crefname{rule}{Rule}{Rules}
\creflinkformats{rule}
\crefname{ruledef}{rule}{rules}
\Crefname{ruledef}{Rule}{Rules}
\creflinkformats{ruledef}
\crefname{lstfloat}{listing}{listings}
\Crefname{lstfloat}{Listing}{Listings}
\creflinkformats{lstfloat}
\crefname{lstlisting}{listing}{listings}
\Crefname{lstlisting}{Listing}{Listings}
\creflinkformats{lstlisting}

% You might want to redefine wordfonts's commands here:
% \renewcommand*{\acronymfontupper}[1]{...}
% \renewcommand*{\acronymfontlower}[1]{...}

% patch \glsunset, such that when the chapter is not included (because of \includeonly), the item is still unset
\let\@origglsunset\glsunset
\renewcommand{\glsunset}[1]{%
	\@origglsunset{#1}%
	\ifdef{\AtEndChapter}{\AtEndChapter*{\string\@origglsunset{#1}}}{}%
}

% patch \glsreset, such that when the chapter is not included (because of \includeonly), the item is still reset
\let\@origglsreset\glsreset
\renewcommand{\glsreset}[1]{%
	\@origglsreset{#1}%
	\ifdef{\AtEndChapter}{\AtEndChapter*{\string\@origglsreset{#1}}}{}%
}

\addto\extrasenglish{%
	\def\reftextfaceafter {}%on the \reftextvario{facing}{next} page}%
	\def\reftextfacebefore{}%on the \reftextvario{facing}{preceding} page}%
	\def\reftextafter     {on the \reftextvario{following}{next} page}%
	\def\reftextbefore    {on the \reftextvario{preceding}{previous} page}%
	\def\reftextcurrent   {}%on \reftextvario{this}{the current} page}%
	\def\reftextfaraway#1{on \cpageref{#1}}%
}

