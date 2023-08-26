import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor class studentWall (){

    type Order = Order.Order;

    public type Content = {
      #Text: Text;
      #Image: Blob;
      #Video: Blob;
    };

    public type Message = {
        vote : Int;
        content: Content;
        creator : Principal;
    };

    var messageID: Nat = 0;

    var wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

    public shared({caller}) func writeMessage (c : Content) : async Nat {
        let tempMessage : Message = {
            vote = 0;
            content = c;
            creator = caller;
        };
        messageID += 1;
        wall.put(messageID, tempMessage );
        return messageID;
    };

    public query func getMessage (messageId: Nat) : async Result.Result<Message, Text>{
        if (messageId > messageID){
            return #err("Sorry please input a valid message ID");
        }else{
            let message = wall.get(messageId);
            switch( message) {
                case(null) { #err("Error getting message") };
                case(?message) {
                    #ok(message) 
                };
            };
        }
    };

    public shared({caller}) func updateMessage (messageId : Nat, c : Content ) : async Result.Result<(), Text>{
        if (messageId > messageID){
            return #err("Invalid Message ID");
        }else{
            let tempMessage = wall.get(messageId);
            switch (tempMessage){
                case(null){
                    return #err("Message is Null");
                };
                case (?tempMessage){
                    if (Principal.equal( tempMessage.creator, caller )){
                        let newmessage = {
                            vote = tempMessage.vote;
                            content = c;
                            creator = tempMessage.creator;
                        };
                        wall.put(messageId, newmessage);
                    }else{
                        return #err("You are not owner");
                    };

                };
            };
            return #ok();
        };

    };

    public func deleteMessage (messageId: Nat) : async Result.Result<(), Text>{
        if(messageId > messageID){
            #err("Invalid Message ID")
        }else{
            ignore wall.remove(messageId);
            #ok() 
        };
    };

    public func upVote (messageId: Nat): async Result.Result<(), Text>{
        if (messageId > messageID){
            return #err("Invalid Message ID");
        }else{
            let tempMessage = wall.get(messageId);
            switch (tempMessage){
                case (null){
                    return #err("Message is Null");
                };
                case (?tempMessage){
                    let newmessage= {
                        vote = 1 + tempMessage.vote;
                        content = tempMessage.content;
                        creator = tempMessage.creator;
                    };
                    wall.put(messageId, newmessage);
                }
            };
            return #ok();
        }
    };

    public func downVote (messageId  : Nat) : async Result.Result<(), Text>{
                if (messageId > messageID){
            return #err("Invalid Message ID");
        }else{
            let tempMessage = wall.get(messageId);
            switch (tempMessage){
                case (null){
                    return #err("Message is Null");
                };
                case (?tempMessage){
                    let newmessage= {
                        vote = tempMessage.vote - 1;
                        content = tempMessage.content;
                        creator = tempMessage.creator;
                    };
                    wall.put(messageId, newmessage);
                }
            };
            return #ok();
        }
    };

    public query func getAllMessages  () : async [Message]{
        let buff = Buffer.Buffer<Message>(1);

        for (value in wall.vals()) {
            buff.add(value);
        };

        Buffer.toArray(buff);
    };

    func compareMessage(m1: Message, m2: Message) : Order {
        if (m1.vote == m2.vote){
           return #equal;
        }else if (m1.vote > m2. vote) {
            return #less;
        }else{
            return #greater;
        }
    };

    public query func getAllMessagesRanked  () : async [Message]{
        let tempArray : [Message] = Iter.toArray(wall.vals());
        return Array.sort<Message>(tempArray, compareMessage);
    };
}
