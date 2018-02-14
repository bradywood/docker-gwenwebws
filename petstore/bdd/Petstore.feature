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

 Feature: First time petstore user

Scenario: Create a new user

          As someone who is new to the pet store, I would like the ability to create a new user

    Given I am a first time user to the petstore
     When I create a new user
     Then I should be able to login successfully

Scenario: User should be shown an empty list

          As the petstore, when someone tries to search an empty petstore they will be shown an emptylist

    Given I am a first time user to the petstore
     When I search for a list of pets available
     Then I will be shown an empty list