part of 'home_screen.dart';

final class PostListViewController {
  void init(_PostListScreenState self) async {
    await _read(self);
  }
  Future<void> onPulled(_PostListScreenState self) async {
    await _read(self);
  }

  void onListEnd(_PostListScreenState self) async {
    self.onNextLoading(true);
     await self.controller.readNext();
    self.onNextLoading(false);
  }

  void search(_PostListScreenState self, String query) async {
    self.startLoading();
    await self.controller.search(query);
    self.stopLoading();
  }

  Future<void> _read(_PostListScreenState self) async {
    self.startLoading();
    await self.controller.readPost();
    self.stopLoading();
  }
}
