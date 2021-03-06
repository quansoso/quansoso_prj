//
//  QSMerchantCommendView.m
//  Quansoso
//
//  Created by qf on 14/11/27.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "QSMerchantCommendView.h"
#import "SVProgressHUD.h"
#import <TAESDK/TAESDK.h>
#import "QSItem.h"
#import "QSItemsCellTableViewCell.h"
@interface QSMerchantCommendView ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,QSItemsCellDelegate>{
	UILabel *tips;
	UIView *toolView;
}
@end

@implementation QSMerchantCommendView

- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items{
	if (self = [super initWithFrame:frame]) {
		[self setUI:1];
		_itemArray = items;
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type{
	if (self = [super initWithFrame:frame]) {
		[self setUI:type];
	}
	return self;
}

- (void)setItemArray:(NSArray *)itemArray{
	if (!_itemArray) {
		_itemArray = [[NSArray alloc] initWithArray:itemArray];
	}
	if (_itemArray.count) {
		[_tableView reloadData];
	}
}

- (void)setUI:(NSInteger)type{
	UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
	titleLb.text = @"热门商品";
	titleLb.textColor = [UIColor blackColor];
	titleLb.textAlignment = NSTextAlignmentLeft;
	titleLb.font = kFont15;
//	[self addSubview:titleLb];
	int morex = kMainScreenWidth;
	UIImageView *gotoShopImg;
	UILabel *gotoShopLb;
	UIButton *gotoShopBt;
	if (type == 2) {
		//gotoShop
		gotoShopLb = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLb.top, 40, 20)];
		gotoShopLb.width = [self widthOfString:@"进入店铺" withFont:kFont13];
		gotoShopLb.right = kMainScreenWidth - 10;
		gotoShopLb.text = @"进入店铺";
		gotoShopLb.textColor = [UIColor lightGrayColor];
		gotoShopLb.font = kFont13;
	//	[self addSubview:gotoShopLb];
	
		gotoShopImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLb.top, 20, 20)];
		gotoShopImg.image = [UIImage imageNamed:@"QSgoMerc"];
		gotoShopImg.right = gotoShopLb.left-5;
	//	[self addSubview:gotoShopImg];
	
		gotoShopBt = [[UIButton alloc] initWithFrame:CGRectMake(gotoShopImg.left, titleLb.top, gotoShopLb.right-gotoShopImg.left, 30)];
		[gotoShopBt addTarget:self action:@selector(gotoShop) forControlEvents:UIControlEventTouchDown];
		//	[self addSubview:gotoShopBt];
		////gotoshop end
		morex = gotoShopBt.left;
		
	}
	
//more
	UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLb.top, 40, 20)];
	more.width = [self widthOfString:@"更多优惠" withFont:kFont13];
	more.right = morex-10;
	more.text = @"更多优惠";
	more.textColor = [UIColor lightGrayColor];
	more.font = kFont13;
//	[self addSubview:more];
	
	UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLb.top, 20, 20)];
	moreImg.image = [UIImage imageNamed:@"QSMore"];
	moreImg.right = more.left-5;
//	[self addSubview:moreImg];

	UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(moreImg.left, titleLb.top, more.right - moreImg.left, 30)];
	[moreButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchDown];
//	[self addSubview:moreButton];
//more end
	
	toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, titleLb.bottom+10)];
	toolView.backgroundColor = [UIColor whiteColor];
	[toolView addSubview:titleLb];
	[toolView addSubview:gotoShopLb];
	[toolView addSubview:gotoShopBt];
	[toolView addSubview:gotoShopImg];
	[toolView addSubview:more];
	[toolView addSubview:moreImg];
	[toolView addSubview:moreButton];
	
//	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLb.bottom+5, kMainScreenWidth, self.height-titleLb.bottom+5) style:UITableViewStylePlain];
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.height)];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.allowsSelection = NO;
	[self addSubview:_tableView];
}

- (void)gotoShop
{
	[_delegate gotoShop];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		NSString *str = [self.webSiteUrl substringFromIndex:[self.webSiteUrl rangeOfString:@"http"].location+4];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"taobao%@",str]];
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (void)more{
	[_delegate gotoMoreCard];
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
	return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (void)showTips{
	if (!tips) {
		tips = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2, kMainScreenWidth, 30)];
		tips.textColor = [UIColor lightGrayColor];
		tips.backgroundColor = [UIColor clearColor];
		tips.textAlignment = NSTextAlignmentCenter;
		tips.text = @"没有热门商品信息";
	}
	[self.tableView addSubview:tips];
}

- (void)hiddenTips{
	if (tips && [tips superview]) {
		[tips removeFromSuperview];
	}
}
#pragma mark - tableview

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return toolView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return toolView.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (_itemArray.count == 0) {
		[self showTips];
	}else{
		[self hiddenTips];
	}
	return (_itemArray.count+1)/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [QSItemsCellTableViewCell heightOfCell];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"QSItemsCell";
	QSItemsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[QSItemsCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.delegate = self;
	}
	cell.indexOfRow = indexPath.row;
	NSInteger num = 1;
	QSItem *item1 = [[QSItem alloc] initWithDictionary:[_itemArray objectAtIndex:indexPath.row*2]];
	[cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:item1.picUrl]];
	cell.titleLb1.text = item1.title;
	cell.priceLb1.text = [NSString stringWithFormat:@"¥%@元",item1.price];
	if (_itemArray.count > indexPath.row*2+1) {
		num = 2;
		QSItem *item2 = [[QSItem alloc] initWithDictionary:[_itemArray objectAtIndex:indexPath.row*2+1]];
		[cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:item2.picUrl]];
		cell.titleLb2.text = item2.title;
		cell.priceLb2.text = [NSString stringWithFormat:@"¥%@元",item2.price];
	}
	
	[cell showItemWith:num];
	return cell;
}

- (void)selectCellAtIndex:(NSInteger)index andRow:(NSInteger)row{
	NSInteger num = row*2+index;
	QSItem *item = [[QSItem alloc] initWithDictionary:[_itemArray objectAtIndex:num]];
	[_delegate gotoItem:item.openIid];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
