// lib/strings.dart

// Aktuelle Sprache (wird im Menü einstellbar gemacht)
String currentLanguage = 'en';

// Alle übersetzten Texte
final Map<String, Map<String, String>> _localizedStrings = {
  'en': {
    'appTitle': 'Imposter Game',
    'hint': 'Hint',
    'player': 'Player',
    'show': 'Show',
    'hide': 'Hide',
    'nextPlayer': 'Next Player',
    'confirmReady': 'Confirm',
    'backToMenu': 'Back to Menu',
    'allPlayersReady': 'All players have their word!',
    'startsFirst': 'starts first',
    'selectCategory': 'Select Category',
    'selectAll': 'Select All',
    'deselectAll': 'Deselect All',
    'noWordHintPairs': 'No word-hint pairs found.',
    'addPlayer': 'Add Player',
    'revealImposter': 'Reveal Imposter',
    'imposterIs': 'The impostor is',
    'startGame': 'Start Game',

    // Neue Keys für Settings
    'settings': 'Settings',
    'numberOfImpostors': 'Number of Impostors',
    'hintForImpostor': 'Hint for Impostor',
    'save': 'Save',
  },
  'de': {
    'appTitle': 'Imposter Spiel',
    'hint': 'Hinweis',
    'player': 'Spieler',
    'show': 'Aufdecken',
    'hide': 'Zudecken',
    'nextPlayer': 'Nächster Spieler',
    'confirmReady': 'Bestätigen',
    'backToMenu': 'Zurück zum Menü',
    'allPlayersReady': 'Alle Spieler haben ihr Wort!',
    'startsFirst': 'fängt an',
    'selectCategory': 'Kategorie wählen',
    'selectAll': 'Alle auswählen',
    'deselectAll': 'Alle abwählen',
    'noWordHintPairs': 'Keine Wort-Hinweis-Paare gefunden.',
    'addPlayer': 'Spieler hinzufügen',
    'revealImposter': 'Imposter auflösen',
    'imposterIs': 'Der Imposter ist',
    'startGame': 'Spiel starten',

    // Neue Keys für Settings
    'settings': 'Einstellungen',
    'numberOfImpostors': 'Anzahl Impostoren',
    'hintForImpostor': 'Hinweis für Impostor',
    'save': 'Speichern',
  },
  'es': {
    'appTitle': 'Juego Impostor',
    'hint': 'Pista',
    'player': 'Jugador',
    'show': 'Mostrar',
    'hide': 'Ocultar',
    'nextPlayer': 'Siguiente jugador',
    'confirmReady': 'Confirmar',
    'backToMenu': 'Volver al menú',
    'allPlayersReady': '¡Todos tienen su palabra!',
    'startsFirst': 'comienza primero',
    'selectCategory': 'Seleccionar categoría',
    'selectAll': 'Seleccionar todo',
    'deselectAll': 'Deseleccionar todo',
    'noWordHintPairs': 'No se encontraron pares palabra-pista.',
    'addPlayer': 'Agregar jugador',
    'revealImposter': 'Revelar impostor',
    'imposterIs': 'El impostor es',
    'startGame': 'Empezar el juego',

    // Neue Keys für Settings
    'settings': 'Configuración',
    'numberOfImpostors': 'Número de impostores',
    'hintForImpostor': 'Pista para el impostor',
    'save': 'Guardar',
  },
  'fr': {
    'appTitle': 'Jeu Imposteur',
    'hint': 'Indice',
    'player': 'Joueur',
    'show': 'Montrer',
    'hide': 'Cacher',
    'nextPlayer': 'Joueur suivant',
    'confirmReady': 'Valider',
    'backToMenu': 'Retour au menu',
    'allPlayersReady': 'Tous les joueurs ont leur mot !',
    'startsFirst': 'commence',
    'selectCategory': 'Choisir catégorie',
    'selectAll': 'Tout sélectionner',
    'deselectAll': 'Tout désélectionner',
    'noWordHintPairs': 'Aucune paire mot-indice trouvée.',
    'addPlayer': 'Ajouter un joueur',
    'revealImposter': 'Révéler l\'imposteur',
    'imposterIs': 'L\'imposteur est',
    'startGame': 'Commencer le jeu',

    // Neue Keys für Settings
    'settings': 'Paramètres',
    'numberOfImpostors': 'Nombre d\'imposteurs',
    'hintForImpostor': 'Indice pour l\'imposteur',
    'save': 'Enregistrer',
  },
};

// Übersetzungsfunktion
String t(String key) {
  return _localizedStrings[currentLanguage]?[key] ?? key;
}
