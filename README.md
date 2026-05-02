# Huffman -- Compression & Décompression de texte en OCaml

Implémentation en OCaml d'un programme de compression et décompression de fichiers texte basé sur l'algorithme de Huffman, réalisé dans le cadre du projet universitaire en progrmmation fonctinnelle (L2).

## Fonctionnalités

- Compression d'un fichier texte en fichier binaire (`.hf`)
- Décompression d'un fichier `.hf` vers le texte original
- Affichage de statistiques de compression (`--stats`)
- Gestion des cas limites (fichier vide, fichier à caractère unique)
- File de priorité implémentée from scratch (`heap.ml`)
- Sérialisation/désérialisation de l'arbre de Huffman

## Structure

```
projet/
├── bs.ml / bs.mli              # Bitstream : lecture/écriture bit à bit
├── heap.ml / heap.mli          # File de priorité
├── huffman.ml                  # Algorithme de Huffman (arbre, encodage, décodage)
├── huff.ml                     # Point d'entrée, gestion ligne de commande
├── test.ml                     # Tests
├── dune / dune-project         # Configuration du build
└── tests/
    ├── test1.txt               # Fichier court (caractères répétés)
    ├── test2.txt               # Fichier moyen (distribution variée)
    └── testVide.txt            # Fichier vide
```

## Installation & Utilisation

### Prérequis

- OCaml
- `dune`

### Build

```bash
dune build
```

### Compression

```bash
./huff monfichier.txt
```

Génère `monfichier.hf` (fichier compressé).

### Décompression

```bash
./huff monfichier.hf
```

### Statistiques

```bash
./huff --stats monfichier.txt
```

Affiche la taille originale, la taille compressée et le taux de compression.

## Exemples de résultats

| Fichier | Taille originale | Taille compressée | Taux de compression |
|---------|-----------------|-------------------|---------------------|
| test1.txt (100× 'a') | 100 octets | 3 octets | 97% |
| test2.txt (texte varié) | 824 octets | 497 octets | 39.7% |
