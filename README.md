CachedCells
===========

How to cache UITableView cells. Maybe you just don't want them to leave memory.

Apple's dequeueReusableCellWithIdentifier: does a great job at making your UITableView efficient. The majority of
the time, this is the correct approach. But what about those times where you want a relatively small number of very 
complex cells? Performance can take a hit when offscreen-rendering (software vs hardware drawing) takes place each time a cell is displayed. I 
needed this when I had cells that each contained a collection view whose items had additional drawing/image loading needs.

Offscreen-rendering can happen when you do one of the following:

- Implement drawRect: (even if it's empty!)
- shouldRasterize = YES;
- Add a mask or dropshadow
- Use a CGContext
- Change text (UILabel, CATextLayer, CoreText)

UITableViewCells are redrawn each time they are dequeued, which can cause a huge drop in scroll performance if software drawing is needed.

Want to know if your app is using offscreen drawing? Use Instruments! In Xcode, run the profiler and choose Core Animation.
While your app is running, find the box that says "Color Offscreen-Rendered Yellow"

![Instruments Image](http://i.imgur.com/Kynx8Tw.png)

```objective-c
@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *cells;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cells = [[NSMutableDictionary alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Don't create a new cell if your cell is already in memory. Return it from your dictionary of cells
    if ([self.cells objectForKey:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]]) {
        return [self.cells objectForKey:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    }
    
    //Register a new identifier for each cell to avoid dequeueReusableCellWithIdentifier: reusing an old one
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    //Do any additional cell setup here
    
    [self.cells setObject:cell forKey:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    
    return cell;
}


@end
```
