package com.attentivereactnativesdk;

import android.app.Activity;
import android.util.Log;
import android.view.ViewGroup;
import androidx.annotation.NonNull;

import com.attentive.androidsdk.AttentiveConfig;
import com.attentive.androidsdk.AttentiveEventTracker;
import com.attentive.androidsdk.UserIdentifiers;
import com.attentive.androidsdk.creatives.Creative;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.module.annotations.ReactModule;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@ReactModule(name = AttentiveReactNativeSdkModule.NAME)
public class AttentiveReactNativeSdkModule extends ReactContextBaseJavaModule {
  public static final String NAME = "AttentiveReactNativeSdk";
  private static final String TAG = NAME;

  private AttentiveConfig attentiveConfig;

  public AttentiveReactNativeSdkModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void initialize(ReadableMap config) {
    final String domain = config.getString("attentiveDomain");
    final AttentiveConfig.Mode mode =  getModeEnumFromModeParam(config.getString("mode"));
    attentiveConfig = new AttentiveConfig(domain, mode, this.getReactApplicationContext());
    AttentiveEventTracker.getInstance().initialize(attentiveConfig);
  }

  @ReactMethod
  public void triggerCreative() {
    Log.i(TAG, "Native Attentive module was called to trigger the creative.");
    try {
      Activity currentActivity = getReactApplicationContext().getCurrentActivity();
      if (currentActivity != null) {
        ViewGroup rootView =
          (ViewGroup) currentActivity.getWindow().getDecorView().getRootView();
        // The following calls edit the view hierarchy so they must run on the UI thread
        UiThreadUtil.runOnUiThread(() -> {
          Creative creative = new Creative(attentiveConfig, rootView);
          creative.trigger();
        });
      } else {
        Log.w(TAG, "Could not trigger the Attentive Creative because the current Activity was null");
      }
    } catch (Exception e) {
      Log.e(TAG, "Exception when triggering the creative: " + e);
    }
  }

  @ReactMethod
  public void clearUser() {
    attentiveConfig.clearUser();
  }

  @ReactMethod
  public void identifyUser(ReadableMap identifiers) {
    UserIdentifiers.Builder idsBuilder = new UserIdentifiers.Builder();
    if (identifiers.hasKey("phone")) {
      idsBuilder.withPhone(identifiers.getString("phone"));
    }
    if (identifiers.hasKey("email")) {
      idsBuilder.withEmail(identifiers.getString("email"));
    }
    if (identifiers.hasKey("klaviyoId")) {
      idsBuilder.withKlaviyoId(identifiers.getString("klaviyoId"));
    }
    if (identifiers.hasKey("shopifyId")) {
      idsBuilder.withShopifyId(identifiers.getString("shopifyId"));
    }
    if (identifiers.hasKey("clientUserId")) {
      idsBuilder.withClientUserId(identifiers.getString("clientUserId"));
    }
    if (identifiers.hasKey("customIdentifiers")) {
      Map<String, String> customIds = new HashMap<>();
      Map<String, Object> rawCustomIds = identifiers.getMap("customIdentifiers").toHashMap();
      for (Map.Entry<String, Object> entry : rawCustomIds.entrySet()) {
        if (entry.getValue() instanceof String) {
          customIds.put(entry.getKey(), (String) entry.getValue());
        }
      }
      idsBuilder.withCustomIdentifiers(customIds);
    }

    attentiveConfig.identify(idsBuilder.build());
  }

  private AttentiveConfig.Mode getModeEnumFromModeParam(String mode) {
    for (AttentiveConfig.Mode modeOption : AttentiveConfig.Mode.values()) {
      if (modeOption.toString().equalsIgnoreCase(mode)) {
        return modeOption;
      }
    }

    throw new IllegalArgumentException(String.format("Invalid mode parameter. Value was '%s' and valid values are '%s'", mode, Arrays.toString(AttentiveConfig.Mode.values())));
  }
}
