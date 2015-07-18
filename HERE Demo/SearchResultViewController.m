#import "SearchResultViewController.h"
#import "Types.h"
#import "LocationSearch.h"

@interface SearchResultViewController ()

@property(nonatomic, copy) NSString *searchTerm;
@property(nonatomic) NSMutableArray *searchResults;

@end

@implementation SearchResultViewController


- (IBAction)searchFieldChanged:(UITextField *)sender
{
    NSString *searchTerm = [sender.text copy];

    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakSelf)
        {
            return;
        }
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (![searchTerm isEqualToString:sender.text])
        {
            return;
        }
        if ([searchTerm length] == 0)
        {
            return;
        }
        strongSelf.searchTerm = searchTerm;
        [strongSelf issueSearchRequestFor:searchTerm];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterFromKeyboardNotifications];
    self.searchTerm = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *location = self.searchResults[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultLocation"];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell.textLabel setText:location.label];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectLocation:self.searchResults[(NSUInteger) indexPath.row]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self issueSearchRequestFor:textField.text];
    return YES;
}

#pragma mark - Private

- (void)issueSearchRequestFor:(NSString *)searchTerm
{
    __weak __typeof(self) weakSelf = self;
    [LocationSearch searchFor:searchTerm done:^(NSArray *searchResults, NSString *requestedSearchTerm) {
        if (!weakSelf)
        {
            return;
        }
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (![requestedSearchTerm isEqualToString:strongSelf.searchTerm])
        {
            return;
        }
        [strongSelf.searchResults removeAllObjects];
        [strongSelf.searchResults addObjectsFromArray:searchResults];
        [strongSelf.resultsTable reloadData];
    }];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(keyboardWasShown:)
            name:UIKeyboardDidShowNotification object:nil];


   [[NSNotificationCenter defaultCenter] addObserver:self
             selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[notification userInfo][UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);

    self.resultsTable.contentInset = contentInsets;
    self.resultsTable.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.resultsTable.contentInset = contentInsets;
    self.resultsTable.scrollIndicatorInsets = contentInsets;
}

@end
