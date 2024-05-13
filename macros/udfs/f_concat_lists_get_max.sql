{% macro create_f_concat_lists_get_max() %}

    create or replace function {{target.schema}}.f_concat_lists_get_max("list_1" varchar, "list_2" varchar)
        returns string
        language javascript
        comment = 'Returns the maximum value in a set of distinct strings found in the concatenation of two lists of strings'
    as
    $$

        const list_1_array = (list_1 || '').split(',').map(s => s.trim());
        const list_2_array = (list_2 || '').split(',').map(s => s.trim());
        const set = new Set([...list_1_array,...list_2_array]);
        set.delete('');
        set.delete('N/A');
        set.delete('null');
        set.delete(null);
        const max_value = [...set].sort((a, b) => b - a)[0];
        return max_value || null;

    $$

{% endmacro %}