
# comes from rxDerived regexp
.linCmtParReg <- "^(?:(?:(?:V|Q|VP|VT|CLD)[[:digit:]])|KA|VP|VT|CLD|V|VC|CL|VSS|K|KE|KEL|Q|VT|(?:K[[:digit:]][[:digit:]])|AOB|ALPHA|BETA|GAMMA|A|B|C)$"

# translations to rxode2

.linCmtAdvan <- new.env(parent=emptyenv())

.linCmtAdvan$`1` <- new.env(parent=emptyenv())
.linCmtAdvan$`1`$`1` <- c("K"="k", "V"="v")
.linCmtAdvan$`1`$`2` <- c("CL"="cl", "V"="v")

.linCmtAdvan$`2` <- new.env(parent=emptyenv())
.linCmtAdvan$`2`$`1` <- c("KA"="ka", "K"="k", "V"="v")
.linCmtAdvan$`2`$`2` <- c("KA"="ka", "Cl"="cl", "V"="v")

.linCmtAdvan$`3` <- new.env(parent=emptyenv())
# #1 = volume associated with cmt1
.linCmtAdvan$`3`$`1` <- c("K"="k", "K12"="k12", "K21"="k21", "#1"="vc")
.linCmtAdvan$`3`$`3` <- c("CL"="cl", "V"="v", "Q"="q", "VSS"="vss")
.linCmtAdvan$`3`$`4` <- c("CL"="cl", "V1"="v1", "Q"="q", "V2"="v2")
.linCmtAdvan$`3`$`5` <- c("AOB"="aob", "ALPHA"="alpha", "BETA"="beta","#1"="vc")
.linCmtAdvan$`3`$`6` <- c("ALPHA"="alpha", "BETA"="beta", "K21"="k21", "#1"="vc")

.linCmtAdvan$`4` <- new.env(parent=emptyenv())
# #2 = volume associated with cmt2
.linCmtAdvan$`4`$`1` <- c("KA"="ka", "K"="k", "K23"="k23", "K32"="k32", "#2"="vc")
.linCmtAdvan$`4`$`3` <- c("CL"="cl", "V"="v", "Q"="q", "VSS"="vss", "KA"="ka")
.linCmtAdvan$`4`$`4` <- c("CL"="cl", "V2"="v2", "Q"="q", "V3"="v3", "KA"="ka")
.linCmtAdvan$`4`$`5` <- c("AOB"="aob", "ALPHA"="alpha", "BETA"="beta", "KA"="ka", "#2"="vc")

.linCmtAdvan$`11` <- new.env(parent=emptyenv())
.linCmtAdvan$`11`$`1` <- c("K"="k", "K12"="k12", "K21"="k21", "K13"="k13","K31"="k31", "#1"="vc")
.linCmtAdvan$`11`$`4` <- c(	"CL"="cl", "V1"="v1", "Q2"="q2", "V2"="v2", "Q3"="q3", "V3"="v3")

.linCmtAdvan$`12` <- new.env(parent=emptyenv())
.linCmtAdvan$`12`$`1` <- c("KA"="ka", "K"="k", "K23"="k23", "K32"="k32", "K24"="k24", "K42"="k42", "#2"="vc")
.linCmtAdvan$`12`$`2` <- c("CL"="cl", "V2"="Vc", "Q3"="q1", "V3"="Vp1", "Q4"="q2", "V4"="Vp2", "KA"="ka")
