//
//  ViewController.m
//  KJEmitterView
//
//  Created by 杨科军 on 2018/11/26.
//  Copyright © 2018 杨科军. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+KJOverstep.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *sectionTemps;
@property(nonatomic, strong) NSMutableArray *temps;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionTemps = @[@"效果类",@"扩展类",@"CALayer类",@"自定义控件"];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTemps.count;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.temps[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size.height / 18.;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableViewCell"];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,dic[@"VCName"]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"describeName"];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor.blueColor colorWithAlphaComponent:0.5];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTemps[section];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = UIColor.redColor;
    header.textLabel.font = [UIFont boldSystemFontOfSize:14];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.temps[indexPath.section][indexPath.row];
    Class class = NSClassFromString(dic[@"VCName"]);
    BaseViewController *vc = [[class alloc]init];
    vc.title = dic[@"describeName"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy
- (NSMutableArray *)temps{
    if (!_temps) {
        _temps = [NSMutableArray array];
        NSMutableArray *temp0 = [NSMutableArray array];
        [temp0 addObject:@{@"VCName":@"KJReflectionVC",@"describeName":@"倒影处理"}];
        [temp0 addObject:@{@"VCName":@"KJShadowVC",@"describeName":@"内阴影相关"}];
        [temp0 addObject:@{@"VCName":@"KJShineVC",@"describeName":@"内发光处理"}];
        [temp0 addObject:@{@"VCName":@"KJFilterImageVC",@"describeName":@"滤镜相关和特效渲染"}];
        [temp0 addObject:@{@"VCName":@"KJCoreImageVC",@"describeName":@"CoreImage框架相关"}];
        
        NSMutableArray *temp1 = [NSMutableArray array];
        [temp1 addObject:@{@"VCName":@"KJButtonVC",@"describeName":@"Button图文布局点赞粒子"}];
        [temp1 addObject:@{@"VCName":@"KJViewVC",@"describeName":@"View快速切圆角"}];
        [temp1 addObject:@{@"VCName":@"KJSliderVC",@"describeName":@"Slider渐变色滑块"}];
        [temp1 addObject:@{@"VCName":@"KJTextViewVC",@"describeName":@"TextView设置限制字数"}];
        [temp1 addObject:@{@"VCName":@"KJFloodImageVC",@"describeName":@"填充同颜色区域图片"}];
        [temp1 addObject:@{@"VCName":@"KJIMageVC",@"describeName":@"加水印和拼接图片"}];
        [temp1 addObject:@{@"VCName":@"KJMathVC",@"describeName":@"数学方程式"}];
        
        NSMutableArray *temp2 = [NSMutableArray array];
        [temp2 addObject:@{@"VCName":@"KJEmiterLayerVC",@"describeName":@"图片粒子效果整理封装"}];
        [temp2 addObject:@{@"VCName":@"KJEmitterVC",@"describeName":@"粒子效果"}];
        [temp2 addObject:@{@"VCName":@"KJErrorVC",@"describeName":@"错误提示效果"}];
        
        NSMutableArray *temp3 = [NSMutableArray array];
        [temp3 addObject:@{@"VCName":@"KJAlertVC",@"describeName":@"两种AlertView"}];
        [temp3 addObject:@{@"VCName":@"KJSelectController",@"describeName":@"自定义动画选中控件"}];
        [temp3 addObject:@{@"VCName":@"KJSwitchVC",@"describeName":@"自定义动画Switch控件"}];
        [temp3 addObject:@{@"VCName":@"KJMarqueeLabelVC",@"describeName":@"跑马灯Label"}];
        [_temps addObject:temp0];
        [_temps addObject:temp1];
        [_temps addObject:temp2];
        [_temps addObject:temp3];
    }
    return _temps;
}

@end
