import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'attentive-react-native-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const AttentiveReactNativeSdk = NativeModules.AttentiveReactNativeSdk
  ? NativeModules.AttentiveReactNativeSdk
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export enum Mode {
  Production = 'production',
  Debug = 'debug',
}

export type AttentiveConfiguration = {
  attentiveDomain: string;
  mode: Mode;
};

export type UserIdentifiers = {
  phone?: string;
  email?: string;
  klaviyoId?: string;
  shopifyId?: string;
  clientUserId?: string;
  customIdentifiers?: UserIdentifierCustomIdentifier;
};

export type UserIdentifierCustomIdentifier = {
  key: string;
  value: string;
};

export class Attentive {
  static initialize(configuration: AttentiveConfiguration): void {
    AttentiveReactNativeSdk.initialize(configuration);
  }

  static identifyUser(userIdentifiers: UserIdentifiers): void {
    AttentiveReactNativeSdk.identifyUser(userIdentifiers);
  }

  static clearUser(): void {
    AttentiveReactNativeSdk.clearUser();
  }

  static triggerCreative(): void {
    AttentiveReactNativeSdk.triggerCreative();
  }
}
