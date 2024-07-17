export type Item = {
  productId: string;
  productVariantId: string;
  price: Price;
  productImage?: string;
  name?: string;
  quantity?: number;
  category?: string;
};

export type Price = {
  price: string;
  currency: string;
};

export type Order = {
  orderId: string;
};

export type Cart = {
  cartId?: string;
  cartCoupon?: string;
};

export type ProductViewEvent = {
  items: Item[];
  deeplink?: string;
};

export type AddToCartEvent = {
  items: Item[];
  deeplink?: string;
};

export type PurchaseEvent = {
  items: Item[];
  order: Order;
  cart?: Cart;
};

export type CustomEvent = {
  type: string;
  properties: Record<string, string>;
};
