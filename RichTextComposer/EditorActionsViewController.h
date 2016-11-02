
@protocol EditorActionsDelegateProtocol <NSObject>

- (void)boldRequested:(BOOL)selected;
- (void)italicRequested:(BOOL)selected;
- (void)imageRequested;
- (void)indentRequested:(BOOL)rightIndent;

@end

@protocol EditorActionsProtocol <NSObject>

+ (id<EditorActionsProtocol>)actionsViewWithDelegate:(id<EditorActionsDelegateProtocol>)delegate;
- (UIView*)actionsView;

@end

@interface EditorActionsViewController : UIViewController<EditorActionsProtocol>

@end
