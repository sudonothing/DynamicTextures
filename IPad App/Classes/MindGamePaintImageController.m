//
//  MindGamePaintImageController.m
//  
//
//  Created by Roman Smirnov on 01.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MindGamePaintImageController.h"
#import "KidsPaintAppDelegate.h"
#import "BookManager.h"
#import "Constants.h"
#import "PictureShower.h"

#define EDIT_MODE 0
#define GAME_MODE 1

//#import "MFMailComposeViewController.h"

@implementation MindGamePaintImageController

@synthesize perfectImage;
@synthesize numberOfAreas;

@synthesize areasDictEditMode = _areasDictEditMode;
//@synthesize areasDictGameMode = _areasDictGameMode;

//
//- (NSMutableDictionary *)areasDictEditMode {
//    if (!areasDictEditMode) {
//        areasDictEditMode = [NSMutableDictionary dictionary];
//        [areasDictEditMode retain];
//    }
//    return areasDictEditMode;
//}
//
- (NSMutableDictionary *)areasDictGameMode {
    if (!areasDictGameMode) {
        areasDictGameMode = [NSMutableDictionary dictionary];
        [areasDictGameMode retain];
    }
    return areasDictGameMode;
}

//- (void) viewDidLoad {
//    [super viewDidLoad];
//    BookManager *bm = [BookManager sharedInstance];
//    
//    self.currentPage = [bm pageNumber:4 InBook:[bm bookNumber:0]];
//}


- (void)restoreImageBookNumber:(int)booknumber PageNumber:(int)pagenumber
{
//    
//    [paintingView erase];
//    
//    
//    
//    //    KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
//    
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    //    NSLog(@"paths are %@", paths);
//    
//	NSString *documents = [[paths objectAtIndex:0] retain];
//    
//    //    NSLog(@"documents are %@", documents);
//    
//    //    NSLog(@"app.selectedImegename is%@", app.selectedImageName);
//    
//    
//    //	NSString* filePath = [NSString stringWithFormat:@"%@/Book1/SavedData/%@.png", documents, app.selectedImageName];
//    //    NSString* filePath = [NSString stringWithFormat:@"%@/Book1/SavedData/%@.png", documents, app.selectedImageName];
//    NSString *filePath = [NSString stringWithFormat:@"%@/SavedData/editor/book%d/%d.png", documents, booknumber, pagenumber];
//    
//    
//	
//	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//	
//	if (imagePathExists)
//	{
//		UIImage* imageToAdd = [UIImage imageWithContentsOfFile:filePath];
//        UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
//		UIImageView* imageView   = [[UIImageView alloc] initWithImage:imageToAdd];
//		
//		[containerView addSubview:imageView];
//		[imageView release];
//		
//        
//		UIImage* blendedImage = nil;
//		UIGraphicsBeginImageContext(containerView.frame.size);
//		[containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
//		blendedImage = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//		[containerView release];
//        
//        
//		[paintingView setImage:blendedImage];
//        //        NSLog(@"PaintImageController: end of [paintingView setImage:blendedImage]");
//	} else {
//        NSLog(@"EditorPaintImageController: failed to restore image. Path %@ does not exist.", filePath);
//    }
// 
}

- (void)restoreDictionaryBookNumber:(int)booknumber PageNumber:(int)pagenumber
{
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [[paths objectAtIndex:0] retain];
    NSString *filePath = [NSString stringWithFormat:@"%@/SavedData/editor/book%d/%d", documents, booknumber, pagenumber];
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (imagePathExists)
	{
        self.areasDictEditMode = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        paintedAreas = [[self.areasDictGameMode valueForKey:@"areascount"] intValue];
	} else {
        NSLog(@"MindGamePaintImageController: failed to restore dictionary. Path %@ does not exist.", filePath);
    }
    
}



