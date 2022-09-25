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


def reencrypt(password_store_dir=None, recipient=None, verbose=False):
    """Decrypt password-store"""

    # retrieve *.gpg files
    files = glob.glob("%s/**/*.gpg" % password_store_dir, recursive = True)
    for gpg_file in files:
        # decrypt
        cmd = "gpg --decrypt %s" % gpg_file
        (errno, cleartext, stderrdata) = system(cmd)
        if errno != 0:
            print(stderrdata)
            sys.exit(1)

        # encrypt with new GPG key email
        cmd = "gpg --quiet --yes --output %s --encrypt --recipient %s" % (gpg_file, recipient)
        (errno, stdoutdata, stderrdata) = system(cmd, input=cleartext)
        if errno != 0:
            print(stderrdata)
            sys.exit(1)

        print(gpg_file)

        # show encryption details
        if verbose:
            cmd = "gpg --list-packets %s" % gpg_file
            (errno, stdoutdata, stderrdata) = system(cmd, input=cleartext)
            print(stderrdata)
            print("--------------------------------------------------------------------------------")

if __name__ == '__main__':
    args = sys.argv[1:]
    parser = argparse.ArgumentParser(description="Mass Re-encrypt of Password Store")

    parser.add_argument("--reencrypt", metavar='EMAIL', help="Re-encrypt Password Store using GPG Email or ID")
    parser.add_argument("password_store_dir", metavar='DIR', help="Password Store directory")
    parser.add_argument("-v", "--verbose", action='store_true', help="Show GPG file details")

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

    if args.reencrypt:
        reencrypt(password_store_dir=args.password_store_dir, recipient=args.reencrypt, verbose=args.verbose)
    else:
        parser.print_help()
