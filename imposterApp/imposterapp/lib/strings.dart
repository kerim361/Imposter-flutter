library strings;

// 🌍 Unterstützte Sprachen
String currentLanguage = 'de'; // Standard: Deutsch

// Übersetzungstabelle
const Map<String, Map<String, String>> localizedStrings = {
  'de': {
    'appTitle': 'Imposter Spiel',
    'addPlayer': 'Spieler hinzufügen',
    'startGame': 'Spiel starten',
    'selectCategory': 'Kategorien wählen',
    'language': 'Sprache',
    'playersAdded': 'Spieler hinzugefügt',
    'needPlayers': 'Mindestens 3 Spieler erforderlich',
    'needCategories': 'Bitte mindestens eine Kategorie wählen',
    'enterPlayerName': 'Spielername eingeben',
    'selectedCategories': 'Ausgewählt',
    'backToMenu': 'Zurück zum Menü',
    'player': 'Spieler',
    'cardHidden': '🃏 Karte verdeckt',
    'allPlayersReady': '✅ Alle Spieler haben ihr Wort!',
    'startsFirst': '🔔 beginnt',
    'show': 'Aufdecken',
    'hide': 'Zudecken',
    'nextPlayer': 'Nächster Spieler',
  },
  'en': {
    'appTitle': 'Imposter Game',
    'addPlayer': 'Add Player',
    'startGame': 'Start Game',
    'selectCategory': 'Select Categories',
    'language': 'Language',
    'playersAdded': 'Players added',
    'needPlayers': 'At least 3 players required',
    'needCategories': 'Please select at least one category',
    'enterPlayerName': 'Enter player name',
    'selectedCategories': 'Selected',
    'backToMenu': 'Back to Menu',
    'player': 'Player',
    'cardHidden': '🃏 Card Hidden',
    'allPlayersReady': '✅ All players have their word!',
    'startsFirst': '🔔 starts first',
    'show': 'Aufdecken',
    'hide': 'Zudecken',
    'nextPlayer': 'Nächster Spieler',


  },
  'es': {
    'appTitle': 'Juego de Impostores',
    'addPlayer': 'Agregar jugador',
    'startGame': 'Iniciar juego',
    'selectCategory': 'Seleccionar categorías',
    'language': 'Idioma',
    'playersAdded': 'Jugadores añadidos',
    'needPlayers': 'Se requieren al menos 3 jugadores',
    'needCategories': 'Seleccione al menos una categoría',
    'enterPlayerName': 'Nombre del jugador',
    'selectedCategories': 'Seleccionado',
    'backToMenu': 'Volver al menú',
    'player': 'Jugador',
    'cardHidden': '🃏 Carta oculta',
    'allPlayersReady': '✅ ¡Todos los jugadores tienen su palabra!',
    'startsFirst': '🔔 empieza',
    'show': 'Mostrar',
    'hide': 'Ocultar',
    'nextPlayer': 'Siguiente jugador',

  },
  'fr': {
    'appTitle': 'Jeu d\'imposteur',
    'addPlayer': 'Ajouter un joueur',
    'startGame': 'Démarrer le jeu',
    'selectCategory': 'Choisir des catégories',
    'language': 'Langue',
    'playersAdded': 'Joueurs ajoutés',
    'needPlayers': 'Au moins 3 joueurs requis',
    'needCategories': 'Veuillez sélectionner au moins une catégorie',
    'enterPlayerName': 'Nom du joueur',
    'selectedCategories': 'Sélectionné',
    'backToMenu': 'Retour au menu',
    'player': 'Joueur',
    'cardHidden': '🃏 Carte cachée',
    'allPlayersReady': '✅ Tous les joueurs ont leur mot !',
    'startsFirst': '🔔 commence',
    'show': 'Afficher',
    'hide': 'Cacher',
    'nextPlayer': 'Joueur suivant',

  },
};

// Zugriffsfunktion
String t(String key) {
  return localizedStrings[currentLanguage]?[key] ?? '[$key]';
}
