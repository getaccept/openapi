{
  title: "GetAccept",

  #   Alternative sample OAuth2 authentication. See more examples at https://docs.workato.com/developing-connectors/sdk/authentication.html
  connection: {
    base_uri: lambda do |_connection|
      "https://api.getaccept.com/v1/"
    end,

    authorization: {
      type: "oauth2",
      authorization_url: lambda do |_connection|
        params = {
          client_id: "Workato",
          response_type: "code",
          redirect_uri: "https://www.workato.com/oauth/callback",
          scope: "basic",
        }.to_param

        "https://app.getaccept.com/oauth2/authorize?" + params
      end,

      acquire: lambda do |_connection, auth_code|
        response = post("https://app.getaccept.com/oauth2/token").
          payload(
          code: auth_code,
          grant_type: "authorization_code",
          client_id: "Workato",
          client_secret: "app",
          redirect_uri: "https://www.workato.com/oauth/callback",
        ).
          request_format_www_form_urlencoded
        [
          {
            access_token: response["access_token"],
            refresh_token: response["refresh_token"],
          },
        ]
      end,

      refresh_on: [401, 403],

      refresh: lambda do |_connection, refresh_token|
        response = post("https://app.getaccept.com/oauth2/token").
          payload(
          grant_type: "refresh_token",
          refresh_token: refresh_token,
          client_id: "Workato",
          client_secret: "app",
          redirect_uri: "https://www.workato.com/oauth/callback",
        ).
          request_format_www_form_urlencoded
        [
          { # Tokens hash
            access_token: response["access_token"],
            refresh_token: response["refresh_token"],
          },
        ]
      end,

      apply: lambda do |_connection, access_token|
        headers("Authorization": "Bearer #{access_token}")
      end,
    },

  },

  test: lambda do |_connection|
    get("test")
  end,

  object_definitions: {
    #  Object definitions can be referenced by any input or output fields in actions/triggers.
    #  Use it to keep your code DRY. Possible arguments - connection, config_fields
    #  See more at https://docs.workato.com/developing-connectors/sdk/object-definition.html

    document: {
      fields: lambda do |_connection, _config_fields|
        [
          { name: "id" },
          { name: "name" },
          { name: "type" },
          { name: "external_id" },
          { name: "is_private", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "is_signing", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "user_id" },
          { name: "sender_name" },
          { name: "sender_thumb" },
          { name: "status" },
          { name: "value", type: "integer", control_type: "number" },
          { name: "sign_date", type: "date_time", control_type: "date_time", parse_output: lambda do |field| field != "0000-00-00 00:00:00" ? field : nil end },
          { name: "expiration_date", type: "date_time", control_type: "date_time", parse_output: lambda do |field| field != "0000-00-00 00:00:00" ? field : nil end },
          { name: "created_at", type: "date_time", control_type: "date_time" },
          {
            name: "recipients",
            type: "array",
            of: "object",
            properties: [
              { name: "first_name" },
              { name: "last_name" },
              { name: "email", control_type: "email" },
              { name: "thumb_url", control_type: "url" },
              { name: "gender" },
              { name: "status" },
              { name: "role", control_type: "select", picklist: [["signer"], ["approver"], ["cc"]] },
              { name: "company_name" },
              { name: "note" },
              { name: "company_number" },
            ],
          },
        ]
      end,
    },
    user: {
      fields: lambda do |_connection, _config_fields|
        [
          {
            name: "user",
            type: "object",
            properties: [
              { name: "user_id" },
              { name: "first_name" },
              { name: "last_name" },
              { name: "email", control_type: "email" },
              { name: "phone" },
              { name: "mobile" },
              { name: "title" },
              { name: "note" },
              { name: "thumb_url", control_type: "url" },
              { name: "entity_id" },
              { name: "entity_name" },
              { name: "language" },
              { name: "timezone" },
              { name: "role", control_type: "select", picklist: [["user"], ["manager"], ["admin"]] },
              { name: "status", control_type: "select", picklist: [["active"], ["inactive"], ["pending"]] },
              { name: "team_id" },
            ],
          },
          {
            name: "entities",
            type: "object",
            properties: [
              { name: "id" },
              { name: "name" },
              { name: "role", control_type: "select", picklist: [["user"], ["manager"], ["admin"]] },
              { name: "plan" },
              { name: "plan_title" },
            ],
          },
        ]
      end,
    },
    users: {
      fields: lambda do |_connection, _config_fields|
        [
          {
            name: "users",
            type: "array",
            of: "object",
            properties: [
              { name: "user_id" },
              { name: "name" },
              { name: "first_name" },
              { name: "last_name" },
              { name: "email", control_type: "email" },
              { name: "status" },
              { name: "role" },
              { name: "team_name" },
              { name: "last_login", type: "date_time", control_type: "date_time", parse_output: lambda do |field| field != "0000-00-00 00:00:00" ? field : nil end },
            ],
          },
        ]
      end,
    },
    fields: {
      fields: lambda do |_connection, _config_fields|
        [
          {
            name: "fields",
            type: "array",
            of: "object",
            properties: [
              { name: "field_id" },
              { name: "page_id" },
              { name: "field_type" },
              { name: "field_label" },
              { name: "field_value" },
              { name: "is_collectable", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_editable", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_required", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "recipient_id" },
              { name: "recipient_name" },
              { name: "field_top" },
              { name: "field_left" },
              { name: "field_width" },
              { name: "field_height" },
              { name: "validation_regex" },
              { name: "validation_warning" },
            ],
          },
        ]
      end,
    },

    field_values_output: {
      fields: lambda do |_connection, config_fields|
        if config_fields["document_id"].present?
          [
            {
              name: "fields",
              type: "array",
              of: "object",
              properties: get("documents/#{config_fields["document_id"]}/field_values")&.first&.
                map do |key, value|
                {
                  name: key.downcase.gsub(/\s+/, "_").gsub(/\-/, "_"),
                  type: "string",
                  label: key,
                  control_type: "text",
                  optional: true,
                  sticky: true,
                  default: value,
                }
              end,
            },
          ]
        else
        end
      end,
    },

    recipients: {
      fields: lambda do |_connection, _config_fields|
        [
          {
            name: "recipients",
            type: "array",
            of: "object",
            properties: [
              { name: "id" },
              { name: "fullname" },
              { name: "first_name" },
              { name: "last_name" },
              { name: "email", control_type: "email" },
              { name: "role" },
              { name: "status" },
              { name: "company_name" },
              { name: "company_number" },
              { name: "title" },
              { name: "note" },
              { name: "thumb_url", control_type: "url" },
              { name: "document_url", control_type: "url" },
            ],
          },
        ]
      end,
    },
    subscription: {
      fields: lambda do |_connection, config_fields|
        [
          { name: "event" },
          { name: "event_type" },
          { name: "event_action" },
          { name: "subscription_id" },
          {
            name: "document",
            type: "object",
            properties: [
              { name: "id" },
              { name: "name" },
              { name: "value", type: "integer", control_type: "number" },
              { name: "status" },
              { name: "external_id" },
              { name: "type" },
              { name: "tags" },
              { name: "send_date", type: "date_time", control_type: "date_time" },
              { name: "sender_email" },
              { name: "sender_name" },
              { name: "sign_date", type: "date_time", control_type: "date_time" },
              { name: "user_id" },
              { name: "email_send_message" },
              { name: "email_send_subject" },
              { name: "is_selfsign", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_signing", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_signing_biometric", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_signing_initials", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_signing_order", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "is_video", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "expiration_date", type: "date_time", control_type: "date_time" },
              { name: "video_id" },
              { name: "preview_url", control_type: "url" },
              { name: "download_url", control_type: "url" },
            ],
          },
          {
            name: "recipient",
            type: "object",
            properties: [
              { name: "fullname" },
              { name: "first_name" },
              { name: "last_name" },
              { name: "email", control_type: "email" },
              { name: "title" },
              { name: "note" },
              { name: "gender" },
              { name: "mobile" },
              { name: "thumb_url", control_type: "url" },
              { name: "role" },
              { name: "company_name" },
              { name: "company_number" },
              { name: "status" },
              { name: "order_num", type: "integer", control_type: "number" },
            ],
          },
          {
            name: "custom_fields",
            type: "object",
            properties: if config_fields["document_id"].present?
              get("documents/#{config_fields["document_id"]}/field_values")&.first&.
                map do |key, value|
                {
                  name: key.downcase.gsub(/\s+/, "_").gsub(/\-/, "_"),
                  type: "string",
                  label: key,
                  control_type: "text",
                  optional: true,
                  sticky: true,
                  default: value,
                }
              end
            end,
          },
          {
            name: "event_sign_metadata",
            type: "object",
          },
        ]
      end,
    },
    send_document_input: {
      fields: lambda do |_connection, config_fields|
        custom_fields = []
        if config_fields["template_id"].present?
          file_fields = []
          fields_data = get("templates/#{config_fields["template_id"]}/fields")
          if fields_data["fields"].present?
            fields_data["fields"].each do |field|
              if field["field_label"].present? || field["field_value"].present?
                case field["field_type"]
                when "text", "merge"
                  add_field =
                    { name: field["field_id"], optional: true, sticky: true,
                     default: field["field_value"],
                     label: if field["field_label"]
                      field["field_label"]
                    else
                      if field["field_value"]
                        field["field_value"]
                      else
                        field["field_type"] + " " + field["field_id"]
                      end
                    end }
                  custom_fields << add_field
                when "check"
                  add_field = { name: field["field_id"], label: field["field_label"],
                                type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_ouput: "boolean_conversion" }
                  if field["field_value"] == 1
                    add_field["default"] = true
                  else
                    if field["field_value"] == 0
                      add_field["default"] = false
                    end
                  end
                  custom_fields << add_field
                end
              end
            end
          end
          roles = get("templates/#{config_fields["template_id"]}/roles")
          if roles["roles"].present?
            roles = roles["roles"].pluck("role_name", "role_id")
          end
        else
          roles = []
          file_fields = [
            {
              name: "file_url",
              label: "File URL",
              hint: "Url to document file. Documents must be public available for download",
              control_type: "url",
              sticky: true,
            },
            {
              name: "file_name",
              label: "File name",
              hint: "Filename of the document, with the extension. This will be helpful for converting different file-types.",
              sticky: true,
            },
            {
              name: "file_content",
              label: "File content",
              control_type: "text-area",
              hint: "Base64-encoded file binary data",
              sticky: true,
            },
            {
              name: "file_ids",
              label: "File IDs",
              hint: "Comma-separated, unique file-ids received when uploading files",
              sticky: false,
            },
          ]
        end

        standard_fields = [
          { name: "name", label: "Document Name", hint: "Enter a name of the document", optional: false },
          { name: "external_id", label: "External ID", hint: "External system ID for identification", optional: true, sticky: true },
          { name: "value", label: "Document Value", hint: "The value associated with the document for statistics", optional: true, sticky: true, type: "integer", control_type: "number" },
          { name: "type", label: "Document Type", control_type: "select", default: "sales", pick_list: "document_type_list", optional: true, sticky: false },
          { name: "is_automatic_sending", label: "Send automatically", hint: "If the document should be sent after creation", optional: true, default: true, type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "is_sms_sending", label: "Send by SMS", hint: "Should the document be sent to recipient mobile by text", optional: true, default: false, type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "expiration_date", label: "Expiration date", hint: "Date and time when the document should expire", optional: true, type: "date_time", control_type: "date_time" },
          { name: "sender_email", label: "Sender Email", hint: "Send from other email (existing user) than authenticated user", optional: true, sticky: false, control_type: "email" },
          { name: "sender_id", label: "Sender User ID", hint: "Send from other user than authenticated", optional: true, sticky: false },
          { name: "email_send_subject", label: "Email Send Subject", hint: "Subject line used to send out the document", optional: true, sticky: false, control_type: "text-area" },
          { name: "email_send_message", label: "Email Send Message", hint: "Message to the recipient(s) when sending out the document", optional: true, sticky: false, control_type: "text-area" },
          { name: "send_date", label: "Send date", optional: true, type: "date_time", control_type: "date_time" },
          {
            name: "recipients",
            label: "Recipients",
            list_mode: "static",
            list_mode_toggle: false,
            item_label: "Recipient",
            add_item_label: "Add another recipient",
            empty_list_title: "Recipient details",
            empty_list_text: "Click the button below to add recipients.",
            type: "array",
            of: "object",
            properties: [
              { name: "first_name", label: "First name", sticky: true, optional: true },
              { name: "last_name", label: "Last name", sticky: true, optional: true },
              { name: "fullname", label: "Full Name", sticky: true, optional: true, hint: "Use as alternative to first/last name - automatically split at space" },
              { name: "company_name", label: "Company name", sticky: true, optional: true },
              { name: "company_number", label: "Company number", sticky: true, optional: true },
              { name: "email", label: "Email", control_type: "email", sticky: true, optional: true },
              { name: "mobile", label: "Mobile", control_type: "phone", sticky: true, optional: true, hint: "Mobile number of the user in international format (ex. +12137105000)" },
              { name: "note", label: "Notes", optional: true },
              { name: "order_num", label: "Signing order number", optional: true, type: "integer", control_type: "number" },
              { name: "verify_eid", label: "Verify recipient using EID", optional: true, default: false, type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              { name: "verify_sms", label: "Verify recipient by SMS", optional: true, default: false, type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
              if roles.length() > 0
                { name: "role_id", label: "Template role", control_type: "select", pick_list: roles, sticky: true }
              else
                { name: "role", label: "Role", control_type: "select", default: "signer", pick_list: "recipient_role_list", optional: false, sticky: true }
              end,
            ],
          },
          {
            name: "attachments",
            label: "Attachments",
            list_mode: "static",
            list_mode_toggle: false,
            item_label: "Attachment",
            add_item_label: "Add another attachment",
            empty_list_title: "Attachment details",
            empty_list_text: "Click the button below to add an attachment.",
            type: "array",
            of: "object",
            properties: [
              { name: "type", label: "Type", sticky: true, optional: true, control_type: "select", pick_list: [["File", "file"], ["External url", "external"]] },
              { name: "id", label: "Uploaded Attachment ID", sticky: true, optional: true },
              { name: "url", label: "Attachment URL", control_type: "url", sticky: true, optional: true },
              { name: "title", label: "Title", optional: true },
              { name: "require_view", label: "Require recipient to view", optional: true, type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
            ],
          },
          { name: "custom_fields", type: "object", optional: true, sticky: custom_fields.length() > 0, properties: custom_fields },
        ]
        json_fields = [
          { name: "custom", label: "Custom JSON parameters", hint: "Specify custom parameters using JSON object", control_type: "text-area" },
        ]
        file_fields + standard_fields + json_fields
      end,
    },

    create_contact_input: {
      fields: lambda do |_connection, _config_fields|
        [
          { name: "first_name", label: "First Name", sticky: true, optional: true },
          { name: "last_name", label: "Last Name", sticky: true, optional: true },
          { name: "fullname", label: "Full Name", sticky: true, hint: "Use as alternative to first/last name - automatically split at space", optional: true },
          { name: "email", label: "Email", sticky: true, optional: true, control_type: "email" },
          { name: "title", label: "Title", hint: "The title of the contact, ex. CEO, Sales manager
", sticky: true, optional: true },
          { name: "phone", label: "Phone", hint: "Phone number of the user in international format (ex. +13238701200)", sticky: false, optional: true, control_type: "phone" },
          { name: "mobile", label: "Mobile", hint: "Mobile number of the user in international format (ex. +12137105000)", sticky: true, optional: true, control_type: "phone" },
          { name: "note", label: "Note", sticky: false, optional: true },
          { name: "company_name", label: "Company Name", sticky: true, optional: true },
          { name: "company_number", label: "Company Number", sticky: false, optional: true },
        ]
      end,
    },

    custom_action_input: {
      fields: lambda do |_connection, config_fields|
        verb = config_fields["verb"]
        input_schema = parse_json(config_fields.dig("input", "schema") || "[]")
        data_props =
          input_schema.map do |field|
            if config_fields["request_type"] == "multipart" &&
               field["binary_content"] == "true"
              field["type"] = "object"
              field["properties"] = [
                { name: "file_content", optional: false },
                {
                  name: "content_type",
                  default: "text/plain",
                  sticky: true,
                },
                { name: "original_filename", sticky: true },
              ]
            end
            field
          end
        data_props = call("make_schema_builder_fields_sticky", data_props)
        input_data = if input_schema.present?
            if input_schema.dig(0, "type") == "array" &&
               input_schema.dig(0, "details", "fake_array")
              {
                name: "data",
                type: "array",
                of: "object",
                properties: data_props.dig(0, "properties"),
              }
            else
              { name: "data", type: "object", properties: data_props }
            end
          end

        [
          {
            name: "path",
            hint: "Base URI is <b>" \
            "https://api.getaccept.com/v1/" \
            "</b> - path will be appended to this URI. Use absolute URI to " \
            "override this base URI.",
            optional: false,
          },
          if %w[post put patch].include?(verb)
            {
              name: "request_type",
              default: "json",
              sticky: true,
              extends_schema: true,
              control_type: "select",
              pick_list: [
                ["JSON request body", "json"],
                ["URL encoded form", "url_encoded_form"],
                ["Mutipart form", "multipart"],
                ["Raw request body", "raw"],
              ],
            }
          end,
          {
            name: "response_type",
            default: "json",
            sticky: false,
            extends_schema: true,
            control_type: "select",
            pick_list: [["JSON response", "json"], ["Raw response", "raw"]],
          },
          if %w[get options delete].include?(verb)
            {
              name: "input",
              label: "Request URL parameters",
              sticky: true,
              add_field_label: "Add URL parameter",
              control_type: "form-schema-builder",
              type: "object",
              properties: [
                {
                  name: "schema",
                  sticky: input_schema.blank?,
                  extends_schema: true,
                },
                input_data,
              ].compact,
            }
          else
            {
              name: "input",
              label: "Request body parameters",
              sticky: true,
              type: "object",
              properties: if config_fields["request_type"] == "raw"
                [{
                  name: "data",
                  sticky: true,
                  control_type: "text-area",
                  type: "string",
                }]
              else
                [
                  {
                    name: "schema",
                    sticky: input_schema.blank?,
                    extends_schema: true,
                    schema_neutral: true,
                    control_type: "schema-designer",
                    sample_data_type: "json_input",
                    custom_properties: if config_fields["request_type"] == "multipart"
                      [{
                        name: "binary_content",
                        label: "File attachment",
                        default: false,
                        optional: true,
                        sticky: true,
                        render_input: "boolean_conversion",
                        parse_output: "boolean_conversion",
                        control_type: "checkbox",
                        type: "boolean",
                      }]
                    end,
                  },
                  input_data,
                ].compact
              end,
            }
          end,
          {
            name: "request_headers",
            sticky: false,
            extends_schema: true,
            control_type: "key_value",
            empty_list_title: "Does this HTTP request require headers?",
            empty_list_text: "Refer to the API documentation and add " \
            "required headers to this HTTP request",
            item_label: "Header",
            type: "array",
            of: "object",
            properties: [{ name: "key" }, { name: "value" }],
          },
          unless config_fields["response_type"] == "raw"
            {
              name: "output",
              label: "Response body",
              sticky: true,
              extends_schema: true,
              schema_neutral: true,
              control_type: "schema-designer",
              sample_data_type: "json_input",
            }
          end,
          {
            name: "response_headers",
            sticky: false,
            extends_schema: true,
            schema_neutral: true,
            control_type: "schema-designer",
            sample_data_type: "json_input",
          },
        ].compact
      end,
    },

    custom_action_output: {
      fields: lambda do |_connection, config_fields|
        response_body = { name: "body" }

        [
          if config_fields["response_type"] == "raw"
            response_body
          elsif (output = config_fields["output"])
            output_schema = call("format_schema", parse_json(output))
            if output_schema.dig(0, "type") == "array" &&
               output_schema.dig(0, "details", "fake_array")
              response_body[:type] = "array"
              response_body[:properties] = output_schema.dig(0, "properties")
            else
              response_body[:type] = "object"
              response_body[:properties] = output_schema
            end

            response_body
          end,
          if (headers = config_fields["response_headers"])
            header_props = parse_json(headers)&.map do |field|
              if field[:name].present?
                field[:name] = field[:name].gsub(/\W/, "_").downcase
              elsif field["name"].present?
                field["name"] = field["name"].gsub(/\W/, "_").downcase
              end
              field
            end

            { name: "headers", type: "object", properties: header_props }
          end,
        ].compact
      end,
    },
  },

  actions: {
    send_document: {
      title: "Create and send document",
      subtitle: "Send out a document using a template or uploaded file",
      description: "Send <span class='provider'>document</span> using a <span class='provider'>template or file</span> with <span class='provider'>GetAccept</span>",
      help: {
        body: "When you send a document via GetAccept, we deliver an email to all recipients, each containing a unique, secure link.<br> You can send out a file as a document from another trigger/source or select a predefined template from GetAccept. When using templates in combination with fields and attachments we recommend defining template roles in GetAccept.<br> To change default settings for sendings, notifications and reminders, go to <a href='https://app.getaccept.com/settings/document-settings' target='_blank'>document settings</a>.",
        learn_more_text: "Manage your templates in GetAccept",
        learn_more_url: "https://app.getaccept.com/template",
      },
      config_fields: [
        {
          name: "template_id",
          label: "Select a GetAccept template",
          type: "string",
          hint: "Select a template to use for the sending or leave empty to upload a file",
          sticky: true, control_type: "select", pick_list: "template_list",
        },
      ],
      input_fields: lambda do |object_definitions|
        object_definitions["send_document_input"]
      end,

      execute: lambda do |_connection, input|
        if input["custom"]
          input = input + parse_json(input["custom"])
          input.delete("custom")
        end
        if input["custom_fields"].present?
          input = call("format_custom_fields", input)
        end
        post("documents", input)
      end,
    },
    upload_attachment: {
      title: "Upload attachment",
      subtitle: "Upload a file to be used as attachment in document sendouts",
      description: "Upload <span class='provider'>attachment</span> to <span class='provider'>GetAccept</span>",
      hint: "You can upload attachment files to include with documents you send.",
      input_fields: lambda do
        [
          { name: "file_name", optional: false, sticky: true, },
          { name: "file_data", optional: false, sticky: true },
        ]
      end,

      execute: lambda do |_connection, input|
        post("upload").
          request_format_multipart_form.
          payload(file: [input["file_data"], "application/pdf"],
                  file_name: input["file_name"])
      end,

      output_fields: lambda do |_object_definitions|
        [
          { name: "id" },
          { name: "type" },
          { name: "title" },
          { name: "filename" },
        ]
      end,
    },

    upload_file: {
      title: "Upload file",
      subtitle: "Upload a document file (e.g. pdf, doc) to be used in a sendout",
      description: "Upload <span class='provider'>file</span> to <span class='provider'>GetAccept</span>",
      hint: "You can upload one file at a time and get a file id. The returned file id is used to connect a file with a GetAccept document which is sent to recipients. If you want to upload mutliple files you run multiple POST. We only accept files up to 10 MB as default. Uploaded file need to be imported/added to a document within 48 hours after uploading.\n\nWe recommended you to upload PDF files in order to guarantee the same look when sent. Other file types can be converted, such as:\n\nMirosoft Office: doc, docx, xl, xls, xlsx, ppt, pptx\nMac: numbers, key\nImages: jpg, jpeg, png\nOther: html, tex, csv",
      input_fields: lambda do
        [
          { name: "file_name", optional: false, sticky: true, hint: "Include file extension e.g. myfile.doc to make automatic file conversion work properly" },
          { name: "file_data", optional: false, sticky: true },
        ]
      end,

      execute: lambda do |_connection, input|
        post("upload").
          request_format_multipart_form.
          payload(file: [input["file_data"], "application/pdf"],
                  file_name: input["file_name"])
      end,

      output_fields: lambda do |_object_definitions|
        [
          { name: "file_id" },
          { name: "file_status" },
        ]
      end,
    },

    search_documents: {
      title: "Search documents",
      subtitle: "Search available documents from a GetAccept entity",
      description: "Search <span class='provider'>documents</span> in <span class='provider'>GetAccept</span>",
      help: "This action retrieve documents from GetAccept. Use this action to list and find available documents and apply filters to narrow down list.",
      input_fields: lambda do |_object_definitions|
        [
          { name: "filter", label: "Filter on status" },
          { name: "sort_by", label: "Sort result by" },
          { name: "sort_order", label: "Sort order" },
          { name: "showteam", label: "Include documents from team members", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "showall", label: "Include all documents from entity", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "external_id", label: "External id on document" },
        ]
      end,
      execute: lambda do |_connection, input, _input_schema, _output_schema|
        {
          documents: Array.wrap(get("documents").params(input)),
        }
      end,

      output_fields: lambda do |object_definitions|
        [
          {
            name: "documents",
            type: "array",
            of: "object",
            properties: object_definitions["document"],
          },
        ]
      end,

      sample_output: lambda do |_connection, input|
        get("documents/latest").params(input)
      end,
    },
    list_templates: {
      title: "List templates",
      subtitle: "List available templates from a GetAccept entity",
      description: "List <span class='provider'>templates</span> in <span class='provider'>GetAccept</span>",
      help: "This action retrieve templates from GetAccept. Use this action to list and find available templates.",
      input_fields: lambda do |_object_definitions|
        [
          { name: "showall", label: "Include all documents from entity", type: "boolean", control_type: "checkbox", render_input: "boolean_conversion", parse_output: "boolean_conversion" },
          { name: "folder_id", label: "Select a folder", control_type: "select", pick_list: "template_folder_list" },
        ]
      end,
      execute: lambda do |_connection, input, _input_schema, _output_schema|
        get("templates").params(input)
      end,

      output_fields: lambda do |object_definitions|
        [
          {
            name: "templates",
            type: "array",
            of: "object",
            properties: object_definitions["document"],
          },
        ]
      end,

      sample_output: lambda do |_connection, input|
        get("templates").params(input)
      end,
    },
    get_document_details: {
      title: "Get document details",
      subtitle: "Show all parameters and values for a specific document",
      description: "Get details about a specific <span class='provider'>document</span> in <span class='provider'>GetAccept</span>",
      input_fields: lambda { |_object_definitions|
        [{ name: "id", label: "Document ID", optional: false }]
      },
      output_fields: lambda { |object_definitions|
        object_definitions["document"]
      },
      execute: lambda { |_connection, input|
        get("documents/#{input["id"]}")
      },
    },

    get_document_fields: {
      title: "Get document fields",
      subtitle: "Show all available input fields for a specific document",
      description: "Get <span class='provider'>fields</span> for a <span class='provider'>document</span> in <span class='provider'>GetAccept</span>",
      input_fields: lambda { |_object_definitions|
        [
          { name: "id", label: "Document ID", optional: false },
        ]
      },
      output_fields: lambda { |object_definitions|
        object_definitions["fields"]
      },
      execute: lambda { |_connection, input|
        get("documents/#{input["id"]}/fields")
      },
    },

    get_document_field_values: {
      title: "Get document field values",
      subtitle: "Show all available input fields as key/value for a specific document",
      description: "Get <span class='provider'>field values</span> for a <span class='provider'>document</span> in <span class='provider'>GetAccept</span>",
      config_fields: [
        {
          name: "document_id",
          label: "Select sample document with same fields to use when building workflow",
          hint: "You must use the same field labels in the sample and sent document",
          control_type: "select",
          type: "string",
          optional: false,
          sticky: true,
          control_type: "select", pick_list: "document_list",
        },
      ],
      input_fields: lambda { |_object_definitions|
        [
          { name: "id", label: "Document ID", hint: "A Document ID from previous step", optional: false },
        ]
      },
      output_fields: lambda { |object_definitions|
        object_definitions["field_values_output"]
      },
      execute: lambda { |_connection, input|
        {
          fields: get("documents/#{input["id"]}/field_values"),
        }
      },
    },

    get_document_recipients: {
      title: "Get document recipients",
      subtitle: "Show a list of all recipients for a specific document",
      description: "Get <span class='provider'>recipients</span> for a <span class='provider'>document</span> in <span class='provider'>GetAccept</span>",
      input_fields: lambda { |_object_definitions|
        [{ name: "id", label: "Document ID", optional: false }]
      },
      output_fields: lambda { |object_definitions|
        object_definitions["recipients"]
      },
      execute: lambda { |_connection, input|
        get("documents/#{input["id"]}/recipients")
      },
    },

    download_document: {
      title: "Download document",
      subtitle: "Get the binary file or a download url for a PDF version of a signed document",
      description: "Download a <span class='provider'>document</span> in <span class='provider'>GetAccept</span>",
      input_fields: lambda { |_object_definitions|
        [
          { name: "id", label: "Document ID", optional: false },
          { name: "direct", type: "boolean", label: "Direct download", hint: "Return the binary file directly", default: true, optiona: true, sticky: false, control_type: "checkbox" },
        ]
      },
      output_fields: lambda { |_object_definitions|
        [
          { name: "content" },
        ]
      },
      execute: lambda { |_connection, input|
        file = get("documents/#{input["id"]}/download?direct=#{input["direct"]}").response_format_raw
        { content: file }
      },
      summarize_output: ["content"],
      sample_output: lambda { |_connection, _input|
        { "content": "test" }
      },
    },

    list_users: {
      title: "List users",
      subtitle: "Show a list of available users",
      description: "List <span class='provider'>users</span> in <span class='provider'>GetAccept</span>",
      help: {
        body: "User API documentation",
        learn_more_text: "Read more",
        learn_more_url: "https://app.getaccept.com/api/#listusers",
      },
      output_fields: lambda { |object_definitions|
        object_definitions["users"]
      },
      execute: lambda { |_connection, _input|
        get("users")
      },
    },

    get_user_details: {
      title: "Get user details",
      subtitle: "Show details for specific user",
      description: "Get <span class='provider'>user details</span> in <span class='provider'>GetAccept</span>",
      help: {
        body: "User API documentation",
        learn_more_text: "Read more",
        learn_more_url: "https://app.getaccept.com/api/#getuser",
      },
      input_fields: lambda { |_object_definitions|
        [{ name: "id", label: "User ID", optional: false,
           control_type: "text" }]
      },
      output_fields: lambda { |object_definitions|
        object_definitions["users"]
      },
      execute: lambda { |_connection, input|
        get("users/#{input["id"]}")
      },
    },

    create_contact: {
      title: "Create contact",
      subtitle: "Create a new contact to be used for future document sendouts, e.g. to sync CRM contacts with GetAccept",
      description: "Create a new <span class='provider'>contact</span> in <span class='provider'>GetAccept</span>",
      help: {
        body: "Create Contact API documentation",
        learn_more_text: "Read more",
        learn_more_url: "https://app.getaccept.com/api/#createcontact",
      },
      input_fields: lambda do |object_definitions|
        object_definitions["create_contact_input"]
      end,
      output_fields: lambda { |_object_definitions|
        [
          { name: "contact_id" },
        ]
      },
      execute: lambda { |_connection, input|
        post("contacts", input)
      },
    },

    custom_action: {
      title: "Custom action",
      subtitle: "Build your own GetAccept action with a HTTP request",
      description: lambda do |object_value, _object_label|
        "<span class='provider'>" \
        "#{object_value[:action_name] || "Custom action"}</span> in " \
        "<span class='provider'>GetAccept</span>"
      end,

      help: {
        body: "Build your own GetAccept action with a HTTP request. " \
        "The request will be authorized with your GetAccept connection.",
        learn_more_url: "https://app.getaccept.com/api/",
        learn_more_text: "GetAccept API documentation",
      },

      config_fields: [
        {
          name: "action_name",
          hint: "Give this action you're building a descriptive name, e.g. " \
          "create record, get record",
          default: "Custom action",
          optional: false,
          schema_neutral: true,
        },
        {
          name: "verb",
          label: "Method",
          hint: "Select HTTP method of the request",
          optional: false,
          control_type: "select",
          pick_list: %w[get post put patch options delete]
            .map { |verb| [verb.upcase, verb] },
        },
      ],

      input_fields: lambda do |object_definition|
        object_definition["custom_action_input"]
      end,

      execute: lambda do |_connection, input|
        verb = input["verb"]
        if %w[get post put patch options delete].exclude?(verb)
          error("#{verb.upcase} not supported")
        end
        path = input["path"]
        data = input.dig("input", "data") || {}
        if input["request_type"] == "multipart"
          data = data.each_with_object({}) do |(key, val), hash|
            hash[key] = if val.is_a?(Hash)
                [val[:file_content],
                 val[:content_type],
                 val[:original_filename]]
              else
                val
              end
          end
        end
        request_headers = input["request_headers"]
          &.each_with_object({}) do |item, hash|
          hash[item["key"]] = item["value"]
        end || {}
        request = case verb
        when "get"
          get(path, data)
        when "post"
          if input["request_type"] == "raw"
            post(path).request_body(data)
          else
            post(path, data)
          end
        when "put"
          if input["request_type"] == "raw"
            put(path).request_body(data)
          else
            put(path, data)
          end
        when "patch"
          if input["request_type"] == "raw"
            patch(path).request_body(data)
          else
            patch(path, data)
          end
        when "options"
          options(path, data)
        when "delete"
          delete(path, data)
        end.headers(request_headers)
        request = case input["request_type"]
          when "url_encoded_form"
            request.request_format_www_form_urlencoded
          when "multipart"
            request.request_format_multipart_form
          else
            request
          end
        response =
          if input["response_type"] == "raw"
            request.response_format_raw
          else
            request
          end
            .after_error_response(/.*/) do |code, body, headers, message|
            error({ code: code, message: message, body: body, headers: headers }
              .to_json)
          end

        response.after_response do |_code, res_body, res_headers|
          {
            body: res_body ? call("format_response", res_body) : nil,
            headers: res_headers,
          }
        end
      end,

      output_fields: lambda do |object_definition|
        object_definition["custom_action_output"]
      end,
    },
  },

  triggers: {
    document_signed: {
      title: "Document has been signed",
      subtitle: "Triggered when a document has been signed",
      description: "When a <span class='provider'>document</span> is <span class='provider'>signed</span> in <span class='provider'>GetAccept</span>",

      config_fields: [
        {
          name: "document_id",
          label: "Sample document to use while building your workflow",
          hint: "To use custom fields you must use a document with same field labels",
          control_type: "select",
          type: "string",
          optional: true,
          sticky: true,
          control_type: "select", pick_list: "document_list",
        },
      ],
      input_fields: lambda do |_object_definitions|
        [
          {
            name: "global",
            label: "Trigger for all users in entity",
            control_type: "checkbox",
            default: true,
            optional: true,
            sticky: true,
            type: "boolean",
            render_input: "boolean_conversion",
            parse_output: "boolean_conversion",
          },
        ]
      end,

      webhook_subscribe: lambda do |webhook_url, _connection, input|
        post("subscriptions",
             target_url: webhook_url,
             event: "document.signed",
             global: input["global"])
      end,

      webhook_notification: lambda do |_input, payload|
        payload
      end,

      webhook_unsubscribe: lambda do |webhook|
        delete("subscriptions/#{webhook["id"]}")
      end,

      dedup: lambda do |subscription|
        subscription.dig('document', 'id')
      end,

      output_fields: lambda do |object_definitions|
        object_definitions["subscription"]
      end,

      sample_output: lambda do |_connection, _input|
        call("sample_subscription")
      end,
    },

    other_document_event: {
      title: "Other document event",
      subtitle: "Use this trigger for other document status, e.g. viewed, reviewed and rejected",
      description: lambda do |_object_value, object_label|
        "When a <span class='provider'>document</span> get status <span class='provider'>" \
        "#{object_label[:event]&.downcase || "update"}</span> in " \
        "<span class='provider'>GetAccept</span>"
      end,

      config_fields: [
        {
          name: "event",
          label: "Trigger when a document gets",
          control_type: "select",
          pick_list: "event_list",
          default: "document.viewed",
          optional: false,
        },
        {
          name: "document_id",
          label: "Sample document to use while building your workflow",
          hint: "To use custom fields you must use a document with same field labels",
          control_type: "select",
          type: "string",
          optional: true,
          sticky: true,
          control_type: "select", pick_list: "document_list",
        },
      ],
      input_fields: lambda do |_object_definitions|
        [
          {
            name: "global",
            label: "Trigger for all users in entity",
            control_type: "checkbox",
            default: true,
            optional: true,
            sticky: true,
            type: "boolean",
            render_input: "boolean_conversion",
            parse_output: "boolean_conversion",
          },
        ]
      end,

      webhook_subscribe: lambda do |webhook_url, _connection, input|
        post("subscriptions",
             target_url: webhook_url,
             event: input["event"],
             global: input["global"])
      end,

      webhook_notification: lambda do |_input, payload|
        payload
      end,

      webhook_unsubscribe: lambda do |webhook|
        delete("subscriptions/#{webhook["id"]}")
      end,

      dedup: lambda do |subscription|
        subscription.dig('document', 'id')
      end,

      output_fields: lambda do |object_definitions|
        object_definitions["subscription"]
      end,

      sample_output: lambda do |_connection, _input|
        call("sample_subscription")
      end,
    },

  },

  pick_lists: {
    # Picklists can be referenced by inputs fields or object_definitions
    # possible arguements - connection
    # see more at https://docs.workato.com/developing-connectors/sdk/pick-list.html
    template_list: lambda do |_connection|
      [["- No template / Upload file -", ""]] + get("templates")["templates"].pluck("name", "id")
    end,
    template_folder_list: lambda do |_connection|
      [["- All templates -", ""]] + get("folders?type=template")["folders"].pluck("name", "id")
    end,
    document_list: lambda do |_connection|
      [["- No document selected -", ""]] + get("documents").pluck("name", "id")
    end,
    recipient_role_list: lambda do |_connection|
      [
        ["Signer", "signer"],
        ["View only", "cc"],
        ["Approver", "approver"],
      ]
    end,
    document_type_list: lambda do |_connection|
      [
        ["Sales", "sales"],
        ["HR", "hr"],
        ["Presentation", "introduction"],
        ["Other", "other"],
      ]
    end,
    event_list: lambda do |_connection|
      [
        # Display name, value
        ["Created", "document.created"],
        ["Sent", "document.sent"],
        ["Viewed", "document.viewed"],
        ["Reviewed", "document.reviewed"],
        ["Signed", "document.signed"],
        ["Approved", "document.approved"],
        ["Expired", "document.expired"],
        ["Rejected", "document.rejected"],
        ["Downloaded", "document.downloaded"],
        ["Printed", "document.printed"],
        ["Forwarded", "document.forwarded"],
        ["Partially-signed", "document.partially_signed"],
        ["Commented", "document.commented"],
        ["Hard-Bounced", "document.hardbounced"],
      ]
    end,

    document_status_list: lambda do |_connection|
      [
        # Display name, value
        ["Created", "created"],
        ["Sent", "sent"],
        ["Viewed", "viewed"],
        ["Reviewed", "reviewed"],
        ["Signed", "signed"],
        ["Approved", "approved"],
        ["Expired", "expired"],
        ["Rejected", "rejected"],
        ["Downloaded", "downloaded"],
        ["Printed", "printed"],
        ["Forwarded", "forwarded"],
        ["Partially-signed", "partially_signed"],
        ["Commented", "commented"],
        ["Hard-Bounced", "hardbounced"],
      ]
    end,

  },

  # Reusable methods can be called from object_definitions, picklists or actions
  # See more at https://docs.workato.com/developing-connectors/sdk/methods.html#reusable-methods
  methods: {
    sample_subscription: lambda do
      {
        "document": {
          "id": "abc123def",
          "name": "Test proposal",
          "value": 4900,
          "external_id": "doc_19953",
          "type": "sales",
          "tags": "",
          "company_name": "Demo Company Inc",
          "company_id": "9nr2h6kn",
          "is_selfsign": true,
          "is_signing_biometric": false,
          "is_signing_initials": false,
          "is_private": false,
          "status": "signed",
          "send_date": "2020-10-17T09:16:53+00:00",
          "sender_email": "demo@company.com",
          "sender_name": "Demo Admin",
          "sign_date": "2020-10-19T17:56:40+00:00",
          "user_id": "aw8nkgnx",
          "email_send_template_id": "ax2n5gxx",
          "email_send_subject": "{{sender.first_name}} sent you document {{document.name}} for review",
          "email_send_message": "Hello {{recipient.first_name}}, ",
          "is_signing": true,
          "is_signing_order": false,
          "is_video": false,
          "expiration_date": "2020-10-31",
          "is_scheduled_sending": false,
          "scheduled_sending_time": "2020-10-17 08:46:00",
          "is_reminder_sending": false,
          "video_id": 0,
          "preview_url": "https:\/\/app.getaccept.com\/v\/gpyjhkyn\/8pxqyt4n\/a\/632fbe364a9c47f32059bafc16eebb04",
          "download_url": "https:\/\/ga-x-y-1.s3-x-y-1.amazonaws.com/xyz123/signed/abc123def.pdf",
        },
        "recipient": {
          "fullname": "Test Testersson",
          "first_name": "Test",
          "last_name": "Testersson",
          "email": "test.testersson@getaccept.com",
          "title": "Tester",
          "note": "",
          "gender": "M",
          "mobile": "",
          "thumb_url": "",
          "role": "signer",
          "company_name": "",
          "company_number": "",
          "status": "signed",
          "order_num": "1",
        },
        "entity": {
          "email_send_subject": "",
          "email_send_message": "",
        },
        "payload": "action=dosomething",
        "custom_fields": {
          "speaker_name": "Demo Admin",
          "shoe_size": "9",
        },
        "event": "document.signed",
        "event_type": "document",
        "event_action": "signed",
        "subscription_id": "pw1333abc",
      }
    end,

    make_schema_builder_fields_sticky: lambda do |schema|
      schema.map do |field|
        if field["properties"].present?
          field["properties"] = call("make_schema_builder_fields_sticky",
                                     field["properties"])
        end
        field["sticky"] = true

        field
      end
    end,
    format_schema: lambda do |input|
      input&.map do |field|
        if (props = field[:properties])
          field[:properties] = call("format_schema", props)
        elsif (props = field["properties"])
          field["properties"] = call("format_schema", props)
        end
        if (name = field[:name])
          field[:label] = field[:label].presence || name.labelize
          field[:name] = name
            .gsub(/\W/) { |spl_chr| "__#{spl_chr.encode_hex}__" }
        elsif (name = field["name"])
          field["label"] = field["label"].presence || name.labelize
          field["name"] = name
            .gsub(/\W/) { |spl_chr| "__#{spl_chr.encode_hex}__" }
        end

        field
      end
    end,
    format_response: lambda do |response|
      response = response&.compact unless response.is_a?(String) || response
      if response.is_a?(Array)
        response.map do |array_value|
          call("format_response", array_value)
        end
      elsif response.is_a?(Hash)
        response.each_with_object({}) do |(key, value), hash|
          key = key.gsub(/\W/) { |spl_chr| "__#{spl_chr.encode_hex}__" }
          if value.is_a?(Array) || value.is_a?(Hash)
            value = call("format_response", value)
          end
          hash[key] = value
        end
      else
        response
      end
    end,
    format_custom_fields: lambda do |input|
      if input["custom_fields"].present?
        custom_fields = []
        input["custom_fields"].map do |key, value|
          custom_fields << { 'id': key, 'value': value }
        end
        input["custom_fields"] = custom_fields
      end
      input
    end,
  },
}
