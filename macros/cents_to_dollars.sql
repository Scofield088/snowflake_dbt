{% macro cents_to_dollars(column_name, decimal_places=2) %}
    {#
      This macro converts monetary amounts in cents into dollars.
      It rounds the output to the specified number of decimal places (default is 2).
    #}
    round(cast({{ column_name }} as decimal(16, 4)) / 100, {{ decimal_places }})
{% endmacro %}
