class GameData {
    private final DateFormat df = new SimpleDateFormat("MM_dd_yyyy_HH_mm_ss");
    private static final int MAX_WORD_SCORE = 100;
    private static final int WRONG_DEDUCTION = 10;
    private static final int ROOM_COUNT = 3;
    String playerName;
    String startTime;
    int score;
    Language language;
    Map<UUID, FlashcardScore> scores;
    Map<Integer, RoomFlashcardData> roomFlashcardDataMap;
    
    GameData(String playerName, Language language) {
        this.playerName = playerName;
        this.language = language;
        
        startTime = df.format(new Date());
        scores = new HashMap<UUID, FlashcardScore>();
        getFlashcardData(true);
        score = 0;
    }
    
    GameData(String playerName, Language language, String date) {
        this.playerName = playerName;
        this.language = language;
        startTime = date;
        scores = new HashMap<UUID, FlashcardScore>();
        score = 0;
        loadGameFromFile(String.format("%s_%s_%s.txt", playerName, language, date));
        getFlashcardData(false);
    }
    
    Map<Color, FlashcardData> getFlashcardDataMap(int roomID) {
        return roomFlashcardDataMap.get(roomID).flashcards; 
    }
    
    void getFlashcardData(boolean newGame) {
        roomFlashcardDataMap = new HashMap<Integer, RoomFlashcardData>();
        RoomFlashcardData roomFlashcardData;
        Table dataTable;
        FlashcardData flashcardData;
        UUID uuid;
        String filenameFormat = "csv/room%d.csv";
        for (int i = 1; i <= ROOM_COUNT; i++) {
            roomFlashcardData = new RoomFlashcardData(i);
            dataTable = loadTable(String.format(filenameFormat, i), "header");
            for (TableRow row : dataTable.rows()) {
                uuid = UUID.fromString(row.getString("UUID"));
                flashcardData = new FlashcardData(uuid, row.getString("Word"));
                flashcardData.addTranslations("Spanish", row);
                flashcardData.addTranslations("Italian", row);
                flashcardData.addTranslations("French", row);
                roomFlashcardData.addFlashcardData(COLORS.get(row.getString("Color")), flashcardData);
                if (newGame) {
                    addNewFlashcard(uuid);
                }
            }
            roomFlashcardDataMap.put(i, roomFlashcardData);
        }
    }
    
    void loadGameFromFile(String filename) {
        BufferedReader reader = createReader(filename);
        String line = "";
        String[] scoreData;
        boolean correct;
        int flashcardScore;
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
                correct = boolean(scoreData[1]);
                flashcardScore = int(scoreData[4]);
                scores.put(UUID.fromString(scoreData[0]),
                    new FlashcardScore(correct, int(scoreData[2]),
                        int(scoreData[3]), flashcardScore));
                if (correct) {
                    score += flashcardScore; 
                }
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
        FlashcardScore flashcardScore = scores.get(id);
        flashcardScore.update(correct);
        if (correct) {
             score += flashcardScore.finalScore;
        }
    }
    
    boolean checkGameOver() {
        for (UUID id : scores.keySet()) {
            if (!scores.get(id).correct) {
              return false;
            }
        }
        return true;
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
        //println(finalScore);
        return finalScore;
    }
}

class RoomFlashcardData {
    int roomID;
    Map<Color, FlashcardData> flashcards;
    
    RoomFlashcardData(int roomID) {
        this.roomID = roomID;
        flashcards = new HashMap<Color, FlashcardData>(); 
    }
    
    void addFlashcardData(Color c, FlashcardData flashcard) {
        flashcards.put(c, flashcard); 
    }
}

class FlashcardData {
   UUID uuid;
   String word;
   Map<Language, List<String>> translations;
    
   FlashcardData(UUID uuid, String word) {
       this.uuid = uuid;
       this.word = word;
       translations = new HashMap<Language, List<String>>();
   }
    
   void addTranslations(String lang, TableRow row) {
       translations.put(Language.valueOf(lang.toUpperCase()), Arrays.asList(row.getString(lang).split(",")));
   }
   
   float longestTranslation(Language language) {
       float tw;
       float longest = 0;
       textFont(wordFont, 80);
       for (String translation : translations.get(language)) {
           tw = textWidth(translation);
           longest = tw > longest ? tw : longest;
       }
       return longest;
   }
    
   boolean checkAnswer(String answer, Language language) {
      answer = answer.trim().toLowerCase();
      for (String translation : translations.get(language)) {
         //println(translation);
          if (translation.equals(answer)) {
              getGame().updateFlashcard(uuid, true);
              return true;
          }
      }
      getGame().updateFlashcard(uuid, false);
      return false;
   }
}