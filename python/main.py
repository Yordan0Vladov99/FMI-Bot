from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

bot = ChatBot('FMI',  
    logic_adapters=[
        'chatterbot.logic.BestMatch',
        'chatterbot.logic.TimeLogicAdapter'],)

name=input("Enter Your Name: ")
print("Welcome to the Bot Service! Let me know how can I help you?")


while True:
    request=input(name+':')
    if request=='Bye' or request =='bye':
        print('Bot: Bye')
        break
    else:
        response=bot.get_response(request)
        print('Bot:',response)


