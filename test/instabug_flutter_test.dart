import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/APM.dart';
import 'package:instabug_flutter/BugReporting.dart';
import 'package:instabug_flutter/Chats.dart';
import 'package:instabug_flutter/CrashReporting.dart';
import 'package:instabug_flutter/FeatureRequests.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'package:instabug_flutter/InstabugLog.dart';
import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/Replies.dart';
import 'package:instabug_flutter/Surveys.dart';
import 'package:instabug_flutter/models/crash_data.dart';
import 'package:instabug_flutter/models/exception_data.dart';
import 'package:instabug_flutter/models/network_data.dart';
import 'package:instabug_flutter/models/trace.dart' as execution_trace;
import 'package:instabug_flutter/utils/platform_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stack_trace/stack_trace.dart';

import 'instabug_flutter_test.mocks.dart';

@GenerateMocks([
  PlatformManager,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final List<MethodCall> log = <MethodCall>[];
  const appToken = '068ba9a8c3615035e163dc5f829c73be';
  final List<InvocationEvent> invocationEvents = <InvocationEvent>[
    InvocationEvent.floatingButton
  ];
  const email = 's@nta.com';
  const name = 'santa';
  const message = 'Test Message';
  const String userAttribute = '19';
  const Map<String, String> userAttributePair = <String, String>{
    'gender': 'female'
  };
  late MockPlatformManager mockPlatform;

  const String url = 'https://jsonplaceholder.typicode.com';
  const String method = 'POST';
  final DateTime startDate = DateTime.now();
  final DateTime endDate = DateTime.now().add(const Duration(hours: 1));
  const dynamic requestBody = 'requestBody';
  const dynamic responseBody = 'responseBody';
  const int status = 200;
  const Map<String, dynamic> requestHeaders = <String, dynamic>{
    'request': 'request'
  };
  const Map<String, dynamic> responseHeaders = <String, dynamic>{
    'response': 'response'
  };
  const int duration = 10;
  const String contentType = 'contentType';
  final NetworkData networkData = NetworkData(
    url: url,
    method: method,
    startTime: startDate,
    contentType: contentType,
    duration: duration,
    endTime: endDate,
    requestBody: requestBody,
    responseBody: responseBody,
    requestHeaders: requestHeaders,
    responseHeaders: responseHeaders,
    status: status,
  );

  setUpAll(() async {
    const MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getTags':
          return <String>['tag1', 'tag2'];
        case 'getUserAttributeForKey:':
          return userAttribute;
        case 'getUserAttributes':
          return userAttributePair;
        default:
          return null;
      }
    });
  });

  setUp(() {
    mockPlatform = MockPlatformManager();
    PlatformManager.setPlatformInstance(mockPlatform);
  });

  tearDown(() async {
    log.clear();
  });

  test('startWithToken:invocationEvents: should be called on iOS', () async {
    when(mockPlatform.isIOS()).thenAnswer((_) => true);

    Instabug.start(appToken, invocationEvents);
    final List<dynamic> args = <dynamic>[
      appToken,
      <String>[InvocationEvent.floatingButton.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'startWithToken:invocationEvents:',
        arguments: args,
      )
    ]);
  });

  test('showWelcomeMessageWithMode: Test', () async {
    Instabug.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
    final List<dynamic> args = <dynamic>[WelcomeMessageMode.beta.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'showWelcomeMessageWithMode:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test', () async {
    Instabug.identifyUser(email, name);
    final List<dynamic> args = <dynamic>[email, name];
    expect(log, <Matcher>[
      isMethodCall(
        'identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test Optional Parameter', () async {
    Instabug.identifyUser(email);
    final List<dynamic> args = <dynamic>[email, null];
    expect(log, <Matcher>[
      isMethodCall(
        'identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });

  test('logOut Test', () async {
    Instabug.logOut();
    expect(log, <Matcher>[isMethodCall('logOut', arguments: null)]);
  });

  test('setLocale:', () async {
    Instabug.setLocale(IBGLocale.german);
    final List<dynamic> args = <dynamic>[IBGLocale.german.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setLocale:',
        arguments: args,
      )
    ]);
  });

  test('setSdkDebugLogsLevel:', () async {
    Instabug.setSdkDebugLogsLevel(IBGSDKDebugLogsLevel.verbose);
    final List<dynamic> args = <dynamic>[
      IBGSDKDebugLogsLevel.verbose.toString()
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setSdkDebugLogsLevel:',
        arguments: args,
      )
    ]);
  });

  test('logVerbose: Test', () async {
    InstabugLog.logVerbose(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logVerbose:',
        arguments: args,
      )
    ]);
  });

  test('logDebug: Test', () async {
    InstabugLog.logDebug(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logDebug:',
        arguments: args,
      )
    ]);
  });

  test('logInfo: Test', () async {
    InstabugLog.logInfo(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logInfo:',
        arguments: args,
      )
    ]);
  });

  test('clearAllLogs: Test', () async {
    InstabugLog.clearAllLogs();
    expect(log, <Matcher>[isMethodCall('clearAllLogs', arguments: null)]);
  });

  test('logError: Test', () async {
    InstabugLog.logError(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logError:',
        arguments: args,
      )
    ]);
  });

  test('logWarn: Test', () async {
    InstabugLog.logWarn(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logWarn:',
        arguments: args,
      )
    ]);
  });

  test('test setColorTheme should be called with argument colorTheme',
      () async {
    const ColorTheme colorTheme = ColorTheme.dark;
    Instabug.setColorTheme(colorTheme);
    final List<dynamic> args = <dynamic>[colorTheme.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setColorTheme:',
        arguments: args,
      )
    ]);
  });

  test('test appendTags should be called with argument List of strings',
      () async {
    const List<String> tags = ['tag1', 'tag2'];
    Instabug.appendTags(tags);
    final List<dynamic> args = <dynamic>[tags];
    expect(log, <Matcher>[
      isMethodCall(
        'appendTags:',
        arguments: args,
      )
    ]);
  });

  test('test resetTags should be called with no arguments', () async {
    Instabug.resetTags();
    expect(log, <Matcher>[isMethodCall('resetTags', arguments: null)]);
  });

  test(
      'test getTags should be called with no arguments and returns list of tags',
      () async {
    final tags = await Instabug.getTags();
    expect(log, <Matcher>[isMethodCall('getTags', arguments: null)]);
    expect(tags, ['tag1', 'tag2']);
  });

  test(
      'test setUserAttributeWithKey should be called with two string arguments',
      () async {
    const String value = '19';
    const String key = 'Age';
    Instabug.setUserAttribute(value, key);
    final List<dynamic> args = <dynamic>[value, key];
    expect(log, <Matcher>[
      isMethodCall(
        'setUserAttribute:withKey:',
        arguments: args,
      )
    ]);
  });

  test('test removeUserAttributeForKey should be called with a string argument',
      () async {
    const String key = 'Age';
    Instabug.removeUserAttribute(key);
    final List<dynamic> args = <dynamic>[key];
    expect(log, <Matcher>[
      isMethodCall(
        'removeUserAttributeForKey:',
        arguments: args,
      )
    ]);
  });

  test(
      'test getUserAttributeForKey should be called with a string argument and return a string',
      () async {
    const String key = 'Age';
    final value = await Instabug.getUserAttributeForKey(key);
    expect(log, <Matcher>[
      isMethodCall('getUserAttributeForKey:', arguments: <dynamic>[key])
    ]);
    expect(value, userAttribute);
  });

  test(
      'test getuserAttributes should be called with no arguments and returns a Map',
      () async {
    final Map<String, String> result = await Instabug.getUserAttributes();
    expect(log, <Matcher>[isMethodCall('getUserAttributes', arguments: null)]);
    expect(result, userAttributePair);
  });

  test('show Test', () async {
    Instabug.show();
    expect(log, <Matcher>[
      isMethodCall(
        'show',
        arguments: null,
      )
    ]);
  });

  test('logUserEventWithName: Test', () async {
    Instabug.logUserEvent(name);
    final List<dynamic> args = <dynamic>[name];
    expect(log, <Matcher>[
      isMethodCall(
        'logUserEventWithName:',
        arguments: args,
      )
    ]);
  });

  test('test setValueForStringWithKey should be called with two arguments',
      () async {
    const String value = 'Some key';
    const CustomTextPlaceHolderKey key = CustomTextPlaceHolderKey.shakeHint;
    Instabug.setValueForStringWithKey(value, key);
    final List<dynamic> args = <dynamic>[value, key.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setValue:forStringWithKey:',
        arguments: args,
      )
    ]);
  });

  test('setSessionProfilerEnabled: Test', () async {
    const bool sessionProfilerEnabled = true;
    final List<dynamic> args = <dynamic>[sessionProfilerEnabled];
    Instabug.setSessionProfilerEnabled(sessionProfilerEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setSessionProfilerEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setDebugEnabled: Test', () async {
    when(mockPlatform.isAndroid()).thenAnswer((_) => true);

    const bool debugEnabled = true;
    final List<dynamic> args = <dynamic>[debugEnabled];
    Instabug.setDebugEnabled(debugEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setDebugEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setPrimaryColor: Test', () async {
    const c = Color.fromRGBO(255, 0, 255, 1.0);
    final List<dynamic> args = <dynamic>[c.value];
    Instabug.setPrimaryColor(c);
    expect(log, <Matcher>[
      isMethodCall(
        'setPrimaryColor:',
        arguments: args,
      )
    ]);
  });

  test('setUserData: Test', () async {
    const s = 'This is a String';
    final List<dynamic> args = <dynamic>[s];
    Instabug.setUserData(s);
    expect(log, <Matcher>[
      isMethodCall(
        'setUserData:',
        arguments: args,
      )
    ]);
  });

  test('addFileAttachmentWithURL: Test', () async {
    const filePath = 'filePath';
    const fileName = 'fileName';
    final List<dynamic> args = <dynamic>[filePath, fileName];
    Instabug.addFileAttachmentWithURL(filePath, fileName);
    expect(log, <Matcher>[
      isMethodCall(
        'addFileAttachmentWithURL:',
        arguments: args,
      )
    ]);
  });

  test('addFileAttachmentWithData: Test', () async {
    final bdata = Uint8List(10);
    const fileName = 'fileName';
    final List<dynamic> args = <dynamic>[bdata, fileName];
    Instabug.addFileAttachmentWithData(bdata, fileName);
    expect(log, <Matcher>[
      isMethodCall(
        'addFileAttachmentWithData:',
        arguments: args,
      )
    ]);
  });

  test('clearFileAttachments Test', () async {
    Instabug.clearFileAttachments();
    expect(log, <Matcher>[
      isMethodCall(
        'clearFileAttachments',
        arguments: null,
      )
    ]);
  });

  test('setWelcomeMessageMode Test', () async {
    final List<dynamic> args = <dynamic>[WelcomeMessageMode.live.toString()];
    Instabug.setWelcomeMessageMode(WelcomeMessageMode.live);
    expect(log, <Matcher>[
      isMethodCall(
        'setWelcomeMessageMode:',
        arguments: args,
      )
    ]);
  });

  test('reportScreenChange Test', () async {
    const String screenName = 'screen 1';
    final List<dynamic> args = <dynamic>[screenName];
    Instabug.reportScreenChange(screenName);
    expect(log, <Matcher>[
      isMethodCall(
        'reportScreenChange:',
        arguments: args,
      )
    ]);
  });

  test('setReproStepsMode Test', () async {
    final List<dynamic> args = <dynamic>[ReproStepsMode.enabled.toString()];
    Instabug.setReproStepsMode(ReproStepsMode.enabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setReproStepsMode:',
        arguments: args,
      )
    ]);
  });

  test('setBugReportingEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    BugReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setBugReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setShakingThresholdForiPhone: Test', () async {
    const iPhoneShakingThreshold = 1.6;
    final List<dynamic> args = <dynamic>[iPhoneShakingThreshold];

    when(mockPlatform.isIOS()).thenAnswer((_) => true);

    BugReporting.setShakingThresholdForiPhone(iPhoneShakingThreshold);
    expect(log, <Matcher>[
      isMethodCall(
        'setShakingThresholdForiPhone:',
        arguments: args,
      )
    ]);
  });

  test('setShakingThresholdForiPad: Test', () async {
    const iPadShakingThreshold = 1.6;
    final List<dynamic> args = <dynamic>[iPadShakingThreshold];

    when(mockPlatform.isIOS()).thenAnswer((_) => true);

    BugReporting.setShakingThresholdForiPad(iPadShakingThreshold);
    expect(log, <Matcher>[
      isMethodCall(
        'setShakingThresholdForiPad:',
        arguments: args,
      )
    ]);
  });

  test('setShakingThresholdForAndroid: Test', () async {
    const androidThreshold = 1000;
    final List<dynamic> args = <dynamic>[androidThreshold];

    when(mockPlatform.isAndroid()).thenAnswer((_) => true);

    BugReporting.setShakingThresholdForAndroid(androidThreshold);
    expect(log, <Matcher>[
      isMethodCall(
        'setShakingThresholdForAndroid:',
        arguments: args,
      )
    ]);
  });

  test('setOnInvokeCallback Test', () async {
    BugReporting.setOnInvokeCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnInvokeCallback',
        arguments: null,
      )
    ]);
  });

  test('setOnDismissCallback Test', () async {
    BugReporting.setOnDismissCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnDismissCallback',
        arguments: null,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setInvocationEvents(
        <InvocationEvent>[InvocationEvent.floatingButton]);
    final List<dynamic> args = <dynamic>[
      <String>[InvocationEvent.floatingButton.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationEvents:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setInvocationEvents(null);
    final List<dynamic> args = <dynamic>[<String>[]];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationEvents:',
        arguments: args,
      )
    ]);
  });

  test(
      'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording: Test',
      () async {
    BugReporting.setEnabledAttachmentTypes(false, false, false, false);
    final List<dynamic> args = <dynamic>[false, false, false, false];
    expect(log, <Matcher>[
      isMethodCall(
        'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setReportTypes(<ReportType>[ReportType.feedback]);
    final List<dynamic> args = <dynamic>[
      <String>[ReportType.feedback.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setReportTypes:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setExtendedBugReportMode(
        ExtendedBugReportMode.enabledWithOptionalFields);
    final List<dynamic> args = <dynamic>[
      ExtendedBugReportMode.enabledWithOptionalFields.toString()
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setExtendedBugReportMode:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationOptions Test', () async {
    BugReporting.setInvocationOptions(
        <InvocationOption>[InvocationOption.emailFieldHidden]);
    final List<dynamic> args = <dynamic>[
      <String>[InvocationOption.emailFieldHidden.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationOptions:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationOptions Test: empty', () async {
    BugReporting.setInvocationOptions(null);
    final List<dynamic> args = <dynamic>[<String>[]];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationOptions:',
        arguments: args,
      )
    ]);
  });

  test('showBugReportingWithReportTypeAndOptions:options Test', () async {
    BugReporting.show(
        ReportType.bug, <InvocationOption>[InvocationOption.emailFieldHidden]);
    final List<dynamic> args = <dynamic>[
      ReportType.bug.toString(),
      <String>[InvocationOption.emailFieldHidden.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'showBugReportingWithReportTypeAndOptions:options:',
        arguments: args,
      )
    ]);
  });

  test('showBugReportingWithReportTypeAndOptions:options Test: empty options',
      () async {
    BugReporting.show(ReportType.bug, null);
    final List<dynamic> args = <dynamic>[ReportType.bug.toString(), <String>[]];
    expect(log, <Matcher>[
      isMethodCall(
        'showBugReportingWithReportTypeAndOptions:options:',
        arguments: args,
      )
    ]);
  });

  test('setSurveysEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Surveys.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setSurveysEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAutoShowingSurveysEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Surveys.setAutoShowingEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAutoShowingSurveysEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setOnShowSurveyCallback Test', () async {
    Surveys.setOnShowCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnShowSurveyCallback',
        arguments: null,
      )
    ]);
  });

  test('setOnDismissSurveyCallback Test', () async {
    Surveys.setOnDismissCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnDismissSurveyCallback',
        arguments: null,
      )
    ]);
  });

  test('setShouldShowSurveysWelcomeScreen: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Surveys.setShouldShowWelcomeScreen(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setShouldShowSurveysWelcomeScreen:',
        arguments: args,
      )
    ]);
  });

  test('showSurveysIfAvailable Test', () async {
    Surveys.showSurveyIfAvailable();
    expect(log, <Matcher>[
      isMethodCall(
        'showSurveysIfAvailable',
        arguments: null,
      )
    ]);
  });

  test('showSurveyWithToken Test', () async {
    const token = 'token';
    final List<dynamic> args = <dynamic>[token];
    Surveys.showSurvey(token);
    expect(log, <Matcher>[
      isMethodCall(
        'showSurveyWithToken:',
        arguments: args,
      )
    ]);
  });

  test('hasRespondedToSurvey Test', () async {
    const token = 'token';
    final List<dynamic> args = <dynamic>[token];
    Surveys.hasRespondedToSurvey(token, () => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'hasRespondedToSurveyWithToken:',
        arguments: args,
      )
    ]);
  });

  test('setAppStoreURL Test', () async {
    const appStoreURL = 'appStoreURL';
    final List<dynamic> args = <dynamic>[appStoreURL];

    when(mockPlatform.isIOS()).thenAnswer((_) => true);

    Surveys.setAppStoreURL(appStoreURL);
    expect(log, <Matcher>[
      isMethodCall(
        'setAppStoreURL:',
        arguments: args,
      )
    ]);
  });

  test('showFeatureRequests Test', () async {
    FeatureRequests.show();
    expect(
        log, <Matcher>[isMethodCall('showFeatureRequests', arguments: null)]);
  });

  test('setEmailFieldRequiredForFeatureRequests:forAction: Test', () async {
    const isEmailFieldRequired = false;
    final List<dynamic> args = <dynamic>[
      isEmailFieldRequired,
      <String>[ActionType.addCommentToFeature.toString()]
    ];
    FeatureRequests.setEmailFieldRequired(
        isEmailFieldRequired, [ActionType.addCommentToFeature]);
    expect(log, <Matcher>[
      isMethodCall(
        'setEmailFieldRequiredForFeatureRequests:forAction:',
        arguments: args,
      )
    ]);
  });

  test('showChats Test', () async {
    Chats.show();
    expect(log, <Matcher>[isMethodCall('showChats', arguments: null)]);
  });

  test('setChatsEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Chats.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setChatsEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setRepliesEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Replies.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setRepliesEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setInAppNotificationSound: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];

    when(mockPlatform.isAndroid()).thenAnswer((_) => true);

    Replies.setInAppNotificationSound(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setEnableInAppNotificationSound:',
        arguments: args,
      )
    ]);
  });

  test('showReplies Test', () async {
    Replies.show();
    expect(log, <Matcher>[isMethodCall('showReplies', arguments: null)]);
  });

  test('hasChats Test', () async {
    Replies.hasChats(() => () {});
    expect(log, <Matcher>[isMethodCall('hasChats', arguments: null)]);
  });

  test('setOnNewReplyReceivedCallback Test', () async {
    Replies.setOnNewReplyReceivedCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall('setOnNewReplyReceivedCallback', arguments: null)
    ]);
  });

  test('getUnreadRepliesCount Test', () async {
    Replies.getUnreadRepliesCount(() => () {});
    expect(
        log, <Matcher>[isMethodCall('getUnreadRepliesCount', arguments: null)]);
  });

  test('setChatNotificationEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Replies.setInAppNotificationsEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setChatNotificationEnabled:',
        arguments: args,
      )
    ]);
  });

  test('networkLog: Test', () async {
    final data =
        NetworkData(method: 'method', url: 'url', startTime: DateTime.now());
    final List<dynamic> args = <dynamic>[data.toMap()];
    NetworkLogger.networkLog(data);
    expect(log, <Matcher>[
      isMethodCall(
        'networkLog:',
        arguments: args,
      )
    ]);
  });

  test('setCrashReportingEnabled: Test', () async {
    const isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    CrashReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setCrashReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('sendJSCrashByReflection:handled: Test', () async {
    try {
      final List<dynamic> params = <dynamic>[1, 2];
      params[5] = 2;
    } catch (exception, stack) {
      const bool handled = true;
      final Trace trace = Trace.from(stack);
      final List<ExceptionData> frames = <ExceptionData>[];
      for (int i = 0; i < trace.frames.length; i++) {
        frames.add(ExceptionData(
            trace.frames[i].uri.toString(),
            trace.frames[i].member,
            trace.frames[i].line,
            trace.frames[i].column == null ? 0 : trace.frames[i].column!));
      }
      final crashData = CrashData(
          exception.toString(), Platform.operatingSystem.toString(), frames);
      final List<dynamic> args = <dynamic>[jsonEncode(crashData), handled];
      CrashReporting.reportHandledCrash(exception, stack);
      expect(log, <Matcher>[
        isMethodCall(
          'sendJSCrashByReflection:handled:',
          arguments: args,
        )
      ]);
    }
  });
  test('Test NetworkData model ToMap', () async {
    final newNetworkData = networkData.toMap();
    expect(networkData.url, newNetworkData['url']);
    expect(networkData.method, newNetworkData['method']);
    expect(networkData.contentType, newNetworkData['contentType']);
    expect(networkData.duration, newNetworkData['duration']);
    expect(networkData.requestBody, newNetworkData['requestBody']);
    expect(networkData.responseBody, newNetworkData['responseBody']);
    expect(networkData.requestHeaders, newNetworkData['requestHeaders']);
    expect(networkData.responseHeaders, newNetworkData['responseHeaders']);
  });
  test('Test NetworkData model CopyWith empty', () async {
    final newNetworkData = networkData.copyWith();
    final newNetworkDataMap = newNetworkData.toMap();
    final networkDataMap = networkData.toMap();
    networkDataMap.forEach((key, dynamic value) {
      expect(value, newNetworkDataMap[key]);
    });
  });

  test('Test NetworkData model CopyWith', () async {
    const String urlCopy = 'https://jsonplaceholder.typicode.comCopy';
    const String methodCopy = 'POSTCopy';
    const dynamic requestBodyCopy = 'requestBodyCopy';
    const dynamic responseBodyCopy = 'responseBodyCopy';
    const Map<String, dynamic> requestHeadersCopy = <String, dynamic>{
      'requestCopy': 'requestCopy'
    };
    const Map<String, dynamic> responseHeadersCopy = <String, dynamic>{
      'responseCopy': 'responseCopy'
    };
    const int durationCopy = 20;
    const String contentTypeCopy = 'contentTypeCopy';
    final DateTime startDateCopy = DateTime.now().add(const Duration(days: 1));
    final DateTime endDateCopy = DateTime.now().add(const Duration(days: 2));
    const int statusCopy = 300;

    final newNetworkData = networkData.copyWith(
        url: urlCopy,
        method: methodCopy,
        requestBody: requestBodyCopy,
        requestHeaders: requestHeadersCopy,
        responseBody: responseBodyCopy,
        responseHeaders: responseHeadersCopy,
        duration: durationCopy,
        contentType: contentTypeCopy,
        startTime: startDateCopy,
        endTime: endDateCopy,
        status: statusCopy);

    expect(newNetworkData.url, urlCopy);
    expect(newNetworkData.method, methodCopy);
    expect(newNetworkData.requestBody, requestBodyCopy);
    expect(newNetworkData.requestHeaders, requestHeadersCopy);
    expect(newNetworkData.responseBody, responseBodyCopy);
    expect(newNetworkData.responseHeaders, responseHeadersCopy);
    expect(newNetworkData.duration, durationCopy);
    expect(newNetworkData.contentType, contentTypeCopy);
    expect(newNetworkData.startTime, startDateCopy);
    expect(newNetworkData.endTime, endDateCopy);
    expect(newNetworkData.status, statusCopy);
  });

  test('setAPMEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    APM.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAPMEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAPMLogLevel: Test', () async {
    LogLevel level = LogLevel.error;
    final List<dynamic> args = <dynamic>[level.toString()];
    APM.setLogLevel(level);
    expect(log, <Matcher>[
      isMethodCall(
        'setAPMLogLevel:',
        arguments: args,
      )
    ]);
  });

  test('setColdAppLaunchEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    APM.setColdAppLaunchEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setColdAppLaunchEnabled:',
        arguments: args,
      )
    ]);
  });

  test('startExecutionTrace: Test', () async {
    const String name = 'test_trace';
    final DateTime timestamp = DateTime.now();
    final List<dynamic> args = <dynamic>[name.toString(), timestamp.toString()];
    APM.startExecutionTrace(name);
    expect(log, <Matcher>[
      isMethodCall(
        'startExecutionTrace:id:',
        arguments: args,
      )
    ]);
  }, skip: 'TODO: mock timestamp');

  test('setExecutionTraceAttribute: Test', () async {
    const String name = 'test_trace';
    const String id = '111';
    const String key = 'key';
    const String value = 'value';
    final List<dynamic> args = <dynamic>[id, key, value];
    final execution_trace.Trace trace = execution_trace.Trace(id, name);
    trace.setAttribute(key, value);
    expect(log, <Matcher>[
      isMethodCall(
        'setExecutionTraceAttribute:key:value:',
        arguments: args,
      )
    ]);
  }, skip: 'TODO: mock timestamp');

  test('setCrashReportingEnabled: Test', () async {
    const bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    CrashReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setCrashReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAutoUITraceEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    APM.setAutoUITraceEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAutoUITraceEnabled:',
        arguments: args,
      )
    ]);
  });

  test('startUITrace: Test', () async {
    String name = 'UI_Trace';
    final List<dynamic> args = <dynamic>[name];
    APM.startUITrace(name);
    expect(log, <Matcher>[
      isMethodCall(
        'startUITrace:',
        arguments: args,
      )
    ]);
  });

  test('endUITrace: Test', () async {
    final List<dynamic> args = <dynamic>[null];
    APM.endUITrace();
    expect(log, <Matcher>[isMethodCall('endUITrace', arguments: null)]);
  });

    test('endAppLaunch: Test', () async {
    final List<dynamic> args = <dynamic>[null];
    APM.endAppLaunch();
    expect(log, <Matcher>[isMethodCall('endAppLaunch', arguments: null)]);
  });
}
