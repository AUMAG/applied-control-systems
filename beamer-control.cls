
\ProvidesClass{beamer-control}
\PassOptionsToClass{aspectratio=43}{beamer}
\LoadClassWithOptions{beamer}

\title{{\large ENGM\,X004}\\\bigskip {\huge \emph{Applied Control Systems}}\\\bigskip \textsc{Course Notes}}
\author{Assoc.\ Prof.\ William Robertson \and Dr Sean McGowan}
\date{\small \emph{Document compiled \the\year/\the\month/\the\day}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PATHS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage{graphicx}
\def\PATHSETUP#1{
  \def\input@path{#1}
  \graphicspath{#1}
}
\PATHSETUP{
  {matlab/}
  {figures/}
  {pracs/}
  {workshops/}
  {concept1/}
  {concept2/}
  {concept3/}
  {concept4/}
  {concept5/}
  {concept6/}
  {concept7/}
  {concept8/}
  {concept9/}
  % the following is to allow the makefile to build without having to manually copy everything:
  {../matlab/}
  {../figures/}
  {../pracs/}
  {../workshops/}
  {../concept1/}
  {../concept2/}
  {../concept3/}
  {../concept4/}
  {../concept5/}
  {../concept6/}
  {../concept7/}
  {../concept8/}
  {../concept9/}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PACKAGES AND GENERAL SETUP %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand\MODULE[2][0]{%
  \gdef\currMODULE{#2}%
  \ifnum #1>0\relax\setcounter{part}{\numexpr #1-1\relax}\fi
  \part{#2}%
}
\newcommand\TOPIC[2][0]{%
  \gdef\currTOPIC{#2}%
  \ifnum #1>0\relax\setcounter{section}{\numexpr #1-1\relax}\fi
  \section{#2}%
}
\newcommand\CONCEPT[2][0]{%
  \gdef\currCONCEPT{#2}%
  \ifnum #1>0\relax\setcounter{subsection}{\numexpr #1-1\relax}\fi
  \lecture{#2}{#2}%
  \subsection{#2}%
}
\newcommand\SUBCONCEPT[1]{%
  \subsubsection{#1}%
}
\newcommand\INPUTCONCEPT[1]{%
  \input{#1}%
}

\expandafter\def\expandafter\JOBNAME\detokenize{acs}-#1-#2-#3-#4\relax{%
  \setcounter{part}{\numexpr #1\relax}%
  \setcounter{section}{\numexpr #2\relax}%
  \setcounter{subsection}{\numexpr #3-1\relax}%
}

\newcommand\INCLUDEONLY[1]{%
  \expandafter\JOBNAME\jobname\relax
  \includeonlylecture{#1}
  \begin{document}
    \input{applied-control-systems}
  \end{document}
}

\newcommand\astrom[1][]{KJ Åström \& RM Murray (2020), 2nd Ed. #1}
\newcommand\AMref[1]{(\AA\&M: #1)}

\newcommand\QUIZ[1]{\fbox{Q:\em #1}}

\PassOptionsToPackage{fleqn}{amsmath}

\usepackage{amsmath,array,booktabs,docmute,environ,multicol,siunitx,bookmark,pdfpages,etoolbox}

\usepackage{fontspec,unicode-math}

\usepackage{listings,matlab-prettifier}

\usepackage{beamer-control-maths}

%%%%%%%%%%%%%%%%%
%% BIBLIOGRAPHY
%%%%%%%%%%%%%%%%%


\newcommand\minicite[1]{%
  \citeauthor{#1} (\citeyear{#1}) \citetitle{#1}
}
\usepackage[
     backend = bibtex,
       style = authoryear,
  refsection = section,
  giveninits = true,
    ]{biblatex}

\bibliography{control}

\renewcommand\bibfont{\scriptsize}


%%%%%%%%%%%%
%% FONTS
%%%%%%%%%%%%

\setmainfont{texgyrepagella}[
  Extension = .otf ,
  UprightFont = *-regular ,
  ItalicFont = *-italic ,
  BoldFont = *-bold ,
  BoldItalicFont = *-bolditalic ,
]
\setmathfont{texgyrepagella-math.otf}

%%%%%%%%%%%%
%% TIKZ
%%%%%%%%%%%%

\usepackage{tikz}
\usetikzlibrary{positioning}
\usetikzlibrary{shapes,arrows,calc}
\usetikzlibrary{patterns,decorations.pathmorphing}

%%%%%%%%%%%%%%%%%%%%%%%%
%% MATLAB INTERFACING
%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand\includematlab[2]{%
  \lstinputlisting
     [
      style=Matlab-editor,
      basicstyle=\upshape\footnotesize\ttfamily,
      columns=fullflexible,
      frame=single,
      rangeprefix={\%},
      includerangemarker=false,
      linerange=<*#2>-</#2>,
     ]{#1}
}

\newcommand\Mbutton[1]{\textsf{\textbf{#1}}}
\newcommand\CODE{\texttt}

%%%%%%%%%%%%%%%
%% STRUCTURE %%
%%%%%%%%%%%%%%%

\numberwithin{equation}{subsection}
\renewcommand{\maketag@@@}[1]{\hbox{\m@th\tiny\normalfont#1}}%
\renewcommand\eqref[1]{(\ref{eq:#1})}

\renewcommand\partname{Module}
\renewcommand\sectionname{Topic}
\renewcommand\subsectionname{Concept}
\newcommand\subsubsectionname{Concept part}

\setcounter{secnumdepth}{5}
\setcounter{tocdepth}{5}

\newcommand\SECTOC{%
  \tableofcontents[
    sectionstyle=show/hide,
    subsectionstyle=show/show/hide,
  ]
}
\newcommand\SUMMARYFRAME{}

\newcommand\BIB{%
  \begin{frame}[plain,allowframebreaks]
    \frametitle{References}
    \printbibliography[heading=none]
  \end{frame}
}

\newcommand\PPTSLIDE[2][\PPTWD]{%
  {\includegraphics[page=#2,width=#1,trim=50 40 50 40,clip]{Advanced_Control_PPT}}
}

\newcommand\PPTSLIDECLIP[3][\PPTWD]{%
  {\includegraphics[page=#2,width=#1,trim=#3,clip]{Advanced_Control_PPT}}
}

%%%%%%%%%%%%
%% TABLES %%
%%%%%%%%%%%%

\extrarowheight=2pt
\newdimen\colwd
\colwd=1.3cm

\newcommand\STRUT[2]{\rule[#1]{0pt}{#2}\rule[-#1]{0pt}{#2}}
\newcolumntype{C}{>{$\displaystyle}c<{$}}
\newcolumntype{P}{>{\hfil$\displaystyle}p{\colwd}<{$\hfil}}
\newcolumntype{L}{>{}p{1cm}<{\hfil}}

%%%%%%%
%% FORMULAE
%%%%%%%

\newcommand\FORMULA[1]{%
  \def\theFORMULA{#1}%
}


%%%%%%%%%%%%%%%%%%
%% BEAMER HACK %%
%%%%%%%%%%%%%%%%%%

\long\def\beamer@part[#1]#2{%
  \GetTitleString{#1}%
  \let\@currentlabelname\GetTitleStringResult
  \beamer@savemode
  \mode<all>%
  \ifbeamer@inlecture
    \refstepcounter{part}%
    \def\beamer@partname{#2}%
    \def\beamer@partnameshort{#1}%
    \addtocontents{nav}{\protect\headcommand{\protect\partentry{#2}{\the\c@part}}}%
    \xdef\partlink{{Navigation\the\c@page}{\noexpand\beamer@partname}}%
    \xdef\partlinkshort{{Navigation\the\c@page}{\noexpand\beamer@partnameshort}}%
    \beamer@tempcount=\c@page\advance\beamer@tempcount by -1%
    \addtocontents{nav}{\protect\headcommand{%
        \protect\beamer@partpages{\the\beamer@partstartpage}{\the\beamer@tempcount}}}%
    \addtocontents{nav}{\protect\headcommand{%
        \protect\beamer@sectionpages{\the\beamer@sectionstartpage}{\the\beamer@tempcount}}}%
    \addtocontents{nav}{\protect\headcommand{%
        \protect\beamer@subsectionpages{\the\beamer@subsectionstartpage}{\the\beamer@tempcount}}}%
    \beamer@partstartpage=\c@page
    \beamer@sectionstartpage=\c@page
    \beamer@subsectionstartpage=\c@page
    \protected\def\insertsection{}%
    \protected\def\insertsubsection{}%
    \protected\def\insertsubsubsection{}%
    \protected\def\insertsectionhead{}%
    \protected\def\insertsubsectionhead{}%
    \protected\def\insertsubsubsectionhead{}%
    \def\lastsubsection{}%
    \protected\def\insertpart{\expandafter\hyperlink\partlink}%
    \Hy@writebookmark{\the\c@part}{#1}{Outline\the\c@part}{1}{toc}%
    \hyper@anchorstart{Outline\the\c@part}\hyper@anchorend
    \beamer@atbeginpart
  \fi%
  \beamer@resumemode}%


%%%%%%%%%%%%%%%%%%
%% BEAMER SETUP %%
%%%%%%%%%%%%%%%%%%



\@addtoreset{framenumber}{subsection}
%\@removefromreset{subsection}{section}

\setbeamerfont{section in head/foot}{size=\footnotesize}
\setbeamerfont{subsection in head/foot}{size=\footnotesize}
\setbeamerfont{frametitle}{size=\large}

\setbeamertemplate{section in toc}[sections numbered]
\setbeamertemplate{subsection in toc}[subsections numbered]

\setbeamertemplate{itemize items}[circle]

\usefonttheme{serif}
\beamertemplatenavigationsymbolsempty
\definecolor{NorthTce}{rgb}{0.5,0.42,0.97}
\definecolor{AUHighlight}{rgb}{0.141,0.278,0.965}
\definecolor{AUBlue}{rgb}{0.0745,0.0627,0.302}
\setbeamercolor{structure}{fg=NorthTce}
\setbeamercolor{alerted text}{fg=NorthTce}

\setbeamertemplate{headline}
  {%
    \begin{beamercolorbox}[wd=\paperwidth,colsep=1.5pt]{upper separation line head}
      \hfill\smash{\raisebox{-3.5ex}{\color[gray]{0.6}\fbox{\ifnum\c@section>0\relax\arabic{section}-\fi\ifnum\c@subsection>0\relax\arabic{subsection}-\else 0\fi\insertframenumber}~}}
    \end{beamercolorbox}
    \ifdefined\currMODULE
    \begin{beamercolorbox}[wd=\paperwidth,ht=4.5ex,dp=1.125ex,%
      leftskip=2.5mm,rightskip=.3cm plus1fil]{section in head/foot}
      \usebeamerfont{section in head/foot}%
      \currMODULE: \currTOPIC\qquad
    \end{beamercolorbox}
    \fi
    \ifdefined\currCONCEPT
    \begin{beamercolorbox}[wd=\paperwidth,ht=3ex,dp=1.125ex,%
      leftskip=2.5mm,rightskip=.3cm plus1fil]{subsection in head/foot}
      \usebeamerfont{subsection in head/foot}%
      \currCONCEPT
    \end{beamercolorbox}
    \fi
    \begin{beamercolorbox}[wd=\paperwidth,colsep=1.5pt]{lower separation line head}
    \end{beamercolorbox}
  }

%\AtBeginLecture{%
%  \setbeamercolor{background canvas}{bg=green!10}
%  \frame[plain]{\centering\fontsize{36}{36}\selectfont\itshape \insertlecture\par}
%  \setbeamercolor{background canvas}{bg=}
%}

% A combination of \partpage and \(sub)sectionpage: (WR)
\setbeamertemplate{subsection page}{
  \centering
  \includegraphics{au-logo}\par\bigskip
  {\large \scshape Applied Control Systems --- {ENGM\,X004}\par}
  \bigskip\bigskip
  \ifdefined\currMODULE
  \begingroup
    \centering
    {\usebeamerfont{part name}\usebeamercolor[fg]{part name}\partname~\insertromanpartnumber}%
    \vskip0.2ex\par
    \begin{beamercolorbox}[sep=16pt,center]{part title}
      \usebeamerfont{part title}\currMODULE\par
    \end{beamercolorbox}
  \endgroup
  \else
    \vfil
  \fi
  \ifdefined\currTOPIC
  \smallskip
  \begingroup
    \centering
    {\usebeamerfont{section name}\usebeamercolor[fg]{section name}\sectionname~\insertsectionnumber}%
    \vskip0.2ex\par
    \begin{beamercolorbox}[sep=12pt,center]{section title}
      \usebeamerfont{section title}\currTOPIC\par
    \end{beamercolorbox}
  \endgroup
  \else
    \vfil
  \fi
  \ifdefined\currCONCEPT
  \smallskip
  \begingroup
    \centering
    {\usebeamerfont{subsection name}\usebeamercolor[fg]{subsection name}\subsectionname~\insertsubsectionnumber}
    \vskip0.2ex\par
    \begin{beamercolorbox}[sep=8pt,center]{subsection title}
      \usebeamerfont{subsection title}\currCONCEPT\par
    \end{beamercolorbox}
  \endgroup
  \else
    \vfil
  \fi
}

\AtBeginSubsection{%
  \frame[plain]{\subsectionpage}%
  \frame{
      \frametitle{Topic contents}
      \tableofcontents[
        sectionstyle=hide/hide,
        subsectionstyle=show/shaded/hide,
        subsubsectionstyle=show/show/hide,
      ]
  }
}

\AtBeginSubsubsection{%
  \begin{frame}
    \centering
    {\usebeamerfont{subsection name}\usebeamercolor[fg]{subsection name}\subsubsectionname~\insertsubsubsectionnumber}
    \vskip0.5ex\par
    \begin{beamercolorbox}[sep=8pt,center]{subsection title}
      \usebeamerfont{subsection title}\insertsubsubsection\par
    \end{beamercolorbox}
  \end{frame}
}

\newcommand\ifonlylectureT[1]{%
  \ifx\beamer@onlylecture\@empty
    \expandafter\@firstofone
  \else
    \expandafter\@gobble
  \fi{#1}
}
\newcommand\ifonlylectureF[1]{%
  \ifx\beamer@onlylecture\@empty
    \expandafter\@gobble
  \else
    \expandafter\@firstofone
  \fi{#1}
}


\NewEnviron{SUMMARY}{%
  \xdef\SUMMARYFRAME{%
    \unexpanded{\setbeamercolor{background canvas}{bg=AUHighlight!15}}%
    \unexpanded{\begin{frame}{Concept summary}}%
    \unexpanded\expandafter{\BODY}
    \unexpanded{\end{frame}}%
    \unexpanded{\setbeamercolor{background canvas}{bg=white}}%
  }
  \SUMMARYFRAME
}

\newcommand\FINALESLIDE{%
  \setbeamercolor{background canvas}{bg=AUBlue}
  \begin{frame}[plain]
    \vspace*{2.5cm}% visually centered, not exact
    \centering
    \includegraphics{au-logo-inverse}
    \vfill
    \textcolor{white}
      {\fontsize{4}{4}\selectfont Australian University Provider Number PRV14404 / CRICOS Provider Number 04249J}
  \end{frame}
  \setbeamercolor{background canvas}{bg=white}
}

\newcommand\FINALE{}

\AtEndDocument{\FINALESLIDE}





% fix TOC spacing
\makeatletter
\patchcmd{\beamer@sectionintoc}
  {\vskip1.5em}
  {\vskip0.5em}
  {}
  {}
\makeatother  
