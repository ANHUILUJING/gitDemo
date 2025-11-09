// entry/src/main/ets/utils/PreferencesUtil.ets
import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

export class PreferencesUtil {
  private static prefs: preferences.Preferences | null = null;

  // 使用正确的context类型
  static async initPreferences(context: common.Context): Promise<void> {
    try {
      // 正确的调用方式
      PreferencesUtil.prefs = await preferences.getPreferences(context, 'mytodo_prefs');
      console.info('Preferences initialized successfully');
    } catch (error) {
      console.error('Preferences init failed:', JSON.stringify(error));
      // 只能抛出Error对象
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error(`Preferences init failed: ${JSON.stringify(error)}`);
      }
    }
  }

  // 保存Token
  static async setToken(token: string): Promise<void> {
    if (PreferencesUtil.prefs) {
      await PreferencesUtil.prefs.put('token', token);
      await PreferencesUtil.prefs.flush();
      console.info('Token saved successfully');
    } else {
      throw new Error('Preferences not initialized');
    }
  }

  // 获取Token - 明确的返回类型
  static async getToken(): Promise<string> {
    if (PreferencesUtil.prefs) {
      const token = await PreferencesUtil.prefs.get('token', '');
      return token.toString();
    } else {
      throw new Error('Preferences not initialized');
    }
  }

  // 清除Token（退出登录）
  static async clearToken(): Promise<void> {
    if (PreferencesUtil.prefs) {
      await PreferencesUtil.prefs.delete('token');
      await PreferencesUtil.prefs.flush();
      console.info('Token cleared successfully');
    } else {
      throw new Error('Preferences not initialized');
    }
  }
}