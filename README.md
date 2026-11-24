# Vanta 0.1 — prototype

Vanta est une distribution Linux personnalisée pour le jeu, le développement et
l'analyse technique. Elle dérive de Bazzite. Ce dépôt contient la configuration
et les scripts destinés à construire une image ISO pour PC x86_64. La chaîne de
construction n'a pas encore été exécutée de bout en bout.

La variante principale cible ce PC : Ryzen 5 5600X, RTX 2080 et 32 Go de RAM.
Elle fonctionne aussi sur un processeur Intel x86_64 compatible. La variante
NVIDIA requiert un GPU NVIDIA adapté ; une variante AMD/Intel graphique
demanderait une autre image de base.

## Ce qui est prévu dans l'image

- Bureau Bazzite avec Steam et Proton.
- QEMU/KVM, libvirt et virt-manager pour AMD-V ou Intel VT-x.
- `vanta-check` : état du processeur, de KVM et du GPU, en lecture seule.
- `vanta-lab` : boîte de développement Fedora 45 créée au premier lancement,
  avec Rust/Cargo, C/C++, GDB, binutils, radare2, Python, Nmap, outils DNS,
  WHOIS et jq.
- Raccourcis de bureau pour les deux outils Vanta.

Distrobox partage le dossier personnel de l'hôte. C'est un environnement de
développement, pas un bac à sable pour des fichiers malveillants. Pour analyser
un échantillon non fiable, utiliser une machine virtuelle jetable.

## Jeux

La compatibilité Steam/Proton dépend du jeu et du choix de son éditeur pour
l'anti-cheat. Au 24 novembre 2026, League of Legends avec Vanguard et les
serveurs officiels Rust protégés par EAC ne sont pas pris en charge dans cette
image Linux. Conserver Windows pour ces jeux. L'ISO ne modifie pas Windows et
n'installe pas automatiquement un double démarrage.

## Générer l'ISO avec GitHub Actions

1. Créer un dépôt GitHub nommé `vanta` et y pousser cette source sur `main`.
   Avec cette configuration, rendre le package GHCR public pour les futures
   mises à jour. Un package privé demanderait une authentification à configurer
   sur Vanta, qui n'est pas incluse ici.
2. Activer GitHub Actions. Lancer **Build container image** ou pousser sur
   `main`, puis attendre la réussite de `ghcr.io/<compte>/vanta:latest`.
3. Lancer **Build Vanta ISO**. Télécharger l'artefact `vanta-iso` et vérifier
   l'ISO avec `SHA256SUMS`.
4. Tester le démarrage et l'installateur en machine virtuelle avant de créer
   une clé USB. Sauvegarder le disque cible avant toute installation.

Le workflow renseigne automatiquement le nom du compte GitHub dans la
configuration de l'installateur. Sans secret Cosign `SIGNING_SECRET`, l'image
conteneur n'est pas signée et l'étape de signature est ignorée.

## État de construction

Les scripts Bash, les fichiers YAML/TOML et les chemins ont été vérifiés
statiquement. L'image conteneur et l'ISO ne sont pas encore construits ni
validés au démarrage. Ce dépôt est un prototype technique, pas une image prête
à installer sur un ordinateur principal.

## Origine et licence

Construit à partir du [modèle Universal Blue](https://github.com/ublue-os/image-template)
et de [Bazzite](https://github.com/ublue-os/bazzite). Licence du modèle :
Apache-2.0, voir `LICENSE`.

Sources de compatibilité :
[Valve / Proton](https://partner.steamgames.com/doc/steamdeck/proton),
[Riot / Vanguard](https://www.leagueoflegends.com/en-ph/news/dev/dev-vanguard-x-lol/),
[Facepunch / Rust](https://rust.facepunch.com/news/the-lumberjack).
