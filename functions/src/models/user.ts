import { DocumentData, QueryDocumentSnapshot } from "firebase-admin/firestore";

class User {
  constructor(
    readonly id: string,
    readonly username: string,
    public totalScore: number
  ) {}
}

const userConverter = {
  toFirestore(user: User): DocumentData {
    return {
      username: user.username,
      totalScore: user.totalScore,
    };
  },
  fromFirestore(snapshot: QueryDocumentSnapshot): User {
    const data = snapshot.data();
    return new User(snapshot.id, data.username, data.totalScore);
  },
};

export { User, userConverter };
