import datetime
import math
import multiprocessing

def main():
    do_math(1)

    t0 = datetime.datetime.now()

    #do_math(num=30000000)

    print("Doing math on {:,}".format(multiprocessing.cpu_count()))
    processor_count = multiprocessing.cpu_count()
    pool = multiprocessing.Pool()
    tasks = []
    for n in range(1, processor_count +1):
        task = pool.apply_async(do_math,(30_000_0000 * (n - 1) / processor_count,3_000_0000 * n / processor_count))
        tasks.append(task)

    pool.close()
    pool.join()

    
    dt = datetime.datetime.now() -t0
    print("done in {:,.2f}".format(dt.total_seconds()))
    print("Our results: ")

    for t in tasks:
        print("get tasks",t.get())

    



def do_math(start=0, num=10):
    pos = start
    k_sq = 1000 * 1000
    ave = 0
    while pos < num:
        pos += 1
        val = math.sqrt((pos - k_sq) * (pos - k_sq))
        ave += val / num
    return int(ave)

if __name__ == '__main__':
    main()