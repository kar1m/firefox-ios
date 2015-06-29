/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "FXCrashDetector.h"

static BOOL crashOccurred = NO;

@implementation FXCrashDetector

+ (BOOL)didWeCrash
{
    NSSetUncaughtExceptionHandler(&HandleException);

    struct sigaction signalAction;
    memset(&signalAction, 0, sizeof(signalAction));
    signalAction.sa_handler = &HandleSignal;

    sigaction(SIGABRT, &signalAction, NULL);
    sigaction(SIGILL, &signalAction, NULL);
    sigaction(SIGBUS, &signalAction, NULL);
    sigaction(SIGSEGV, &signalAction, NULL);

    BOOL crashed = crashOccurred;
    crashOccurred = NO;
    return crashed;
}

#pragma mark - Private Handlers

void HandleException(NSException *exception) {
    crashOccurred = YES;
}

void HandleSignal(int signal) {
    crashOccurred = YES;
}

@end
