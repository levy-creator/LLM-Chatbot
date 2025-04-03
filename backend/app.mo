import Array "mo:base/Array";
import LLM "mo:llm";

actor {
  type ChatMessage = LLM.ChatMessage;
  type Role = LLM.Role;

  public func prompt(prompt : Text) : async Text {
    await LLM.prompt(#Llama3_1_8B, prompt);
  };

  public func chat(messages : [ChatMessage]) : async Text {
    let lastMessage = messages[messages.size() - 1].content;

    if (lastMessage == "What is marine conservation?" or lastMessage == "Define marine conservation") {
        return "Marine conservation is the protection and sustainable management of ocean ecosystems, ensuring the long-term health and productivity of marine life through proactive initiatives and responsible practices.";
    };

    if (lastMessage == "What are the main threats to the ocean?" or lastMessage == "Describe ocean threats") {
        return "The main threats to our oceans include plastic pollution, overfishing, coral reef degradation, habitat destruction from coastal development, and the impacts of climate change such as ocean acidification and rising sea levels.";
    };

    if (lastMessage == "What is sustainable fishing?" or lastMessage == "Define sustainable fishing") {
        return "Sustainable fishing involves practices that maintain fish populations and protect the marine ecosystem. This includes setting fishing quotas, using selective gear to reduce bycatch, and supporting local fisheries to ensure long-term viability.";
    };

    if (lastMessage == "How can we protect coral reefs?" or lastMessage == "Describe coral reef protection") {
        return "Protecting coral reefs requires a multi-faceted approach: reducing greenhouse gas emissions, enforcing sustainable fishing practices, establishing marine protected areas, and implementing restoration projects like coral farming.";
    };

    if (lastMessage == "How can we reduce plastic pollution?" or lastMessage == "What is plastic pollution reduction?") {
        return "Reducing plastic pollution entails banning or limiting single-use plastics, promoting recycling and biodegradable alternatives, organizing beach cleanups, and enacting policy changes to mitigate plastic waste entering our oceans.";
    };

    if (lastMessage == "What are the impacts of climate change on oceans?" or lastMessage == "Describe climate change impacts on oceans") {
        return "Climate change impacts oceans through rising sea levels, ocean acidification, and increased water temperatures which cause coral bleaching. These changes disrupt marine ecosystems and affect coastal communities worldwide.";
    };

    // Format messages to the required structure
    let formattedMessages = Array.map<ChatMessage, { role: Role; content: Text }>(
      messages,
      func(message) {
        { role = message.role; content = message.content }
      }
    );

    // Create a system message with a focus on marine conservation
    let systemMessage : [{ role : Role; content : Text }] = [
        {
            role = #system_;
            content = "You are a helpful AI assistant specialized in marine conservation.
                       You provide information on ocean preservation, marine ecosystems, sustainable fishing, coral reef protection, plastic pollution reduction, and climate change impacts on oceans.
                       Always give clear, concise, and accurate responses while referring to real-world examples and conservation initiatives when applicable."
        }
    ];

    return await LLM.chat(#Llama3_1_8B, Array.append(systemMessage, formattedMessages));
  };
};
