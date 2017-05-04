//
// {{ operationId|upperCamelCase }}.swift
//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension {{ options.name }}{% if tag %}.{{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }}{% endif %} {

    {% if description %}
    /** {{ description }} */
    {% endif %}
    public class {{ operationId|upperCamelCase }}: APIRequest<{{successType|default:"Void"}}> {

        public static let service = APIService<{{successType|default:"Void"}}>(id: "{{ operationId }}", tag: "{{ tag }}", method: "{{ method|uppercase }}", path: "{{ path }}", hasBody: {% if hasBody %}true{% else %}false{% endif %}{% if securityRequirement %}, authorization: Authorization(type: "{{ securityRequirement.name }}", scope: "{{ securityRequirement.scope }}"){% endif %}, decode: {% if successType %}JSONDecoder.decode{% else %}{ _ in }{% endif %})
        {% for enum in enums %}
        {% if not enum.isGlobal %}

        {% if enum.description %}
        /** {{ enum.description }} */
        {% endif %}
        public enum {{ enum.enumName }}: String {
            {% for enumCase in enum.enums %}
            case {{ enumCase.name }} = "{{enumCase.value}}"
            {% endfor %}

            public static let cases: [{{ enum.enumName }}] = [
              {% for enumCase in enum.enums %}
              .{{ enumCase.name }},
              {% endfor %}
            ]
        }
        {% endif %}
        {% endfor %}
        {% if nonBodyParams %}

        public struct Options {
            {% for param in nonBodyParams %}

            {% if param.description %}
            /** {{ param.description }} */
            {% endif %}
            public var {{ param.name }}: {{ param.optionalType }}
            {% endfor %}

            public init({% for param in nonBodyParams %}{{param.name}}: {{param.optionalType}}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
                {% for param in nonBodyParams %}
                self.{{param.name}} = {{param.name}}
                {% endfor %}
            }
        }

        public var options: Options
        {% endif %}
        {% if bodyParam %}
        {% if bodyParam.anonymousSchema %}

        {% if bodyParam.anonymousSchema.description %}
        /** {{ bodyParam.schema.description }} */
        {% endif %}
        public struct Body {
          {% for property in bodyParam.anonymousSchema.properties %}

          {% if property.description %}
          /** {{ property.description }} */
          {% endif %}
          public var {{ property.name }}: {{ property.optionalType }}
          {% endfor %}

          public init({% for property in bodyParam.anonymousSchema.properties %}{{property.name}}: {{property.optionalType}}{% ifnot property.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
              {% for property in bodyParam.anonymousSchema.properties %}
              self.{{property.name}} = {{property.name}}
              {% endfor %}
          }
        }
        {% endif %}

        public var {{ bodyParam.name}}: {{bodyParam.optionalType}}
        {% endif %}

        public init({% if bodyParam %}_ {{ bodyParam.name}}: {{ bodyParam.optionalType }}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}_ options: Options{% endif %}) {
            {% if bodyParam %}
            self.{{ bodyParam.name}} = {{ bodyParam.name}}
            {% endif %}
            {% if nonBodyParams %}
            self.options = options
            {% endif %}
            super.init(service: {{ operationId|upperCamelCase }}.service)
        }
        {% if nonBodyParams %}

        public convenience init({% for param in params %}{{ param.name }}: {{ param.optionalType }}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
            {% if nonBodyParams %}
            let options = Options({% for param in nonBodyParams %}{{param.name}}: {{param.name}}{% ifnot forloop.last %}, {% endif %}{% endfor %})
            {% endif %}
            self.init({% if bodyParam %}{{ bodyParam.name}}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}options{% endif %})
        }
        {% endif %}
        {% if pathParams %}

        public override var path: String {
            return super.path{% for param in pathParams %}.replacingOccurrences(of: "{" + "{{ param.name }}" + "}", with: "\(self.options.{{ param.encodedValue }})"){% endfor %}
        }
        {% endif %}
        {% if nonBodyParams %}

        public override var parameters: [String: Any] {
            var params: JSONDictionary = [:]
            {% for param in nonBodyParams %}
            {% if param.optional %}
            if let {{ param.name }} = options.{{ param.encodedValue }} {
              params["{{ param.value }}"] = {{ param.name }}
            }
            {% else %}
            params["{{ param.value }}"] = options.{{ param.encodedValue }}
            {% endif %}
            {% endfor %}
            return params
        }
        {% endif %}
        {% if bodyParam %}

        public override var jsonBody: Any? {
            return {{ bodyParam.encodedValue }}
        }
        {% endif %}
    }
}
