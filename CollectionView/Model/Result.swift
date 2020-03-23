//
//  Result.swift
//  CollectionView
//
//  Created by Nguyễn Đức Tân on 3/23/20.
//  Copyright © 2020 Nguyễn Đức Tân. All rights reserved.
//

import Foundation

enum Result<ResultType> {
  case results(ResultType)
  case error(Error)
}
