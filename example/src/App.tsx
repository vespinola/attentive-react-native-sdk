/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, { useContext, useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import type { RootStackParamList } from './navTypes';
import HomeScreen from './HomeScreen';
import ProductScreen from './ProductScreen';
import { Attentive, Mode } from 'attentive-react-native-sdk';

const Stack = createNativeStackNavigator<RootStackParamList>();

function App(): JSX.Element {
  const attentiveDomain = useContext(AttentiveDomainContext);
  useEffect(() => {
    // 'initialize' should be the first Attentive code called
    Attentive.initialize({
      attentiveDomain: 'YOUR_ATTENTIVE_DOMAIN',
      mode: Mode.Production,
    });
    Attentive.identifyUser({ phone: '+15556667777' });
    // Attentive.identifyUser(identifiers);
    // Attentive.triggerCreative();
    // Attentive.clearUser();
    // Attentive.trackEvent(event);
    // When the app starts up, send the user's identifiers to Attentive ASAP to improve the
    // functionality of the Attentive Creative
    /*
    const identifiers = {
      'phone': '+15556667777',
      'email': 'some_email@gmailfake.com',
      'klaviyoId': 'userKlaviyoId',
      'shopifyId': 'userShopifyId',
      'clientUserId': 'userClientUserId',
      'customIdentifiers': { 'customIdKey': 'customIdValue' }
    };
    AttentiveCreativeModule.identify(identifiers);
    */
  }, [attentiveDomain]);

  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen
          name="Home"
          component={HomeScreen}
          options={{ title: 'Home' }}
        />
        <Stack.Screen
          name="Product"
          component={ProductScreen}
          options={{ title: 'Product Screen' }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default App;
