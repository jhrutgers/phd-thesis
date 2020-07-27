% vim:syntax=tex

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cover}

\pdfcompresslevel=9

\newif\iffrontonly\frontonlyfalse
\newif\ifbackonly\backonlyfalse
\newif\iffullcover\fullcovertrue
\newif\iflowres\lowresfalse
\newif\ifcroppedcover\croppedcoverfalse
\newif\ifinvitation\invitationtrue

\RequirePackage{kvoptions}
\DeclareStringOption[0.058mm]{bulk}% defaule: assume Gildeprint's Biotop 100, glued
\DeclareOption{frontonly}{\frontonlytrue\backonlyfalse\fullcoverfalse\croppedcovertrue\lowrestrue\invitationfalse}
\DeclareOption{backonly}{\frontonlyfalse\backonlytrue\fullcoverfalse\croppedcovertrue\lowrestrue\invitationfalse}
\DeclareOption{cropped}{\croppedcovertrue\invitationfalse}
\DeclareOption{hires}{\lowresfalse}
\ProcessOptions
\ProcessKeyvalOptions*

\PassOptionsToPackage{rgb}{xcolor}
\LoadClass{article}

\RequirePackage[file=../info]{thesisinfo}
\RequirePackage{etex}

\newlength{\frontwidth}\setlength{\frontwidth}{170mm}
\newlength{\frontheight}\setlength{\frontheight}{240mm}
\newlength{\backwidth}\setlength{\backwidth}{\frontwidth}
\newlength{\backheight}\setlength{\backheight}{\frontheight}
\newlength{\invitationwidth}\setlength{\invitationwidth}{60mm}
\newlength{\invitationheight}\setlength{\invitationheight}{\dimexpr\frontheight-10mm\relax}
\newlength{\spinewidth}
\InputIfFileExists{../../sheetcount.aux}{}{}
\ifdef{\thesheetcount}{
	\setlength{\spinewidth}{\dimexpr\cover@bulk*\thesheetcount+0.5mm\relax}
	\typeout{The spine width is calculated as \the\spinewidth}
}{
	\setlength{\spinewidth}{1cm}
	\typeout{The spine width is ASSUMED TO BE \the\spinewidth}
}
\newlength{\spineheight}\setlength{\spineheight}{\frontheight}
\newlength{\bleedwidth}
\setlength{\bleedwidth}{5mm}
\newlength{\marginwidth}
\ifcroppedcover
	\setlength{\marginwidth}{0pt}
\else
	\setlength{\marginwidth}{20mm}
\fi

\newlength{\coverwidth}
\setlength{\coverwidth}{\backwidth}
\addtolength{\coverwidth}{\spinewidth}
\addtolength{\coverwidth}{\frontwidth}
\newlength{\coverheight}
\setlength{\coverheight}{\backheight}

\setlength{\paperheight}{\frontheight}
\iffrontonly\setlength{\paperwidth}{\frontwidth}\fi
\ifbackonly\setlength{\paperwidth}{\backwidth}\fi
\iffullcover
	\setlength{\paperwidth}{\frontwidth}
	\addtolength{\paperwidth}{\spinewidth}
	\addtolength{\paperwidth}{\backwidth}
\fi
\ifinvitation
	\addtolength{\paperwidth}{\dimexpr 2\bleedwidth+\invitationwidth}
\fi
\newlength{\viewportwidth}
\setlength{\viewportwidth}{\paperwidth}
\newlength{\viewportheight}
\setlength{\viewportheight}{\paperheight}
\ifcroppedcover\else
	\addtolength{\paperwidth}{2\marginwidth}
	\addtolength{\paperheight}{2\marginwidth}
	\addtolength{\viewportwidth}{\marginwidth}
	\addtolength{\viewportheight}{\marginwidth}
\fi


\pagestyle{empty}

\RequirePackage{tikz,ragged2e,ifempty,printlen,xargs,environ}
\RequirePackage[paperwidth=\paperwidth,paperheight=\paperheight]{geometry}

\RequirePackage[english,dutch]{babel}
\RequirePackage{datetime}
\RequirePackage[utf8x]{inputenc}
\RequirePackage[protrusion=true,expansion=true,stretch=10,shrink=10,babel,tracking=true]{microtype}
\RequirePackage[T1]{fontenc}
\RequirePackage{stmaryrd,textcomp}\def\mathds{\mathbb}%,dsfont}
\RequirePackage{MyriadPro}
\RequirePackage[fullfamily,textosf,mathlf,minionint,footnotefigures]{MinionPro}
\renewcommand\sfdefault{MyriadPro-LF}
\RequirePackage{tgcursor}% courier-like
\def\nohyphenation{\hyphenpenalty=10000\exhyphenpenalty=10000}

