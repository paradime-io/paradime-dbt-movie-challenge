{% macro create_f_concat_lists_get_min() %}

    create or replace function {{target.schema}}.f_concat_lists_get_min("list_1" varchar, "list_2" varchar)
        returns string
        language javascript
        comment = 'Returns the minimum value in a set of distinct strings found in the concatenation of two lists of strings'
    as
    $$

        const list_1_array = (list_1 || '').split(',').map(s => s.trim());
        const list_2_array = (list_2 || '').split(',').map(s => s.trim());
        const set = new Set([...list_1_array,...list_2_array]);
        set.delete('');
        set.delete('N/A');
        set.delete('null');
        set.delete(null);
        const min_value = [...set].sort()[0];
        return min_value || null;

    $$

{% endmacro %}