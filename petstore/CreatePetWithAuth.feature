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

Background: Set petstore context
     Given the base URL is "http://localhost:8002/v2"

Scenario: As a pet owner, I would like the ability to add my pet tiger
    Given the target request is GET "user/login"
      And the "username" request query parameter is "admin"
      And the "password" request query parameter is "admin"
     When I send the request
     Then the response code should be "200"

    Given the target request is POST "pet"
      And my petname is "tiger"
      And the "accept" request header is "application/json"
      And the "Content-type" request header is "application/json"
      And the request body is defined by file "features/petstore/CreatePetTemplate.json"
     When I send the request
     Then the response code should be "200"


