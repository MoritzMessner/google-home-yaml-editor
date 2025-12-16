import 'package:flutter/material.dart';

import '../../../../domain/models/automation.dart';
import '../../../core/themes/app_theme.dart';

/// Card for editing a single action
class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.action,
    required this.index,
    required this.onChanged,
    required this.onRemove,
  });

  final AutomationAction action;
  final int index;
  final ValueChanged<AutomationAction> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppTheme.actionColor, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt,
                    size: 18,
                    color: AppTheme.actionColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _getActionType(action),
                      decoration: const InputDecoration(
                        labelText: 'Action Type',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'onoff',
                          child: Text('On/Off'),
                        ),
                        DropdownMenuItem(
                          value: 'brightness',
                          child: Text('Brightness'),
                        ),
                        DropdownMenuItem(
                          value: 'color',
                          child: Text('Color'),
                        ),
                        DropdownMenuItem(
                          value: 'delay',
                          child: Text('Delay'),
                        ),
                      ],
                      onChanged: (value) => _changeActionType(value ?? 'onoff'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                    tooltip: 'Remove action',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionFields(context),
            ],
          ),
        ),
      ),
    );
  }

  String _getActionType(AutomationAction action) {
    return switch (action) {
      OnOffAction() => 'onoff',
      BrightnessAction() => 'brightness',
      ColorAction() => 'color',
      DelayAction() => 'delay',
    };
  }

  void _changeActionType(String type) {
    switch (type) {
      case 'onoff':
        onChanged(const OnOffAction(devices: [], on: true));
      case 'brightness':
        onChanged(const BrightnessAction(devices: [], brightness: 100));
      case 'color':
        onChanged(ColorAction(
          devices: const [],
          color: const ColorName('warm white'),
        ));
      case 'delay':
        onChanged(const DelayAction(duration: '1sec'));
    }
  }

  Widget _buildActionFields(BuildContext context) {
    return switch (action) {
      OnOffAction(:final devices, :final on) => Column(
          children: [
            _DevicesField(
              devices: devices,
              onChanged: (newDevices) =>
                  onChanged(OnOffAction(devices: newDevices, on: on)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('State:'),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('ON'),
                  selected: on,
                  selectedColor: AppTheme.actionColor,
                  onSelected: (_) =>
                      onChanged(OnOffAction(devices: devices, on: true)),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('OFF'),
                  selected: !on,
                  selectedColor: AppTheme.actionColor,
                  onSelected: (_) =>
                      onChanged(OnOffAction(devices: devices, on: false)),
                ),
              ],
            ),
          ],
        ),
      BrightnessAction(:final devices, :final brightness) => Column(
          children: [
            _DevicesField(
              devices: devices,
              onChanged: (newDevices) => onChanged(
                BrightnessAction(devices: newDevices, brightness: brightness),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.brightness_6, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: brightness.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '$brightness%',
                    onChanged: (value) => onChanged(
                      BrightnessAction(
                        devices: devices,
                        brightness: value.round(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '$brightness%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ColorAction(:final devices, :final color) => Column(
          children: [
            _DevicesField(
              devices: devices,
              onChanged: (newDevices) =>
                  onChanged(ColorAction(devices: newDevices, color: color)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _getColorType(color),
                    decoration: const InputDecoration(
                      labelText: 'Color Type',
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'name', child: Text('By Name')),
                      DropdownMenuItem(
                          value: 'temperature', child: Text('Temperature')),
                    ],
                    onChanged: (type) {
                      if (type == 'name') {
                        onChanged(ColorAction(
                          devices: devices,
                          color: const ColorName('warm white'),
                        ));
                      } else {
                        onChanged(ColorAction(
                          devices: devices,
                          color: const ColorTemperature('2700K'),
                        ));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildColorValueField(devices, color)),
              ],
            ),
          ],
        ),
      DelayAction(:final duration) => TextFormField(
          initialValue: duration,
          key: ValueKey('delay_$duration'),
          decoration: const InputDecoration(
            labelText: 'Duration',
            hintText: 'e.g., 3sec, 1min',
            isDense: true,
            prefixIcon: Icon(Icons.timer, size: 18),
          ),
          onChanged: (value) => onChanged(DelayAction(duration: value)),
        ),
    };
  }

  String _getColorType(ColorValue color) {
    return switch (color) {
      ColorName() => 'name',
      ColorTemperature() => 'temperature',
    };
  }

  Widget _buildColorValueField(List<String> devices, ColorValue color) {
    return switch (color) {
      ColorName(:final name) => TextFormField(
          initialValue: name,
          key: ValueKey('color_name_$name'),
          decoration: const InputDecoration(
            labelText: 'Color Name',
            hintText: 'e.g., warm white',
            isDense: true,
          ),
          onChanged: (value) => onChanged(ColorAction(
            devices: devices,
            color: ColorName(value),
          )),
        ),
      ColorTemperature(:final temperature) => TextFormField(
          initialValue: temperature,
          key: ValueKey('color_temp_$temperature'),
          decoration: const InputDecoration(
            labelText: 'Temperature',
            hintText: 'e.g., 2700K',
            isDense: true,
          ),
          onChanged: (value) => onChanged(ColorAction(
            devices: devices,
            color: ColorTemperature(value),
          )),
        ),
    };
  }
}

/// Field for editing a list of devices
class _DevicesField extends StatefulWidget {
  const _DevicesField({
    required this.devices,
    required this.onChanged,
  });

  final List<String> devices;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_DevicesField> createState() => _DevicesFieldState();
}

class _DevicesFieldState extends State<_DevicesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.devices.join('\n'));
  }

  @override
  void didUpdateWidget(_DevicesField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.devices.join('\n');
    if (_controller.text != newText && !_controller.text.contains('\n')) {
      // Only update if significantly different
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: 'Devices (one per line)',
        hintText: 'Device 1 - Room\nDevice 2 - Room',
        isDense: true,
        prefixIcon: Icon(Icons.devices, size: 18),
      ),
      maxLines: 3,
      minLines: 1,
      onChanged: (value) {
        final devices = value
            .split('\n')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        widget.onChanged(devices);
      },
    );
  }
}

