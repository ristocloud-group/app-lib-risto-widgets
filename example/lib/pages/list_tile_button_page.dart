// list_tile_button_page.dart
import 'package:flutter/material.dart';
import 'package:risto_widgets/widgets/buttons/list_tile_button.dart';

class ListTileButtonPage extends StatelessWidget {
  const ListTileButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'List Tile Button Examples',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTileButton(
            margin: const EdgeInsets.symmetric(vertical: 8),
            body: const Text('List Tile Button with Elevation'),
            subtitle: const Text('Subtitle Text'),
            onPressed: () {},
            backgroundColor: Colors.white,
            borderColor: Colors.blue,
            elevation: 4.0,
            trailing: const Icon(Icons.arrow_forward),
            minHeight: 90,
          ),
          const SizedBox(height: 16),
          ListTileButton(
            margin: const EdgeInsets.symmetric(vertical: 8),
            body: const Text('List Tile Button without Elevation'),
            subtitle: const Text('Subtitle Text'),
            onPressed: () {},
            backgroundColor: Colors.white,
            borderColor: Colors.blue,
            trailing: const Icon(Icons.arrow_forward),
          ),
          const SizedBox(height: 16),
          ListTileButton(
            margin: const EdgeInsets.symmetric(vertical: 8),
            body: const Text('List Tile Button with icon'),
            backgroundColor: Colors.white,
            subtitle: const Text('Without action'),
            trailing: Icon(
              Icons.error,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
            leading: const Icon(Icons.info, color: Colors.blue),
            leadingSizeFactor: 1.5,
          ),
          ListTileButton(
            margin: const EdgeInsets.symmetric(vertical: 8),
            body: const Text('List Tile Button center'),
            subtitle: const Text('Disabled'),
            backgroundColor: Colors.white,
            elevation: 2,
            trailing: Icon(
              Icons.error,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
            leading: const Icon(Icons.info, color: Colors.blue),
            contentAlignment: Alignment.center,
            leadingSizeFactor: 1.5,
            disabled: true,
          ),
          ListTileButton(
            onPressed: () => {},
            backgroundColor: Colors.white,
            leading: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("21"),
                Padding(padding: EdgeInsets.only(top: 2.0), child: Text("set")),
              ],
            ),
            leadingSizeFactor: 2,
            trailing: const Icon(Icons.arrow_forward),
            subtitle: const Text('Subtitle Text'),
            body: Text('List Tile Button column leading'),
          ),
          const SizedBox(height: 16),
          IconListTileButton(
            margin: const EdgeInsets.symmetric(vertical: 8),
            title: const Text('Icon List Tile with Elevation'),
            icon: Icons.star,
            subtitle: const Text('Subtitle Text'),
            onPressed: () {},
            backgroundColor: Colors.white,
            borderColor: Colors.purple,
            iconColor: Colors.purple,
            elevation: 4.0,
            trailing: const Icon(Icons.arrow_forward),
            leadingSizeFactor: 2.0,
          ),
          const SizedBox(height: 16),
          IconListTileButton(
            margin: const EdgeInsets.symmetric(vertical: 8),
            title: const Text('Icon List Tile without Elevation'),
            icon: Icons.star_border,
            subtitle: const Text('Subtitle Text'),
            onPressed: () {},
            backgroundColor: Colors.transparent,
            elevation: 1,
            shadowColor: Colors.transparent,
            borderColor: Colors.purple,
            iconColor: Colors.purple,
            trailing: const Icon(Icons.arrow_forward),
            leadingSizeFactor: 1.0,
          ),
          const SizedBox(height: 16),
          ListTileButton(
            onPressed: () {},
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.purple),
                Text('Pianifica assenza'),
              ],
            ),
            backgroundColor: Colors.white,
            borderColor: Colors.purple,
            leadingSizeFactor: 1.2,
            elevation: 1.5,
            bodyPadding: EdgeInsets.zero,
            borderRadius: 18,
            contentAlignment: Alignment.center,
            minHeight: 70,
          ),
          const SizedBox(height: 20),
          Text(
            'Double List Tile Buttons',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DoubleListTileButtons(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            space: 16.0,
            firstButton: ListTileButton(
              margin: const EdgeInsets.only(right: 8.0),
              body: const Center(child: Text('First Button with Elevation')),
              onPressed: () {},
              backgroundColor: Colors.red,
              elevation: 2.0,
            ),
            secondButton: ListTileButton(
              margin: const EdgeInsets.only(left: 8.0),
              body: const Center(child: Text('Second Button with Elevation')),
              onPressed: () {},
              backgroundColor: Colors.green,
              elevation: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          DoubleListTileButtons(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            space: 16.0,
            firstButton: ListTileButton(
              margin: const EdgeInsets.only(right: 8.0),
              body: const Center(child: Text('First Button without Elevation')),
              onPressed: () {},
              backgroundColor: Colors.red,
            ),
            secondButton: ListTileButton(
              margin: const EdgeInsets.only(left: 8.0),
              body: const Center(
                child: Text('Second Button without Elevation'),
              ),
              onPressed: () {},
              backgroundColor: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          DoubleListTileButtons(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            space: 16.0,
            firstButton: ListTileButton(
              margin: const EdgeInsets.only(right: 8.0),
              body: const Center(child: Text('First Button without Elevation')),
              onPressed: () {},
              backgroundColor: Colors.red,
            ),
            secondButton: ListTileButton(
              onPressed: () {},
              body: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Icon(Icons.calendar_today, color: Colors.purple),
                    ),
                    Expanded(child: Text('Pianifica assenza')),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              borderColor: Colors.purple,
              leadingSizeFactor: 1.2,
              elevation: 1.5,
              borderRadius: 18,
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              contentAlignment: Alignment.center,
              minHeight: 50,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.045,
            child: DoubleListTileButtons(
              space: 10,
              firstButton: IconListTileButton(
                onPressed: () {},
                icon: Icons.school,
                iconColor: Colors.white,
                title: Text(
                  'Profilo',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.blueAccent,
                borderRadius: 19 * 2,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                leadingPadding: EdgeInsets.only(left: 10 / 2, right: 10 / 3),
                bodyPadding: EdgeInsets.zero,
                contentAlignment: Alignment.center,
              ),
              secondButton: IconListTileButton(
                onPressed: () {},
                icon: Icons.restaurant_menu,
                iconColor: Colors.white,
                title: Text(
                  'Assente',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                borderRadius: 19 * 2,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                leadingPadding: EdgeInsets.only(left: 10 / 2, right: 10 / 3),
                bodyPadding: EdgeInsets.zero,
                contentAlignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