\RequirePackage{ean13isbn}

\RequirePackage[x]{mypdfx}
\RequirePackage{hyperref}
\hypersetup{pdfpagelayout=SinglePage,pdfstartview=Fit}
\expandafter\global\expandafter\pdfpageattr\expandafter{\the\pdfpageattr /Group <</S /Transparency /I true /CS /DeviceRGB>>}

\usetikzlibrary{calc,fit}
\pgfdeclarelayer{deepground}
\pgfdeclarelayer{background}
\pgfdeclarelayer{shadow}
\pgfdeclarelayer{foreground}
\pgfsetlayers{deepground,background,main,shadow,foreground}

\tikzset{
	cover section/.style={outer sep=0,inner sep=0},
	back cover/.style={cover section},
	spine/.style={cover section},
	front cover/.style={cover section},
	invitation/.style={cover section},
	trim marker/.style={draw,black!75},
	ruler/.style={draw,fill,inner sep=0,outer sep=0,anchor=west,minimum height=.25cm,minimum width=1cm},
	size indicator/.style={draw,latex-latex,every node/.append style={near start,sloped,anchor=south}},
}

\uselengthunit{mm}

\ifbackonly\NewEnviron{coverfront}{}\else\newenvironment{coverfront}{}{}\fi
\iffrontonly\NewEnviron{coverback}{}\else\newenvironment{coverback}{}{}\fi
\iffrontonly\NewEnviron{coverspine}{}\else\ifbackonly\NewEnviron{coverspine}{}\else\newenvironment{coverspine}{}{}\fi\fi
\ifinvitation\newenvironment{invitation}{}{}\else\NewEnviron{invitation}{}\fi

\appto\document{%
	\begin{tikzpicture}[overlay,remember picture]
	\coordinate (cover anchor) at ($(current page.north west)+(\marginwidth,-\marginwidth)$);
	\iffullcover\coordinate (viewport) at (cover anchor);\fi
	\ifbackonly\coordinate (viewport) at (cover anchor);\fi
	\iffrontonly\coordinate (viewport) at ($(cover anchor)+(-\backwidth,0)+(-\spinewidth,0)$);\fi
	\node[back cover,minimum width=\backwidth,minimum height=\backheight,anchor=north west]
		(back cover) at (viewport) {};
	\node[spine,minimum width=\spinewidth,minimum height=\spineheight,anchor=north west]
		(spine) at (back cover.north east) {};
	\node[front cover,minimum width=\frontwidth,minimum height=\frontheight,anchor=north west]
		(front cover) at (spine.north east) {};
	\ifinvitation
		\node[invitation,minimum width=\invitationwidth,minimum height=\invitationheight,anchor=north west]
			(invitation) at ($(front cover.north east)+(2\bleedwidth,0)$) {};
	\fi
	\ifcroppedcover\else
		\draw[trim marker] (back cover.north west) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
		\draw[trim marker] (back cover.north west) ++(-\bleedwidth,0) -- ++(-2\bleedwidth,0);
		\draw[trim marker] (back cover.west) ++(-\bleedwidth,0) -- ++(-2\bleedwidth,0);
		\draw[trim marker] (back cover.north) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
		\draw[trim marker] (back cover.south) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
		\draw[trim marker] (back cover.south west) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
		\draw[trim marker] (back cover.south west) ++(-\bleedwidth,0) -- ++(-2\bleedwidth,0);
		\draw[trim marker] (front cover.north east) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
		\ifinvitation
			\draw[trim marker] (invitation.north east) ++(\bleedwidth,0) -- ++(2\bleedwidth,0);
			\draw[trim marker] (invitation.east) ++(\bleedwidth,0) -- ++(2\bleedwidth,0);
			\draw[trim marker] (invitation.south east) ++(\bleedwidth,0) -- ++(2\bleedwidth,0);
			\draw[trim marker] (invitation.north west) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
			\draw[trim marker] (invitation.north east) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
			\draw[trim marker] (invitation.south west) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
			\draw[trim marker] (invitation.south east) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
			\draw[size indicator] ($(invitation.north west)+(0,2\bleedwidth)$) to node {\printlength{\invitationwidth}} ($(invitation.north east)+(0,2\bleedwidth)$);
			\draw[size indicator] ($(invitation.north east)+(2\bleedwidth,0)$) to node {\printlength{\invitationheight}} ($(invitation.south east)+(2\bleedwidth,0)$);
		\else
			\draw[trim marker] (front cover.north east) ++(\bleedwidth,0) -- ++(2\bleedwidth,0);
			\draw[trim marker] (front cover.east) ++(\bleedwidth,0) -- ++(2\bleedwidth,0);
			\draw[trim marker] (front cover.south east) ++(\bleedwidth,0) -- ++(2\bleedwidth,0);
		\fi
		\draw[trim marker] (front cover.north) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
		\draw[trim marker] (front cover.south) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
		\draw[trim marker] (front cover.south east) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
		\draw[trim marker] (spine.north west) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
		\draw[trim marker] (spine.north east) ++(0,\bleedwidth) -- ++(0,2\bleedwidth);
		\draw[trim marker] (spine.south west) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
		\draw[trim marker] (spine.south east) ++(0,-\bleedwidth) -- ++(0,-2\bleedwidth);
		\path[draw]
			(back cover.south west) ++(.5\marginwidth,-.5\marginwidth)
						node[ruler,fill=black] {}
			++(1cm,0)	node[ruler,fill=white] {}
			++(1cm,0)	node[ruler,fill=black] {}
			++(1cm,0)	node[ruler,fill=white] {}
			++(1cm,0)	node[ruler,fill=black] {};
		\node[anchor=south,text width=10ex,text badly centered] at ($(spine.north)+(0,\bleedwidth)$) %
			{\ifdef{\thesheetcount}{\thesheetcount~p.}{?~p.}\\\printlength{\spinewidth}};
		\draw[size indicator] ($(back cover.north west)+(0,2\bleedwidth)$) to node {\printlength{\backwidth}} ($(back cover.north east)+(0,2\bleedwidth)$);
		\draw[size indicator] ($(front cover.north west)+(0,2\bleedwidth)$) to node {\printlength{\frontwidth}} ($(front cover.north east)+(0,2\bleedwidth)$);
		\draw[size indicator] ($(back cover.south west)+(-2\bleedwidth,0)$) to node {\printlength{\backheight}} ($(back cover.north west)+(-2\bleedwidth,0)$);
	\fi
	\coordinate (center) at (spine.center);
}
\preto\enddocument{
	\end{tikzpicture}%
}

