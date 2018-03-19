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

#import "Firestore/Source/Local/FSTLocalViewChanges.h"

#include <utility>

#import "Firestore/Source/Core/FSTViewSnapshot.h"
#import "Firestore/Source/Model/FSTDocument.h"

#include "Firestore/core/src/firebase/firestore/model/document_key_set.h"

using firebase::firestore::model::DocumentKeySet;

NS_ASSUME_NONNULL_BEGIN

@interface FSTLocalViewChanges ()
- (instancetype)initWithQuery:(FSTQuery *)query
                    addedKeys:(DocumentKeySet)addedKeys
                  removedKeys:(DocumentKeySet)removedKeys NS_DESIGNATED_INITIALIZER;
@end

@implementation FSTLocalViewChanges {
  DocumentKeySet _addedKeys;
  DocumentKeySet _removedKeys;
}

+ (instancetype)changesForViewSnapshot:(FSTViewSnapshot *)viewSnapshot {
  DocumentKeySet addedKeys{};
  DocumentKeySet removedKeys{};

  for (FSTDocumentViewChange *docChange in viewSnapshot.documentChanges) {
    switch (docChange.type) {
      case FSTDocumentViewChangeTypeAdded:
        addedKeys.insert(docChange.document.key);
        break;

      case FSTDocumentViewChangeTypeRemoved:
        removedKeys.insert(docChange.document.key);
        break;

      default:
        // Do nothing.
        break;
    }
  }

  return [self changesForQuery:viewSnapshot.query addedKeys:addedKeys removedKeys:removedKeys];
}

+ (instancetype)changesForQuery:(FSTQuery *)query
                      addedKeys:(DocumentKeySet)addedKeys
                    removedKeys:(DocumentKeySet)removedKeys {
  return [[FSTLocalViewChanges alloc] initWithQuery:query
                                          addedKeys:std::move(addedKeys)
                                        removedKeys:std::move(removedKeys)];
}

- (instancetype)initWithQuery:(FSTQuery *)query
                    addedKeys:(DocumentKeySet)addedKeys
                  removedKeys:(DocumentKeySet)removedKeys {
  self = [super init];
  if (self) {
    _query = query;
    _addedKeys = std::move(addedKeys);
    _removedKeys = std::move(removedKeys);
  }
  return self;
}

- (DocumentKeySet *)addedKeys {
  return &_addedKeys;
}

- (DocumentKeySet *)removedKeys {
  return &_removedKeys;
}

@end

NS_ASSUME_NONNULL_END