- (void)viewDidLoad {
    
    
//    [super viewDidLoad];

    
    //    NSLog(@"PIC: ViewDidLoad");
	
	KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
	[app HideMainNavigationBar];
	
	// Erase the view when recieving a notification named "shake" from the NSNotificationCenter object
	// The "shake" nofification is posted by the PaintingWindow object when user shakes the device
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"shake" object:nil];
	
    UIColor* tempColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"FlowCoverBack.png"]];
    
    
	self.view.backgroundColor = tempColor;
	[tempColor release]; 
    
	[self selectInitialImage];
	
	//UIImage* selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", app.selectedImageName]];
	
	UIImage* selectedImage;
    //	NSString* imagePath = [NSString stringWithFormat:@"%@/Book1/%@.png", [[NSBundle mainBundle] resourcePath], app.selectedImageName];
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    int booknumber = [defaults integerForKey:@"lastViewedBook"];
    //    NSString *key = [NSString stringWithFormat:@"lastViewedPageForBook%d", booknumber];
    //    int pagenumber = [defaults integerForKey:key];
    int booknumber = self.currentBook.number;
    int pagenumber = self.currentPage.number;    
    NSString* imagePath = [NSString stringWithFormat:@"%@/books/book%d/images/%d.png", [[NSBundle mainBundle] resourcePath], booknumber, pagenumber];
    
    //    NSLog(@"paintImageController: restored defaults: lastViewedBook = %d, lastViewedPage = %d", booknumber, pagenumber);
    //    NSLog(@"paintImageController: imagePath is: %@", imagePath);
    
	
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
	
	if (imagePathExists)
	{
		selectedImage = [UIImage imageWithContentsOfFile:imagePath];
	}
	
	// Отступ верхнего левого угла бумаги для рисования
	CGFloat imageOriginX = 184; //134;
	CGFloat imageOriginY = 100; //148;
	
	// Добавляем фон с выбранной картинкой (рисуют на view выше фона)
	selectedImage = [self addTextureToImage:[UIImage imageNamed:@"paperTexture1.png"] selectedImage:selectedImage];
	paintingViewBg = [[UIImageView alloc] initWithImage:selectedImage];
	paintingViewBg.frame = CGRectMake(imageOriginX, imageOriginY, selectedImage.size.width, selectedImage.size.height);
    //#define IMAGE_SIZE_X 560
    //#define IMAGE_SIZE_Y 800
    //    paintingViewBg.frame = CGRectMake(imageOriginX, imageOriginY, IMAGE_SIZE_X, IMAGE_SIZE_Y);
    
	[self.view insertSubview:paintingViewBg atIndex:0];
	[paintingViewBg release];
    
	// Это view, на котором рисуют
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MindGamePaintingView" owner:self options:nil];
	paintingView = [topLevelObjects objectAtIndex:0];
    paintingView.delegate = self;
	paintingView.frame = CGRectMake(imageOriginX, imageOriginY, selectedImage.size.width, selectedImage.size.height);
	[paintingView initDefaults:selectedImage];
	[paintingView setBrushColorWithRed:1.0 green:0.0 blue:0.0];
	
	// Слой полупрозрачный, иначе не увидим фоновую картинку
    //	paintingView.alpha = kPaintingViewAlpha;
    
    //загружаем области рисования из файла
    [paintingView loadAreasFromFileForBookNumber:booknumber Page:pagenumber];
    
	[self.view insertSubview:paintingView atIndex:1];
    
    [paintingView erase];    
