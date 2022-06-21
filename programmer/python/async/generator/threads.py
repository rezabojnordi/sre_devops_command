
# import time
# def main():
#     greeter("Reza", 100)



# def greeter(name: str, times: int):
#     for _ in range(times):
#         print("Hello there {}".format(name))
#         time.sleep(1)

# if __name__ == "__main__":
#     main()

##----------------------------------------------------------------


import time
import threading
def main():
    # t1 = threading.Thread(target=greeter, args=("Reza",10),daemon=True)
    # t2 = threading.Thread(target=greeter, args=("sarah",5),daemon=True)
    # t1.start()
    # t2.start()
    # t1.join()
    # t2.join()
    threads = [threading.Thread(target=greeter, args=("Reza",10),daemon=True),
               threading.Thread(target=greeter, args=("sarah",5),daemon=True),
               threading.Thread(target=greeter, args=("ab",5),daemon=True),
               threading.Thread(target=greeter, args=("ac",5),daemon=True)
    ]

    [t.start() for t in threads]
    [t.join() for t in threads]
    print("Done")



def greeter(name: str, times: int):
    for _ in range(times):
        print("Hello there {}".format(name))
        time.sleep(1)

if __name__ == "__main__":
    main()
