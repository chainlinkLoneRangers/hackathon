   struct review {
      address reviewer;
      address reviewee;
      string reviewText;
      int8 reviewScore;
      bool isPublished;
      bool needsArbitration;
      bool settled;
      bool reviewerArbitrated;
      bool revieweeArbitrated;
      bool reviewerSettled;
      bool revieweeSettled;
   }