//
//  mClassViewController.m
//  mClass
//
//  Created by 김규완 on 10. 11. 30..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//  로그인 화면 입니다
//  ECS_CMS_USER

#import "LoginViewController.h"
#import "HTTPRequest.h"
#import "JSON.h"
#import "Utils.h"
#import "LoginProperties.h"
#import "AlertUtils.h"
#import "Constants.h"
#import "SmartLMSAppDelegate.h"
#import "iToast.h"

@implementation LoginViewController

@synthesize txtUserID;
@synthesize txtPassword;
@synthesize swSaveID;
@synthesize swAutoLogin;
@synthesize loginButton;
@synthesize loginProperties;
@synthesize versionLabel;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	
    [[iToast makeText:@"로그인페이지 입니다."] show];
    
    //버전 확인 및 출력
    versionLabel.text = [[SmartLMSAppDelegate sharedAppDelegate] version];
    
    
	//저장된 로그인 정보 가져오기
	loginProperties = [Utils loginProperties];
	
    //저장된 정보가 있으면
	if (loginProperties != nil) {
		NSLog(@"not nil");
		if ([loginProperties userID] != nil) {
			[txtUserID setText:[loginProperties userID]];
		}
		if ([loginProperties password] != nil) {
			[txtPassword setText:[loginProperties password]];
		}
		if ([loginProperties autoLogin]  != nil) {
			if ([[loginProperties autoLogin] isEqualToString:@"YES"]) {
				[swAutoLogin setOn:YES];
			} else {
				[swAutoLogin setOn:NO];
			}
		}
		if ([loginProperties saveUserID] != nil) {
			if ([[loginProperties saveUserID] isEqualToString:@"YES"]) {
				[swSaveID setOn:YES];
			} else {
				[swSaveID setOn:NO];
			}
		}
		
	} else {//없으면 초기화
		NSLog(@"nil");
		loginProperties = [[LoginProperties alloc] init];
	}
	
	[self.txtUserID setReturnKeyType:UIReturnKeyNext];
	[self.txtUserID setDelegate:self];//<UITextFieldDelegate> 구현객체에서 사용
	[self.txtPassword setReturnKeyType:UIReturnKeyGo];
	[self.txtPassword setDelegate:self];
	
	

    [super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	txtUserID = nil;
	txtPassword = nil;
	swSaveID = nil;
	swAutoLogin = nil;
	loginProperties = nil;
	spinner = nil;
}


- (void)dealloc {
	[txtUserID release];
	[txtPassword release];
	[swSaveID release];
	[swAutoLogin release];
	[loginProperties release];
	[spinner release];
    [super dealloc];
}

#pragma mark -
#pragma mark 메소드 구현

- (IBAction)loginButtonPressed:(id)sender {
	[txtUserID resignFirstResponder];
    [txtPassword resignFirstResponder];
	[self loginProcess];
	
}

//로그인 처리
- (void)loginProcess {
	/*request생성*/
	//접속할 주소 설정
	//NSString *url = [[[mClassAppDelegate sharedAppDelegate] serverUrl] stringByAppendingString:[[mClassAppDelegate sharedAppDelegate] loginUrl]];
	//NSString serverUrl = [[NSString alloc] initWithString:kServerUrl];
	//loginUrl = [[NSString alloc] initWithString:kLoginUrl];
	NSString *url = [kServerUrl stringByAppendingString:kLoginUrl];
    NSLog(@"url = %@", url);
	
	HTTPRequest *httpRequest = [[SmartLMSAppDelegate sharedAppDelegate] httpRequest];
	NSString *userID = self.txtUserID.text;
	NSString *password = self.txtPassword.text;
	
	//로그인 인디케이터 시작
	spinner = [[ProgressIndicator alloc] initWithLabel:@"로그인중..."];
	[spinner show];
	
	//POST로 전송할 데이터 설정
	NSDictionary *bodyObject = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"userid", password, @"passwd", nil];
	
    
	//통신완료 후 호출할 델리게이트 셀렉터 설정
	[httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
	
	//페이지 호출
	[httpRequest requestUrl:url bodyObject:bodyObject httpMethod:@"POST" withTag:nil];
    
    
    /* sync방식
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [httpRequest requestUrlSync:url bodyObject:bodyObject httpMethod:@"POST" error:error response:response];
    NSString *resultData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [self didReceiveFinished:resultData];
    */
    
	
	[spinner dismissWithClickedButtonIndex:0 animated:YES];
	
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if ([textField isEqual:txtUserID]) {
		[txtPassword becomeFirstResponder];
	} else {
		[textField resignFirstResponder];
		[self loginProcess];
	}
	
	
	return YES;
}

#pragma mark -
#pragma mark Connection Result Delegate
- (void)didReceiveFinished:(NSString *)result {
	NSLog(@"receiveData : %@", result);
	
	// JSON형식 문자열로 Dictionary생성
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	NSDictionary *jsonData = [jsonParser objectWithString:result];
	NSDictionary *userSession = (NSDictionary *)[jsonData objectForKey:@"userSession"];
	/*
	NSString *key;
	for (key in jsonData){
		NSLog(@"Key: %@, Value: %@", key, [jsonData valueForKey:key]);
	}
	for (key in userSession){
		NSLog(@"Key: %@, Value: %@", key, [userSession valueForKey:key]);
	}
	*/
	
	[jsonParser release];
	
	
	NSString *message = (NSString *)[userSession objectForKey:@"message"];
	NSString *resultStr = (NSString *)[userSession objectForKey:@"result"];
	//NSLog(@"message = %@", message);
	//NSLog(@"result = %@", resultStr);
	
	//로그인 성공이면
	if ([resultStr isEqualToString:@"success"]) {
	
		//이제 로그인 완료 후 설정데이타 저장
		LoginProperties *loginProp = [[LoginProperties alloc] init];
		
		[loginProp setUserID:txtUserID.text];
		[loginProp setPassword:txtPassword.text];
		
		if (swAutoLogin.on) {
			[loginProp setAutoLogin:@"YES"];
		} else {
			[loginProp setAutoLogin:@"NO"];
		}
		
		if (swSaveID.on) {
			[loginProp setSaveUserID:@"YES"];
		} else {
			[loginProp setSaveUserID:@"NO"];
		}
		[[SmartLMSAppDelegate sharedAppDelegate] setIsAuthenticated:YES];
        [[SmartLMSAppDelegate sharedAppDelegate] setAuthGroup:[userSession valueForKey:@"userKind"]];
        
        NSLog(@"userKind = %@", [[SmartLMSAppDelegate sharedAppDelegate] authGroup]);
		//로그인 설정 저장
		[Utils saveLoginProperties:loginProp];
		
        [[SmartLMSAppDelegate sharedAppDelegate] setAuthUserID:txtUserID.text];
		//페이지 전환
		[[SmartLMSAppDelegate sharedAppDelegate] switchMainView];
        
			
	} else {
		
		AlertWithMessage(message);
	}

	
	//spinner stop 없애기
	[spinner dismissWithClickedButtonIndex:0 animated:YES];
	
	//[self dismissModalViewControllerAnimated:YES];
	//NSLog(@"dismissModalViewController");
	
}

@end
