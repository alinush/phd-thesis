#!/bin/bash

num_players="3 7 15 31 63 127 255 511 1023 2047 4095 8191 16383 32767 65535 131071 262143 524287 1048575 2097151"

printVssHeader() {
echo '
\begin{table}[t]
    %\large
    %\small
    \footnotesize
    %\scriptsize
    \centering
    \begin{tabular}{cccclrlrlr}
        {\makecell{Total \# of\\players}}
        & \makecell{Dealing\\round\\time}
        & \makecell{Verification\\round\\time}
        & \multicolumn{2}{c}{\makecell{Reconstruction\\phase time\\(BC / WC)}}
        & \multicolumn{2}{c}{\makecell{End-to-end\\time\\(BC / WC)}}
        & \multicolumn{2}{c}{\makecell{End-to-end\\speed-up\\(BC / WC)}}\\
        \toprule
'
}

printVssFooter() {
echo '
    \end{tabular}
    \caption{
        Detailed performance numbers from \cref{s:eval:vss} for \evss vs \ourvss.
    }
    \label{t:vss-perf} % must go after \caption{} for \cref{} to work
\end{table}
'
}

indent()
{
    for i in `seq 1 $1`; do
        echo -n "    "
    done
}

printVssData()
{
    schemes="evss amt"
    for n in $num_players; do
        for scheme in $schemes; do
            indent 2
            if [ "$scheme" == "evss" ]; then
                echo -n "\\multirow{2}{*}{\$n=$n\$}"
            fi

            echo -n " & \\${scheme}VssDealTime{$n} & \\${scheme}VssVerifyTime{$n} & \\${scheme}VssReconstrBcTime{$n} & \\${scheme}VssReconstrWcTime{$n} & \\${scheme}VssEndToEndBcTime{$n} & \\${scheme}VssEndToEndWcTime{$n} & "

            if [ "$scheme" == "evss" ]; then
                echo "\\amtVssEndToEndBcTimeImprovOverevss{$n} & \\amtVssEndToEndWcTimeImprovOverevss{$n} \\\\"
            else
                echo "& \\\\"
            fi
        done

        indent 2
        echo "\\addlinespace[0.4em]"
        echo
    done
}

printVss()
{
    printVssHeader
    printVssData
    printVssFooter
}

printDkg()
{
    schemes="ejf amt"
    for n in $num_players; do
        for scheme in $schemes; do
            echo "\$n=$n\$ & \\${scheme}DkgDealTime{$n} & \\${scheme}DkgVerifyBcTime{$n} / \\${scheme}DkgVerifyWcTime{$n} & \\${scheme}DkgReconstrBcTime{$n} / \\${scheme}DkgReconstrWcTime{$n} & \\${scheme}DkgEndToEndBcTime{$n} / \\${scheme}DkgEndToEndWcTime{$n}\\\\"
        done
        echo "\\addlinespace[0.4em]"
        echo
    done
}

echo
echo "eJF vs. AMT DKG"
echo
printDkg

echo
echo "eVSS vs. AMT VSS"
echo
printVss >table-evss-vs-amtvss.tex
echo "Updated table-evss-vs-amtvss.tex"
