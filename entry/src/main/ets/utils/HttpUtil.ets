// entry/src/main/ets/utils/HttpUtil.ets
import http from '@ohos.net.http';

// 定义明确的响应类型
export interface HttpResponse {
  code: string;
  msg: string;
  data: string | object | null;
}

export class HttpUtil {
  // 使用类名而不是this访问静态属性
  private static readonly baseURL: string = 'http://10.54.32.207:8080';

  // 定义明确的返回类型，不使用any
  static async post(url: string, data: object): Promise<HttpResponse> {
    // 移除HttpClient类型注解，让ArkTS自动推断
    const httpRequest = http.createHttp();
    const fullUrl: string = `${HttpUtil.baseURL}${url}`;

    try {
      const response = await httpRequest.request(
        fullUrl,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(data)
        }
      );

      // 添加类型检查
      if (response && response.result) {
        const resultStr: string = response.result.toString();
        const result: HttpResponse = JSON.parse(resultStr) as HttpResponse;
        httpRequest.destroy();
        return result;
      } else {
        throw new Error('Invalid response: response or result is null');
      }
    } catch (error) {
      console.error(`HTTP POST Error: ${JSON.stringify(error)}`);
      httpRequest.destroy();
      // 只能抛出Error对象，不能抛出任意类型
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error(`HTTP POST Error: ${JSON.stringify(error)}`);
      }
    }
  }

  // 定义明确的返回类型
  static async get(url: string, token?: string): Promise<HttpResponse> {
    const httpRequest = http.createHttp();
    const fullUrl: string = `${HttpUtil.baseURL}${url}`;
    const headers: Record<string, string> = {};

    if (token) {
      headers['token'] = token;
    }

    try {
      const response = await httpRequest.request(
        fullUrl,
        {
          method: http.RequestMethod.GET,
          header: headers
        }
      );

      // 添加类型检查
      if (response && response.result) {
        const resultStr: string = response.result.toString();
        const result: HttpResponse = JSON.parse(resultStr) as HttpResponse;
        httpRequest.destroy();
        return result;
      } else {
        throw new Error('Invalid response: response or result is null');
      }
    } catch (error) {
      console.error(`HTTP GET Error: ${JSON.stringify(error)}`);
      httpRequest.destroy();
      // 只能抛出Error对象
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error(`HTTP GET Error: ${JSON.stringify(error)}`);
      }
    }
  }

  // 定义明确的返回类型
  static async put(url: string, data: object, token: string): Promise<HttpResponse> {
    const httpRequest = http.createHttp();
    const fullUrl: string = `${HttpUtil.baseURL}${url}`;

    try {
      const response = await httpRequest.request(
        fullUrl,
        {
          method: http.RequestMethod.PUT,
          header: {
            'Content-Type': 'application/json',
            'token': token
          },
          extraData: JSON.stringify(data)
        }
      );

      // 添加类型检查
      if (response && response.result) {
        const resultStr: string = response.result.toString();
        const result: HttpResponse = JSON.parse(resultStr) as HttpResponse;
        httpRequest.destroy();
        return result;
      } else {
        throw new Error('Invalid response: response or result is null');
      }
    } catch (error) {
      console.error(`HTTP PUT Error: ${JSON.stringify(error)}`);
      httpRequest.destroy();
      // 只能抛出Error对象
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error(`HTTP PUT Error: ${JSON.stringify(error)}`);
      }
    }
  }
}