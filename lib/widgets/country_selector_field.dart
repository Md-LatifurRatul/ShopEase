import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountrySelectorField extends StatelessWidget {
  const CountrySelectorField({
    super.key,
    this.selectedCountry,
    required this.onCountrySelected,
    required this.label,
  });
  final String? selectedCountry;
  final void Function(String country) onCountrySelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          onSelect: (Country country) {
            onCountrySelected(country.name);
          },
        );
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Choose your country',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          controller: TextEditingController(text: selectedCountry ?? ''),
          validator:
              (value) =>
                  value == null || value.isEmpty
                      ? 'Please select a country'
                      : null,
        ),
      ),
    );
  }
}
