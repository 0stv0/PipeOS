#include <unistd.h>
#include <string.h>

#define PIPEOS_VERSION "0.1"

static void print(const char *s) {
	write(1, s, strlen(s));
}

static void print_usage(void) {
	print("usage:\n");
	print("pipeos --version\n");
	print("pipeos --create <id> <repo_url> [type]\n");
	print("pipeos --list\n");
	print("pipeos --start <id>\n");
	print("pipeos --stop <id>\n");
}

static void cmd_version(void) {
	print("PipeOS v" PIPEOS_VERSION "\n");
}

int main(int argc, char *argv[]) {
	if (argc < 2) {
		print_usage();
		return 1;
	}
	if (strcmp(argv[1], "--version") == 0) {
		cmd_version();
	} else {
		print("unknown option: ");
		print(argv[1]);
		print("\n");
		print_usage();
		return 1;
	}
}


