% Documentclass seismica.cls

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{seismica}[2022 LaTeX2e document class]

\newif\if@review
\@reviewfalse
\DeclareOption{review}{\@reviewtrue}

% used for review
\newif\if@onecolumn
\@onecolumnfalse
\DeclareOption{onecolumn}{\@onecolumntrue}

\newif\if@anonymous
\@anonymousfalse
\DeclareOption{anonymous}{\@anonymoustrue}

\newif\if@breakmath
\@breakmathfalse
\DeclareOption{breakmath}{\@breakmathtrue}

\newif\if@languages
\@languagesfalse
\DeclareOption{languages}{\@languagestrue}

\newif\if@preprint
\@preprintfalse
\DeclareOption{preprint}{\@preprinttrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% Review option by default
\if@preprint
\else
\@reviewtrue
\fi

\if@review
\@onecolumntrue
\fi

\if@onecolumn
\LoadClass[10pt,twoside,a4paper,onecolumn]{article}
\else
\LoadClass[10pt,twoside,a4paper,twocolumn]{article}
\fi

\RequirePackage[headsep=0.7cm,
				top=2cm,
				bottom=1.5cm,
				left=1.5cm,
				right=1.5cm,
				footskip=0.7cm]{geometry}
\setlength{\columnsep}{0.8cm}
\RequirePackage[table]{xcolor}
\definecolor{linkblue}{RGB}{38,81,143}
\definecolor{seismicacolor1}{RGB}{18,52,103}
\definecolor{seismicacolor2}{RGB}{77,185,123}
\definecolor{seismicacolor3}{RGB}{222,60,75}
\definecolor{codebackcolor}{RGB}{243,243,243}
\RequirePackage[unicode,
				bookmarks=true,
				linkcolor=linkblue,
				citecolor=linkblue,
				hidelinks,
				hyperfootnotes=false]{hyperref}
\hypersetup{colorlinks,linkcolor=linkblue}
\hypersetup{colorlinks,citecolor=linkblue}
\hypersetup{colorlinks,urlcolor=gray}

\RequirePackage{graphicx}
\RequirePackage{titlesec}
\RequirePackage{titling}
\RequirePackage{abstract}
\RequirePackage{fancyhdr}
\RequirePackage{bookmark}
\RequirePackage{caption} 
\RequirePackage[round]{natbib}
\IfFileExists{abbrvnat_seismica.bst}{\bibliographystyle{abbrvnat_seismica}}{\bibliographystyle{abbrvnat}}
\RequirePackage{doi}
%\RequirePackage{orcidlink}
\RequirePackage[noblocks]{authblk}
\setcounter{Maxaffil}{0}
\RequirePackage{adjustbox}
\RequirePackage{datatool}
\RequirePackage{etoolbox}
\RequirePackage{comment}
\RequirePackage{physics}
\RequirePackage{listings}

% fonts and math
\RequirePackage{amsmath}
\if@breakmath
	\RequirePackage{breqn}
	\BeforeBeginEnvironment{dmath}{\begin{nolinenumbers}}
	\AfterEndEnvironment{dmath}{\end{nolinenumbers}}
	\BeforeBeginEnvironment{dmath*}{\begin{nolinenumbers}}
	\AfterEndEnvironment{dmath*}{\end{nolinenumbers}}
	\renewenvironment{equation}{%
		\begin{dmath}}{%
		\end{dmath}}
\fi
\newcommand{\mathbfup}[1]{\mathord{\textnormal{\textbf{#1}}}}

\RequirePackage{lineno} %% loaded here because incompatibility with breqn
\if@review
\linenumbers
\fi


\if@languages
	\RequirePackage{polyglossia}
	\RequirePackage{fontspec}
	\setmainlanguages[]{english}
	\RequirePackage[opentype,default,tabular,lining]{sourcesanspro}
	\RequirePackage[opentype,default,tabular,lining]{sourceserifpro}
	\RequirePackage[opentype,default,tabular,lining]{sourcecodepro}
\else
	\RequirePackage[regular]{sourcesanspro}
	\RequirePackage[regular]{sourcecodepro}
	\RequirePackage[default,regular]{sourceserifpro}
	\RequirePackage[T1]{fontenc}
\fi

%-------------------------------------------------------------------------------
%                Configuration for authors
%-------------------------------------------------------------------------------

% package authblk
\renewcommand*{\Authsep}{, }
\renewcommand*{\Authand}{, }
\renewcommand*{\Authands}{, }
\renewcommand*{\Authfont}{\sffamily\bfseries}    % make author names boldface    
\setlength{\affilsep}{0.2cm}   % set the space between author and affiliation
\renewcommand*{\Affilfont}{\normalfont\sffamily\small}
\renewcommand\AB@affilsepx{, \protect\Affilfont}

% For orcid symbol without lualatex
% Copy of orcidlinks.sty / https://github.com/duetosymmetry/orcidlink-LaTeX-command
\RequirePackage{tikz}
\usetikzlibrary{svg.path}

\definecolor{orcidlogocol}{HTML}{A6CE39}
\tikzset{
	orcidlogo/.pic={
		\fill[orcidlogocol] svg{M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z};
		\fill[white] svg{M86.3,186.2H70.9V79.1h15.4v48.4V186.2z}
		svg{M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z}
		svg{M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z};
	}
}
%% Reciprocal of the height of the svg whose source is above.  The
%% original generates a 256pt high graphic; this macro holds 1/256.
\newcommand{\@OrigHeightRecip}{0.00390625}
%% We will compute the current X height to make the logo the right height
\newlength{\@curXheight}

\DeclareRobustCommand\orcidlink[1]{%
	\texorpdfstring{%
		\setlength{\@curXheight}{\fontcharht\font`X}%
		\href{https://orcid.org/#1}{\XeTeXLinkBox{\mbox{%
					\begin{tikzpicture}[yscale=-\@OrigHeightRecip*\@curXheight,
						xscale=\@OrigHeightRecip*\@curXheight,transform shape]
						\pic{orcidlogo};
					\end{tikzpicture}%
	}}}}{}}

\newcommand{\orcid}[1]{\orcidlink{#1}}

% Credit
\DTLgnewdb{credits}
\newcommand*{\credit}[2]{%
	\DTLnewrow{credits}%
	\DTLnewdbentry{credits}{credrole}{#1}%
	\DTLnewdbentry{credits}{credauthor}{#2}%
}

\if@anonymous
	\renewcommand{\@author}{}
\fi

% Redefine thanks symbol for compatibility with fonts
\def\@fnsymbol#1{\ensuremath{\ifcase#1\or *\or \dagger\or \ddagger\or
		\mathsection\or \mathparagraph\or \|\or **\or \dagger\dagger
		\or \ddagger\ddagger \else\@ctrerr\fi}}
%-------------------------------------------------------------------------------
%                Configuration for heading
%-------------------------------------------------------------------------------

% For credit
\newcommand{\printcreditifnotempty}{%
	\ifdim\DTLrowcount{credits}pt=0pt
	\else
	\vskip .5em
	\sffamily\footnotesize\raggedright\textcolor{seismicacolor1}{Author contributions:} \DTLforeach*{credits}{\Credrole=credrole, \Credauthor=credauthor}{\textcolor{seismicacolor1}{ \textit{ \Credrole}: \Credauthor.} }
	\fi
}

\pretitle{
	\begin{flushleft}
		\fontsize{21pt}{1em}\sffamily\bfseries
	}
	\posttitle{%
	\end{flushleft}%
	\vskip .2cm
}
\preauthor{%
	\lineskip 0.2cm%
	\begin{flushleft}
	}
	
\if@anonymous
		\postauthor{%
		\end{flushleft}%
		\vskip -.5em
		\par
		}
\else
	\postauthor{%
	\end{flushleft}%
	\vskip -.5em
	\printcreditifnotempty
	\par
	}
\fi
\predate{}
\postdate{}
\date{}

\newcommand{\banner}{banner}

\def\doi#1{\def\@doi{#1}}
\doi{}


\renewcommand\maketitlehooka{%
	\vspace{-1.5cm}
	\href{https://seismica.org/}{\includegraphics[width=\textwidth]{\banner}}
	
	{\vspace*{-1.3cm} \hspace{0.1cm} 
		\href{https://seismica.org/}{\color{black} \sffamily\small Non-peer reviewed manuscript submitted to} }
	
	\vspace*{1.7cm}
}

\renewcommand\maketitlehookd{%
	\pagestyle{fancy}
	\thispagestyle{plain}
}

%-------------------------------------------------------------------------------
%                Configuration for abstract
%-------------------------------------------------------------------------------

\newcommand*{\abstracttitlestyle}[1]{{\sffamily\large \bfseries #1}}

\let\oldthanks\thanks
\renewcommand{\thanks}[1]{\oldthanks{\sffamily\small   #1}}

\newenvironment{summary}[1]
{
	%	\pdfbookmark{#1}{#1}
	\vspace{0.3cm}
	\par
	\noindent \abstracttitlestyle{#1} \hspace{0.2cm}\sffamily
}%
{
}

\if@onecolumn
\newcommand*{\makeseistitle}[1]{%
	\maketitle
	\begin{adjustbox}{minipage=0.68\paperwidth}
		#1
	\end{adjustbox}
	\vspace{1cm}
}
\else
\newcommand*{\makeseistitle}[1]{%
	\twocolumn[%
	\maketitle
	\begin{adjustbox}{minipage=0.68\paperwidth}
		#1
	\end{adjustbox}
	\vspace{1cm}
	]
	\saythanks
}
\fi

%-------------------------------------------------------------------------------
%                Configuration for sections
%-------------------------------------------------------------------------------

\titleformat{\section}{\fontsize{14pt}{1em}\bfseries\sffamily}{\thesection}{1em}{}
\titleformat{\subsection}{\fontsize{12pt}{0.3em}\bfseries\sffamily}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\fontsize{11pt}{0.1em}\bfseries\sffamily}{\thesubsubsection}{1em}{}

\setcounter{secnumdepth}{3}

\newenvironment{acknowledgements}
{\section*{Acknowledgements}
}%
{}

\if@anonymous
	\excludecomment{acknowledgements}
\fi

%-------------------------------------------------------------------------------
%                Configuration for header and footer
%-------------------------------------------------------------------------------

\def\shorttitle@internal{}
\newcommand{\shorttitle}[1]{\gdef\shorttitle@internal{#1}}
\newcommand{\insertshorttitle}{\shorttitle@internal}

\pagestyle{fancy}
\fancyhf{}
\fancyfoot{}
\fancyfoot[L]{\sffamily\bfseries\footnotesize \thepage}
\fancyhead[L]{\sffamily\footnotesize This is a non-peer reviewed manuscript submitted to {\scshape \bfseries\href{https://seismica.org/}{\color{seismicacolor1}SEISMICA}} }
\fancyhead[R]{\sffamily\footnotesize \color{seismicacolor1}\insertshorttitle}
\renewcommand{\headrule}{}

\fancypagestyle{plain}{%
	\fancyhead{}
	\renewcommand{\headrule}{}
}

%
%%-------------------------------------------------------------------------------
%%                Configuration for captions
%%-------------------------------------------------------------------------------

\captionsetup{font=sf, 
	labelfont=bf, 
	labelsep=quad, 
	justification=justified, 
	singlelinecheck=false, oneside}


% equations
\if@breakmath
\renewcommand{\eqnumcolor}{\color{gray}}
\renewcommand{\eqnumfont}{\sffamily}
\else
\renewcommand{\eqref}[1]{\textup{\eqreftagform@{\ref{#1}}}}
\let\eqreftagform@\tagform@
\def\tagform@#1{%
	\maketag@@@{\color{gray}\sffamily(\ignorespaces#1\unskip\@@italiccorr)}%
}
\fi

\renewcommand{\theequation}{\color{gray}\arabic{equation}}

%%-------------------------------------------------------------------------------
%%                Configuration for references
%%-------------------------------------------------------------------------------

\setlength{\bibsep}{3pt}
\renewcommand{\bibsection}{\section*{References}}
\def\bibfont{\sffamily\small}
\renewcommand*{\doi}[1]{\href{http://doi.org/#1}{doi:~#1}}

%%-------------------------------------------------------------------------------
%%                Configuration for code
%%-------------------------------------------------------------------------------

% in-line code words
\def\code#1{\fontsize{9}{10}\colorbox{codebackcolor}{\texttt{#1}}}
\setlength{\fboxsep}{1pt}

\lstset{
	tabsize=4,
	captionpos=t,
	breaklines=true,
	showstringspaces=false,
	basicstyle=\fontsize{9}{10}\ttfamily,
	keywordstyle=\color{seismicacolor2},
	commentstyle=\color{gray},
	stringstyle=\color{seismicacolor1},
	emphstyle=\color{seismicacolor3},
	%	frameshape={RYR}{Y}{Y}{RYR},
	backgroundcolor=\color{codebackcolor},   
	rulecolor=\color{codebackcolor}
}

% end of seismica.cls 
