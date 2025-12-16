import 'package:flutter/material.dart';

import '../../../../domain/models/automation.dart';
import '../../../core/themes/app_theme.dart';

/// Card for editing a single starter
class StarterCard extends StatelessWidget {
  const StarterCard({
    super.key,
    required this.starter,
    required this.onChanged,
    required this.onRemove,
    this.canRemove = true,
  });

  final Starter starter;
  final ValueChanged<Starter> onChanged;
  final VoidCallback onRemove;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: AppTheme.starterColor, width: 3),
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
                    Icons.play_circle_outline,
                    size: 18,
                    color: AppTheme.starterColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _getStarterType(starter),
                      decoration: const InputDecoration(
                        labelText: 'Trigger Type',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'okgoogle',
                          child: Text('OK Google Command'),
                        ),
                        DropdownMenuItem(
                          value: 'device_state',
                          child: Text('Device State'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == 'okgoogle') {
                          onChanged(const OkGoogleStarter(''));
                        } else {
                          onChanged(const DeviceStateStarter(
                            device: '',
                            state: 'on',
                            value: true,
                          ));
                        }
                      },
                    ),
                  ),
                  if (canRemove)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: onRemove,
                      tooltip: 'Remove starter',
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _buildStarterFields(context),
            ],
          ),
        ),
      ),
    );
  }

  String _getStarterType(Starter starter) {
    return switch (starter) {
      OkGoogleStarter() => 'okgoogle',
      DeviceStateStarter() => 'device_state',
    };
  }

  Widget _buildStarterFields(BuildContext context) {
    return switch (starter) {
      OkGoogleStarter(:final query) => TextFormField(
          initialValue: query,
          key: ValueKey('okgoogle_$query'),
          decoration: const InputDecoration(
            labelText: 'Voice Command',
            hintText: 'e.g., "Turn on living room lights"',
            isDense: true,
            prefixIcon: Icon(Icons.mic, size: 18),
          ),
          onChanged: (value) => onChanged(OkGoogleStarter(value)),
        ),
      DeviceStateStarter(:final device, :final state, :final value) => Column(
          children: [
            TextFormField(
              initialValue: device,
              key: ValueKey('device_$device'),
              decoration: const InputDecoration(
                labelText: 'Device',
                hintText: 'Device name',
                isDense: true,
                prefixIcon: Icon(Icons.devices, size: 18),
              ),
              onChanged: (newDevice) => onChanged(DeviceStateStarter(
                device: newDevice,
                state: state,
                value: value,
              )),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: state,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'on', child: Text('On')),
                      DropdownMenuItem(value: 'off', child: Text('Off')),
                    ],
                    onChanged: (newState) => onChanged(DeviceStateStarter(
                      device: device,
                      state: newState ?? 'on',
                      value: value,
                    )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<bool>(
                    value: value == true,
                    decoration: const InputDecoration(
                      labelText: 'Is',
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: true, child: Text('True')),
                      DropdownMenuItem(value: false, child: Text('False')),
                    ],
                    onChanged: (newValue) => onChanged(DeviceStateStarter(
                      device: device,
                      state: state,
                      value: newValue ?? true,
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
    };
  }
}

