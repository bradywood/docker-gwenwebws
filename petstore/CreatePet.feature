#
# Copyright (c) 2017 Gwenify Pty Ltd. All rights reserved.
# Authors: Branko Juric, Brady Wood
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

 Feature: Ability to create a pet in the store

Scenario: As a pet owner, I would like the ability to add my pet tiger
    Given the base URL is "http://localhost:8002/v2"
      And the target request is POST "/pet"
      And the "Content-type" request header is "application/json"
      And the request body is defined by file "features/petstore/CreatePetTemplate.json"
      And my petname is "tiger"
     When I send the request
     Then the response code should be "200"
      And the response content type should be "application/json"
      And the response body at json path "$.id" should not be "0"
      And the response body at json path "$.category.name" should be "pet"
      And the response body at json path "$.name" should be "tiger"
      And the response body at json path "$.status" should be "available"
