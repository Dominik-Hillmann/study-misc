setwd("C:/Users/Dominik/Dropbox/Geteilte-Ordner/Studium/VWL/VWL-Semester-6/Applied-Econometrics")
# setwd("C:/Users/Student/Downloads/Applied-Econometrics")
getwd()

X = read.table(
  file = "fertility.csv", 
  header = TRUE,
  sep = ";"
)
N = nrow(X) # rund 250 000 Beobachtungen
y = X[1:N, "weeksm1"]

#############################
# Exploratory Data Analysis #
#############################

binVars = list("morekids", "boy1st", "boy2nd", "samesex", "black", "hispan", "othrace")
nonBinVars = list("agem1", "weeksm1")

# Verteilung nicht-binaerer Daten
# Alter relativ normalverteilt
# bei den Arbeitswochen ??berwiegend Frauen, die entweder gar nicht oder das ganze Jahr arbeiteten
hist(
  X[1:N, "agem1"], 
  col = rgb(.3, .5, .01),
  main = NULL,#"Histogram of Mothers' ages",
  xlab = NULL,
  ylab = NULL
)
mean(X[1:N, "agem1"])
sd(X[1:N, "agem1"])
median(X[1:N, "agem1"])


hist(
  X[1:N, "weeksm1"], 
  col = rgb(.3, .5, .01),
  main = NULL,#"Histogram of Mothers' ages",
  xlab = NULL,
  ylab = NULL
)
mean(X[1:N, "weeksm1"])
sd(X[1:N, "weeksm1"])
median(X[1:N, "weeksm1"])

# 38% mehr als 2 Kinder
# ~ 50% je, dass Kind Junge war 
# 50% der Faelle mit Kindern, die das gleiche Geschlecht hatten
# 5% schwarz, 7% Hispanics, 5% sonstiges ausser weiss
# mean binaerer Variablen = Anteil an 1en 
for (binVar in binVars) {
  summ = summary(X[binVar])
  print(summ)
}


corMatrix = round(cor(X), 2)
corMatrix
# Auflistung starker Korrelationen > |+-0.10|
corMatrix["morekids", "weeksm1"] # negativ: mehr Kinder weniger Arbeit oder mehr Arbeit -> weniger Kinder
corMatrix["morekids", "agem1"] # je aelter eine Frau ist, desto wahrscheinlicher ist es, das sie mehrere Kinder bekam
corMatrix["agem1", "weeksm1"] # je aelter eine Frau, desto mehr arbeitete sie nach Geburt
corMatrix["black", "weeksm1"] # schwarze Frauen arbeiten eher mit Kind
corMatrix["hispan", "othrace"] # sollte sich das nicht gegenseitig ausschliessen?

###########################
# Erstes einfaches Modell #
###########################

# morekids als Proxy fuer Fertilitaet
morekids = X[1:N, "morekids"]
simpleLinModel = lm(y ~ morekids)
summary(simpleLinModel)
# Interpretation des Modells
# -5.38, statistisch signifikante f??r beta_morekids:
# mehr als 2 Kinder zu haben, wird die Mutter durchscnittlich 5.38 Wochen weniger arbeiten lassen
# Je mehr Kinder, desto mehr Zeit wird f?r diese gebraucht => weniger angebotene Arbeit
# Signifikanz wegen grossem N?
yHat = predict(simpleLinModel)
u = y - yHat
predMoreKids0 = yHat[1] # morekids == 0
predMoreKids1 = yHat[11] # morekids == 1

plot(
  morekids, y,
  ylim = c(0, 53),
  xlim = c(-1, 2),
  asp = 1,
  col = "blue",
  pch = 20
)
abline(simpleLinModel, col = "red", lwd = 2)
lines(
  c(-80, 0), 
  c(predMoreKids0, predMoreKids0), 
  lty = 2
)
lines(
  c(-80, 1), 
  c(predMoreKids1, predMoreKids1), 
  lty = 2
)
text(-5, predMoreKids1 + 2, toString(round(predMoreKids1, 2)))
text(-5, predMoreKids0 + 2, toString(round(predMoreKids0, 2)))

