//
//  GXChooseAddressView.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseAddressView.h"
#import "SPPickerView.h"
#import "SPPageMenu.h"
#import "GXAddressCell.h"

static NSString *const AddressCell = @"AddressCell";

@interface GXChooseAddressView ()<SPPickerViewDatasource,SPPickerViewDelegate, SPPageMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *pickerContentView;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) SPPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) SPProvince *selectedProvince;
@property (nonatomic, strong) SPCity *selectedCity;
@property (nonatomic, strong) SPDistrict *selectedDistrict;


@property (nonatomic, assign) NSInteger numerOfComponents;
@end
@implementation GXChooseAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 默认1列
        self.numerOfComponents = 1;
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    // 默认1列
    self.numerOfComponents = 1;
    [self.menuView addSubview:self.pageMenu];
    [self.pickerContentView addSubview:self.pickerView];
}
- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    self.provinces = [NSMutableArray array];
    for (NSDictionary *dict in datas) {
        SPProvince *province = [[SPProvince alloc] init];
        [province setValuesForKeysWithDictionary:dict];
        [self.provinces addObject:province];
    }
//    self.selectedProvince = self.provinces.firstObject;
//    self.selectedCity = self.selectedProvince.children.firstObject;
    
    [self.pickerView sp_reloadAllComponents];
}

#pragma mark - SPPageMenuDelegate

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    [self.pickerView sp_scrollToComponent:index atComponentScrollPosition:SPPickerViewComponentScrollPositionDefault animated:YES];
}

#pragma mark - SPPickerViewDatasource,SPPickerViewDelegate
// 返回多少列
- (NSInteger)sp_numberOfComponentsInPickerView:(SPPickerView *)pickerView {
    return self.numerOfComponents;
}

// 每一列返回多少行
- (NSInteger)sp_pickerView:(SPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    } else if (component == 1) {
        return self.selectedProvince.children.count;
    } else {
        return self.selectedCity.children.count;
    }
}