\RequirePackage{tikzcontour}

\iflowres
	\newlength{\imgwidth}
	% \doconvert[resolution]{imgfile_without_extension}{extension}
	\newcommandx{\doConvert}[4][1=100,4=]{%
		\setlength{\imgwidth}{\dimexpr #3\relax}%
		\pgfmathsetmacro{\imgwidthpx}{0.0351459804*\imgwidth*#1}%
		\immediate\write18{convert #2 -resample #1x#1 -resize \imgwidthpx '' -quality 75 #4 +repage #2.rs}}
	% \imgRs[resolution]{imgfile_without_extension}{extension}[convert options]{targeted width of image}
	\newcommandx{\imgRs}[5][1=50,4=]{\doConvert[#1]{#2.#3}{#5}[#4]\includegraphics[width=\dimexpr #5\relax, type=#3, ext=.#3.rs, read=.#3.rs]{#2}}
\else
	\newcommand{\doConvert}[3][]{}
	\newcommand{\imgRs}[4][]{\includegraphics[width=\dimexpr #4\relax]{#2}}
\fi

% add TrimBox to mypdfx's \pdfsetpageboxes
\renewcommand{\pdfsetpageboxes}{
	\def\attrpw{\converttopdfunit{\the\paperwidth}\relax}
	\def\attrph{\converttopdfunit{\the\paperheight}\relax}
	\def\attrbm{\converttopdfunit{\the\marginwidth}\relax}
	\def\attrbw{\converttopdfunit{\the\viewportwidth}\relax}
	\def\attrbh{\converttopdfunit{\the\viewportheight}\relax}
	\edef\attr{
		\the\pdfpageattr
%		/MediaBox [0 0 \attrpw\space \attrph] % set by pdfTeX
		/BleedBox [0 0 \attrpw\space \attrph]
		/TrimBox [\attrbm\space \attrbm\space \attrbw\space \attrbh]
		}
	\expandafter\pdfpageattr\expandafter{\attr}
}

\RequirePackage[acronym,smallcaps,nonumberlist,hyperfirst=false,shortcuts]{glossaries}
\RequirePackage{wordfonts,ifempty}
\input{../acronyms}

