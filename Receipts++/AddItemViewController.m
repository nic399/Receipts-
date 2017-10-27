//
//  AddItemViewController.m
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (strong, nonatomic, readwrite) NSArray *tagsArr;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagTableView.allowsMultipleSelection = true;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *requestTags = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:requestTags error:&error];
    if (!results) {
        NSLog(@"Error fetching Tag objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    self.tagsArr = results;
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)addReceiptPressed:(id)sender {
    Receipt *myReceipt = [[Receipt alloc] initWithContext:self.managedObjectContext];
    myReceipt.amount = [NSDecimalNumber decimalNumberWithString:self.amountField.text];
    myReceipt.note = self.descriptionTextView.text;
    myReceipt.timestamp = self.datePicker.date;
    NSArray<NSIndexPath *> *selectedTags =  self.tagTableView.indexPathsForSelectedRows;
    NSMutableSet *tagSet = [[NSMutableSet alloc] init];
    for (NSIndexPath *thisOne in selectedTags) {
        [tagSet addObject:[self.tagsArr objectAtIndex:thisOne.row]];
    }
    myReceipt.hasTag = tagSet;
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    [self cancelPressed:self];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)endEditingPressed:(id)sender {
    [self.view endEditing:true];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    return true;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tagTableView dequeueReusableCellWithIdentifier:@"tagCell" forIndexPath:indexPath];
    Tag *tag = [self.tagsArr objectAtIndex:indexPath.row];
    [self configureCell:cell withTag:tag];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagsArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Category";
}

- (void)configureCell:(UITableViewCell *)cell withTag:(Tag *)tag {
    cell.textLabel.text = tag.tagName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}










@end










































