#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>

int main(void) {
    while (1) {
        printk("Hello, Zephyr!\n");
        k_sleep(K_SECONDS(1));
    }
}