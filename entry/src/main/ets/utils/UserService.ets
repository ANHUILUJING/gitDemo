// entry/src/main/ets/utils/UserService.ets
import { HttpUtil, HttpResponse } from './HttpUtil';

// 数据类型定义 - 使用明确的类型
export interface ApiResponse<T> {
  code: string;
  msg: string;
  data: T | null;
}

export interface LoginResponse {
  token: string;
}

// 添加LoginRequest接口
export interface LoginRequest {
  login: string;
  password: string;
}

export interface RegisterRequest {
  username: string;
  password: string;
  avatarUrl?: string;
  telephone?: string;
  email?: string;
}

export interface UserResponse {
  userId: number;
  username: string;
  avatarUrl?: string;
  telephone?: string;
  email?: string;
  createdTime: string;
  updatedTime: string;
}

export interface UpdateUserRequest {
  avatarUrl?: string;
  telephone?: string;
  email?: string;
}

export class UserService {
  // 用户登录 - 明确的返回类型
  static async login(login: string, password: string): Promise<ApiResponse<LoginResponse>> {
    // 使用LoginRequest接口
    const loginData: LoginRequest = {
      login: login,
      password: password
    };

    const httpResponse: HttpResponse = await HttpUtil.post('/api/accounts/login', loginData);

    return {
      code: httpResponse.code,
      msg: httpResponse.msg,
      data: httpResponse.data as LoginResponse | null
    };
  }

  // 用户注册 - 明确的返回类型
  static async register(userData: RegisterRequest): Promise<ApiResponse<string>> {
    const httpResponse: HttpResponse = await HttpUtil.post('/api/accounts', userData);

    return {
      code: httpResponse.code,
      msg: httpResponse.msg,
      data: httpResponse.data as string | null
    };
  }

  // 获取用户信息 - 明确的返回类型
  static async getUserInfo(username: string, token: string): Promise<ApiResponse<UserResponse>> {
    const httpResponse: HttpResponse = await HttpUtil.get(`/api/accounts/${username}`, token);

    return {
      code: httpResponse.code,
      msg: httpResponse.msg,
      data: httpResponse.data as UserResponse | null
    };
  }

  // 更新用户信息 - 明确的返回类型
  static async updateUserInfo(userData: UpdateUserRequest, token: string): Promise<ApiResponse<string>> {
    const httpResponse: HttpResponse = await HttpUtil.put('/api/accounts', userData, token);

    return {
      code: httpResponse.code,
      msg: httpResponse.msg,
      data: httpResponse.data as string | null
    };
  }
}