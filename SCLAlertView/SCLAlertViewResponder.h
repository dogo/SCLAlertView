//
//  SCLAlertViewResponder.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLAlertView.h"

@interface SCLAlertViewResponder : NSObject

/// Inicializa o responder vinculado a uma instância de SCLAlertView.
- (instancetype)init:(SCLAlertView *)alertview;

/// Atualiza o título do alerta.
- (void)setTitle:(NSString *)title;

/// Atualiza o subtítulo/texto do corpo do alerta.
- (void)setSubTitle:(NSString *)subTitle;

/// Fecha o alerta.
- (void)close;

@end
