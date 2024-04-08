{%- macro sum_categorical(column_name, categorical_values) -%}
    {%- for cat_val in categorical_values %}
    sum(iff( {{ column_name }} = '{{ cat_val }}', 1, 0)) AS total_{{ cat_val }} {% if not loop.last %},{% endif %}
    {%- endfor %}
{%- endmacro -%}