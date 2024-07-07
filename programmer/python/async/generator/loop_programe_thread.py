import datetime
import colorama
import random
import time
import threading


def main():
    t0 = datetime.datetime.now()
    print(colorama.Fore.WHITE + "App started.", flush=True)
    data=[]

# create thread
    threads = [
        threading.Thread(target=generate_data,args=(20,data)),
        threading.Thread(target=process_data,args=(20,data),daemon=True)
    ]

    abort_thread = threading.Thread(target=check_cancel,daemon=True)
    abort_thread.start()
    # generate_data(20,data)
    # process_data(20,data)
    #start thread
    [t.start() for t in threads]
    print("Started...")
    # other work while generate_data is running ................
    # Wait for completion
    

    while any([t.is_alive() for t in threads]):
        [t.join(.001) for t in threads]
        if not abort_thread.is_alive():
            print("Cancelling on your request!", flush=True)
            break

    dt = datetime.datetime.now() -t0

    print(colorama.Fore.WHITE + "App exiting total time: {:,.2f} sec".format(dt.total_seconds()))


def check_cancel():
    print(colorama.Fore.RED + "Press enter to cancel...",flush=True)
    input()
def generate_data(num: int, data: list):
    for idx in range(0, num +1):
        item = idx*idx
        data.append((item, datetime.datetime.now()))

        print(colorama.Fore.YELLOW + f" --generated item {idx}", flush=True)
        time.sleep(random.random() + .5)


def process_data(num: int, data: list):
    processed = 0
    while processed < num:
        item = None
        if data:
            item = data.pop(0)
        if not item:
            time.sleep(.01)
            continue

        processed += 1
        value = item[0]
        t = item[1]
        dt = datetime.datetime.now() -t

        print(colorama.Fore.CYAN + 
              " +++ Processed value {} after {:,.2f} sec.".format(value, dt.total_seconds()))
        time.sleep(.5)


if __name__ == '__main__':
    main()
