#!/bin/bash

Slibsh_PrintJudgement_Base() {
    export Slibsh_printJudgement_sentenceBeginning="Checking whether "
    export Slibsh_printJudgement_sentenceEnding="... "
    export Slibsh_printJudgement_answerYes="yes"
    export Slibsh_printJudgement_answerNo="no"
}

Slibsh_PrintJudgement_SentenceBeginning() {
    Slibsh_PrintJudgement_Base
    echo -n "$Slibsh_printJudgement_sentenceBeginning"
}

Slibsh_PrintJudgement_SentenceEnding() {
    Slibsh_PrintJudgement_Base
    echo -n "$Slibsh_printJudgement_sentenceEnding"
}

Slibsh_PrintJudgement_AnswerYes() {
    Slibsh_PrintJudgement_Base
    echo $Slibsh_printJudgement_answerYes
}

Slibsh_PrintJudgement_AnswerNo() {
    Slibsh_PrintJudgement_Base
    echo $Slibsh_printJudgement_answerNo
}

Slibsh_PrintJudgement_Existence() {
    Slibsh_PrintJudgement_Base
    Slibsh_PrintJudgement_SentenceBeginning
    echo -n "$1 exists"
    Slibsh_PrintJudgement_SentenceEnding
}

Slibsh_PrintJudgement_Architecture() {
    Slibsh_PrintJudgement_Base
    Slibsh_PrintJudgement_SentenceBeginning
    echo -n "the architecture of this host is $1"
    Slibsh_PrintJudgement_SentenceEnding
}

Slibsh_PrintJudgement_Os() {
    Slibsh_PrintJudgement_Base
    Slibsh_PrintJudgement_SentenceBeginning
    echo -n "the OS on this host is $1"
    Slibsh_PrintJudgement_SentenceEnding
}

# usage: Slibsh_PrintJudgement_Version [<target>] <version>
Slibsh_PrintJudgement_Version() {
    Slibsh_PrintJudgement_Base
    Slibsh_PrintJudgement_SentenceBeginning
    [ -z "$2" ] && echo -n "the version is $1"
    [ -n "$2" ] && echo -n "the version of $1 is $2"
    Slibsh_PrintJudgement_SentenceEnding
}