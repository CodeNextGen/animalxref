import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'filter.dart';

class Chips extends StatelessWidget {
  static final _dateFormat = DateFormat.Md().add_jm();

  final EdgeInsets padding;

  const Chips({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<FilterNotifier>(context);
    final sortLabel = filter.sort == Sort.name
        ? 'Name'
        : filter.sort == Sort.bells ? 'Bells' : 'Size';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16) + padding,
      child: Wrap(
        spacing: 8,
        children: [
          Builder(
            builder: (context) => InputChip(
              avatar: Icon(Icons.sort, size: 18),
              label: Text(sortLabel),
              selected: filter.sort != Sort.name,
              showCheckmark: false,
              onPressed: () async {
                final value = await showMenu<Sort>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: [
                    PopupMenuItem(
                      value: Sort.name,
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha),
                          SizedBox(width: 16),
                          Text('Name'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Sort.bells,
                      child: Row(
                        children: [
                          Icon(Icons.local_offer),
                          SizedBox(width: 16),
                          Text('Bells'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: Sort.size,
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 16),
                          Text('Size'),
                        ],
                      ),
                    ),
                  ],
                );
                if (value == null) return;
                filter.sort = value;
              },
              onDeleted: filter.sort == Sort.name
                  ? null
                  : () => filter.sort = Sort.name,
            ),
          ),
          Builder(
            builder: (context) => InputChip(
              label: Text(filter.time == Time.any
                  ? 'Any'
                  : filter.time == Time.now
                      ? 'Now'
                      : _dateFormat.format(filter.dateTime)),
              avatar: Icon(Icons.schedule, size: 18),
              onPressed: () async {
                final value = await showMenu<Time>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: [
                    PopupMenuItem(child: Text('Any'), value: Time.any),
                    PopupMenuItem(child: Text('Now'), value: Time.now),
                    PopupMenuItem(child: Text('Custom'), value: Time.custom),
                  ],
                );
                if (value == null) return;

                switch (value) {
                  case Time.any:
                    filter.time = Time.any;
                    return;
                  case Time.now:
                    filter.time = Time.now;
                    return;
                  case Time.custom:
                    break;
                }

                final now = DateTime.now().toLocal();
                final date = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 1, now.month, now.day),
                  builder: _buildPicker,
                );
                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: _buildPicker,
                );
                if (time == null) return;

                filter.dateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              },
              onDeleted:
                  filter.time == Time.any ? null : () => filter.time = Time.any,
              selected: filter.time != Time.any,
              showCheckmark: false,
            ),
          ),
          FilterChip(
            label: Text('Donate'),
            avatar: Icon(Icons.home, size: 18),
            onSelected: (v) => filter.donate = v ? Donate.no : Donate.any,
            selected: filter.donate == Donate.no,
            showCheckmark: false,
          ),
          Builder(
            builder: (context) => InputChip(
              avatar: Icon(Icons.place, size: 18),
              label: Text(fishLocationText[filter.fishLocation]),
              selected: filter.fishLocation != FishLocation.any,
              showCheckmark: false,
              onPressed: () async {
                final value = await showMenu<FishLocation>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: fishLocationText.keys.map((l) {
                    return PopupMenuItem(
                      value: l,
                      child: Text(fishLocationText[l]),
                    );
                  }).toList(),
                );
                if (value == null) return;
                filter.fishLocation = value;
              },
              onDeleted: filter.fishLocation == FishLocation.any
                  ? null
                  : () => filter.fishLocation = FishLocation.any,
            ),
          ),
          Builder(
            builder: (context) => InputChip(
              avatar: Icon(Icons.search, size: 18),
              label: Text(fishSizeText[filter.fishSize]),
              selected: filter.fishSize != FishSize.any,
              showCheckmark: false,
              onPressed: () async {
                final value = await showMenu<FishSize>(
                  context: context,
                  position: _getMenuPosition(context),
                  items: fishSizeText.keys.map((f) {
                    return PopupMenuItem(
                      value: f,
                      child: Text(fishSizeText[f]),
                    );
                  }).toList(),
                );
                if (value == null) return;
                filter.fishSize = value;
              },
              onDeleted: filter.fishSize == FishSize.any
                  ? null
                  : () => filter.fishSize = FishSize.any,
            ),
          ),
          if (filter.sort != Sort.name ||
              filter.fishLocation != FishLocation.any ||
              filter.time != Time.any ||
              filter.fishSize != FishSize.any ||
              filter.donate != Donate.any)
            ButtonTheme(
              minWidth: 56,
              child: FlatButton(
                onPressed: () {
                  filter.sort = Sort.name;
                  filter.fishLocation = FishLocation.any;
                  filter.time = Time.any;
                  filter.fishSize = FishSize.any;
                  filter.donate = Donate.any;
                },
                child: Text('Reset'),
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }

  static Widget _buildPicker(BuildContext context, Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: 500,
        ),
        child: child,
      ),
    );
  }

  static RelativeRect _getMenuPosition(BuildContext context) {
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset.zero,
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  }
}
