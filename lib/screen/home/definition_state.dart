import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../model/definition.dart';

part "definition_state.freezed.dart";

@freezed
class DefinitionState with _$DefinitionState {
  const factory DefinitionState.loading() = _Loading;
  const factory DefinitionState.noData() = NoData;
  const factory DefinitionState.data(List<Definition> data) = _Data;
}