part of 'infinite_snap_list_bloc.dart';

/// Base event for InfiniteSnapList
abstract class InfiniteSnapListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Selects the snapped item
class SelectItemEvent<T> extends InfiniteSnapListEvent {
  final T selectedItem;

  SelectItemEvent(this.selectedItem);

  @override
  List<Object?> get props => [selectedItem];
}
