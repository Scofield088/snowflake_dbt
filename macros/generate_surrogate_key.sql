{% macro generate_surrogate_key(field_list) %}
    {#
      This macro generates a deterministic surrogate key (MD5 hash) by concatenating 
      a list of fields with a separator and handling null values.
      It functions similarly to Spark's md5(concat_ws('-', coalesce(col1, ''), ...)).
    #}
    md5(
        {%- for field in field_list -%}
            coalesce(cast({{ field }} as {{ dbt.type_string() }}), '_dbt_null_placeholder_')
            {%- if not loop.last %} || '-' || {% endif -%}
        {%- endfor -%}
    )
{% endmacro %}
