#
#	MetaCall FaaS by Parra Studios
#	TypeScript reimplementation of MetaCall FaaS.
#
#	Copyright (C) 2016 - 2021 Vicente Eduardo Ferrer Garcia <vic798@gmail.com>
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
#

# MetaCall CLI Image
FROM metacall/cli AS builder

WORKDIR /metacall/source

COPY . .

RUN metacall npm install \
	&& metacall npm run build \
	&& rm -rf ./node_modules \
	&& metacall npm install --only=prod

# MetaCall FaaS Image
FROM metacall/cli AS faas

WORKDIR /metacall/source

COPY --from=builder /metacall/source/dist/ /metacall/source/
COPY --from=builder /metacall/source/node_modules /metacall/source/node_modules

CMD ["index.js"]
