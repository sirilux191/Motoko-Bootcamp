import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Hash "mo:base/Hash";
import Result "mo:base/Result";

actor class studentWall (){
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
}
