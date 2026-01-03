import 'package:flutter/material.dart';

import '../../../../domain/models/condition.dart';
import '../../../core/themes/app_theme.dart';
import 'weekday_selector.dart';

/// Card for editing the optional condition in an automation
class ConditionCard extends StatelessWidget {
  const ConditionCard({
    super.key,
    required this.condition,
    required this.onChanged,
    required this.onRemove,
  });

  final Condition? condition;
  final ValueChanged<Condition> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (condition == null) {
      return _buildAddConditionCard(context);
    }

    final currentType = ConditionType.fromCondition(condition!);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppTheme.conditionColor.withValues(alpha: 0.7),
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
                    child: DropdownButtonFormField<ConditionType>(
                      value: currentType,
                      decoration: const InputDecoration(
                        labelText: 'Condition Type',
                        isDense: true,
                      ),
                      items: ConditionType.values.map((type) {
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                    tooltip: 'Remove condition',
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildConditionFields(context, currentType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddConditionCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppTheme.conditionColor.withValues(alpha: 0.3),
              width: 3,
            ),
          ),
        ),
        child: InkWell(
          onTap: () => onChanged(ConditionType.timeBetween.createDefault()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.conditionColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  'Add a condition',
                  style: TextStyle(
                    color: AppTheme.conditionColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionFields(
      BuildContext context, ConditionType conditionType) {
    final c = condition!;
    return KeyedSubtree(
      key: ValueKey('condition_fields_${conditionType.name}'),
      child: switch (c) {
        TimeBetweenCondition c => _buildTimeBetweenFields(c),
        HomePresenceCondition c => _buildHomePresenceFields(c),
        OnOffCondition c => _buildOnOffFields(c),
        BrightnessCondition c => _buildBrightnessFields(c),
        VolumeCondition c => _buildVolumeFields(c),
        LockUnlockCondition c => _buildLockUnlockFields(c),
        OpenCloseCondition c => _buildOpenCloseFields(c),
        TemperatureSettingCondition c => _buildTemperatureSettingFields(c),
        ArmDisarmCondition c => _buildArmDisarmFields(c),
        DockCondition c => _buildDockFields(c),
        StartStopCondition c => _buildStartStopFields(c),
        FanSpeedCondition c => _buildFanSpeedFields(c),
        HumiditySettingCondition c => _buildHumiditySettingFields(c),
        FillCondition c => _buildFillFields(c),
        EnergyStorageCondition c => _buildEnergyStorageFields(c),
        MotionDetectionCondition c => _buildMotionDetectionFields(c),
        OccupancySensingCondition c => _buildOccupancySensingFields(c),
        OnlineCondition c => _buildOnlineFields(c),
        TimerCondition c => _buildTimerFields(c),
        MediaStateCondition c => _buildMediaStateFields(c),
        SensorStateCondition c => _buildSensorStateFields(c),
        DeviceStateCondition c => _buildDeviceStateFields(c),
      },
    );
  }

  Widget _buildTimeBetweenFields(TimeBetweenCondition c) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                key: ValueKey('timeBetween_after'),
                initialValue: c.after ?? '',
                decoration: const InputDecoration(
                  labelText: 'After',
                  hintText: 'e.g., sunset',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(TimeBetweenCondition(
                    after: v.isEmpty ? null : v,
                    before: c.before,
                    weekdays: c.weekdays)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                key: ValueKey('timeBetween_before'),
                initialValue: c.before ?? '',
                decoration: const InputDecoration(
                  labelText: 'Before',
                  hintText: 'e.g., sunrise',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(TimeBetweenCondition(
                    after: c.after,
                    before: v.isEmpty ? null : v,
                    weekdays: c.weekdays)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        WeekdaySelector(
          selected: c.weekdays ?? [],
          onChanged: (weekdays) => onChanged(TimeBetweenCondition(
              after: c.after,
              before: c.before,
              weekdays: weekdays.isEmpty ? null : weekdays)),
        ),
      ],
    );
  }

  Widget _buildHomePresenceFields(HomePresenceCondition c) {
    return Column(
      children: [
        TextFormField(
          key: ValueKey('homePresence_state'),
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., homePresenceMode',
            isDense: true,
          ),
          onChanged: (v) => onChanged(HomePresenceCondition(
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<HomePresenceMode>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is (Home/Away)',
            isDense: true,
          ),
          items: HomePresenceMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(mode.value),
            );
          }).toList(),
          onChanged: (value) => onChanged(HomePresenceCondition(
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildOnOffFields(OnOffCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(OnOffCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<bool>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is (On/Off)',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('True (On)')),
            DropdownMenuItem(value: false, child: Text('False (Off)')),
          ],
          onChanged: (value) => onChanged(OnOffCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildBrightnessFields(BrightnessCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(BrightnessCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Brightness Level)',
            hintText: 'e.g. 50',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (v) => onChanged(BrightnessCondition(
            device: c.device,
            state: c.state,
            is_: int.tryParse(v),
          )),
        ),
      ],
    );
  }

  Widget _buildVolumeFields(VolumeCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(VolumeCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., currentVolume',
            isDense: true,
          ),
          onChanged: (v) => onChanged(VolumeCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        // Simplification: Using text field as it can be int (volume) or bool (isMuted)
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            hintText: 'e.g. 50 or true',
            isDense: true,
          ),
          onChanged: (v) {
            dynamic value = int.tryParse(v); // Try int first
            if (value == null &&
                (v.toLowerCase() == 'true' || v.toLowerCase() == 'false')) {
              value = v.toLowerCase() == 'true'; // Then bool
            }
            if (value == null && v.isNotEmpty)
              value = v; // Fallback to string if not empty

            onChanged(VolumeCondition(
              device: c.device,
              state: c.state,
              is_: value,
            ));
          },
        ),
      ],
    );
  }

  Widget _buildLockUnlockFields(LockUnlockCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(LockUnlockCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<bool>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is Locked',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('True (Locked)')),
            DropdownMenuItem(value: false, child: Text('False (Unlocked)')),
          ],
          onChanged: (value) => onChanged(LockUnlockCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildOpenCloseFields(OpenCloseCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(OpenCloseCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Open Percent)',
            hintText: 'e.g. 0 (Closed) or 100 (Open)',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (v) => onChanged(OpenCloseCondition(
            device: c.device,
            state: c.state,
            is_: int.tryParse(v),
          )),
        ),
      ],
    );
  }

  Widget _buildTemperatureSettingFields(TemperatureSettingCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(TemperatureSettingCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., thermostatMode',
            isDense: true,
          ),
          onChanged: (v) => onChanged(TemperatureSettingCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        // Simplification: Using text field as it can be Mode or double
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            hintText: 'e.g. heat or 22.5',
            isDense: true,
          ),
          onChanged: (v) {
            dynamic value = double.tryParse(v);
            if (value == null && v.isNotEmpty)
              value = v; // Fallback to string (likely mode)

            onChanged(TemperatureSettingCondition(
              device: c.device,
              state: c.state,
              is_: value,
            ));
          },
        ),
      ],
    );
  }

