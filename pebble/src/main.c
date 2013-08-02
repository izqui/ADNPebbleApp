#include "pebble_os.h"
#include "pebble_app.h"
#include "pebble_fonts.h"


#define MY_UUID { 0x3C, 0xB4, 0x32, 0xD0, 0xD2, 0xF8, 0x44, 0x63, 0xA6, 0xC4, 0x36, 0xE0, 0xC5, 0x32, 0xB0, 0xB0 }
PBL_APP_INFO(MY_UUID,
             "ADN Pebble", "Jorge Izquierdo",
             1, 0, /* App version */
             DEFAULT_MENU_ICON,
             APP_INFO_STANDARD_APP);

Window rootWindow;
Window messagesWindow;
Window profileWindow;

SimpleMenuLayer rootMenu;
SimpleMenuLayer messagesMenu;


SimpleMenuItem rootMenuItems[2];
SimpleMenuSection sections[1];

SimpleMenuItem messagesMenuItems[10];
SimpleMenuSection messagesSections[1];



//Methods
static void messageSentSuccessfullyCallback(DictionaryIterator *sent, void *context);
static void messageSentWithErrorCallback(DictionaryIterator *failed, AppMessageResult reason, void *context);
static void messageReceivedSuccessfullyCallback(DictionaryIterator *received, void *context);
static void messageReceivedWithErrorCallback(void *context, AppMessageResult reason);
static void rootMenuCallback(int index, void *context);
static void messagesMenuCallback(int index, void *context);

static void requestMessages();
static void requestProfile();


static void messageSentSuccessfullyCallback(DictionaryIterator *sent, void *context)
{

}

static void messageSentWithErrorCallback(DictionaryIterator *failed, AppMessageResult reason, void *context)
{
   
}

static void messageReceivedSuccessfullyCallback(DictionaryIterator *received, void *context)
{
	
	static int initialized = 0;

    if (initialized == 1)
    {

        return;
    }
    
    initialized = 1;

    Tuple *firstElement = dict_read_first(received);
	
	
    int index = 0;
	
    if (firstElement)
    {	
		char *firsttext = (char *)firstElement->value;
        messagesMenuItems[0] = (SimpleMenuItem){.title = firsttext, .subtitle = NULL, .icon = NULL, .callback = messagesMenuCallback};
        index++;

        while (1)
        {
            Tuple *nextElement = dict_read_next(received);

            if (!nextElement)
            {
                break;
            }

            char *text = (char *)nextElement->value;

            messagesMenuItems[index] = (SimpleMenuItem){.title = text, .subtitle = NULL, .icon = NULL, .callback = messagesMenuCallback};

            index++;
        }    
    }

    
	
	sections[0] = (SimpleMenuSection){.items = messagesMenuItems, .num_items = index, .title = NULL};
	simple_menu_layer_init(&messagesMenu, messagesWindow.layer.bounds, &messagesWindow, sections, 1, NULL);
	layer_add_child(&messagesWindow.layer, simple_menu_layer_get_layer(&messagesMenu));



}

static void messagesMenuCallback(int index, void *context){
	
	Tuplet value = TupletInteger(0, index); 
	
	
	

    DictionaryIterator *iter;
    app_message_out_get(&iter);

    if (iter == NULL)
        return;

    dict_write_tuplet(iter, &value);
    dict_write_end(iter);

    app_message_out_send();
    app_message_out_release();
}

static void messageReceivedWithErrorCallback(void *context, AppMessageResult reason)
{
    
}


void handle_init(AppContextRef ctx) {
  (void)ctx;

  window_init(&rootWindow, "ADN Pebble");
  window_stack_push(&rootWindow, true);

	rootMenuItems[0] = (SimpleMenuItem){.title = "Send message", .subtitle = NULL, .icon = NULL, .callback = rootMenuCallback};
	rootMenuItems[1] = (SimpleMenuItem){.title = "Profile", .subtitle = NULL, .icon = NULL, .callback = rootMenuCallback};
	sections[0] = (SimpleMenuSection){.items = rootMenuItems, .num_items = 2, .title = NULL};
	simple_menu_layer_init(&rootMenu, rootWindow.layer.bounds, &rootWindow, sections, 1, NULL);
	layer_add_child(&rootWindow.layer, simple_menu_layer_get_layer(&rootMenu));
}

static void rootMenuCallback (int index, void *context){

	if (index == 0){
		
		window_init(&messagesWindow, "Messages");
  		window_stack_push(&messagesWindow, true);
		requestMessages();
	}
	else if (index == 1){
		
		window_init(&messagesWindow, "Profile");
  		window_stack_push(&messagesWindow, true);
		requestProfile();
	}
}

static void requestMessages(){
	
	Tuplet value = TupletCString(0, "messages");

    DictionaryIterator *iter;
    app_message_out_get(&iter);

    if (iter == NULL)
        return;

    dict_write_tuplet(iter, &value);
    dict_write_end(iter);

    app_message_out_send();
    app_message_out_release();
}

static void requestProfile(){
	Tuplet value = TupletCString(0, "profile");

    DictionaryIterator *iter;
    app_message_out_get(&iter);

    if (iter == NULL)
        return;

    dict_write_tuplet(iter, &value);
    dict_write_end(iter);

    app_message_out_send();
    app_message_out_release();
}
void pbl_main(void *params) {
  PebbleAppHandlers handlers = {
    .init_handler = &handle_init,
	.messaging_info =
        {
            .buffer_sizes =
            {
                .inbound = dict_calc_buffer_size(10, sizeof(char) * 100),
                .outbound = dict_calc_buffer_size(1),
            },
            .default_callbacks.callbacks =
            {
                .out_sent = messageSentSuccessfullyCallback,
                .out_failed = messageSentWithErrorCallback,
                .in_received = messageReceivedSuccessfullyCallback,
                .in_dropped = messageReceivedWithErrorCallback,
            },
        }
  };
  app_event_loop(params, &handlers);
}
