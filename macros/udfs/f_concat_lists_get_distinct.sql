{% macro create_f_concat_lists_get_distinct() %}

    create or replace function {{target.schema}}.f_concat_lists_get_distinct("list_1" varchar, "list_2" varchar)
        returns string
        language javascript
        comment = 'Returns a set of distinct strings found in the concatenation of two lists of strings'
    as
    $$

        const list_1_array = (list_1 || '').split(',').map(s => s.trim());
        const list_2_array = (list_2 || '').split(',').map(s => s.trim());
        const set = new Set([...list_1_array,...list_2_array]);
        set.delete('');
        set.delete('N/A');
        set.delete('null');
        set.delete(null);
        return [...set].join(',') || null;
    $$

{% endmacro %}