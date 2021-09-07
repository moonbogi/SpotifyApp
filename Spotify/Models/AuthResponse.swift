//
//  AuthResponse.swift
//  Spotify
//
//  Created by Leo Moon on 2021-09-06.
//

import Foundation

struct AuthResponse: Codable {
    
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}


//SUCCESS: {
//    "access_token" = "BQBjswxg_C9bcFZtTfb00QiQsAPk-IdfResYBf6viX0Hy6OLGrw2T0DiTw5Bf2p6Wxt3UBUP4hEb1QeCHW53TqxSHOEvSx16a1RUgf1B8c75W7tl35-iMYXneAv0q2p2l4oP_3bawtVJPJ7nW-mUVd_HoCJZatCJ4ilQ-opdUdbn9NQ";
//    "expires_in" = 3600;
//    "refresh_token" = "AQCp6cY3QpvLTSNX-qE7NqIam03B5ahMMt5lFasBhQUS-qopsOrNjz31b1xsPpB663M8gmrK7_ja-N0tDtzUgPPCRwAqlU4SBE8Ii_d4BeTSZT9i0-gRqfzHv3A2l7mgCRo";
//    scope = "user-read-private";
//    "token_type" = Bearer;
//}
