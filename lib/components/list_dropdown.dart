import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/row_with_gaps.dart';
import 'package:flutter_common_widgets/presentation_layer/helpers/global_variables.dart';

class CustomDropdown<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget child;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(int) onChange;

  /// list of DropdownItems
  final List<DropdownItem<T>> items;

  /// dropdown button icon defaults to caret
  final Widget? icon;
  final bool hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  final String semanticsLabel;
  final MainAxisAlignment mainAxisAlignment;
  final bool enabled;

  final String? label;

  const CustomDropdown({
    super.key,
    this.hideIcon = false,
    required this.child,
    this.label,
    required this.items,
    this.enabled = true,
    this.icon,
    this.leadingIcon = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    required this.onChange,
    required this.semanticsLabel,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var dropdownStyle = theme.dropdownMenuTheme;
    InputDecorationTheme inputTheme = dropdownStyle.inputDecorationTheme!;

    OutlineInputBorder border = (widget.enabled
        ? inputTheme.border
        : inputTheme.disabledBorder) as OutlineInputBorder;

    // link the overlay to the button
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            // width: style.width,
            // height: style.height,
            padding: inputTheme.contentPadding,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? theme.colorScheme.surface
                  : Colors.transparent,
              borderRadius: border.borderRadius,
              border: Border.all(
                width: border.borderSide.width,
                color: border.borderSide.color,
              ),
            ),
            child: Semantics(
              label: widget.semanticsLabel,
              excludeSemantics: true,
              child: InkWell(
                onTap: widget.enabled ? _toggleDropdown : null,
                child: _getDropdownBaseWidget(),
              ),
            ),
          ),
        ),
        if (widget.label is String)
          Positioned(
            top: -8 * MediaQuery.textScaleFactorOf(context),
            left: inputTheme.contentPadding!.horizontal / 2 - 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, theme.colorScheme.surface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 0.5],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.label!,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _getDropdownBaseWidget() {
    return RowWithGaps(
      mainAxisAlignment: widget.mainAxisAlignment,
      textDirection: widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: widget.child),
        if (!widget.hideIcon && widget.enabled)
          AnimatedScale(
            scale: _isOpen ? -1 : 1,
            duration: const Duration(milliseconds: 300),
            child: (widget.icon ?? _downFacingArrow()),
          ),
      ],
    );
  }

  Widget _downFacingArrow() {
    return const RotatedBox(
      quarterTurns: 3,
      child: Icon(
        Icons.arrow_back_ios_rounded,
        size: 13,
        color: Colors.grey,
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;
    var theme = Theme.of(context);
    var dropdownStyle = theme.dropdownMenuTheme;
    var menuStyle = dropdownStyle.menuStyle;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => Semantics(
        label: 'Close dropdown',
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () => _toggleDropdown(close: true),
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: offset.dx,
                  top: topOffset,
                  width: size.width,
                  child: CompositedTransformFollower(
                    offset: Offset(0, size.height + 5),
                    link: _layerLink,
                    showWhenUnlinked: false,
                    child: Material(
                      elevation: menuStyle?.elevation?.resolve({}) ?? 0,
                      color: menuStyle?.backgroundColor?.resolve({}),
                      shape: menuStyle?.shape?.resolve({}),
                      child: SizeTransition(
                        axisAlignment: 1,
                        sizeFactor: _expandAnimation,
                        child: _dropdownContent(topOffset),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdownContent(double topOffset) {
    var theme = Theme.of(context);
    var dropdownStyle = theme.dropdownMenuTheme;

    var theoreticalLimit = MediaQuery.of(context).size.height - topOffset - 15;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: (theoreticalLimit).isNegative ? 100 : theoreticalLimit,
      ),
      child: RawScrollbar(
        thumbVisibility: true,
        thumbColor: theme.scrollbarTheme.thumbColor!.resolve({}),
        controller: _scrollController,
        child: ListView.separated(
          padding: dropdownStyle.menuStyle?.padding?.resolve({}),
          controller: _scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final optionValue =
                widget.items.asMap().entries.map((e) => e.value).toList();
            final optionKey =
                widget.items.asMap().entries.map((e) => e.key).toList();
            return Semantics(
              label: "${widget.semanticsLabel} option $index",
              excludeSemantics: true,
              child: InkWell(
                onTap: () {
                  widget.onChange(optionKey[index]);
                  _toggleDropdown();
                },
                child: optionValue[index],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: stdPadding);
          },
          itemCount: widget.items.asMap().entries.length,
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  final T? value;
  final Widget child;

  const DropdownItem({super.key, this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final ShapeBorder? shape;
  final double elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation = 0,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Color? scrollbarColor;

  /// Add shape and border radius of the dropdown from here
  final ShapeBorder? shape;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.shape,
    this.color,
    this.padding,
    this.scrollbarColor,
  });
}
