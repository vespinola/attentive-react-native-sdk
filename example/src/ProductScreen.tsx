import React, { useEffect } from 'react';
import { Alert, Button, Text, View, Image } from 'react-native';
import type { ProductScreenProps } from './navTypes';
import { Attentive, AddToCartEvent, PurchaseEvent, ProductViewEvent, CustomEvent } from 'attentive-react-native-sdk';

const ProductScreen = ({}: ProductScreenProps) => {
  const getItems = () => {
    return {
      items: [
        {
          productId: '555',
          productVariantId: '777',
          price: {
            price: '14.99',
            currency: 'USD',
          },
        },
      ],
    };
  };

  useEffect(() => {
    const productViewAttrs : ProductViewEvent = {
      ...getItems(),
    };

    Attentive.recordProductViewEvent(productViewAttrs);

    Alert.alert('Product View event recorded');
  }, []);

  const addToCart = () => {
    const addToCartAttrs : AddToCartEvent = {
      ...getItems(),
    };
    Attentive.recordAddToCartEvent(addToCartAttrs);

    Alert.alert('Add to Cart event recorded');
  };

  const purchase = () => {
    const purchaseAttrs : PurchaseEvent = {
      ...getItems(),
      order: {
        orderId: '8989',
      },
    };
    Attentive.recordPurchaseEvent(purchaseAttrs);

    Alert.alert('Purchase event recorded');
  };

  const customEvent = () => {
    const customEventAttrs : CustomEvent = {
      type: "Added to Wishlist",
      properties: {"lastName": "Christmas List"}
    }

    Attentive.recordCustomEvent(customEventAttrs);

    Alert.alert('Custom event recorded');
  }

  return (
    <View style={{ flex: 1 }}>
      <Image source={require('../assets/images/tshirt.png')} />
      <Text>T-Shirt</Text>
      <Button title="Add to Cart" color="#841584" onPress={addToCart} />
      <Button title="Purchase" onPress={purchase} />
      <Button title="Add to Wishlist" onPress={customEvent} />
    </View>
  );
};

export default ProductScreen;
