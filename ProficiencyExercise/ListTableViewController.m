
#import "ListTableViewController.h"
#import "CustomListTableViewCell.h"
#import "Constant.h"
#import "APIManager.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/UIImageView+WebCache.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ListTableViewController ()

@property(strong,nonatomic) NSDictionary *listDataDictionary;

@end

@implementation ListTableViewController


/* 
 Initialisation method for UITable View
 */
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = PLACEHOLDER_SCREEN_TITLE;
        
    }
    return self;
}

#pragma mark -- System Methods --
/*
 Initialisation method for UITable View
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Initialise view data to show the contents on screen
    [self initializeViewData];
}

/*
 Method to show memory warnings if any.
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- System Methods --
/*
 Method to notify that system just laid out its subviews
 */

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView layoutSubviews];
}

/*
 Method to initialise request for contents to be shown in tableview
 */

-(void)initializeViewData{
    //Registering the class so that it is ready for use
    [self.tableView registerClass:[CustomListTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    //Calling method fetch and parse the response
    [self downloadDataInBackground];
}

/*
 * Method to call REST API using WEBSERVICE_URL so as to start download of the data and
 * return the response in NSdictionary format.
 */

-(void)downloadDataInBackground{
    
    // create a dispatch queue with string and NULL argument
    dispatch_queue_t parsingQueue = dispatch_queue_create("parsingQueue", NULL);
    
    // execute a task on that queue asynchronously
    dispatch_async(parsingQueue, ^{
        
        //APIManager class will manage sending REST API request to server and it will return response
        APIManager *api = [[APIManager alloc] init];
        
        //getJsonResponse method will take Webservice URL as parameter and it will return response in NSdictionary format
        [api getJsonResponse:WEBSERVICE_URL success:^(NSDictionary *responseDict) {
            
            self.listDataDictionary = [NSDictionary dictionaryWithDictionary:responseDict];
            self.title              = [self.listDataDictionary objectForKey:TITLE_DICTIONARY_KEY];

            // once this is done, if you need to you can call
            // some code on a main thread (delegates, notifications, UI updates...)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
            
            
        } failure:^(NSError *error) {
            //        error handling for the
        }];
        
    });
}


#pragma mark - Table view data source
/*
 * TableView Data Source method to specify number of Rows to be shown in Sections in TableView
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.listDataDictionary objectForKey:ROWS_DICTIONARY_KEY] count];
}

/*
 * TableView Data Source method to specify contents to be shown in TableView
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Reuse identifier so that on screen cell will be reused for updated contents
    CustomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Get selected response in array format so that it will be rendered on tableview cells
    NSArray *dataArray = [self.listDataDictionary objectForKey:ROWS_DICTIONARY_KEY];
    //Fetching data to be shown in relative tableview cells
    NSDictionary *listDictionary = [dataArray objectAtIndex:indexPath.row];
    
    //Checking if response data has null/nil values, Adding contents to the titleLabel
    if(![[listDictionary objectForKey:TITLE_DICTIONARY_KEY] isEqual:[NSNull null]] && [listDictionary objectForKey:TITLE_DICTIONARY_KEY] != nil)
        cell.titleLabel.text = [listDictionary objectForKey:TITLE_DICTIONARY_KEY];

    //Checking if response data has null/nil values, Adding contents to the descriptionLabel
    if(![[listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY] isEqual:[NSNull null]] && [listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY] != nil)
        cell.descriptionLabel.text = [listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY]?[listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY]:@"";

    //Checking if response data has null/nil values, Adding response image to the imageView
    if(![[listDictionary objectForKey:IMAGE_DICTIONARY_KEY] isEqual:[NSNull null]])
        [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:[listDictionary objectForKey:IMAGE_DICTIONARY_KEY]]
                      placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_KEY]];


    return cell;
}

/*
 * TableView method to specify height of uitableviecell contents to be shown in TableView
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *dataArray            = [self.listDataDictionary objectForKey:ROWS_DICTIONARY_KEY];
    NSDictionary *listDictionary  = [dataArray objectAtIndex:indexPath.row];
    
    //Basic margin height at top and bottom
    CGFloat height = 30;
    
    //Checking if response data has null/nil values, Adding contents to the titleLabel
    if(![[listDictionary objectForKey:TITLE_DICTIONARY_KEY] isEqual:[NSNull null]] && [listDictionary objectForKey:TITLE_DICTIONARY_KEY] != nil) {
        CGRect firstLabelSize = [[listDictionary objectForKey:TITLE_DICTIONARY_KEY] boundingRectWithSize:CGSizeMake(tableView.frame.size.width-60, 0)
                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                                                                     context:nil];
        height += firstLabelSize.size.height;
    }
    
    if(![[listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY] isEqual:[NSNull null]] && [listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY] != nil) {
        CGRect secondLabelSize = [[listDictionary objectForKey:DESCRIPTION_DICTIONARY_KEY] boundingRectWithSize:CGSizeMake(tableView.frame.size.width-60, 0)
                                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                                                                           context:nil];
        height += secondLabelSize.size.height;
    }
    
    
    return height;
}



@end
