from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

bot = ChatBot('FMI',  
    logic_adapters=[
        'chatterbot.logic.BestMatch',
        'chatterbot.logic.TimeLogicAdapter'],)


trainer = ListTrainer(bot)
sentences=[]

session_sentences = open('../text_files/sentences.txt', 'r')
Lines = session_sentences.readlines()

for line in Lines:
    if line == "":
        trainer.train(sentences)
        sentences = []
    else:
        sentences.append(line.strip())
    



schedule_sentences = open('../text_files/schedule_sentences.txt','r')
Lines = schedule_sentences.readlines()

for line in Lines:
    if line == "":
        trainer.train(sentences)
        sentences = []
    else:
        sentences.append(line.strip())

static_sentences = open('../text_files/static_questions.txt','r')
Lines = static_sentences.readlines()

for line in Lines:
    if line == "":
        trainer.train(sentences)
        sentences = []
    else:
        sentences.append(line.strip())



trainer.train(sentences)
