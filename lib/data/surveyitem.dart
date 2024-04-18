class SurveyItem{
  var questionType = -1;
  var questionTitle = "";
  var answerList = [];
  var userAnswer = "";
  var answerType = -1;

  SurveyItem( qtype, qtitle, answtype, anslist){
    this.questionType = int.parse(qtype.toString());
    this.questionTitle = qtitle;
    this.answerType = int.parse(answtype.toString());
    this.answerList = anslist;
  }

  setUserAnswer(userans){
    if(answerType == 0 ){
      userAnswer = (userans).toString();
    }
    else{
      userAnswer = userans;
    }
  }

  getUserAnswer(){
    if(answerType == 0 ){
      return int.parse(userAnswer);
    }
    else{
      return userAnswer;
    }
  }

  hasUserAnswer(){
    if(userAnswer == ""){
      return false;
    }else{
      return true;
    }
  }

  getQuestionType(){
    return questionType;
  }

  getQuestionTitle(){
    return questionTitle;
  }

  getAnswerType(){
    return answerType;
  }


}