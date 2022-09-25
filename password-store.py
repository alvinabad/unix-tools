#!/usr/bin/env python

import sys
import os
import glob
import shlex
import subprocess
import argparse

def system(cmd, input=None, tty=False, shell=False, donotsplit=False, bufsize=0):
    """
    Run a system command
    Input: cmd, input
    Returns tupple: (returncode, stdoutdata, stderrdata)
    returncode:
        - exit code of the system command
        - None if command has timed-out or command not found
    """

    if tty:
        if donotsplit or shell:
            pass
        else:
            cmd = shlex.split(cmd)

        error = 1
        try:
            error = subprocess.call(cmd, shell=shell)
        except KeyboardInterrupt:
            print("Keyboard Interrupt")
            error = 0
        except:
            raise "Error running system command."

        return error

    stdoutdata = ''
    stderrdata = ''

    if donotsplit or shell:
        pass
    else:
        cmd = shlex.split(cmd)

    try:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE,
                                   stdin=subprocess.PIPE, shell=shell, bufsize=bufsize)
    except OSError:
        # command not found
        raise "System command not found."

    try:
        (stdoutdata, stderrdata) = p.communicate(input=input)
        error_code = p.returncode
    except:
        p.kill()
        raise "Error running system command."

    return (error_code, stdoutdata.rstrip(), stderrdata.rstrip())


def decrypt(password_store_dir):
    """Decrypt password-store"""

    files = glob.glob("%s/**/*.gpg" % password_store_dir, recursive = True)
    for gpg_file in files:
        txt_file = gpg_file.replace('.gpg', '.txt')

        cmd = "gpg --output %s --decrypt %s" % (txt_file, gpg_file)
        (errno, stdoutdata, stderrdata) = system(cmd)
        if errno != 0:
            print(stderrdata)
            sys.exit(1)

        print(txt_file)

def encrypt(password_store_dir, recipient):
    """Decrypt password-store"""

    files = glob.glob("%s/**/*.txt" % password_store_dir, recursive = True)
    for txt_file in files:
        gpg_file = txt_file.replace('.txt', '.gpg')
        cmd = "gpg --yes --output %s --encrypt --recipient %s %s" % (gpg_file, recipient, txt_file)
        (errno, stdoutdata, stderrdata) = system(cmd)
        if errno != 0:
            print(stderrdata)
            sys.exit(1)

        print(gpg_file)
        os.remove(txt_file)


if __name__ == '__main__':
    args = sys.argv[1:]
    parser = argparse.ArgumentParser(description="Mass Decrypt/Encrypt of Password Store")

    parser.add_argument("-e", "--encrypt", metavar='EMAIL', help="Encrypt Password Store using GPG Email or ID")
    parser.add_argument("-d", "--decrypt", action='store_true', help="Decrypt Password Store")
    parser.add_argument("password_store_dir", metavar='DIR', help="Password Store directory")

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)

    try:
        args = parser.parse_args(args)
    except:
        print("Use -h for more help usage.")
        sys.exit(1)

    if not os.path.isdir(args.password_store_dir):
        print("ERROR: Not found: %s" % args.password_store_dir)
        sys.exit(1)

    if args.decrypt:
        decrypt(args.password_store_dir)
    elif args.encrypt:
        encrypt(args.password_store_dir, args.encrypt)
    else:
        parser.print_help()
