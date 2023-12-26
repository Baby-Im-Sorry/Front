class Main:
    def __init__(self, kakao, chatG):
        self.kakao = kakao
        self.chatG = chatG

    def kakaoMerge(self, b):
        print("kakao"+ b)
    
    def chatGMerge(self, b):
        print("chatG" + b)
    
if __name__ == "__main__":
    m = Main(kakao="kakao", chatG="chatG")
    b = "api"
    m.kakaoMerge(b); m.chatGMerge(b);
