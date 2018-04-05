/*------------------------------------------------
File Name: FeedBabe.java

Name:   Joseph Csoti
CruzID: jcsoti
Class:  CMPE 12
Date:   03/05/18
------------------------------------------------*/

class FeedBabe {
  public static void main(String[] args) {
    //Loop 1 => 500
    for(int i=1; i<=500; i++) {
      if(i%3==0 & i%4==0)
        System.out.println("FEEDBABE");  //Divisible by 3 & 4 
      else if(i%3 == 0) 
        System.out.println("FEED");      //Divisible by 3
      else if(i%4 == 0)
        System.out.println("BABE");      //Divisible by 4
      else
        System.out.println(i);           //Print "non-special" number
    }
  }
}