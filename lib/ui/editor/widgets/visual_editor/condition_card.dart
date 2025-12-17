import 'package:flutter/material.dart';

import '../../../../domain/models/condition.dart';
import '../../../core/themes/app_theme.dart';

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
                      items: ConditionType.values
                          .where((t) =>
                              t != ConditionType.and_ &&
                              t != ConditionType.or_ &&
                              t != ConditionType.not_)
                          .map((type) {
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

  Widget _buildConditionFields(BuildContext context, ConditionType conditionType) {
    final c = condition!;
    return KeyedSubtree(
      key: ValueKey('condition_fields_${conditionType.name}'),
      child: switch (c) {
      AndCondition() => const Text('AND condition (nested not supported yet)'),
      OrCondition() => const Text('OR condition (nested not supported yet)'),
      NotCondition() => const Text('NOT condition (nested not supported yet)'),
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
        TextFormField(
          key: ValueKey('timeBetween_weekdays'),
          initialValue: c.weekdays?.map((d) => d.value).join(', ') ?? '',
          decoration: const InputDecoration(
            labelText: 'Weekdays',
            hintText: 'e.g., MON, TUE, WED (comma-separated)',
            isDense: true,
          ),
          onChanged: (v) {
            List<Weekday>? weekdays;
            if (v.isNotEmpty) {
              weekdays = v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .map((e) => Weekday.fromString(e))
                  .whereType<Weekday>()
                  .toList();
            }
            onChanged(TimeBetweenCondition(
                after: c.after, before: c.before, weekdays: weekdays));
          },
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildEnumComparisonOperators<HomePresenceMode>(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          HomePresenceMode.values,
          (mode) => mode.value,
          (value) => HomePresenceMode.fromString(value),
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(HomePresenceCondition(
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(OnOffCondition(
            device: c.device,
            state: c.state,
            is_: is_ as bool?,
            isNot: isNot as bool?,
            greaterThan: greaterThan as bool?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as bool?,
            lessThan: lessThan as bool?,
            lessThanOrEqualTo: lessThanOrEqualTo as bool?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(BrightnessCondition(
            device: c.device,
            state: c.state,
            is_: is_ as int?,
            isNot: isNot as int?,
            greaterThan: greaterThan as int?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as int?,
            lessThan: lessThan as int?,
            lessThanOrEqualTo: lessThanOrEqualTo as int?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(VolumeCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(LockUnlockCondition(
            device: c.device,
            state: c.state,
            is_: is_ as bool?,
            isNot: isNot as bool?,
            greaterThan: greaterThan as bool?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as bool?,
            lessThan: lessThan as bool?,
            lessThanOrEqualTo: lessThanOrEqualTo as bool?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(OpenCloseCondition(
            device: c.device,
            state: c.state,
            is_: is_ as int?,
            isNot: isNot as int?,
            greaterThan: greaterThan as int?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as int?,
            lessThan: lessThan as int?,
            lessThanOrEqualTo: lessThanOrEqualTo as int?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(TemperatureSettingCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(ArmDisarmCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(DockCondition(
            device: c.device,
            state: c.state,
            is_: is_ as bool?,
            isNot: isNot as bool?,
            greaterThan: greaterThan as bool?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as bool?,
            lessThan: lessThan as bool?,
            lessThanOrEqualTo: lessThanOrEqualTo as bool?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(StartStopCondition(
            device: c.device,
            state: c.state,
            is_: is_ as bool?,
            isNot: isNot as bool?,
            greaterThan: greaterThan as bool?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as bool?,
            lessThan: lessThan as bool?,
            lessThanOrEqualTo: lessThanOrEqualTo as bool?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(FanSpeedCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(HumiditySettingCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(FillCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(EnergyStorageCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(MotionDetectionCondition(
            device: c.device,
            state: c.state,
            is_: is_ as bool?,
            isNot: isNot as bool?,
            greaterThan: greaterThan as bool?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as bool?,
            lessThan: lessThan as bool?,
            lessThanOrEqualTo: lessThanOrEqualTo as bool?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildEnumComparisonOperators<OccupancyState>(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          OccupancyState.values,
          (state) => state.value,
          (value) => OccupancyState.fromString(value),
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(OccupancySensingCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(OnlineCondition(
            device: c.device,
            state: c.state,
            is_: is_ as bool?,
            isNot: isNot as bool?,
            greaterThan: greaterThan as bool?,
            greaterThanOrEqualTo: greaterThanOrEqualTo as bool?,
            lessThan: lessThan as bool?,
            lessThanOrEqualTo: lessThanOrEqualTo as bool?,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(TimerCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        c.state == 'playbackState'
            ? _buildEnumComparisonOperators<PlaybackState>(
                c.is_,
                c.isNot,
                c.greaterThan,
                c.greaterThanOrEqualTo,
                c.lessThan,
                c.lessThanOrEqualTo,
                PlaybackState.values,
                (state) => state.value,
                (value) => PlaybackState.fromString(value),
                (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
                    onChanged(MediaStateCondition(
                  device: c.device,
                  state: c.state,
                  is_: is_,
                  isNot: isNot,
                  greaterThan: greaterThan,
                  greaterThanOrEqualTo: greaterThanOrEqualTo,
                  lessThan: lessThan,
                  lessThanOrEqualTo: lessThanOrEqualTo,
                )),
              )
            : _buildComparisonOperators(
                c.is_,
                c.isNot,
                c.greaterThan,
                c.greaterThanOrEqualTo,
                c.lessThan,
                c.lessThanOrEqualTo,
                (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
                    onChanged(MediaStateCondition(
                  device: c.device,
                  state: c.state,
                  is_: is_,
                  isNot: isNot,
                  greaterThan: greaterThan,
                  greaterThanOrEqualTo: greaterThanOrEqualTo,
                  lessThan: lessThan,
                  lessThanOrEqualTo: lessThanOrEqualTo,
                )),
                isString: true,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(SensorStateCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
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
            isNot: c.isNot,
            greaterThan: c.greaterThan,
            greaterThanOrEqualTo: c.greaterThanOrEqualTo,
            lessThan: c.lessThan,
            lessThanOrEqualTo: c.lessThanOrEqualTo,
          )),
        ),
        const SizedBox(height: 8),
        _buildComparisonOperators(
          c.is_,
          c.isNot,
          c.greaterThan,
          c.greaterThanOrEqualTo,
          c.lessThan,
          c.lessThanOrEqualTo,
          (is_, isNot, greaterThan, greaterThanOrEqualTo, lessThan, lessThanOrEqualTo) =>
              onChanged(DeviceStateCondition(
            device: c.device,
            state: c.state,
            is_: is_,
            isNot: isNot,
            greaterThan: greaterThan,
            greaterThanOrEqualTo: greaterThanOrEqualTo,
            lessThan: lessThan,
            lessThanOrEqualTo: lessThanOrEqualTo,
          )),
          isString: false,
        ),
      ],
    );
  }

  /// Helper widget to build comparison operator fields
  Widget _buildComparisonOperators(
    dynamic is_,
    dynamic isNot,
    dynamic greaterThan,
    dynamic greaterThanOrEqualTo,
    dynamic lessThan,
    dynamic lessThanOrEqualTo,
    void Function(
      dynamic is_,
      dynamic isNot,
      dynamic greaterThan,
      dynamic greaterThanOrEqualTo,
      dynamic lessThan,
      dynamic lessThanOrEqualTo,
    ) onChanged, {required bool isString}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparison Operators (use one):',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: is_?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Is',
                  hintText: 'Exact match',
                  isDense: true,
                ),
                keyboardType: isString ? TextInputType.text : TextInputType.number,
                onChanged: (v) {
                  final value = v.isEmpty
                      ? null
                      : (isString
                          ? v
                          : (is_ is int
                              ? int.tryParse(v)
                              : (is_ is double
                                  ? double.tryParse(v)
                                  : (is_ is bool
                                      ? v.toLowerCase() == 'true'
                                      : v))));
                  onChanged(
                    value,
                    null,
                    null,
                    null,
                    null,
                    null,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: isNot?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Is Not',
                  hintText: 'Not equal',
                  isDense: true,
                ),
                keyboardType: isString ? TextInputType.text : TextInputType.number,
                onChanged: (v) {
                  final value = v.isEmpty
                      ? null
                      : (isString
                          ? v
                          : (isNot is int
                              ? int.tryParse(v)
                              : (isNot is double
                                  ? double.tryParse(v)
                                  : (isNot is bool
                                      ? v.toLowerCase() == 'true'
                                      : v))));
                  onChanged(
                    null,
                    value,
                    null,
                    null,
                    null,
                    null,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: greaterThan?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Greater Than',
                  hintText: '>',
                  isDense: true,
                ),
                keyboardType: isString ? TextInputType.text : TextInputType.number,
                onChanged: (v) {
                  final value = v.isEmpty
                      ? null
                      : (isString
                          ? v
                          : (greaterThan is int
                              ? int.tryParse(v)
                              : (greaterThan is double ? double.tryParse(v) : v)));
                  onChanged(
                    null,
                    null,
                    value,
                    null,
                    null,
                    null,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: greaterThanOrEqualTo?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Greater Than Or Equal',
                  hintText: '>=',
                  isDense: true,
                ),
                keyboardType: isString ? TextInputType.text : TextInputType.number,
                onChanged: (v) {
                  final value = v.isEmpty
                      ? null
                      : (isString
                          ? v
                          : (greaterThanOrEqualTo is int
                              ? int.tryParse(v)
                              : (greaterThanOrEqualTo is double
                                  ? double.tryParse(v)
                                  : v)));
                  onChanged(
                    null,
                    null,
                    null,
                    value,
                    null,
                    null,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: lessThan?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Less Than',
                  hintText: '<',
                  isDense: true,
                ),
                keyboardType: isString ? TextInputType.text : TextInputType.number,
                onChanged: (v) {
                  final value = v.isEmpty
                      ? null
                      : (isString
                          ? v
                          : (lessThan is int
                              ? int.tryParse(v)
                              : (lessThan is double ? double.tryParse(v) : v)));
                  onChanged(
                    null,
                    null,
                    null,
                    null,
                    value,
                    null,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: lessThanOrEqualTo?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Less Than Or Equal',
                  hintText: '<=',
                  isDense: true,
                ),
                keyboardType: isString ? TextInputType.text : TextInputType.number,
                onChanged: (v) {
                  final value = v.isEmpty
                      ? null
                      : (isString
                          ? v
                          : (lessThanOrEqualTo is int
                              ? int.tryParse(v)
                              : (lessThanOrEqualTo is double
                                  ? double.tryParse(v)
                                  : v)));
                  onChanged(
                    null,
                    null,
                    null,
                    null,
                    null,
                    value,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build comparison operators for enum types using dropdowns
  Widget _buildEnumComparisonOperators<T extends Enum>(
    T? is_,
    T? isNot,
    T? greaterThan,
    T? greaterThanOrEqualTo,
    T? lessThan,
    T? lessThanOrEqualTo,
    List<T> enumValues,
    String Function(T) getValue,
    T? Function(String?) parseValue,
    void Function(
      T? is_,
      T? isNot,
      T? greaterThan,
      T? greaterThanOrEqualTo,
      T? lessThan,
      T? lessThanOrEqualTo,
    ) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparison Operators (use one):',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<T?>(
                value: is_,
                decoration: const InputDecoration(
                  labelText: 'Is',
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem<T?>(value: null, child: const Text('None')),
                  ...enumValues.map((e) => DropdownMenuItem<T?>(
                        value: e,
                        child: Text(getValue(e)),
                      )),
                ],
                onChanged: (value) => onChanged(
                  value,
                  isNot,
                  greaterThan,
                  greaterThanOrEqualTo,
                  lessThan,
                  lessThanOrEqualTo,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<T?>(
                value: isNot,
                decoration: const InputDecoration(
                  labelText: 'Is Not',
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem<T?>(value: null, child: const Text('None')),
                  ...enumValues.map((e) => DropdownMenuItem<T?>(
                        value: e,
                        child: Text(getValue(e)),
                      )),
                ],
                onChanged: (value) => onChanged(
                  is_,
                  value,
                  greaterThan,
                  greaterThanOrEqualTo,
                  lessThan,
                  lessThanOrEqualTo,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
