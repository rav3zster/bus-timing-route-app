import 'package:flutter/material.dart';
import '../../domain/models.dart';

class StopAutocompleteField extends StatelessWidget {
  final String label;
  final List<Stop> stops;
  final Stop? initialValue;
  final void Function(Stop?) onSelected;
  final String? errorText;

  const StopAutocompleteField({
    super.key,
    required this.label,
    required this.stops,
    required this.onSelected,
    this.initialValue,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Autocomplete<Stop>(
      initialValue: initialValue != null
          ? TextEditingValue(text: initialValue!.name)
          : null,
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.toLowerCase();
        if (query.isEmpty) return stops;
        return stops.where((s) => s.name.toLowerCase().contains(query));
      },
      displayStringForOption: (Stop stop) => stop.name,
      onSelected: (Stop stop) => onSelected(stop),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: label,
            errorText: errorText,
            prefixIcon: Icon(
              Icons.place_outlined,
              size: 18,
              color: cs.secondary,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, size: 16, color: cs.secondary),
                    onPressed: () {
                      controller.clear();
                      onSelected(null);
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            if (value.isEmpty) onSelected(null);
          },
        );
      },
      optionsViewBuilder: (context, onOptionSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: const Color(0xFF1A1A1A),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: cs.outline),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 400),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final stop = options.elementAt(index);
                  return InkWell(
                    onTap: () => onOptionSelected(stop),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_bus_outlined,
                            size: 14,
                            color: cs.secondary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            stop.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