###########################
# Suche nach Endogenitaet #
###########################

hist(u) 
mean(u)
sd(u)
t = (mean(u) - 0) / sd(u)
t # *** sehr klein nahe 0, nicht stat. signifikant verschieden von 0
cor(morekids, u)
# falsches Verstaendnis von cor(morekids, u) != 0?
# durch Endogenitaet ist beta biased und es laesst sich nur rein logisch argumentieren
# mathematisch gesehen muss nach OLS u nahe 0 sein, da beta der Koeffizient ist, der
# den kleinsten Fehler verursacht => Endogenitaet laesst sich nicht anhand cor(X, u) != 0 feststellen
# => rein "logische" Argumentation, warum Endogenitaet vorliegen kann:
# wir suchen nach einer Variable, die OVB verursacht
  # 1. Korrelation mit y, also weeksm1
  # 2. Korrelation mit erklaerender Variable, morekids

# labor supply des Vaters: 1., weil je mehr Vater arbeitet, desto weniger
  # muss von der Frau zum HH-Einkommen beigetragen werden, um Lebensstandard aufrecht zu erhalten
  # besitzt Vater niedriges Einkommen, wird vielleicht zweites Einkommen fuer Kind/Lebensstandard benoetigt
  # 2., weil je mehr Kinder eine Familie hat, desto mehr Geld wird fuer diese benoetigt => hoeheres L-Angebot

# wage des Vaters: 
  # 1.: bei gleichbleibendem L-Angebot sorgt hoehere wage fuer weniger "Aufstockung" des HH-Y durch Ehefrau
  # 2.: ein hoeheres Einkommen erlaubt einer Familie, mehr Kinder zu finanzieren
# weitere denkbare Variablen: Ausbildung der Frau? Ueberhaupt verheiratet?

# https://ourworldindata.org/female-labor-force-participation-key-facts
# Notiz: Regeression auf Fehler

###########################
# Suche nach Instrumenten #
###########################

# Da Endogenitaet vorliegen kann: Suche nach einer Variablen Z fuer TSLS, Bedingungen:
  # cor(moreKids, Z) != 0, Relevanz
  # cor(Z, u) == 0, Exogenitaet
corMatrix 
# relevante Variablen in Bezug auf morekids:
relevant = list("samesex", "hispan", "agem1", "black")
# das zweite Kriterium: Ausschluss aller Variablen, die zu hohe Korrelation mit dem Fehler haben
for (attr in relevant) {
  print(c(attr, cor(u, X[1:N, attr])))
}
# es lassen sich black und agem1 definitiv ausschliessen, das sie nicht das Exogenitaetskrit. erfuellen
relevant = list("samesex", "hispan")
# Lateinamerikaner scheinen mehr Kinder zu haben und Leute, deren erste Kinder gleiches Geschlecht hatten



samesex = X[1:N, "samesex"]
moreIfSameSex = lm(morekids ~ samesex)
summary(moreIfSameSex)
# Eltern werden eher > 2 Kinder haben, wenn vorherige Kinder gleiches Geschlecht hatten
# 2 Kinder gleichen Geschlechts zu haben erhoeht ... (Problem Interpretation)
plot(
  samesex, morekids,
  asp = 1,
  col = "blue",
  pch = 20
)
abline(moreIfSameSex, col = "red", lwd = 2)

hispan = X[1:N, "hispan"]
moreIfHispan = lm(morekids ~ hispan)
summary(moreIfHispan)
# ist eine Mutter lateinamerikanisches, wird sie im Schnitt 0.143 mehr Kinder haben
# als eine nicht-lateinamerikanische Frau
# wieder das Problem, dass bei 250 000 Beobachtungen alles signifikant ist

# Frage: warum sollte ich samesex ueber hispan waehlen, wenn hispan besser geeignet ist?
# Frage: ab wann gilt ein Instrument als schwach? Wie niedrig muss die Korrelation sein?

