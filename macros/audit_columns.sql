{% macro audit_columns(source_file=none) %}
    {#
      This macro adds standard metadata/audit columns to models:
      - ingestion_timestamp: The time the model was executed.
      - source_file_name: The name of the source data file or table.
    #}
    current_timestamp() as ingestion_timestamp,
    {% if source_file -%}
        '{{ source_file }}' as source_file_name
    {%- else -%}
        '{{ this.name }}' as source_file_name
    {%- endif %}
{% endmacro %}
