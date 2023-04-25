import React from 'react';
import { Button, Text, View } from 'react-native';
import { Attentive } from 'attentive-react-native-sdk';

import type { HomeScreenProps } from './navTypes';

const HomeScreen = ({ navigation }: HomeScreenProps) => {
  const showCreative = () => {
    Attentive.triggerCreative();
  };

  const showProductPage = () => {
    navigation.navigate('Product');
  };

  const clearUser = () => {
    // Call 'clearUser' if the current user logs out
    Attentive.clearUser();
  };

  return (
    <View style={{ flex: 1 }}>
      <Text>This is React Native!</Text>
      <Button title="Show creative!" color="#841584" onPress={showCreative} />
      <Button title="View Product Page" onPress={showProductPage} />
      <Button title="Clear User" onPress={clearUser} />
    </View>
  );
};

export default HomeScreen;
