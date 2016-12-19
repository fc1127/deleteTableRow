//
//  ViewController.m
//  UITableViewEditDemo
//
//  Created by fc on 15/8/21.
//  Copyright (c) 2015年 LiuYaNan. All rights reserved.
//

#import "ViewController.h"

#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * dataArray; // 数据源 用来保存展示在表格上的数据
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 在导航栏上加系统的编辑按钮 来编辑tableView
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 初始化数据源  如果初始化 直接复制 数据源内是没有东西的
    dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray * deleteArray = [[NSMutableArray alloc] init];
    NSMutableArray * insertArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSString * numberStr = [NSString stringWithFormat:@"第%d行",i];
        [deleteArray addObject:numberStr];
    }
    for (int i = 10; i < 20; i++) {
        NSString * numberStr = [NSString stringWithFormat:@"第%d行",i];
        [insertArray addObject:numberStr];
    }
    
    [dataArray addObject:deleteArray];
    [dataArray addObject:insertArray];
    
  
}

#pragma mark -编辑按钮的事件
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // 默认editing 为NO  点击edit字样 editing置为YES 点击Done editing 置为NO
    [super setEditing:editing animated:animated];
    // 要想对tableView进行编辑 必须将tableView的可编辑性打开 编辑完成之后 要将可编辑性关闭
    [_tableView setEditing:editing animated:animated];
}

#pragma mark -协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 这样写 是为了 避免数组里面没有数据，防止在给表格赋值时发生崩溃现象
    //    如果这里返回为0，就不会再走创建cell的协议方法
    //    if (section == 0) {
    return [dataArray[section] count];
    //    }else {
    //        return [dataArray[section] count];
    //    }
    //    return dataArray.count > 0 ? dataArray.count : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    1.加标示符
    static NSString * cellName = @"cellName";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    /*
     如果一个界面 有两个tableView  而且tableView上的表格样式不一样，则需要定义两种表格，而且这两种表格的标示符要定为不一样的，这样他们复用时，不会发生冲突。。。。。。而且不同的tableView的复用池不一样，每个tableViewCell都有自己的复用池，复用池之间不会发生冲突
     
     */
    
    //    indexPath.row 代表某一行
    cell.textLabel.text = [dataArray[indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

// 要对tableView进行编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     UITableViewCellEditingStyleNone, 无效果
     UITableViewCellEditingStyleDelete, 删除
     UITableViewCellEditingStyleInsert 增加
     */
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleInsert;
    }
}

// 这个是提交编辑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除某一行
        [dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
        // 提交并刷新列表
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }else {
        NSString * numberStr = @"100";
        // 在第几行前面插入
        [[dataArray objectAtIndex:indexPath.section] insertObject:numberStr atIndex:indexPath.row];
        // 提交数据 刷新列表
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:
(NSIndexPath *)destinationIndexPath{
    //sourceIndexPath是要被移动的cell的位置
    //destinationIndexPath要被移动到的位置
    //1把要被移动的数据取出来
    NSString *numberstr=[[dataArray objectAtIndex:sourceIndexPath.section]objectAtIndex:sourceIndexPath.row];
    //2在数组的位置中移除掉
    [[dataArray objectAtIndex:sourceIndexPath.section]removeObjectAtIndex:sourceIndexPath.row];
    //3放到想要移动到的位置
    [[dataArray objectAtIndex:destinationIndexPath.section]insertObject:numberstr atIndex:destinationIndexPath.row];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















