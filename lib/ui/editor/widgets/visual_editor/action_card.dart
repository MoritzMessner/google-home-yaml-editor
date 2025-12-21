import 'package:flutter/material.dart';

import '../../../../domain/models/action.dart';
import '../../../core/themes/app_theme.dart';

/// Card for editing an action in the automation
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
    final currentType = ActionType.fromAction(action);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppTheme.actionColor.withValues(alpha: 0.7),
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
                  ReorderableDragStartListener(
                    index: index,
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: Icon(Icons.drag_handle, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<ActionType>(
                      initialValue: currentType,
                      decoration: const InputDecoration(
                        labelText: 'Action Type',
                        isDense: true,
                      ),
                      items: ActionType.values.map((type) {
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
                    tooltip: 'Remove action',
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
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

  Widget _buildActionFields(BuildContext context) {
    return switch (action) {
      DelayAction a => _buildDelayFields(a),
      BroadcastAction a => _buildBroadcastFields(a),
      AssistantCommandAction a => _buildAssistantCommandFields(a),
      OnOffAction a => _buildOnOffFields(a),
      ActivateSceneAction a => _buildActivateSceneFields(a),
      BrightnessAbsoluteAction a => _buildBrightnessAbsoluteFields(a),
      BrightnessRelativeAction a => _buildBrightnessRelativeFields(a),
      ColorAbsoluteAction a => _buildColorAbsoluteFields(a),
      SetVolumeAction a => _buildSetVolumeFields(a),
      MuteAction a => _buildMuteFields(a),
      MediaNextAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => MediaNextAction(devices: v)),
      MediaPreviousAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => MediaPreviousAction(devices: v)),
      MediaPauseAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => MediaPauseAction(devices: v)),
      MediaResumeAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => MediaResumeAction(devices: v)),
      MediaStopAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => MediaStopAction(devices: v)),
      MediaShuffleAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => MediaShuffleAction(devices: v)),
      LockUnlockAction a => _buildLockUnlockFields(a),
      OpenCloseAction a => _buildOpenCloseFields(a),
      ArmDisarmAction a => _buildArmDisarmFields(a),
      ThermostatSetModeAction a => _buildThermostatSetModeFields(a),
      ThermostatTemperatureSetpointAction a =>
        _buildThermostatTemperatureSetpointFields(a),
      ThermostatTemperatureSetRangeAction a =>
        _buildThermostatTemperatureSetRangeFields(a),
      SetFanSpeedAction a => _buildSetFanSpeedFields(a),
      SetFanSpeedRelativeAction a => _buildSetFanSpeedRelativeFields(a),
      ReverseFanAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => ReverseFanAction(devices: v)),
      SetHumidityAction a => _buildSetHumidityFields(a),
      HumidityRelativeAction a => _buildHumidityRelativeFields(a),
      StartStopAction a => _buildStartStopFields(a),
      PauseUnpauseAction a => _buildPauseUnpauseFields(a),
      DockAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => DockAction(devices: v)),
      ChargeAction a => _buildChargeFields(a),
      RebootAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => RebootAction(devices: v)),
      FillAction a => _buildFillFields(a),
      FindMyDeviceAction a => _buildFindMyDeviceFields(a),
      SetInputAction a => _buildSetInputFields(a),
      NextInputAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => NextInputAction(devices: v)),
      PreviousInputAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => PreviousInputAction(devices: v)),
      SelectChannelAction a => _buildSelectChannelFields(a),
      RelativeChannelAction a => _buildRelativeChannelFields(a),
      ReturnChannelAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => ReturnChannelAction(devices: v)),
      RotateAbsoluteAction a => _buildRotateAbsoluteFields(a),
      TimerStartAction a => _buildTimerStartFields(a),
      TimerAdjustAction a => _buildTimerAdjustFields(a),
      TimerPauseAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => TimerPauseAction(devices: v)),
      TimerResumeAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => TimerResumeAction(devices: v)),
      TimerCancelAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => TimerCancelAction(devices: v)),
      LightEffectColorLoopAction a => _buildLightEffectFields(
          a.devices,
          a.duration,
          (d, dur) => LightEffectColorLoopAction(devices: d, duration: dur)),
      LightEffectPulseAction a => _buildLightEffectFields(a.devices, a.duration,
          (d, dur) => LightEffectPulseAction(devices: d, duration: dur)),
      LightEffectSleepAction a => _buildLightEffectFields(a.devices, a.duration,
          (d, dur) => LightEffectSleepAction(devices: d, duration: dur)),
      LightEffectWakeAction a => _buildLightEffectFields(a.devices, a.duration,
          (d, dur) => LightEffectWakeAction(devices: d, duration: dur)),
      StopLightEffectAction a => _buildDevicesOnlyField(
          a.devices, 'Devices', (v) => StopLightEffectAction(devices: v)),
      AppSelectAction a => _buildAppSelectFields(a),
      AppInstallAction a => _buildAppInstallFields(a),
      AppSearchAction a => _buildAppSearchFields(a),
      CookAction a => _buildCookFields(a),
      DispenseAction a => _buildDispenseFields(a),
      EnableDisableGuestNetworkAction a =>
        _buildEnableDisableGuestNetworkFields(a),
      EnableDisableNetworkProfileAction a =>
        _buildEnableDisableNetworkProfileFields(a),
    };
  }

  Widget _buildDelayFields(DelayAction a) {
    return TextFormField(
      key: ValueKey('${a.runtimeType}.duration'),
      initialValue: a.duration,
      decoration: const InputDecoration(
        labelText: 'Duration',
        hintText: 'e.g., 5s, 1m, 30m',
        isDense: true,
      ),
      onChanged: (v) => onChanged(DelayAction(duration: v)),
    );
  }

  Widget _buildBroadcastFields(BroadcastAction a) {
    return TextFormField(
      key: ValueKey('${a.runtimeType}.message'),
      initialValue: a.message,
      decoration: const InputDecoration(
        labelText: 'Message',
        hintText: 'Message to broadcast',
        isDense: true,
      ),
      onChanged: (v) => onChanged(BroadcastAction(message: v)),
    );
  }

  Widget _buildAssistantCommandFields(AssistantCommandAction a) {
    return TextFormField(
      key: ValueKey('${a.runtimeType}.command'),
      initialValue: a.command,
      decoration: const InputDecoration(
        labelText: 'Command',
        hintText: 'e.g., Play relaxing music',
        isDense: true,
      ),
      onChanged: (v) => onChanged(AssistantCommandAction(command: v)),
    );
  }

  Widget _buildOnOffFields(OnOffAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey('${a.runtimeType}.devices'),
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              hintText: 'Comma-separated device names',
              isDense: true,
            ),
            onChanged: (v) => onChanged(OnOffAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              on: a.on,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: a.on,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('On')),
              DropdownMenuItem(value: false, child: Text('Off')),
            ],
            onChanged: (v) =>
                onChanged(OnOffAction(devices: a.devices, on: v ?? a.on)),
          ),
        ),
      ],
    );
  }

  Widget _buildActivateSceneFields(ActivateSceneAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.scene,
            decoration: const InputDecoration(
              labelText: 'Scene',
              isDense: true,
            ),
            onChanged: (v) =>
                onChanged(ActivateSceneAction(scene: v, activate: a.activate)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<bool>(
            initialValue: a.activate,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Activate')),
              DropdownMenuItem(value: false, child: Text('Deactivate')),
            ],
            onChanged: (v) => onChanged(
                ActivateSceneAction(scene: a.scene, activate: v ?? a.activate)),
          ),
        ),
      ],
    );
  }

  Widget _buildBrightnessAbsoluteFields(BrightnessAbsoluteAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              hintText: 'Comma-separated',
              isDense: true,
            ),
            onChanged: (v) => onChanged(BrightnessAbsoluteAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              brightness: a.brightness,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.brightness.toString(),
            decoration: const InputDecoration(
              labelText: 'Brightness %',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(BrightnessAbsoluteAction(
              devices: a.devices,
              brightness: int.tryParse(v) ?? a.brightness,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildBrightnessRelativeFields(BrightnessRelativeAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(BrightnessRelativeAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            brightnessRelativePercent: a.brightnessRelativePercent,
            brightnessRelativeWeight: a.brightnessRelativeWeight,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: (a.brightnessRelativePercent ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Adjust %',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(BrightnessRelativeAction(
                  devices: a.devices,
                  brightnessRelativePercent: int.tryParse(v),
                  brightnessRelativeWeight: a.brightnessRelativeWeight,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: (a.brightnessRelativeWeight ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  hintText: 'Optional',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(BrightnessRelativeAction(
                  devices: a.devices,
                  brightnessRelativePercent: a.brightnessRelativePercent,
                  brightnessRelativeWeight: int.tryParse(v),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorAbsoluteFields(ColorAbsoluteAction a) {
    return Column(
      children: [
        TextFormField(
          key: ValueKey('${a.runtimeType}.devices'),
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(ColorAbsoluteAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            temperature: a.temperature,
            spectrumRGB: a.spectrumRGB,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.spectrumRGB
                        ?.toRadixString(16)
                        .toUpperCase()
                        .padLeft(6, '0') ??
                    '',
                decoration: const InputDecoration(
                  labelText: 'RGB (hex)',
                  hintText: 'e.g., FF0000',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(ColorAbsoluteAction(
                  devices: a.devices,
                  temperature: a.temperature,
                  spectrumRGB: v.isEmpty ? null : int.tryParse(v, radix: 16),
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: a.temperature?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Temperature (K)',
                  hintText: 'e.g., 2700',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(ColorAbsoluteAction(
                  devices: a.devices,
                  spectrumRGB: a.spectrumRGB,
                  temperature: int.tryParse(v),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSetVolumeFields(SetVolumeAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(SetVolumeAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              volumeLevel: a.volumeLevel,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.volumeLevel.toString(),
            decoration: const InputDecoration(
              labelText: 'Volume %',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(SetVolumeAction(
              devices: a.devices,
              volumeLevel: int.tryParse(v) ?? a.volumeLevel,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildMuteFields(MuteAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(MuteAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              mute: a.mute,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: a.mute,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Mute')),
              DropdownMenuItem(value: false, child: Text('Unmute')),
            ],
            onChanged: (v) =>
                onChanged(MuteAction(devices: a.devices, mute: v ?? a.mute)),
          ),
        ),
      ],
    );
  }

  Widget _buildDevicesOnlyField(List<String> devices, String label,
      AutomationAction Function(List<String>) creator) {
    return TextFormField(
      key: ValueKey('${action.runtimeType}.devices'),
      initialValue: devices.join(', '),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Comma-separated device names',
        isDense: true,
      ),
      onChanged: (v) => onChanged(creator(v
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList())),
    );
  }

  Widget _buildLockUnlockFields(LockUnlockAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(LockUnlockAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              lock: a.lock,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<bool>(
            initialValue: a.lock,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Lock')),
              DropdownMenuItem(value: false, child: Text('Unlock')),
            ],
            onChanged: (v) => onChanged(
                LockUnlockAction(devices: a.devices, lock: v ?? a.lock)),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenCloseFields(OpenCloseAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(OpenCloseAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            openPercent: a.openPercent,
            openDirection: a.openDirection,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: (a.openPercent ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Open %',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(OpenCloseAction(
                  devices: a.devices,
                  openPercent: int.tryParse(v),
                  openDirection: a.openDirection,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: a.openDirection ?? '',
                decoration: const InputDecoration(
                  labelText: 'Direction',
                  hintText: 'Optional',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(OpenCloseAction(
                  devices: a.devices,
                  openPercent: a.openPercent,
                  openDirection: v.isEmpty ? null : v,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArmDisarmFields(ArmDisarmAction a) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.devices.join(', '),
                decoration: const InputDecoration(
                  labelText: 'Devices',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(ArmDisarmAction(
                  devices: v
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  arm: a.arm,
                  armLevel: a.armLevel,
                  cancel: a.cancel,
                )),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<bool>(
                initialValue: a.arm,
                decoration: const InputDecoration(
                  labelText: 'State',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Arm')),
                  DropdownMenuItem(value: false, child: Text('Disarm')),
                ],
                onChanged: (v) => onChanged(ArmDisarmAction(
                  devices: a.devices,
                  arm: v ?? a.arm,
                  armLevel: a.armLevel,
                  cancel: a.cancel,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.armLevel ?? '',
                decoration: const InputDecoration(
                  labelText: 'Arm Level',
                  hintText: 'Optional (not with cancel)',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(ArmDisarmAction(
                  devices: a.devices,
                  arm: a.arm,
                  armLevel: v.isEmpty ? null : v,
                  cancel: v.isEmpty ? a.cancel : null,
                )),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<bool?>(
                initialValue: a.cancel,
                decoration: const InputDecoration(
                  labelText: 'Cancel',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('None')),
                  DropdownMenuItem(value: true, child: Text('Yes')),
                  DropdownMenuItem(value: false, child: Text('No')),
                ],
                onChanged: (v) => onChanged(ArmDisarmAction(
                  devices: a.devices,
                  arm: a.arm,
                  armLevel: v != null ? null : a.armLevel,
                  cancel: v,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThermostatSetModeFields(ThermostatSetModeAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(ThermostatSetModeAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              thermostatMode: a.thermostatMode,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.thermostatMode,
            decoration: const InputDecoration(
              labelText: 'Mode',
              hintText: 'e.g., heat',
              isDense: true,
            ),
            onChanged: (v) => onChanged(ThermostatSetModeAction(
              devices: a.devices,
              thermostatMode: v,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildThermostatTemperatureSetpointFields(
      ThermostatTemperatureSetpointAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(ThermostatTemperatureSetpointAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              thermostatTemperatureSetpoint: a.thermostatTemperatureSetpoint,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.thermostatTemperatureSetpoint.toString(),
            decoration: const InputDecoration(
              labelText: 'Temp °C',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(ThermostatTemperatureSetpointAction(
              devices: a.devices,
              thermostatTemperatureSetpoint:
                  double.tryParse(v) ?? a.thermostatTemperatureSetpoint,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildThermostatTemperatureSetRangeFields(
      ThermostatTemperatureSetRangeAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(ThermostatTemperatureSetRangeAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            thermostatTemperatureSetpointHigh:
                a.thermostatTemperatureSetpointHigh,
            thermostatTemperatureSetpointLow:
                a.thermostatTemperatureSetpointLow,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.thermostatTemperatureSetpointLow.toString(),
                decoration: const InputDecoration(
                  labelText: 'Low °C',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(ThermostatTemperatureSetRangeAction(
                  devices: a.devices,
                  thermostatTemperatureSetpointHigh:
                      a.thermostatTemperatureSetpointHigh,
                  thermostatTemperatureSetpointLow:
                      double.tryParse(v) ?? a.thermostatTemperatureSetpointLow,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: a.thermostatTemperatureSetpointHigh.toString(),
                decoration: const InputDecoration(
                  labelText: 'High °C',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(ThermostatTemperatureSetRangeAction(
                  devices: a.devices,
                  thermostatTemperatureSetpointHigh:
                      double.tryParse(v) ?? a.thermostatTemperatureSetpointHigh,
                  thermostatTemperatureSetpointLow:
                      a.thermostatTemperatureSetpointLow,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSetFanSpeedFields(SetFanSpeedAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(SetFanSpeedAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              fanSpeed: a.fanSpeed,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.fanSpeed,
            decoration: const InputDecoration(
              labelText: 'Speed',
              isDense: true,
            ),
            onChanged: (v) => onChanged(SetFanSpeedAction(
              devices: a.devices,
              fanSpeed: v,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildSetFanSpeedRelativeFields(SetFanSpeedRelativeAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(SetFanSpeedRelativeAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            fanSpeedRelativePercent: a.fanSpeedRelativePercent,
            fanSpeedRelativeWeight: a.fanSpeedRelativeWeight,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: (a.fanSpeedRelativePercent ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Adjust %',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(SetFanSpeedRelativeAction(
                  devices: a.devices,
                  fanSpeedRelativePercent: int.tryParse(v),
                  fanSpeedRelativeWeight: a.fanSpeedRelativeWeight,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: (a.fanSpeedRelativeWeight ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  hintText: 'Optional',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(SetFanSpeedRelativeAction(
                  devices: a.devices,
                  fanSpeedRelativePercent: a.fanSpeedRelativePercent,
                  fanSpeedRelativeWeight: int.tryParse(v),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSetHumidityFields(SetHumidityAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(SetHumidityAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              humidity: a.humidity,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.humidity.toString(),
            decoration: const InputDecoration(
              labelText: 'Humidity %',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(SetHumidityAction(
              devices: a.devices,
              humidity: int.tryParse(v) ?? a.humidity,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildHumidityRelativeFields(HumidityRelativeAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(HumidityRelativeAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            relativeHumidityPercent: a.relativeHumidityPercent,
            relativeHumidityWeight: a.relativeHumidityWeight,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: (a.relativeHumidityPercent ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Adjust %',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(HumidityRelativeAction(
                  devices: a.devices,
                  relativeHumidityPercent: int.tryParse(v),
                  relativeHumidityWeight: a.relativeHumidityWeight,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: (a.relativeHumidityWeight ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  hintText: 'Optional',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(HumidityRelativeAction(
                  devices: a.devices,
                  relativeHumidityPercent: a.relativeHumidityPercent,
                  relativeHumidityWeight: int.tryParse(v),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartStopFields(StartStopAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(StartStopAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              start: a.start,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: a.start,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Start')),
              DropdownMenuItem(value: false, child: Text('Stop')),
            ],
            onChanged: (v) => onChanged(
                StartStopAction(devices: a.devices, start: v ?? a.start)),
          ),
        ),
      ],
    );
  }

  Widget _buildPauseUnpauseFields(PauseUnpauseAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(PauseUnpauseAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              pause: a.pause,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: a.pause,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Pause')),
              DropdownMenuItem(value: false, child: Text('Unpause')),
            ],
            onChanged: (v) => onChanged(
                PauseUnpauseAction(devices: a.devices, pause: v ?? a.pause)),
          ),
        ),
      ],
    );
  }

  Widget _buildChargeFields(ChargeAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(ChargeAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              charge: a.charge,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: a.charge,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Charge')),
              DropdownMenuItem(value: false, child: Text('Stop')),
            ],
            onChanged: (v) => onChanged(
                ChargeAction(devices: a.devices, charge: v ?? a.charge)),
          ),
        ),
      ],
    );
  }

  Widget _buildFillFields(FillAction a) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.devices.join(', '),
                decoration: const InputDecoration(
                  labelText: 'Devices',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(FillAction(
                  devices: v
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  fill: a.fill,
                  fillLevel: a.fillLevel,
                )),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<bool>(
                initialValue: a.fill,
                decoration: const InputDecoration(
                  labelText: 'State',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Fill')),
                  DropdownMenuItem(value: false, child: Text('Drain')),
                ],
                onChanged: (v) => onChanged(FillAction(
                  devices: a.devices,
                  fill: v ?? a.fill,
                  fillLevel: a.fillLevel,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: a.fillLevel ?? '',
          decoration: const InputDecoration(
            labelText: 'Fill Level',
            hintText: 'Optional',
            isDense: true,
          ),
          onChanged: (v) => onChanged(FillAction(
            devices: a.devices,
            fill: a.fill,
            fillLevel: v.isEmpty ? null : v,
          )),
        ),
      ],
    );
  }

  Widget _buildFindMyDeviceFields(FindMyDeviceAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(FindMyDeviceAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              silence: a.silence,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool?>(
            initialValue: a.silence,
            decoration: const InputDecoration(
              labelText: 'Silence',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('None')),
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (v) => onChanged(FindMyDeviceAction(
              devices: a.devices,
              silence: v,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildSetInputFields(SetInputAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(SetInputAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              newInput: a.newInput,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.newInput,
            decoration: const InputDecoration(
              labelText: 'Input',
              hintText: 'e.g., HDMI1',
              isDense: true,
            ),
            onChanged: (v) =>
                onChanged(SetInputAction(devices: a.devices, newInput: v)),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectChannelFields(SelectChannelAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(SelectChannelAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            channelNumber: a.channelNumber,
            channelName: a.channelName,
            channelCode: a.channelCode,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.channelNumber ?? '',
                decoration: const InputDecoration(
                  labelText: 'Channel Number',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(SelectChannelAction(
                  devices: a.devices,
                  channelNumber: v.isEmpty ? null : v,
                  channelName: a.channelName,
                  channelCode: a.channelCode,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: a.channelName ?? '',
                decoration: const InputDecoration(
                  labelText: 'Channel Name',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(SelectChannelAction(
                  devices: a.devices,
                  channelNumber: a.channelNumber,
                  channelName: v.isEmpty ? null : v,
                  channelCode: a.channelCode,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: a.channelCode ?? '',
          decoration: const InputDecoration(
            labelText: 'Channel Code',
            hintText: 'Optional',
            isDense: true,
          ),
          onChanged: (v) => onChanged(SelectChannelAction(
            devices: a.devices,
            channelNumber: a.channelNumber,
            channelName: a.channelName,
            channelCode: v.isEmpty ? null : v,
          )),
        ),
      ],
    );
  }

  Widget _buildRelativeChannelFields(RelativeChannelAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(RelativeChannelAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              channelCount: a.channelCount,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.channelCount.toString(),
            decoration: const InputDecoration(
              labelText: 'Count',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(RelativeChannelAction(
              devices: a.devices,
              channelCount: int.tryParse(v) ?? a.channelCount,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildRotateAbsoluteFields(RotateAbsoluteAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(RotateAbsoluteAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            rotationPercent: a.rotationPercent,
            rotationDegree: a.rotationDegree,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: (a.rotationPercent ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Rotation %',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(RotateAbsoluteAction(
                  devices: a.devices,
                  rotationPercent: double.tryParse(v),
                  rotationDegree: a.rotationDegree,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: (a.rotationDegree ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Rotation Degrees',
                  hintText: 'Optional',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(RotateAbsoluteAction(
                  devices: a.devices,
                  rotationPercent: a.rotationPercent,
                  rotationDegree: double.tryParse(v),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerStartFields(TimerStartAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(TimerStartAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              duration: a.duration,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.duration,
            decoration: const InputDecoration(
              labelText: 'Duration',
              hintText: 'e.g., 30m',
              isDense: true,
            ),
            onChanged: (v) =>
                onChanged(TimerStartAction(devices: a.devices, duration: v)),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerAdjustFields(TimerAdjustAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(TimerAdjustAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              duration: a.duration,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: a.duration,
            decoration: const InputDecoration(
              labelText: 'Adjust',
              hintText: 'e.g., 5m',
              isDense: true,
            ),
            onChanged: (v) =>
                onChanged(TimerAdjustAction(devices: a.devices, duration: v)),
          ),
        ),
      ],
    );
  }

  Widget _buildLightEffectFields(List<String> devices, String? duration,
      AutomationAction Function(List<String>, String?) creator) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(creator(
                v
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                duration)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: duration ?? '',
            decoration: const InputDecoration(
              labelText: 'Duration',
              hintText: 'e.g., 30m',
              isDense: true,
            ),
            onChanged: (v) => onChanged(creator(devices, v.isEmpty ? null : v)),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSelectFields(AppSelectAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(AppSelectAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              applicationName: a.applicationName,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: TextFormField(
            initialValue: a.applicationName,
            decoration: const InputDecoration(
              labelText: 'App',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                AppSelectAction(devices: a.devices, applicationName: v)),
          ),
        ),
      ],
    );
  }

  Widget _buildAppInstallFields(AppInstallAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(AppInstallAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              newApplicationName: a.newApplicationName,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: TextFormField(
            initialValue: a.newApplicationName,
            decoration: const InputDecoration(
              labelText: 'App',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                AppInstallAction(devices: a.devices, newApplicationName: v)),
          ),
        ),
      ],
    );
  }

  Widget _buildAppSearchFields(AppSearchAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(AppSearchAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              applicationName: a.applicationName,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: TextFormField(
            initialValue: a.applicationName,
            decoration: const InputDecoration(
              labelText: 'App',
              isDense: true,
            ),
            onChanged: (v) => onChanged(
                AppSearchAction(devices: a.devices, applicationName: v)),
          ),
        ),
      ],
    );
  }

  Widget _buildCookFields(CookAction a) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.devices.join(', '),
                decoration: const InputDecoration(
                  labelText: 'Devices',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(CookAction(
                  devices: v
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  start: a.start,
                  cookingMode: a.cookingMode,
                  foodPreset: a.foodPreset,
                  quantity: a.quantity,
                  unit: a.unit,
                )),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<bool>(
                initialValue: a.start,
                decoration: const InputDecoration(
                  labelText: 'State',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Start')),
                  DropdownMenuItem(value: false, child: Text('Stop')),
                ],
                onChanged: (v) => onChanged(CookAction(
                  devices: a.devices,
                  start: v ?? a.start,
                  cookingMode: a.cookingMode,
                  foodPreset: a.foodPreset,
                  quantity: a.quantity,
                  unit: a.unit,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: a.cookingMode ?? '',
          decoration: const InputDecoration(
            labelText: 'Cooking Mode',
            hintText: 'e.g., BAKE',
            isDense: true,
          ),
          onChanged: (v) => onChanged(CookAction(
            devices: a.devices,
            start: a.start,
            cookingMode: v.isEmpty ? null : v,
            foodPreset: a.foodPreset,
            quantity: a.quantity,
            unit: a.unit,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.foodPreset ?? '',
                decoration: const InputDecoration(
                  labelText: 'Food Preset',
                  hintText: 'Optional',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(CookAction(
                  devices: a.devices,
                  start: a.start,
                  cookingMode: a.cookingMode,
                  foodPreset: v.isEmpty ? null : v,
                  quantity: a.quantity,
                  unit: a.unit,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: (a.quantity ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Optional',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(CookAction(
                  devices: a.devices,
                  start: a.start,
                  cookingMode: a.cookingMode,
                  foodPreset: a.foodPreset,
                  quantity: int.tryParse(v),
                  unit: a.unit,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: a.unit ?? '',
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'Optional',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(CookAction(
                  devices: a.devices,
                  start: a.start,
                  cookingMode: a.cookingMode,
                  foodPreset: a.foodPreset,
                  quantity: a.quantity,
                  unit: v.isEmpty ? null : v,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDispenseFields(DispenseAction a) {
    return Column(
      children: [
        TextFormField(
          initialValue: a.devices.join(', '),
          decoration: const InputDecoration(
            labelText: 'Devices',
            isDense: true,
          ),
          onChanged: (v) => onChanged(DispenseAction(
            devices: v
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            item: a.item,
            amount: a.amount,
            presetName: a.presetName,
            unit: a.unit,
          )),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.item ?? '',
                decoration: const InputDecoration(
                  labelText: 'Item',
                  hintText: 'e.g., water',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(DispenseAction(
                  devices: a.devices,
                  item: v.isEmpty ? null : v,
                  amount: a.amount,
                  presetName: a.presetName,
                  unit: a.unit,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: (a.amount ?? 0).toString(),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Optional',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(DispenseAction(
                  devices: a.devices,
                  item: a.item,
                  amount: int.tryParse(v),
                  presetName: a.presetName,
                  unit: a.unit,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.presetName ?? '',
                decoration: const InputDecoration(
                  labelText: 'Preset Name',
                  hintText: 'Optional',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(DispenseAction(
                  devices: a.devices,
                  item: a.item,
                  amount: a.amount,
                  presetName: v.isEmpty ? null : v,
                  unit: a.unit,
                )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: a.unit ?? '',
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  hintText: 'Optional',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(DispenseAction(
                  devices: a.devices,
                  item: a.item,
                  amount: a.amount,
                  presetName: a.presetName,
                  unit: v.isEmpty ? null : v,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnableDisableGuestNetworkFields(
      EnableDisableGuestNetworkAction a) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: a.devices.join(', '),
            decoration: const InputDecoration(
              labelText: 'Devices',
              isDense: true,
            ),
            onChanged: (v) => onChanged(EnableDisableGuestNetworkAction(
              devices: v
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              enable: a.enable,
            )),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: DropdownButtonFormField<bool>(
            initialValue: a.enable,
            decoration: const InputDecoration(
              labelText: 'State',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: true, child: Text('Enable')),
              DropdownMenuItem(value: false, child: Text('Disable')),
            ],
            onChanged: (v) => onChanged(EnableDisableGuestNetworkAction(
              devices: a.devices,
              enable: v ?? a.enable,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildEnableDisableNetworkProfileFields(
      EnableDisableNetworkProfileAction a) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: a.devices.join(', '),
                decoration: const InputDecoration(
                  labelText: 'Devices',
                  isDense: true,
                ),
                onChanged: (v) => onChanged(EnableDisableNetworkProfileAction(
                  devices: v
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  enable: a.enable,
                  profile: a.profile,
                )),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<bool>(
                initialValue: a.enable,
                decoration: const InputDecoration(
                  labelText: 'State',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Enable')),
                  DropdownMenuItem(value: false, child: Text('Disable')),
                ],
                onChanged: (v) => onChanged(EnableDisableNetworkProfileAction(
                  devices: a.devices,
                  enable: v ?? a.enable,
                  profile: a.profile,
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: a.profile,
          decoration: const InputDecoration(
            labelText: 'Profile',
            hintText: 'e.g., Kids',
            isDense: true,
          ),
          onChanged: (v) => onChanged(EnableDisableNetworkProfileAction(
            devices: a.devices,
            enable: a.enable,
            profile: v,
          )),
        ),
      ],
    );
  }
}
