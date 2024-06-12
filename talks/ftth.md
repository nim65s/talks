---
title: FTTH tetaneutral.net
subtitle: Capitole du libre 2022
author: L. Guerby, M. Herrb, G. Saurel
date: 2022-11-20
sansfont: Source Sans 3
mainfont: Source Serif 4
monofont: Source Code Pro
talk-urls:
- name: Capitole du Libre 2022 (programme)
  url: https://cfp.capitoledulibre.org/cdl-2022/talk/D7JDBY/
- name: Capitole du Libre 2022 (video)
  url: https://www.youtube.com/watch?v=FtZd1qKd1GQ
---


## C'est quoi Tetaneutral.net ?

<https://tetaneutral.net>

Création association,

Création FFDN,

La neutralité du net, c'est quoi ?

FAI ADSL, radio, VPN  wireguard

Opérateur (IPv6 /48 PI disponibles)

Hebergeur physique, location, VM

Hébergeur de chatons

##

![](media/alex_20130316-crop.jpg)

## C'est quoi Tetaneutral.net ? (suite)

Pas de salarié ni subvention, transparence financière

Limites: Moyens financiers, Temps bénvévoles

Bénévoles, formation technique / éducation populaire

Accès à une infrastructure sympathique pour apprendre

## Objet de l'association

But pédagogique : comprendre les mécanismes des internets

Apprendre en pratiquant : devenir FAI

Défense de la Neutralité du Réseau

Moyens pédagogiques à disposition des enseignants

Collaboration avec tous les acteurs intéressés

# FTTH

## Cadre

ARCEP, gouvernement, répartition FTTH en France: ZTD, AMII, AMEL, RIP

- L’Arcep, gendarme des engagements AMII et AMEL

- Une zone AMII est une partie du territoire dans laquelle un ou plusieurs opérateurs privés ont manifesté leur intérêt pour déployer un réseau en fibre optique FTTH.

- AMEL: Appel à manifestation d’engagements locaux

- RIP: Réseaux d’initiative publique


<https://cartefibre.arcep.fr/>
<https://www.arcep.fr/fileadmin/user_upload/espace_collectivites/rapport-TC-2020/rapport-TC-2020-CHAP2_FICHE3.pdf>

## Carte

![](media/carte-zones-amii.png)

## Chez nous


<https://fr.wikipedia.org/wiki/R%C3%A9seau_FTTH>

Les codes des opérateurs d'immeubles sont des codes composés de 2 caractères alphanumériques destinés à identifier les prises FTTH (PTO). Ils sont attribués par l'Arcep comme suit

> Fibre 31     => HG



## Techno

À la commande, soit l’Opérateur d’Infrastructure nous construit la ligne, soit il nous la transfère

Physiquement de bout en bout à partir du routeur, puis converto, PTO, boitier poteau ou rue, armoire de rue "ideaoptical", PM, NRO, collecte

Notion de porte de collecte operateur, Altitude infrastructure, Kosc, Bouygues

## Fibre dans la fédération FFDN

Dans la FFDN campagne de financement pour acheter les portes (illyse, grenode, Aquilenet, FDN a Paris)

Partenariat avec la société Toulousaine Fullsave évite les FAS des portes au prix d'un setup technique différent
Notion de STAS, montrer un exemple de table des matieres

Plusieurs portes, plusieurs setups techniques

Portes Locale Vs Nationnales

## Exemple fibre31 = Altitude Infrastructure

<https://www.fibre31.fr/wp-content/uploads/sites/13/2019/04/Offres-dacc%C3%A8s-FTTH-actif.pdf>

181 pages, page 134 la technique = ANNEXE 4 – STAS
"Spécifications Techniques d’Accès au Service"

##

![](media/cdl-fibre31.jpg)


## Couverture géographique

| Opérateur | Couverture |
|-----|------------|
| Altitude (fibre 31) | Zone RIP (campagne) 31, (82) |
| Kosc (france) | ZTD + AMII |
| Bouygues (france) | ZTD + AMII |


## Tarifs (€ TTC)
FAS = frais d'accès au service, que la fibre soit déjà là ou pas

|  Offre |     FAS  |  Mensuel  | Débits |
|------|-----|-----|-----|
| Altitude Best Effort |  180€ | 35€  | 1G / 200M |
| Altitude Business |   360€ | 49€ | 1G / 200M prio |
| Kosc    | 120€ | 54€  | 1G / 800M |
| Bouygues | 180€ | 56€ | 1G / 500M, 20M garanti |

### Adhésion association

Prix libre, suggéré **20 €/an**

Pas de service TV ni téléphone

## La box

Celle que vous voulez, un PC linux, un routeur wifi OpenWRT (linux pour petits routeurs) (exemple [Turris Omnia ou Mox](https://www.turris.com/en/))

On aidera les gens qui savent pas gérer ça

## Historique fibre tetaneutral.net en ZTD

Fibres dédiées à un lieu (dans Toulouse)

Local associatif Mix'Art Myrys (maintenant fermé administrativement)

Habitat Participatif "4 vents" (environ 50 abo FTTH, potentiellement à 10G, 30€ / mois, dans un immeuble depuis 2018) => on peut recommencer

Local associatif "Picto" (déménagement Mix'Art Myrys)

## État actuel

On a déja deux FTTH qui marchent sur l'offre fibre31 business dont une ou la ligne fibre n'était pas présente et a été
crée par la commande tetaneutral.net:

![](media/ftth.png)

## Projet technique

- renforcer l'infrastructure de routage
- partie humaine : suivi et commande et mise  en place et suivi de la trésorerie et des prélèvement automatiques

Bénévoles bienvenu·e·s:
- <https://tetaneutral.net/participer/>
- <https://tetaneutral.net/contact/>