  Widget _buildArmDisarmFields(ArmDisarmCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(ArmDisarmCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., isArmed',
            isDense: true,
          ),
          onChanged: (v) => onChanged(ArmDisarmCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        // Simplification: Using text field as it can be bool or String level
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            hintText: 'e.g. true or level_name',
            isDense: true,
          ),
          onChanged: (v) {
            dynamic value;
            if (v.toLowerCase() == 'true' || v.toLowerCase() == 'false') {
              value = v.toLowerCase() == 'true';
            } else if (v.isNotEmpty) {
              value = v;
            }

            onChanged(ArmDisarmCondition(
              device: c.device,
              state: c.state,
              is_: value,
            ));
          },
        ),
      ],
    );
  }

  Widget _buildDockFields(DockCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(DockCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<bool>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is Docked',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('True (Docked)')),
            DropdownMenuItem(value: false, child: Text('False (Undocked)')),
          ],
          onChanged: (value) => onChanged(DockCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildStartStopFields(StartStopCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(StartStopCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., isRunning',
            isDense: true,
          ),
          onChanged: (v) => onChanged(StartStopCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<bool>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('True')),
            DropdownMenuItem(value: false, child: Text('False')),
          ],
          onChanged: (value) => onChanged(StartStopCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildFanSpeedFields(FanSpeedCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(FanSpeedCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., currentFanSpeedSetting',
            isDense: true,
          ),
          onChanged: (v) => onChanged(FanSpeedCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        // Simplification: Can be int or String
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            hintText: 'e.g. 50 or speed_low',
            isDense: true,
          ),
          onChanged: (v) {
            dynamic value = int.tryParse(v);
            if (value == null && v.isNotEmpty) value = v;
            onChanged(FanSpeedCondition(
              device: c.device,
              state: c.state,
              is_: value,
            ));
          },
        ),
      ],
    );
  }

  Widget _buildHumiditySettingFields(HumiditySettingCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(HumiditySettingCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            isDense: true,
          ),
          onChanged: (v) => onChanged(HumiditySettingCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          onChanged: (v) => onChanged(HumiditySettingCondition(
            device: c.device,
            state: c.state,
            is_: v, // Kept dynamic as per model, likely int/double/string
          )),
        ),
      ],
    );
  }

  Widget _buildFillFields(FillCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(FillCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            isDense: true,
          ),
          onChanged: (v) => onChanged(FillCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          onChanged: (v) => onChanged(FillCondition(
            device: c.device,
            state: c.state,
            is_: v,
          )),
        ),
      ],
    );
  }

  Widget _buildEnergyStorageFields(EnergyStorageCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(EnergyStorageCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., isCharging',
            isDense: true,
          ),
          onChanged: (v) => onChanged(EnergyStorageCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          onChanged: (v) {
            // Basic parsing
            dynamic value;
            if (v.toLowerCase() == 'true' || v.toLowerCase() == 'false') {
              value = v.toLowerCase() == 'true';
            } else if (v.isNotEmpty) {
              value = v;
            }
            onChanged(EnergyStorageCondition(
              device: c.device,
              state: c.state,
              is_: value,
            ));
          },
        ),
      ],
    );
  }

  Widget _buildMotionDetectionFields(MotionDetectionCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(MotionDetectionCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<bool>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is Motion Detected',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('True (Detected)')),
            DropdownMenuItem(value: false, child: Text('False (No Motion)')),
          ],
          onChanged: (value) => onChanged(MotionDetectionCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildOccupancySensingFields(OccupancySensingCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(OccupancySensingCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<OccupancyState>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is',
            isDense: true,
          ),
          items: OccupancyState.values.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s.value),
            );
          }).toList(),
          onChanged: (value) => onChanged(OccupancySensingCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildOnlineFields(OnlineCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(OnlineCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<bool>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is Online',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: true, child: Text('True (Online)')),
            DropdownMenuItem(value: false, child: Text('False (Offline)')),
          ],
          onChanged: (value) => onChanged(OnlineCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildTimerFields(TimerCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(TimerCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., timerPaused',
            isDense: true,
          ),
          onChanged: (v) => onChanged(TimerCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          onChanged: (v) => onChanged(TimerCondition(
            device: c.device,
            state: c.state,
            is_: v,
          )),
        ),
      ],
    );
  }

  Widget _buildMediaStateFields(MediaStateCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(MediaStateCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            hintText: 'e.g., playbackState',
            isDense: true,
          ),
          onChanged: (v) => onChanged(MediaStateCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<PlaybackState>(
          value: c.is_,
          decoration: const InputDecoration(
            labelText: 'Is (Playback State)',
            isDense: true,
          ),
          items: PlaybackState.values.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s.value),
            );
          }).toList(),
          onChanged: (value) => onChanged(MediaStateCondition(
            device: c.device,
            state: c.state,
            is_: value,
          )),
        ),
      ],
    );
  }

  Widget _buildSensorStateFields(SensorStateCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(SensorStateCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            isDense: true,
          ),
          onChanged: (v) => onChanged(SensorStateCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          onChanged: (v) => onChanged(SensorStateCondition(
            device: c.device,
            state: c.state,
            is_: v,
          )),
        ),
      ],
    );
  }

  Widget _buildDeviceStateFields(DeviceStateCondition c) {
    return Column(
      children: [
        TextFormField(
          initialValue: c.device,
          decoration: const InputDecoration(
            labelText: 'Device',
            isDense: true,
          ),
          onChanged: (v) => onChanged(DeviceStateCondition(
            device: v,
            state: c.state,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.state,
          decoration: const InputDecoration(
            labelText: 'State',
            isDense: true,
          ),
          onChanged: (v) => onChanged(DeviceStateCondition(
            device: c.device,
            state: v,
            is_: c.is_,
          )),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: c.is_?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Is (Value)',
            isDense: true,
          ),
          onChanged: (v) => onChanged(DeviceStateCondition(
            device: c.device,
            state: c.state,
            is_: v,
          )),
        ),
      ],
    );
  }
}
