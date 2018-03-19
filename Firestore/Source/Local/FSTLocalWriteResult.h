/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

#import "Firestore/Source/Core/FSTTypes.h"

#include "Firestore/core/src/firebase/firestore/model/document_dictionary.h"

NS_ASSUME_NONNULL_BEGIN

/** The result of a write to the local store. */
@interface FSTLocalWriteResult : NSObject

+ (instancetype)resultForBatchID:(FSTBatchID)batchID
                         changes:(firebase::firestore::model::MaybeDocumentDictionary)changes;

- (id)init __attribute__((unavailable("Use resultForBatchID:changes:")));

- (const firebase::firestore::model::MaybeDocumentDictionary &)changes;

@property(nonatomic, assign, readonly) FSTBatchID batchID;

@end

NS_ASSUME_NONNULL_END
