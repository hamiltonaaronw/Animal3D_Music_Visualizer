/*
	Copyright 2011-2019 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	passInstanceID_vs4x.glsl
	Outputs raw position attribute and pass instance ID;
*/

#version 410

layout (location = 0) in vec4 aPosition;

flat out int vPassInstanceID;

void main()
{
	vPassInstanceID = gl_InstanceID;
	gl_Position = aPosition;
}
