part of test_hop;

class TaskListTests {
  static run() {
    test('dupe names are bad', () {
      final tasks = new TaskRegistry();
      tasks.addSync('task', (ctx) => true);

      expect(() => tasks.addSync('task', (ctx) => true), throwsArgumentError);
    });

    test('reject bad task names', () {
      final tasks = new TaskRegistry();
      final goodNames = const['a','aa','a_b','a1','a_9','a_cool_test1', 'a-cool', 'a-9'];

      for(final n in goodNames) {
        tasks.addSync(n, (ctx) => true);
      }

      final badNames = const['', null, ' start white', '1task', '1 start num', '\rtest',
                             'end_white ', 'contains white', 'contains\$bad',
                             'test\r\test', 'UpperCase', 'camelCase', 'a_', 'a-'];

      for(final n in badNames) {
        expect(() => tasks.addSync(n, (ctx) => true), throwsArgumentError);
      }
    });

    test('reject tasks after freeze', () {
      final tasks = new TaskRegistry();

      expect(tasks.isFrozen, isFalse);
      final hopConfig = new HopConfig(tasks, ['bad'], _testPrint);
      expect(tasks.isFrozen, isTrue);

      // cannot add task when frozen
      expect(() => tasks.addSync('task', (ctx) => true), throws);
    });
  }
}
