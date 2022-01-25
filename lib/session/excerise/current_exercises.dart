import 'package:flutter/material.dart';

import 'abs_exercise.dart';

class CurrentExercises {
  final List<Exercise> _exercises = [
    Exercise(
      'Land uppvärmning',
      'Uppvärmning',
      const Perks(iconData: Icons.landscape_outlined, perk: 'Dry',),
      const Perks(iconData: Icons.label_important, perk: 'Important',),
      const Perks(iconData: Icons.personal_injury_outlined, perk: 'Prevent injuries',),
      const Duration(minutes: 5),
      [
        'Snurra armarna runt axlarna framåt',
        'Snurra armarna runt axlarna bakåt',
        'Snurra armarna åt varsitt håll',
        'Håll armarna raka och rakt ut från axlarna i 30s',
        'Repetera 2 varv'
      ],
    ),
    Exercise('Insim',
        'uppvärminng',
        const Perks(iconData: Icons.landscape_outlined, perk: 'Dry',),
        const Perks(iconData: Icons.label_important, perk: 'Important',),
        const Perks(iconData: Icons.personal_injury_outlined, perk: 'Prevent injuries',),
        const Duration(minutes: 10),
        [
      'Värm upp med benspark',
      'Värm upp med armar',
      'Värm upp med både armar och ben',
    ]),
    Exercise(
        'Streamline',
        'Effektivaste positionen',
        const Perks(iconData: Icons.landscape_outlined, perk: 'Dry',),
        const Perks(iconData: Icons.label_important, perk: 'Important',),
        const Perks(iconData: Icons.personal_injury_outlined, perk: 'Prevent injuries',),
        const Duration(minutes: 5),
        [
      'Lägg en hand över den andra',
      'Håll armarna raka och huvudet mellan armarna',
      'Kolla i en spegel eller likande och försöka hålla kroppen i ett sträck'
    ]),
    Exercise(
        'Frånskjut',
        'Nyttja väggen',
        const Perks(iconData: Icons.east_outlined, perk: 'Easy',),
        const Perks(iconData: Icons.label_important, perk: 'Important',),
        const Perks(iconData: Icons.personal_injury_outlined, perk: 'Prevent injuries',),
        const Duration(minutes: 10),

        [
      'Uttnytja streamline positionen',
      'Skjut ifrån när du är under vatten',
          'Försök glida mer än fem meter'
        ]
    ),
    Exercise(
        'Skovel', 'Grepp i vattnet',
        const Perks(iconData: Icons.landscape_outlined, perk: 'Dry',),
        const Perks(iconData: Icons.label_important, perk: 'Important',),
        const Perks(iconData: Icons.personal_injury_outlined, perk: 'Prevent injuries',),
        const Duration(minutes: 10),
        [
          'Ligg på mage',
          'Simma som en hund',
          'Men med långa simtag',
        ]
    ),
    Exercise(
        'Bas rotation', 'Grepp i vattnet',
        const Perks(iconData: Icons.landscape_outlined, perk: 'Dry',),
        const Perks(iconData: Icons.label_important, perk: 'Important',),
        const Perks(iconData: Icons.personal_injury_outlined, perk: 'Prevent injuries',),
        const Duration(minutes: 10),
        [
          'Ligg på mage',
          'Armarna i som om händerna vore i fickor',
          'Sparka med benen för att ta dig framåt',
          'Rotera från sida till sida',
          'Andas när ena axeln är som högst i luften',
        ]
    )
  ];

  List<Exercise> get exercises => _exercises;

// _listExcercises.add(Exercise('Russian long dog', 'Rotation', '4', '25m'));
    // _listExcercises.add(Exercise('Catch up', 'Grepp', '4', '25m'));
    // _listExcercises.add(Exercise('Tre kick', 'rotation, rytm', '4', '25m'));
    // _listExcercises.add(Exercise('Fem kick', 'rotation, rytm', '4', '25m'));
    // _listExcercises.add(Exercise('Sju kick', 'rotation, rytm', '4', '25m'));

}
