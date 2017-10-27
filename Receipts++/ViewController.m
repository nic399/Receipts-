//
//  ViewController.m
//  Receipts++
//
//  Created by Nicholas Fung on 2017-10-26.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import "ViewController.h"
#import "AddItemViewController.h"
#import "Tag+CoreDataClass.h"
#import "Receipt+CoreDataClass.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic, readwrite) NSArray<Receipt *> *receiptsArr;
@property (strong, nonatomic, readwrite) NSArray<Tag *> *tagsArr;
@property (strong, nonatomic, readwrite) NSMutableArray<NSMutableArray *> *dataSourceArr;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSourceArr = [NSMutableArray new];
    // Check if any Tag objects exist
    self.navigationItem.title = @"My Receipts";
    [self seedInitialData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDataArray];
    [self.tableView reloadData];
}

-(void)refreshDataArray {
    NSFetchRequest *requestTags = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:requestTags error:&error];
    if (!results) {
        NSLog(@"Error fetching Tag objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    self.tagsArr = results;
    [self setUpTableSectionData];
}

-(void)setUpTableSectionData {
    self.dataSourceArr = [NSMutableArray new];
    for (int tagIndex = 0; tagIndex < self.tagsArr.count; tagIndex++) {
        self.dataSourceArr[tagIndex] = [NSMutableArray new];
        NSFetchRequest *requestReceipts = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"tagName == %@", self.tagsArr[tagIndex].tagName];
        [requestReceipts setPredicate:myPredicate];
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:requestReceipts error:&error];
        if (!results) {
            NSLog(@"Error fetching Tag objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        Tag *thisTag = [results firstObject];
        for (Receipt *thisReceipt in thisTag.receiptHasTag) {
            [self.dataSourceArr[tagIndex] addObject:thisReceipt];
        }
        self.dataSourceArr[tagIndex] = [[self.dataSourceArr[tagIndex] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        
        NSLog(@"Tag name: %@\nNumber of receipts for that tag: %ld",self.tagsArr[tagIndex].tagName, self.dataSourceArr[tagIndex].count);
    }
    
    
    
    
    
    
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toAddReceiptPressed:(id)sender {
    [self performSegueWithIdentifier:@"toAddReceipt" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddItemViewController *destination = segue.destinationViewController;
    destination.managedObjectContext = self.managedObjectContext;
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tagsArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    NSArray *sectionArr = self.dataSourceArr[indexPath.section];
    Receipt *receipt = sectionArr[indexPath.row];
    [self configureCell:cell withReceipt:receipt];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.managedObjectContext;
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.tagsArr objectAtIndex:section].tagName;
}
- (void)configureCell:(UITableViewCell *)cell withReceipt:(Receipt *)receipt {
    cell.textLabel.text = receipt.note;
    cell.detailTextLabel.text = [receipt.amount stringValue];
}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *completed = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"Done" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        Receipt *receipt = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        NSError *error = nil;
//        if (![context save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//            abort();
//        }
//    }];
//    completed.backgroundColor = [UIColor greenColor];
//
//    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        //        [self.objects removeObjectAtIndex:indexPath.row];
//        //        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
//
//    }];
//
//
//    return @[completed, delete];
//}



//#pragma mark - Fetched results controller
//
//- (NSFetchedResultsController<Receipt *> *)fetchedResultsController {
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    
//    NSFetchRequest<Receipt *> *fetchRequest = Receipt.fetchRequest;
//    
//    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
//    
//    // Edit the sort key as appropriate.
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"note" ascending:NO];
//    
//    [fetchRequest setSortDescriptors:@[sortDescriptor]];
//    
//    // Edit the section name key path and cache name if appropriate.
//    // nil for section name key path means "no sections".
//    NSFetchedResultsController<Receipt *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Receipt"];
//    aFetchedResultsController.delegate = self;
//    
//    NSError *error = nil;
//    if (![aFetchedResultsController performFetch:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//    
//    _fetchedResultsController = aFetchedResultsController;
//    return _fetchedResultsController;
//}
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        default:
//            return;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath {
//    UITableView *tableView = self.tableView;
//    
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withReceipt:anObject];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withReceipt:anObject];
//            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView endUpdates];
//}


- (void)seedInitialData {
    NSFetchRequest *requestTags = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:requestTags error:&error];
    if (!results) {
        NSLog(@"Error fetching Tag objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    // Create standard tags if they don't already exist
    if (results.count == 0) {
        Tag *business = [[Tag alloc] initWithContext:self.managedObjectContext];
        business.tagName = @"Business";
        Tag *family = [[Tag alloc] initWithContext:self.managedObjectContext];
        family.tagName = @"Family";
        Tag *personal = [[Tag alloc] initWithContext:self.managedObjectContext];
        personal.tagName = @"Personal";
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        results = [self.managedObjectContext executeFetchRequest:requestTags error:&error];
        if (!results) {
            NSLog(@"Error fetching Tag objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }
    
    NSFetchRequest *requestReceipts = [NSFetchRequest fetchRequestWithEntityName:@"Receipt"];
    NSArray *receiptsArr = [self.managedObjectContext executeFetchRequest:requestReceipts error:&error];
    if (!receiptsArr) {
        NSLog(@"Error fetching Tag objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    if (receiptsArr.count == 0) {
        Receipt *r1 = [[Receipt alloc] initWithContext:self.managedObjectContext];
        r1.amount = [[NSDecimalNumber alloc] initWithString:@"12.34"];
        r1.note = @"Receipt 1 note";
        r1.timestamp = [NSDate date];
        NSMutableSet<Tag *> *r1set = [[NSMutableSet alloc] initWithObjects:results[0], results[1], results[2], nil];
        r1.hasTag = r1set;
        
        Receipt *r2 = [[Receipt alloc] initWithContext:self.managedObjectContext];
        r2.amount = [[NSDecimalNumber alloc] initWithString:@"23.45"];
        r2.note = @"Receipt 2 note";
        r2.timestamp = [NSDate dateWithTimeIntervalSinceNow:24*60*60*4];
        NSMutableSet<Tag *> *r2set = [[NSMutableSet alloc] initWithObjects:results[0], nil];
        r2.hasTag = r2set;
        
        Receipt *r3 = [[Receipt alloc] initWithContext:self.managedObjectContext];
        r3.amount = [[NSDecimalNumber alloc] initWithString:@"34.56"];
        r3.note = @"Receipt 3 note";
        r3.timestamp = [NSDate dateWithTimeIntervalSinceNow:24*60*60*9];
        NSMutableSet<Tag *> *r3set = [[NSMutableSet alloc] initWithObjects: results[2], nil];
        r3.hasTag = r3set;
        
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

@end
