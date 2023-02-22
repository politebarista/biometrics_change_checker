package dev.politebarista.biometrics_change_checker;

import android.util.Log;

import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;

import java.security.KeyStore;
import java.io.IOException;
import java.security.GeneralSecurityException;
import android.security.keystore.KeyPermanentlyInvalidatedException;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class BiometricsChangeCheckerPlugin implements FlutterPlugin, MethodCallHandler {
  private static final String TAG = "BiometricsChangeCheckerPlugin";
  private static final String keyName = "biometrics_change";

  private MethodChannel channel;

  private KeyStore keyStore;

  private Cipher getCipher() throws GeneralSecurityException {
    return Cipher.getInstance("AES/CBC/PKCS7Padding");
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {   
    KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");
    keyStore.load(null);

    Log.d(TAG, "attached to engine");

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "biometrics_change_checker");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("didBiometricsChanged")) {
      try {
        boolean didBiometricsChanged = didBiometicsChanged();
        result.success(didBiometricsChanged);
      } catch (Exception e) {
        Log.d(TAG, "Exception: " + e.getMessage());
        result.error("error", e.getMessage(), e);
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private boolean didBiometicsChanged() throws GeneralSecurityException, IOException {
    Cipher cipher = getCipher();

    SecretKey key = (SecretKey)keyStore.getKey(keyName, null);

    if (key == null)
      generateKey();

    key = (SecretKey)keyStore.getKey(keyName, null);

    try {
      cipher.init(Cipher.ENCRYPT_MODE, key);
      return false;
    } catch (KeyPermanentlyInvalidatedException e) {
      Log.d(TAG, "Exception: " + e.getMessage());

      keyStore.deleteEntry(keyName);
      generateKey();

      return true;
    }
  }

  private void generateKey() throws GeneralSecurityException {
    KeyGenerator keyGenerator = KeyGenerator.getInstance("AES", "AndroidKeyStore");
      keyGenerator.init(new KeyGenParameterSpec.Builder(
          keyName,
          KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
          .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
          .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
          .setInvalidatedByBiometricEnrollment(true)
          .setUserAuthenticationRequired(true)
          .build());
      keyGenerator.generateKey();
  }
}