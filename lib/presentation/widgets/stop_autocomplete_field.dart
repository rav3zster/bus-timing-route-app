import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models.dart';
import '../app_theme.dart';

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
    final c = context.appColors;

    return Autocomplete<Stop>(
      initialValue: initialValue != null
          ? TextEditingValue(text: initialValue!.name)
          : null,
      optionsBuilder: (TextEditingValue val) {
        final q = val.text.toLowerCase();
        if (q.isEmpty) return stops;
        return stops.where((s) => s.name.toLowerCase().contains(q));
      },
      displayStringForOption: (s) => s.name,
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, _) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: GoogleFonts.spaceGrotesk(
            color: c.text, fontSize: 13, fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.spaceGrotesk(color: c.textDim, fontSize: 13),
            errorText: errorText,
            prefixIcon: Icon(Icons.place_outlined, size: 16, color: c.textSub),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, size: 14, color: c.textSub),
                    onPressed: () {
                      controller.clear();
                      onSelected(null);
                    },
                  )
                : null,
            filled: true,
            fillColor: c.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: c.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: c.text, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14,
            ),
          ),
          onChanged: (v) {
            if (v.isEmpty) onSelected(null);
          },
        );
      },
      optionsViewBuilder: (context, onOptionSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 400),
              child: Container(
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border.all(color: c.border),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, i) {
                    final stop = options.elementAt(i);
                    return InkWell(
                      onTap: () => onOptionSelected(stop),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: c.border),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_bus_outlined,
                              size: 13, color: c.textDim,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                stop.name,
                                style: GoogleFonts.spaceGrotesk(
                                  color: c.text, fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
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
          ),
        );
      },
    );
  }
}