########
# TSLS #
########

# 1st stage: 
pred.morekids = predict(moreIfSameSex)
pred.morekids.0 = pred.morekids[1]
pred.morekids.1 = pred.morekids[5]
pred.morekids

# 2nd stage
tslsFertility = lm(y ~ pred.morekids)
summary(tslsFertility)
# stat. signifikantes beta
# Problem: nun sind vorhergesagte Werte so weit zusammengerueckt, dass es nicht mehr
# wirklich einen Unterschied macht, ist eine Woche Unterschied bedeutend?
# oder muss ich die Inputs von morekids nutzen, also (0, 1), in diesem Falle
pred.tsls = predict(tslsFertility)
pred.tsls.morekids.0 = pred.tsls[1]
pred.tsls.morekids.1 = pred.tsls[5]

plot(
  pred.morekids, y,
  ylim = c(17, 22),
  xlim = c(-1, 2),
  asp = 1,
  col = "blue",
  pch = 20
)
#abline(simpleLinModel, lwd = 2)
abline(tslsFertility, col = "red")
# abline(simpleLinModel)
lines(
  c(-80, pred.morekids.1), 
  c(pred.tsls.morekids.1, pred.tsls.morekids.1), 
  lty = 2
)
lines(
  c(-80, pred.morekids.0), 
  c(pred.tsls.morekids.0, pred.tsls.morekids.0), 
  lty = 2
)
lines(
  c(20, pred.morekids.0),
  c(0, pred.morekids.0),
  lty = 2
)

text(
  0, .1 + pred.tsls.morekids.0, 
  toString(round(pred.tsls.morekids.0, 3))
)
text(
  0, .1 + pred.tsls.morekids.1, 
  toString(round(pred.tsls.morekids.1, 3))
)

summary(lm(y ~ pred.morekids + hispan + X[1:N, "agem1"] + X[1:N, "othrace"]))

# vor TSLS um Variablen erweitern
# Variablen nach Theorie, nicht stat. Kennzahlen waehlen
# Effekt grosses N anschauen #
# warum Endogenitaet diskutieren (durch alle 3 Gruende gehen)
  # jedoch unwahrscheinlich wegen Zeit in gleichzeit. Kausalitaet)
# kurze Wiederholung IV
# diskutieren, was theoretisch Kontrollvariable und was Instrument


# Aufgabe
  # Ziel
  # Technik

# Exploratory Data Analysis
  # woher kommen die Daten
  # Groesse der Daten und Signifikanz -> kein Sinn, da im Prinzip Population
  # Variablen, binaer, fortlaufend
    # fortlaufend: Histogramme
    # binaer: Anteil 1
  # Korraltionsmatrix, interessante Werte markieren

# ein einfaches Modell mit Kontrollvariablen bauen
  # ueber diese Tabellen vergleichen
  # alternativ, was theoretisch reingehoerte

# Endogenitaet
  # moegliche Gruende
  # warum und was hier der Fall ist
  # zwei disproofen, Variablen fuer Endogenitaet geben

# Reminder: kurze grafische Erklaerung der IV
  # http://1.bp.blogspot.com/-RLb__vKMui0/TsfpzJCYQsI/AAAAAAAAAqg/uReaj9UxI5w/s1600/IV_graph.jpg
  # Ingedients
  # Problems, but why not here

# Ausblick und Limitations
  # welche Variablen sind Kandidaten fuer Regressoren, welche fuer Instrumente
  # Ueberidentifikation

# Stil https://s3.envato.com/files/184426091/Priview%20Images%20Set/Slide002.jpg
# http://cdn.shopify.com/s/files/1/2377/0257/products/clean_powerpoint_templates_preview_2_90187e4a-695f-4291-b7f1-4d21490bf42d_1024x1024.jpg
# Scatterpunkte und aktuelle Ueberschrift in Akzentfarbe
weeksm1 = X[1:N, "weeksm1"]
morekids = X[1:N, "morekids"]

summary(lm(weeksm1 ~ morekids))