// 每一列每一行的cell，参数systemCell是系统自带的cell，如果想自定义cell，需要先调用- sp_registerClass: forComponent:方法进行注册
- (UITableViewCell *)sp_pickerView:(SPPickerView *)pickerView cellForRow:(NSInteger)row forComponent:(NSInteger)component systemCell:(UITableViewCell *)systemCell {
    // 从缓存池里取出cell，如果取不到会创建新的
    GXAddressCell *cell = [pickerView sp_dequeueReusableCellAtRow:row atComponent:component];
    if (component == 0) { // 第1列
        SPProvince *province = self.provinces[row];
        // 四个直辖市的省名用简写
        if ([self isEspecialCity:province]) {
            cell.titleLabel.text = province.name;
            cell.titleLabel.textColor = [province.name isEqualToString:self.selectedProvince.name]?[UIColor redColor]:[UIColor blackColor];
        } else {
            cell.titleLabel.text = province.fullname;
            cell.titleLabel.textColor = [province.fullname isEqualToString:self.selectedProvince.fullname]?[UIColor redColor]:[UIColor blackColor];
        }
        
        return cell;
    } else if (component == 1) { // 第2列直接使用系统的cell
        SPCity *city = self.selectedProvince.children[row];
        cell.titleLabel.text = city.fullname;
        cell.titleLabel.textColor = [city.fullname isEqualToString:self.selectedCity.fullname]?[UIColor redColor]:[UIColor blackColor];
        return cell;
    } else { // 第3列的cell自定义，xib创建的cell
        SPDistrict *district = self.selectedCity.children[row];
        cell.titleLabel.text = district.fullname;
        cell.titleLabel.textColor = [district.fullname isEqualToString:self.selectedDistrict.fullname]?[UIColor redColor]:[UIColor blackColor];
        return cell;
    }
}
// 行高
- (CGFloat)sp_pickerView:(SPPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
// 行宽
- (CGFloat)sp_pickerView:(SPPickerView *)pickerView rowWidthForComponent:(NSInteger)component {
    return kScreenWidth;
}

// 点击了哪一列的哪一行
- (void)sp_pickerView:(SPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectedProvince = self.provinces[row];
//        self.selectedCity = [self.selectedProvince.children firstObject];
//        self.selectedDistrict = [self.selectedCity.children firstObject];
        //[self.pickerView sp_reloadComponent:1];
        //[self.pickerView sp_reloadComponent:2];
        
        self.numerOfComponents = 2;
        [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
        if ([self isEspecialCity:self.selectedProvince]) {
            [self setupPageMenuWithName:self.selectedProvince.name atComponent:component];
        } else {
            [self setupPageMenuWithName:self.selectedProvince.fullname atComponent:component];
        }
        
    } else if (component == 1) {
        
        self.selectedCity = self.selectedProvince.children[row];
//        self.selectedDistrict = [self.selectedCity.children firstObject];
        //[self.pickerView sp_reloadComponent:2];
        
        self.numerOfComponents = 3;
        [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
        [self setupPageMenuWithName:self.selectedCity.fullname atComponent:component];
        
    } else {
        self.selectedDistrict = self.selectedCity.children[row];
        [self.pageMenu setTitle:self.selectedDistrict.fullname forItemAtIndex:component];
        self.pageMenu.selectedItemIndex = component;
        
        if (self.lastComponentClickedBlock) {
            self.lastComponentClickedBlock(self.selectedProvince, self.selectedCity, self.selectedDistrict);
        }
    }
}

- (void)setupPageMenuWithName:(NSString *)name atComponent:(NSInteger)component {
    NSString *title = [self.pageMenu titleForItemAtIndex:component];
    if ([title isEqualToString:@"请选择"]) {
        [self.pageMenu insertItemWithTitle:name atIndex:component animated:YES];
    } else {
        // 改变当前item的标题
        [self.pageMenu setTitle:name forItemAtIndex:component];
        // 将下一个置为“请选择”
        [self.pageMenu setTitle:@"请选择" forItemAtIndex:component+1];
        NSInteger itemCount = (self.pageMenu.numberOfItems-1);
        // 保留2个item，2个之后的全部删除
        for (int i = 0; i < itemCount-(component+1); i++) {
            [self.pageMenu removeItemAtIndex:self.pageMenu.numberOfItems-1 animated:YES];
        }
    }
    // 切换选中的item，会执行pageMenu的代理方法，
    self.pageMenu.selectedItemIndex = component+1;
}

// 是否为直辖市
- (BOOL)isEspecialCity:(SPProvince *)province {
    if ([province.name isEqualToString:@"北京"] ||
        [province.name isEqualToString:@"天津"] ||
        [province.name isEqualToString:@"上海"] ||
        [province.name isEqualToString:@"重庆"])
    {
        return YES;
    }
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pageMenu.frame = self.menuView.bounds;
    self.pickerView.frame = self.pickerContentView.bounds;
}

- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.backgroundColor = HXGlobalBg;
        _pageMenu.delegate = self;
        _pageMenu.dividingLine.backgroundColor = [UIColor clearColor];
        [_pageMenu setItems:@[@"请选择"] selectedItemIndex:0];
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:14];
        _pageMenu.selectedItemTitleColor = [UIColor redColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor blackColor];
        [_pageMenu setTrackerHeight:1 cornerRadius:0];
        _pageMenu.itemPadding = 30;
        _pageMenu.bridgeScrollView = self.pickerView.scrollView;
    }
    return  _pageMenu;
}
- (SPPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[SPPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        // 以下代码都可以放在设置代理之前
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:0]; // 注册第0列cell,xib
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:1]; // 注册第1列cell,xib
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:2]; // 注册第2列cell,xib
        
        //        [_pickerView sp_hideSeparatorLineForAllComponentls];
        //        [_pickerView sp_hideSeparatorLineForComponent:1];
        //        [_pickerView sp_showsVerticalScrollIndicatorForAllComponentls];
        //        [_pickerView sp_showsVerticalScrollIndicatorForComponent:2];
    }
    return  _pickerView;
}
@end
