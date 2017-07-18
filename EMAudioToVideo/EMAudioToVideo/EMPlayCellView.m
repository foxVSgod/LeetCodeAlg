//
//  EMPlayCellView.m
//  EMAudioToVideo
//
//  Created by yourongrong on 2017/7/18.
//  Copyright © 2017年 益盟技术部. All rights reserved.
//

#import "EMPlayCellView.h"
#import <Masonry.h>

@interface EMPlayCellView(){
}
@property (nonatomic, strong) UIImageView *playview;

@end

@implementation EMPlayCellView

- (id)init{
    self = [super init];
    if (self) {
        [self initBasicViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initBasicViews];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
    [self.playview setImage:[UIImage imageNamed:imageUrl]];
}

- (void)initBasicViews{
    self.playview = [[UIImageView alloc] init];
    [self addSubview:self.playview];
    self.playview.contentMode = UIViewContentModeScaleAspectFit;
    [self.playview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(1);
            make.right.equalTo(self).with.offset(-1);
            make.center.equalTo(self);
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(-1);
    }];
}
@end
