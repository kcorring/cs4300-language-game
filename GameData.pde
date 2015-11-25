class GameData {
    private final DateFormat df = new SimpleDateFormat("MM_dd_yyyy_HH_mm_ss");
    private static final int MAX_WORD_SCORE = 100;
    private static final int WRONG_DEDUCTION = 10;
    String playerName;
    String startTime;
    Language language;
    Map<UUID, FlashcardScore> scores;
    
    GameData(String playerName, Language language) {
        this.playerName = playerName;
        this.language = language;
        
        startTime = df.format(new Date());
        scores = new HashMap<UUID, FlashcardScore>();
    }
    
    GameData(String playerName, Language language, String date) {
        this.playerName = playerName;
        this.language = language;
        startTime = date;
        scores = new HashMap<UUID, FlashcardScore>();
        loadGameFromFile(String.format("%s_%s_%s.txt", playerName, language, date));
    }
    
    void loadGameFromFile(String filename) {
        BufferedReader reader = createReader(filename);
        String line = "";
        String[] scoreData;
        while (true) {
            try {
              line = reader.readLine();
            } catch (IOException e) {
                e.printStackTrace();
                line = null;
            }
            if (line == null) {
                break;
            } else {
                scoreData = split(line, ',');
                scores.put(UUID.fromString(scoreData[0]),
                    new FlashcardScore(boolean(scoreData[1]), int(scoreData[2]),
                        int(scoreData[3]), int(scoreData[4])));
            }
        }
    }
    
    void saveGameToFile() {
        PrintWriter output = createWriter(String.format("%s_%s_%s.txt", playerName, language, startTime));
        FlashcardScore score;
        for (UUID id : scores.keySet()) {
            score = scores.get(id);
            output.println(String.format("%s,%b,%d,%d,%d",
                id, score.correct, score.attempts, score.deduction, score.finalScore));
        }
        output.flush();
        output.close();
    }
    
    
    void addNewFlashcard(UUID flashcardId) {
        scores.put(flashcardId, new FlashcardScore(MAX_WORD_SCORE, WRONG_DEDUCTION));
    }
    
    void updateFlashcard(UUID id, boolean correct) {
        scores.get(id).update(correct); 
    }
}

class FlashcardScore {
    boolean correct;
    int attempts;
    int deduction;
    int finalScore;
    
    FlashcardScore(int maxScore, int deduction) {
        correct = false;
        attempts = 0;
        this.finalScore = maxScore;
        this.deduction = deduction;
    }
    
    FlashcardScore(boolean correct, int attempts, int deduction, int finalScore) {
        this.correct = correct;
        this.attempts = attempts;
        this.deduction = deduction;
        this.finalScore = finalScore;
    }
    
    int update(boolean correct) {
        if (!correct && finalScore > 0) {
            finalScore = max(0, finalScore - deduction);
        }
        if (!this.correct) {
          attempts++;
        }
        this.correct = correct;
        return finalScore;
    }
}

class FlashcardData {
   UUID uuid;
   String word;
   float longestTranslation = 0;
   Map<Language, List<String>> translations;
    
   FlashcardData(UUID uuid, String word) {
       this.uuid = uuid;
       this.word = word;
       translations = new HashMap<Language, List<String>>();
   }
    
   FlashcardData(String word) {
       this.word = word;
       translations = new HashMap<Language, List<String>>();
   }
    
   void addTranslations(String lang, TableRow row) {
       translations.put(Language.valueOf(lang.toUpperCase()), Arrays.asList(row.getString(lang).split(",")));
        
       textFont(wordFont, 80);
       for (List<String> translationList : translations.values()) {
            for (String translation : translationList) {
                float tw = textWidth(translation);
                longestTranslation = tw > longestTranslation ? tw : longestTranslation;
            }
       }
   }
    
   boolean checkAnswer(String answer, Language language) {
      answer = answer.trim().toLowerCase();
      for (String translation : translations.get(language)) {
          if (translation.equals(answer)) {
              return true;
          }
      }
      return false;
   }
}