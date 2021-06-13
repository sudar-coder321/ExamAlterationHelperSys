//Queries come here

class GraphQLqueries {
  String validateUser({String username, String password}) {
    return '''
mutation {
  tokenAuth(username: "$username", password: "$password") {
    token
  }
}
''';
  }

  String verifyToken(String token) {
    return ''' 
    mutation {
   verifyToken(token:$token) {
     payload
   }
}
    ''';
  }

  String fetchPastRecords() {
    return '''
    {
  me{
     userT
     {
         takers{
            exam{
             exam
                {
                 examName
                 startTime
                 endTime
                 Date
                slot
                }
              course{
           	CourseId
             CourseName     
              }
            }
         }
        
        }
    }   
}

    ''';
  }

  // String getExamCount() {
  //   return '''

  //   ''';
  // }

  // String getFacultyCount() {
  //   return '''
  //   ''';
  // }

  // String getFacNotAvail() {
  //   return '''
  //   ''';
  // }

  // String getFacAvail() {
  //   return '''
  //   ''';
  // }

  // String slotsAllocated() {
  //   return '''
  //   ''';
  // }

  // String roomsAvailable() {
  //   return '''
  //   ''';
  // }

  String getUser({String username, String password}) {
    return '''
{
  me{
    username
    firstName
    email
    userT{
      id
      type
      phno
    }
  }
}
''';
  }

  String getUserEmails() {
    return '''{
      users{
        email
      }
    ''';
  }

  String createGrievances(String facultyName, String grievance) {
    return '''
  mutation
{
  createGrievances(input:{facultyName:"$facultyName",grievance:"$grievance"})
  {
    ok
  }
}
    ''';
  }

  String getFaculties() {
    return '''
    {
  users(sort: "username",type:'faculty') {
  id
  username
  phno
  DOB
  photo
  }
}
    ''';
  }

  String deleteExam(int examId) {
    return '''
mutation {
deleteExam(id:$examId){
  ok
}
}
''';
  }

  String updateExam(
      {String examname,
      String starttime,
      String endtime,
      int duration,
      String day,
      String date,
      String slot,
      String course}) {
    return '''
query {
  updateExam(input: {examName: "$examname", startTime: "$starttime", endTime: "$endtime", duration: $duration,  course: "$course"}) {
    ok
  }
}
''';
  }

  String gettaakeduties() {
    return '''
{
me{
  usert{
    teachesSet{
      courseet{
        courseId
      }
      clas{
      className
      }
    }
  }
}
}
''';
  }

  String createExam(
      {int examId,
      String starttime,
      String endtime,
      int duration,
      String date}) {
    return '''
mutation{
  createExam(input:{examId:$examId,startTime:$starttime,endTime: $endtime}){
    ok
  }
}
''';
  }

  String fetchExamDetails() {
    return '''
   {
  me{
    userT{
      takers{
        exam{
          id
          room{
            RoomId
            Block
          }
          course{
            CourseId
            CourseName
          }
          exam{
            id
            examName
            day
            Date
            startTime
            endTime
            duration
            slot
          }
        }
      }
    }
  }
}
    ''';
  }

  String fetchExam() {
    return '''

  ''';
  }
}