//    [self restoreImageBookNumber:booknumber PageNumber:pagenumber];
    [self restoreDictionaryBookNumber:booknumber PageNumber:pagenumber];
	
	// А это view для выделения текущей активной области
	silhuetteView = [[SilhuetteView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginY, selectedImage.size.width, selectedImage.size.height)];
	[self.view insertSubview:silhuetteView atIndex:2];
	[silhuetteView release];
	
	// Добавляем тени от бумаги
	UIImageView* paperShadowHorizontal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperShadowHorizontal.png"]];
	paperShadowHorizontal.frame = CGRectMake(imageOriginX, imageOriginY+800, 560, 29);
	[self.view insertSubview:paperShadowHorizontal atIndex:3];
	[paperShadowHorizontal release];
	
	UIImageView* paperShadowVertical = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paperShadowVertical.png"]];
	paperShadowVertical.frame = CGRectMake(imageOriginX + 560, imageOriginY + 10, 22, 828);
	[self.view insertSubview:paperShadowVertical atIndex:3];
	[paperShadowVertical release];
	
	// Добавляем "кнопку" поверх картинки
	UIImage* pinImage = [UIImage imageNamed:@"pin.png"];
	pinView = [[UIImageView alloc] initWithImage:pinImage];
	pinView.frame = CGRectMake(imageOriginX + 270, imageOriginY - 10, pinImage.size.width, pinImage.size.height);
	[self.view addSubview:pinView];
	[pinView release];
	
    //инициализируем карандаши
    [self initPencils];
    
	// Настраиваем slider выбора размера кисти
	brushSizeSlider.minimumValue = brushMinSize;
	brushSizeSlider.maximumValue = brushMaxSize;
	brushSizeSlider.continuous = NO;
	
	UIImage* thumbImage = [UIImage imageNamed:@"thumbSlider.png"];
	[brushSizeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
	[brushSizeSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
	
	UIImage* trackImage = [UIImage imageNamed:@"sliderTrack"];
	[brushSizeSlider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
	[brushSizeSlider setMaximumTrackImage:trackImage forState:UIControlStateNormal];
    
    colorPickerController = [[ColorPickerViewController alloc] init];
    
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        brushSizeSlider.value = [defaults floatForKey:@"brushSize"];
        if (brushSizeSlider.value == 0) {
            brushSizeSlider.value = brushDefaultSize;
            [defaults setFloat:brushDefaultSize forKey:@"brushSize"];        
            [defaults synchronize];
        }
        
        //		brushSizeSlider.value = brushInitialSizeSimple;
		[brushSizeSlider setEnabled:NO];
        
        
        //        [paintModeButton setTitle: @"Заливка" forState: UIControlStateNormal];
        UIImage *buttonImage = [UIImage imageNamed:@"PaintModeFill"];
        [paintModeButton setImage:buttonImage forState:UIControlStateNormal];
        
        brushSizeSlider.alpha = 0;
        sliderImage.alpha = 0;
        [self setColorCirclesColorsRed:1.0 Green:0.0 Blue:0.0 Alpha:0.0];  
    
    
	// Выбираем начальный карандаш
    defaultPencil = [self.pencils objectAtIndex:2];
    [self pencilClicked:defaultPencil];
    
    [nextButton setImage:[UIImage imageNamed:@"next_disabled"] forState:UIControlStateDisabled];
    [prevButton setImage:[UIImage imageNamed:@"prev_disabled"] forState:UIControlStateDisabled];
    
	[paintingView becomeFirstResponder];
    
}



- (IBAction)exitPaintImage:(id)sender
{
//	KidsPaintAppDelegate* app = [KidsPaintAppDelegate SharedAppDelegate];
//    
////    UIImage* viewImage = [paintingView imageRepresentation];
////    [app saveCurrentImage:viewImage BookNumber:self.currentBook.number PageNumber:self.currentPage.number];
//        
//	[app goBack];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)checkResultPressed:(id)sender
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Result"
//                                                        message: @"Your score is: 9999"
//                                                       delegate: nil
//                                              cancelButtonTitle: @"Cancel"
//                                              otherButtonTitles: nil];
//    [alertView show];

    // First get the image into your data buffer
    CGImageRef imageRef = [self.perfectImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    //        int byteIndex = (bytesPerRow * 1) + 1 * bytesPerPixel;
    
//    int counter = 1;
//    
//    static int areasOfPixelsInt[560][800];
    
    
    UIImage* realImage = [paintingView imageRepresentation];
    
    CGImageRef realImageRef = [realImage CGImage];
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *realRawData = malloc(height * width * 4);

    
    context = CGBitmapContextCreate(realRawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), realImageRef);
    CGContextRelease(context);

//        for (int j = 0; j < 800; j++)
//        for (int i = 0 ; i < 560; i++)
//            
//        {
//            CGFloat red   = (rawData[bytesPerPixel * (j * 560 + i)]     * 1.0) / 255.0;
//            CGFloat green = (rawData[bytesPerPixel * (j * 560 + i) + 1] * 1.0) / 255.0;
//            CGFloat blue  = (rawData[bytesPerPixel * (j * 560 + i) + 2] * 1.0) / 255.0;
//            CGFloat alpha = (rawData[bytesPerPixel * (j * 560 + i) + 3] * 1.0) / 255.0;
//
//            CGFloat realred   = (realRawData[bytesPerPixel * (j * 560 + i)]     * 1.0) / 255.0;
//            CGFloat realgreen = (realRawData[bytesPerPixel * (j * 560 + i) + 1] * 1.0) / 255.0;
//            CGFloat realblue  = (realRawData[bytesPerPixel * (j * 560 + i) + 2] * 1.0) / 255.0;
//            CGFloat realalpha = (realRawData[bytesPerPixel * (j * 560 + i) + 3] * 1.0) / 255.0;
//            
////            NSLog(@"diff of color of (%d, %d) = (%f, %f, %f, %f))", i, j, realred - red, realgreen - green, realblue - blue, realalpha - alpha);
//        }   
}

- (int) numberOfAreas
{
    
//    int retValue;
    NSMutableSet *set = [NSMutableSet set];
    
    for (int i=0; i<560; i++)
        for (int j=0; j<560; j++) {
            int areaint = paintingView->areas[i][j];
            NSNumber *area = [NSNumber numberWithInt:areaint];
            if (areaint != UNPAINTED_AREA_NUMBER && areaint != BLACK_AREA_NUMBER) {
                if (![set containsObject:area]) {
                    [set addObject:area];
                }
            }
        }
    
    NSLog(@"[set count] = %d", [set count]);
    return [set count];
}

- (BOOL)isAllAreasPainted{
    BOOL retValue = YES;

    int count = [[self.areasDictEditMode objectForKey:@"areascount"] intValue];
    NSLog(@"edit mode count = %d", count);
    for (int i=0; i<count; i++) {
        NSNumber *currentareanumber = [self.areasDictEditMode valueForKey:[NSString stringWithFormat:@"idForArea%d", i]];
        int currarea = [currentareanumber intValue];
        NSString *currentAreaPainted = [self.areasDictGameMode objectForKey:[NSString stringWithFormat:@"isArea%dPainted", currarea]];
        if (![currentAreaPainted isEqualToString:@"YES"]) {
            retValue = NO;
            break;
        }
    }
    
    NSLog(@"areas dictionary Game Mode is: %@", self.areasDictGameMode);
    
    return retValue;
}

- (float)calculateGameResult {
    
    int numberOfRightColors = 0;
    
    
    
    int count = [[self.areasDictEditMode objectForKey:@"areascount"] intValue];
    NSLog(@"count = %d", count);
    NSLog(@"edit dict = %@", self.areasDictEditMode);
    NSLog(@"game dict = %@", self.areasDictGameMode);
    for (int i=0; i<count; i++) {
        NSNumber *currentareanumber = [self.areasDictEditMode valueForKey:[NSString stringWithFormat:@"idForArea%d", i]];
        int currarea = [currentareanumber intValue];
        
        NSNumber *redPlayer = [self.areasDictGameMode objectForKey:[NSString stringWithFormat:@"Area%dRed", currarea]];
        NSNumber *greenPlayer = [self.areasDictGameMode objectForKey:[NSString stringWithFormat:@"Area%dGreen", currarea]];
        NSNumber *bluePlayer = [self.areasDictGameMode objectForKey:[NSString stringWithFormat:@"Area%dBlue", currarea]];

        NSNumber *redSample = [self.areasDictEditMode objectForKey:[NSString stringWithFormat:@"Area%dRed", currarea]];
        NSNumber *greenSample = [self.areasDictEditMode objectForKey:[NSString stringWithFormat:@"Area%dGreen", currarea]];
        NSNumber *blueSample = [self.areasDictEditMode objectForKey:[NSString stringWithFormat:@"Area%dBlue", currarea]];
        
        if ( (fabsf( [redPlayer floatValue] - [redSample floatValue] ) < 0.05)  &&
            (fabsf( [greenPlayer floatValue] - [greenSample floatValue] ) < 0.05)  &&
            (fabsf( [bluePlayer floatValue] - [blueSample floatValue] ) < 0.05) ) 
        {
            numberOfRightColors++;
        }
    }
        
        return (float)numberOfRightColors/(float)count * 100.0f;
}

- (void)processPaintingOfArea:(int)areanumber withRed:(float)red Green:(float)green Blue:(float)blue{

        NSString *areaAlreadyPainted = [self.areasDictGameMode valueForKey:[NSString stringWithFormat:@"isArea%dPainted", areanumber]];
        if (![areaAlreadyPainted isEqualToString:@"YES"]) {
            [self.areasDictGameMode setValue:@"YES" forKey:[NSString stringWithFormat:@"isArea%dPainted", areanumber]];
            [self.areasDictGameMode setValue:[NSString stringWithFormat:@"%d", areanumber] forKey:[NSString stringWithFormat:@"idForArea%d",paintedAreas]];
            paintedAreas++;
            [self.areasDictGameMode setValue:[NSNumber numberWithInt:paintedAreas] forKey:@"areascount"];
        }
        
        NSNumber *rednumber = [NSNumber numberWithFloat:paintingView->lastSetRed];
        NSNumber *greennumber = [NSNumber numberWithFloat:paintingView->lastSetGreen];
        NSNumber *bluenumber = [NSNumber numberWithFloat:paintingView->lastSetBlue];
        
        [self.areasDictGameMode setValue:rednumber forKey:[NSString stringWithFormat:@"Area%dRed", areanumber]];
        [self.areasDictGameMode setValue:greennumber forKey:[NSString stringWithFormat:@"Area%dGreen", areanumber]];
        [self.areasDictGameMode setValue:bluenumber forKey:[NSString stringWithFormat:@"Area%dBlue", areanumber]];

        
        if ([self isAllAreasPainted]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Result"
                                                message: [NSString stringWithFormat:@"Correct %f percents", [self calculateGameResult]]
                                                delegate: self
                                        cancelButtonTitle: @"Next Image"
                                        otherButtonTitles: nil];
            [alertView show];
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"blah");
    
    
     
    

    
    
    PictureShower *ps = [[PictureShower alloc] init];
    
    BookManager *bm = [BookManager sharedInstance];

    int newbook = self.currentBook.number;
    int newpage = self.currentPage.number + 1;
    if (newpage > 4) {
        newpage = 0;
        newbook++;
    }
    if (newbook > 3) {
        newbook = 0;
        newpage = 0;
    }
    
    ps.currentBook = [bm bookNumber:newbook];
    ps.currentPage = [bm pageNumber:newpage InBook:ps.currentBook];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [[paths objectAtIndex:0] retain];
    NSString *filePath = [NSString stringWithFormat:@"%@/SavedData/editor/book%d/%d.png", documents, newbook, newpage];
	BOOL imagePathExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (imagePathExists)
	{
        ps.perfectImage = [UIImage imageWithContentsOfFile:filePath];
	} else {
        NSLog(@"MindGamePaintImageController: failed to restore image. Path %@ does not exist.", filePath);
    }

    
    UIViewController *RootController = [self.navigationController.viewControllers objectAtIndex:0];
    
    NSArray *stack = [NSArray arrayWithObjects:RootController, ps, nil];
    [self.navigationController setViewControllers:stack];
}

- (IBAction)emailPressed {
    
    if (self.numberOfAreas != paintedAreas) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Warning"
                                                            message: @"Not all areas are painted"
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
    } else {
    
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        // Set the subject of email
        [picker setSubject:[NSString stringWithFormat: @"Let's color sample book %d page %d", self.currentBook.number, self.currentPage.number]];
        
        // Add email addresses
        // Notice three sections: "to" "cc" and "bcc"	
        [picker setToRecipients:[NSArray arrayWithObject:@"rs@aplica.ru"]];
    //    [picker setCcRecipients:[NSArray arrayWithObject:@"emailaddress3@domainName.com"]];	
    //    [picker setBccRecipients:[NSArray arrayWithObject:@"emailaddress4@domainName.com"]];
        
        // Fill out the email body text
        NSString *emailBody = @"I just took this picture, check it out.";
        
        // This is not an HTML formatted email
        [picker setMessageBody:emailBody isHTML:NO];
        
        
       
        UIImage* imageToAdd = [paintingView imageRepresentation];
    //    UIImage* imageToAdd = paintingViewBg.image;
        UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        UIImageView* imageView   = [[UIImageView alloc] initWithImage:imageToAdd];
        
        [containerView addSubview:imageView];
        [imageView release];
        
        
        UIImage* blendedImage = paintingViewBg.image;
        UIGraphicsBeginImageContext(containerView.frame.size);
    //    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
        [paintingViewBg.image drawInRect:CGRectMake(0, 0, paintingViewBg.image.size.width, paintingViewBg.image.size.height)];
        [imageToAdd drawInRect:CGRectMake(0, 0, imageToAdd.size.width, imageToAdd.size.height)
//                     blendMode:nil
                     blendMode:kCGBlendModeNormal                 
                         alpha: paintingView.alpha];

        blendedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [containerView release];
        
        
        
        
        [paintingView setImage:blendedImage];

        NSData *data = UIImagePNGRepresentation(blendedImage);

        
        
        // Attach image data to the email
        // 'CameraImage.png' is the file name that will be attached to the email
        [picker addAttachmentData:data mimeType:@"image/png" fileName:@"CameraImage"];
        
    //    NSNumber *areascount = [NSNumber numberWithInt:[self numberOfAreas]];
    //    metadataDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: areascount, nil]
    //                                               forKeys:[NSArray arrayWithObjects: @"numberOfAreas", nil]];
    //    
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.areasDictEditMode
                                                                       format:NSPropertyListBinaryFormat_v1_0
                                                             errorDescription:nil];
        
        NSString *filename = [NSString stringWithFormat:@"mindGameInfoBook%dPage%d", self.currentBook.number, self.currentPage.number];
        [picker addAttachmentData:plistData mimeType:@"application/letscolor" fileName:filename];
        
        
        
        // Show email view	
        [self presentModalViewController:picker animated:YES];
        
        // Release picker
        [picker release];
        
    }
}

- (IBAction)modeChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    
    if (sender.selectedSegmentIndex == 0) {mode = EDIT_MODE; NSLog(@"mode = EDIT_MODE");};
    if (sender.selectedSegmentIndex == 1) {
        mode = GAME_MODE; 
        NSLog(@"mode = GAME_MODE");
        [paintingView erase];
    };
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    // Called once the email is sent
    // Remove the email view controller	
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc{
    self.areasDictEditMode = nil;
//    self.areasDictGameMode = nil;
    [self.areasDictGameMode release];
    [super dealloc];
}

@end