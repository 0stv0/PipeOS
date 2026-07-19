#include <unistd.h>
#include <string.h>

#define DB_VERSION "0.1"

static void print(const char *s) {
	write(1, s, strlen(s));
}

static void print_usage(void) {
	print("usage:\n");
	print("db --version\n");
	print("db --create <id> [type] [port]\n");
	print("db --list\n");
	print("db --start <id>\n");
	print("db --stop <id>\n");
}

static void cmd_version() {
	print("DB Module v" DB_VERSION "\n");
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
