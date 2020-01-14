
from typing import List, TextIO
import multiprocessing
import threading
import math

CORES = multiprocessing.cpu_count()
threads = []

def generate_wordlist(path) -> List[str]:
    fd = open(path)
    fd.seek(0)

    word_list = []

    for word in fd:
        b = word.strip()
        word_list.append(b)

    fd.close()
    return word_list


def divide_list(word_list: List[str], fd: TextIO) -> bool:
    
    segment = len(word_list) // CORES
    print("Segment: ", segment, ", len: ", len(word_list))
    error = len(word_list) - (segment * CORES)
    print("Remainder: ", error)
    index = 0
    counter = 0
    for index in range(0, len(word_list), segment):
        if (index == CORES-1) :
            thread = threading.Thread(target = concat_write, args = (word_list[index:index+segment+error], word_list, fd))
        else :
            thread = threading.Thread(target = concat_write, args = (word_list[index:index+segment], word_list, fd))
        threads.append(thread)
        thread.start()
        counter += 1
        print("Thread ", counter, " spawned")   
    
    return True




def concat_write(list1: List[str], listRef: List[str], newfile: TextIO) -> bool:
    iter = 0

    for word in list1:
        for suffix in listRef:
            fullstring = word + suffix + '\n'
            newfile.write(fullstring)
            iter += 1
    print("Iterations: ", iter)
    return True


if __name__ == "__main__":
    file_name = "english-small.txt"
    new_fd = open("concat_dict.txt", mode="w")
    #nlist = generate_wordlist(file_name)
    #concat_write(nlist, nlist, new_fd)
    divide_list(generate_wordlist(file_name), new_fd)
    for i in range(0, CORES):
        threads[i].join()
    new_fd.close()

   
