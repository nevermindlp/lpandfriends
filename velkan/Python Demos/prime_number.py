__author__ = 'chrisxu'


# create odd number
def odd_num():
    num = 1
    while True:
        num += 2
        yield num


# return a number that can not be divided by the arg n
def not_divisible(n):
    return lambda x: x % n > 0


# impl 'the Sieve of Eratosthenes' algorithm
def primes():
    yield 2

    it = odd_num()
    while True:
        num = next(it)
        yield num

        it = filter(not_divisible(num), it)


if __name__ == "__main__":
    for n in primes():
        if n < 1000:
            print(n)
        else:
            break
