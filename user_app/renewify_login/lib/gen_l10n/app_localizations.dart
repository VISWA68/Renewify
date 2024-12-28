import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta')
  ];

  /// Power up your space!
  ///
  /// In en, this message translates to:
  /// **'Power up your space!'**
  String get power;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @cont.
  ///
  /// In en, this message translates to:
  /// **'Login to Continue'**
  String get cont;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get pass;

  /// No description provided for @forget.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forget;

  /// No description provided for @dont.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dont;

  /// No description provided for @newe.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get newe;

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign up to Continue'**
  String get sign;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @newpass.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newpass;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm;

  /// No description provided for @but.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get but;

  /// No description provided for @tut1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Dashboard! Here you can access various features.'**
  String get tut1;

  /// No description provided for @tut2.
  ///
  /// In en, this message translates to:
  /// **'Click on \'Solar Installation\' to start your solar journey.'**
  String get tut2;

  /// No description provided for @tut3.
  ///
  /// In en, this message translates to:
  /// **'Check out \'Subsidies/Loans\' for financial assistance.'**
  String get tut3;

  /// No description provided for @tut4.
  ///
  /// In en, this message translates to:
  /// **'Explore \'Biogas\' for green energy solutions.'**
  String get tut4;

  /// No description provided for @tut5.
  ///
  /// In en, this message translates to:
  /// **'Monitor \'Electricity\' usage in real-time.'**
  String get tut5;

  /// No description provided for @tut6.
  ///
  /// In en, this message translates to:
  /// **'Visit \'Green Edge\' for the latest news and updates.'**
  String get tut6;

  /// No description provided for @tut7.
  ///
  /// In en, this message translates to:
  /// **'Shop in the \'Energy Market\' for renewable products.'**
  String get tut7;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @renew.
  ///
  /// In en, this message translates to:
  /// **'RENEWIFY'**
  String get renew;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @solar.
  ///
  /// In en, this message translates to:
  /// **'Solar Installation'**
  String get solar;

  /// No description provided for @subl.
  ///
  /// In en, this message translates to:
  /// **'Subsidies /Loans'**
  String get subl;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Biogas'**
  String get bio;

  /// No description provided for @ele.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get ele;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green Edge'**
  String get green;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy Market'**
  String get energy;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get set;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @complaint.
  ///
  /// In en, this message translates to:
  /// **'My Complaints'**
  String get complaint;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @prob.
  ///
  /// In en, this message translates to:
  /// **'Problem Details'**
  String get prob;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call Customer Support'**
  String get call;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File Another Complaint'**
  String get file;

  /// No description provided for @things.
  ///
  /// In en, this message translates to:
  /// **'Things to know'**
  String get things;

  /// No description provided for @noc.
  ///
  /// In en, this message translates to:
  /// **'No Objection Certificate'**
  String get noc;

  /// No description provided for @noc_apply.
  ///
  /// In en, this message translates to:
  /// **'To apply for a No Objection Certificate (NOC) from the municipality, visit the following link:'**
  String get noc_apply;

  /// No description provided for @noc_button.
  ///
  /// In en, this message translates to:
  /// **'Apply for NOC'**
  String get noc_button;

  /// No description provided for @solar_cost.
  ///
  /// In en, this message translates to:
  /// **'Cost of Solar Installation'**
  String get solar_cost;

  /// No description provided for @cost_info.
  ///
  /// In en, this message translates to:
  /// **'The average cost of a solar installation today is between Rs.15,000 to Rs.20,000 per kilowatt, depending on the size of the system and other factors.'**
  String get cost_info;

  /// No description provided for @solar_subsidy.
  ///
  /// In en, this message translates to:
  /// **'Subsidies for Solar Installations'**
  String get solar_subsidy;

  /// No description provided for @solar_sub_info.
  ///
  /// In en, this message translates to:
  /// **'Subsidies for solar installations can cover up to 40% of the total cost, depending on the state and the specific program.'**
  String get solar_sub_info;

  /// No description provided for @tk_payback.
  ///
  /// In en, this message translates to:
  /// **'Payback Period'**
  String get tk_payback;

  /// No description provided for @tk_pay_content.
  ///
  /// In en, this message translates to:
  /// **'The payback period for a solar installation can range from 3 to 7 years, depending on the cost of electricity and the amount of sunlight your location receives.'**
  String get tk_pay_content;

  /// No description provided for @tk_finance.
  ///
  /// In en, this message translates to:
  /// **'Financing Options'**
  String get tk_finance;

  /// No description provided for @tk_fin_content.
  ///
  /// In en, this message translates to:
  /// **'Financing options for solar installations include loans, leases, and power purchase agreements (PPAs), which can help reduce the upfront cost.'**
  String get tk_fin_content;

  /// No description provided for @solar_service.
  ///
  /// In en, this message translates to:
  /// **'Solar Services'**
  String get solar_service;

  /// No description provided for @roof.
  ///
  /// In en, this message translates to:
  /// **'Rooftop Analysis'**
  String get roof;

  /// No description provided for @solar_centers.
  ///
  /// In en, this message translates to:
  /// **'Locate Centers'**
  String get solar_centers;

  /// No description provided for @panel.
  ///
  /// In en, this message translates to:
  /// **'Panel Type'**
  String get panel;

  /// No description provided for @bio_service.
  ///
  /// In en, this message translates to:
  /// **'Biogas Services'**
  String get bio_service;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Requirement Criteria'**
  String get required;

  /// No description provided for @ar_view.
  ///
  /// In en, this message translates to:
  /// **'AR Visualization'**
  String get ar_view;

  /// No description provided for @bio_monitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get bio_monitor;

  /// No description provided for @bio_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact BioGas centers'**
  String get bio_contact;

  /// No description provided for @ar_pop.
  ///
  /// In en, this message translates to:
  /// **'Kindly notice'**
  String get ar_pop;

  /// No description provided for @pop_content.
  ///
  /// In en, this message translates to:
  /// **'Please make sure you place your device camera facing towards an empty space.'**
  String get pop_content;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @req_title.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get req_title;

  /// No description provided for @req_1.
  ///
  /// In en, this message translates to:
  /// **'Ensure there is land or space of about 5 square meters available for the installation.'**
  String get req_1;

  /// No description provided for @req_2.
  ///
  /// In en, this message translates to:
  /// **'The biogas digester must be installed in a place that allows adequate exposure to sunlight.'**
  String get req_2;

  /// No description provided for @req_3.
  ///
  /// In en, this message translates to:
  /// **'The site should be accessible to input feedstock materials and water.'**
  String get req_3;

  /// No description provided for @req_4.
  ///
  /// In en, this message translates to:
  /// **'The location must have adequate drainage to prevent water logging.'**
  String get req_4;

  /// No description provided for @req_5.
  ///
  /// In en, this message translates to:
  /// **'There should be enough distance from the biogas plant to nearby buildings and structures.'**
  String get req_5;

  /// No description provided for @req_6.
  ///
  /// In en, this message translates to:
  /// **'Ensure you have the required permissions from local authorities, if necessary.'**
  String get req_6;

  /// No description provided for @req_7.
  ///
  /// In en, this message translates to:
  /// **'Understand the maintenance requirements of the biogas system, including periodic inspections and servicing.'**
  String get req_7;

  /// No description provided for @req_8.
  ///
  /// In en, this message translates to:
  /// **'Ensure a steady supply of feedstock materials to sustain biogas production.'**
  String get req_8;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @tandc.
  ///
  /// In en, this message translates to:
  /// **'I have read and understood to the'**
  String get tandc;

  /// No description provided for @final_req.
  ///
  /// In en, this message translates to:
  /// **'requirement criteria of RENEWIFY for installing biogas digester.'**
  String get final_req;

  /// No description provided for @pm_surya.
  ///
  /// In en, this message translates to:
  /// **'PRADAN MANDIRI SCHEME'**
  String get pm_surya;

  /// No description provided for @urts.
  ///
  /// In en, this message translates to:
  /// **'Union Roof Top Solar Scheme(URTS)'**
  String get urts;

  /// No description provided for @sbi.
  ///
  /// In en, this message translates to:
  /// **'SBI Surya Ghar'**
  String get sbi;

  /// No description provided for @cbi.
  ///
  /// In en, this message translates to:
  /// **'Central Bank of India Roof Top Solar Loan Scheme'**
  String get cbi;

  /// No description provided for @bob.
  ///
  /// In en, this message translates to:
  /// **'Bank of Baroda'**
  String get bob;

  /// No description provided for @unioncbg.
  ///
  /// In en, this message translates to:
  /// **'Union CBG (Compressed Bio-Gas) Scheme'**
  String get unioncbg;

  /// No description provided for @sbischeme.
  ///
  /// In en, this message translates to:
  /// **'State Bank Scheme'**
  String get sbischeme;

  /// No description provided for @satat.
  ///
  /// In en, this message translates to:
  /// **'SATAT BIO ENERGY SCHEME (SBES)'**
  String get satat;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @shop_title.
  ///
  /// In en, this message translates to:
  /// **'Go green\nGo renewable'**
  String get shop_title;

  /// No description provided for @shop_para.
  ///
  /// In en, this message translates to:
  /// **'Find shops near you at a single marketplace!'**
  String get shop_para;

  /// No description provided for @inverter.
  ///
  /// In en, this message translates to:
  /// **'Hybrid inverters'**
  String get inverter;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Charge controller'**
  String get charge;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get battery;

  /// No description provided for @wall_solar.
  ///
  /// In en, this message translates to:
  /// **'Wall solar panel'**
  String get wall_solar;

  /// No description provided for @cylinder.
  ///
  /// In en, this message translates to:
  /// **'Biogas Cylinders'**
  String get cylinder;

  /// No description provided for @manure.
  ///
  /// In en, this message translates to:
  /// **'Bio manure'**
  String get manure;

  /// No description provided for @shop_now.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get shop_now;

  /// No description provided for @sub.
  ///
  /// In en, this message translates to:
  /// **'Subsidy'**
  String get sub;

  /// No description provided for @solar_loan.
  ///
  /// In en, this message translates to:
  /// **'Loan provided for installation of Grid connected Rooftop Solar'**
  String get solar_loan;

  /// No description provided for @top_loan.
  ///
  /// In en, this message translates to:
  /// **'Loan for Solar Top'**
  String get top_loan;

  /// No description provided for @loan_amt.
  ///
  /// In en, this message translates to:
  /// **'Loan Amount assuming cost of Solar at Rs. 70000 per KW.'**
  String get loan_amt;

  /// No description provided for @cbg.
  ///
  /// In en, this message translates to:
  /// **'Scheme for Financing Compressed Biogas (CBG)'**
  String get cbg;

  /// No description provided for @cbg_loan.
  ///
  /// In en, this message translates to:
  /// **'Loan for setting up of projects for production of CBG'**
  String get cbg_loan;

  /// No description provided for @cbg_proj.
  ///
  /// In en, this message translates to:
  /// **'Scheme for setting up of Compressed Bio-Gas (CBG) projects'**
  String get cbg_proj;

  /// No description provided for @satat_scheme.
  ///
  /// In en, this message translates to:
  /// **'Scheme for providing support for recovery of energy in the form of Biogas under SATAT'**
  String get satat_scheme;

  /// No description provided for @find.
  ///
  /// In en, this message translates to:
  /// **'Find your Gas level'**
  String get find;

  /// No description provided for @biogas.
  ///
  /// In en, this message translates to:
  /// **'Bio Gas Level left'**
  String get biogas;

  /// No description provided for @lpg.
  ///
  /// In en, this message translates to:
  /// **'LPG Gas Level left'**
  String get lpg;

  /// No description provided for @gas.
  ///
  /// In en, this message translates to:
  /// **'GAS Leak Detection'**
  String get gas;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add numbers which should be notified in case of gas leakage:'**
  String get add;

  /// No description provided for @num1.
  ///
  /// In en, this message translates to:
  /// **'Number 1: 8610236842'**
  String get num1;

  /// No description provided for @num2.
  ///
  /// In en, this message translates to:
  /// **'Number 2: 9876543210'**
  String get num2;

  /// No description provided for @num3.
  ///
  /// In en, this message translates to:
  /// **'Number 3: 9742412636'**
  String get num3;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ta': return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
