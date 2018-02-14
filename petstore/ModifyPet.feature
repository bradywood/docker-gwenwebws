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

 Feature: Ability to change a pet in the store

Scenario: As a pet owner, I would like the ability to change my pet tiger
    Given the base URL is "http://localhost:8002/v2"
      And the target request is PUT "pet"
      And the "accept" request header is "application/json"
      And the "Content-type" request header is "application/json"
      And the request body is defined by file "features/petstore/ModifyPetTemplate.json"
     When I send the request
     Then the response code should be "200"
      And the response body at json path "$.name" should be "gwenify"

