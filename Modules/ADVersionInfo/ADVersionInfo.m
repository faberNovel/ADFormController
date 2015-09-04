@interface ADVersionInfo : NSObject
@end

@implementation ADVersionInfo
+ (void)load {
    if ([[[UIDevice currentDevice] name] hasSuffix:@"DEBUG"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_displayVersionInfo:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
}

+ (void)_displayVersionInfo:(NSNotification *)notification {
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];

    NSString * bundleVersion = infoDict[@"CFBundleVersion"];
    NSString * gitCommit = infoDict[@"CFBundleGitCommit"];
    NSString * gitBranch = infoDict[@"CFBundleGitBranch"];
    NSString * gitStatus = infoDict[@"CFBundleGitStatus"];
    NSString * buildDate = [NSString stringWithFormat:@"%s", __DATE__];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Build Infos"
                                                         message:[NSString stringWithFormat:@"V. %@, built %@ | Commit %@ on %@ | Status %@", bundleVersion, buildDate, gitCommit, gitBranch, gitStatus]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertView show];
}
@end
