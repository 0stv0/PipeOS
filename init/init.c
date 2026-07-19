#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <string.h>

static void print(const char *s) {
	write(1, s, strlen(s));
}

int main(void) {
	print("[PipeOS] starting shell...\n");

	setsid();

	int fd = open("/dev/console", O_RDWR);
	if (fd >= 0) {
		ioctl(fd, TIOCSCTTY, 0);
		dup2(fd, 0);
		dup2(fd, 1);
		dup2(fd, 2);
		if (fd > 2) {
			close(fd);
		}
	}

	char *argv[] = { "/bin/bash", NULL };
	char *envp[] = { "PATH=/bin:/usr/bin", "HOME=/root", "TERM=linux", "PS1=sh> ", NULL };

	execve("/bin/bash", argv, envp);

	print("PipeOS init: failed to exec bash\n");
	while (1) {
		pause();
	}
	return 1;
}
