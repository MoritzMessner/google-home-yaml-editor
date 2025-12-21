import 'package:flutter/material.dart';

import '../../../../domain/models/condition.dart'; // Added for HomePresenceMode
import '../../../../domain/models/starter.dart';
import '../../../core/themes/app_theme.dart';
import 'weekday_selector.dart';

/// Card for editing a starter (trigger) in the automation
class StarterCard extends StatelessWidget {
  const StarterCard({
    super.key,
    required this.starter,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final Starter starter;
  final bool canRemove;
  final ValueChanged<Starter> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final currentType = StarterType.fromStarter(starter);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppTheme.starterColor.withValues(alpha: 0.7),
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<StarterType>(
                      initialValue: currentType,
                      decoration: const InputDecoration(
                        labelText: 'Trigger Type',
                        isDense: true,
                      ),
                      items: StarterType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type.displayName,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (type) {
                        if (type != null && type != currentType) {
                          onChanged(type.createDefault());
                        }
                      },
                    ),
                  ),
                  if (canRemove) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: onRemove,
                      tooltip: 'Remove trigger',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
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

  Widget _buildStarterFields(BuildContext context) {
    return switch (starter) {
      OkGoogleStarter s => _buildOkGoogleFields(s),
      TimeScheduleStarter s => _buildTimeScheduleFields(s),
      HomePresenceStarter s => _buildHomePresenceFields(s),
      DoorbellPressStarter s => _buildDeviceField(
          s.device, 'Device', (v) => DoorbellPressStarter(device: v)),
      MotionDetectionEventStarter s => _buildDeviceField(
          s.device, 'Device', (v) => MotionDetectionEventStarter(device: v)),
      PersonDetectionStarter s => _buildDeviceField(
          s.device, 'Device', (v) => PersonDetectionStarter(device: v)),
      FaceFamiliarDetectionStarter s => _buildDeviceField(
          s.device, 'Device', (v) => FaceFamiliarDetectionStarter(device: v)),
      FaceUnfamiliarDetectionStarter s => _buildDeviceField(
          s.device, 'Device', (v) => FaceUnfamiliarDetectionStarter(device: v)),
      AnimalDetectionStarter s => _buildDeviceField(
          s.device, 'Device', (v) => AnimalDetectionStarter(device: v)),
      MovingVehicleDetectionStarter s => _buildDeviceField(
          s.device, 'Device', (v) => MovingVehicleDetectionStarter(device: v)),
      PackageDeliveredStarter s => _buildDeviceField(
          s.device, 'Device', (v) => PackageDeliveredStarter(device: v)),
      PersonTalkingStarter s => _buildDeviceField(
          s.device, 'Device', (v) => PersonTalkingStarter(device: v)),
      SoundEventStarter s => _buildDeviceField(
          s.device, 'Device', (v) => SoundEventStarter(device: v)),
      OnOffStateStarter s => _buildOnOffStateFields(s),
      BrightnessStateStarter s => _buildBrightnessStateFields(s),
      LockUnlockStateStarter s => _buildLockUnlockStateFields(s),
      OpenCloseStateStarter s => _buildOpenCloseStateFields(s),
      TemperatureSettingStarter s => _buildTemperatureSettingFields(s),
      MotionDetectionStateStarter s => _buildMotionDetectionStateFields(s),
      OccupancyStateStarter s => _buildOccupancyStateFields(s),
      EnergyStorageStateStarter s => _buildEnergyStorageStateFields(s),
      TimerStateStarter s => _buildTimerStateFields(s),
      DeviceStateStarter s => _buildDeviceStateFields(s),
    };
  }

  Widget _buildOkGoogleFields(OkGoogleStarter s) {
    return TextFormField(
      key: ValueKey(s.runtimeType),
      initialValue: s.eventData,
      decoration: const InputDecoration(
        labelText: 'Voice Command',
        hintText: 'e.g., Movie Night',
        isDense: true,
      ),
      onChanged: (v) => onChanged(OkGoogleStarter(eventData: v)),
    );
  }

  Widget _buildTimeScheduleFields(TimeScheduleStarter s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: ValueKey('${s.runtimeType}.at'),
          initialValue: s.at,
          decoration: const InputDecoration(
            labelText: 'Time',
            hintText: 'e.g., 6:00 pm, sunrise, sunset',
            isDense: true,
          ),
          onChanged: (v) =>
              onChanged(TimeScheduleStarter(at: v, weekdays: s.weekdays)),
        ),
        const SizedBox(height: 12),
        WeekdaySelector(
          selected: s.weekdays ?? [],
          onChanged: (weekdays) => onChanged(
            TimeScheduleStarter(
                at: s.at, weekdays: weekdays.isEmpty ? null : weekdays),
          ),
        ),
      ],
    );
  }

  Widget _buildHomePresenceFields(HomePresenceStarter s) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<HomePresenceMode>(
            initialValue: s.is_,
            decoration: const InputDecoration(
              labelText: 'Presence',
              isDense: true,
            ),
            items: HomePresenceMode.values.map((mode) {
              return DropdownMenuItem(
                value: mode,
                child: Text(mode.value),
              );
            }).toList(),
            onChanged: (v) =>
                onChanged(HomePresenceStarter(state: s.state, is_: v ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceField(
      String device, String label, Starter Function(String) creator) {
    return TextFormField(
      key: ValueKey('${starter.runtimeType}.device'),
      initialValue: device,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Device name',
        isDense: true,
      ),
      onChanged: (v) => onChanged(creator(v)),
    );
  }

  Widget _buildOnOffStateFields(OnOffStateStarter s) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: s.device,
            decoration: const InputDecoration(
              labelText: 'Device',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                OnOffStateStarter(device: v, state: s.state, is_: s.is_)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: s.is_,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('On')),
              DropdownMenuItem(value: false, child: Text('Off')),
            ],
            onChanged: (v) => onChanged(OnOffStateStarter(
                device: s.device, state: s.state, is_: v ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildBrightnessStateFields(BrightnessStateStarter s) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: s.device,
            decoration: const InputDecoration(
              labelText: 'Device',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                BrightnessStateStarter(device: v, state: s.state, is_: s.is_)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: s.is_.toString(),
            decoration: const InputDecoration(
              labelText: 'Brightness %',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(BrightnessStateStarter(
                device: s.device,
                state: s.state,
                is_: int.tryParse(v) ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildLockUnlockStateFields(LockUnlockStateStarter s) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: s.device,
            decoration: const InputDecoration(
              labelText: 'Device',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                LockUnlockStateStarter(device: v, state: s.state, is_: s.is_)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<bool>(
            initialValue: s.is_,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Locked')),
              DropdownMenuItem(value: false, child: Text('Unlocked')),
            ],
            onChanged: (v) => onChanged(LockUnlockStateStarter(
                device: s.device, state: s.state, is_: v ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenCloseStateFields(OpenCloseStateStarter s) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: s.device,
            decoration: const InputDecoration(
              labelText: 'Device',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                OpenCloseStateStarter(device: v, state: s.state, is_: s.is_)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: s.is_.toString(),
            decoration: const InputDecoration(
              labelText: 'Open %',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(OpenCloseStateStarter(
                device: s.device,
                state: s.state,
                is_: int.tryParse(v) ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureSettingFields(TemperatureSettingStarter s) {
    return Column(
      children: [
        TextFormField(
          initialValue: s.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(
              TemperatureSettingStarter(device: v, state: s.state, is_: s.is_)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: s.state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  hintText: 'e.g., thermostatMode',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(TemperatureSettingStarter(
                    device: s.device, state: v, is_: s.is_)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: s.is_.toString(),
                decoration: const InputDecoration(
                  labelText: 'Value',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(TemperatureSettingStarter(
                    device: s.device, state: s.state, is_: v)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMotionDetectionStateFields(MotionDetectionStateStarter s) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: s.device,
            decoration: const InputDecoration(
              labelText: 'Device',
              isDense: true,
            ),
            onChanged: (v) => onChanged(MotionDetectionStateStarter(
                device: v, state: s.state, is_: s.is_)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<bool>(
            initialValue: s.is_,
            decoration: const InputDecoration(
              labelText: 'Motion',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Detected')),
              DropdownMenuItem(value: false, child: Text('Clear')),
            ],
            onChanged: (v) => onChanged(MotionDetectionStateStarter(
                device: s.device, state: s.state, is_: v ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildOccupancyStateFields(OccupancyStateStarter s) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: s.device,
            decoration: const InputDecoration(
              labelText: 'Device',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                OccupancyStateStarter(device: v, state: s.state, is_: s.is_)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 140,
          child: DropdownButtonFormField<String>(
            initialValue: s.is_,
            decoration: const InputDecoration(
              labelText: 'Occupancy',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'OCCUPIED', child: Text('Occupied')),
              DropdownMenuItem(value: 'UNOCCUPIED', child: Text('Unoccupied')),
            ],
            onChanged: (v) => onChanged(OccupancyStateStarter(
                device: s.device, state: s.state, is_: v ?? s.is_)),
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyStorageStateFields(EnergyStorageStateStarter s) {
    return Column(
      children: [
        TextFormField(
          initialValue: s.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(
              EnergyStorageStateStarter(device: v, state: s.state, is_: s.is_)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: s.state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  hintText: 'e.g., isCharging',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(EnergyStorageStateStarter(
                    device: s.device, state: v, is_: s.is_)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: s.is_.toString(),
                decoration: const InputDecoration(
                  labelText: 'Value',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(EnergyStorageStateStarter(
                    device: s.device, state: s.state, is_: v)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerStateFields(TimerStateStarter s) {
    return Column(
      children: [
        TextFormField(
          initialValue: s.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(
              TimerStateStarter(device: v, state: s.state, is_: s.is_)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: s.state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  hintText: 'e.g., timerPaused',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(
                    TimerStateStarter(device: s.device, state: v, is_: s.is_)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: s.is_.toString(),
                decoration: const InputDecoration(
                  labelText: 'Value',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(TimerStateStarter(
                    device: s.device, state: s.state, is_: v)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceStateFields(DeviceStateStarter s) {
    return Column(
      children: [
        TextFormField(
          initialValue: s.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(
              DeviceStateStarter(device: v, state: s.state, is_: s.is_)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: s.state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(
                    DeviceStateStarter(device: s.device, state: v, is_: s.is_)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: s.is_.toString(),
                decoration: const InputDecoration(
                  labelText: 'Value',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(DeviceStateStarter(
                    device: s.device, state: s.state, is_: v)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
