part of '../../core_ui.dart';




class SearchBarWidget extends StatefulWidget {
  final Function(String query) onQuery;

  const SearchBarWidget({
    Key? key,
    required this.onQuery,
  }) : super(key: key);

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounceTimer;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var query="";

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    _focusNode.dispose(); // Dispose of the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Use custom width if provided
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Search Icon
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey),
            onPressed: () {
              widget.onQuery(searchController.text);
              _focusNode.requestFocus();
            },
          ),
          // TextField
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: _focusNode, // Attach focusNode to the TextField
              onChanged: (query) {
                setState(() {
                  this.query=query;
                });
                if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(seconds: 1), () {
                  widget.onQuery(query);
                  _focusNode.unfocus();
                });
              },
              onSubmitted: (value) {
                widget.onQuery(value);
              },
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          // Clear Icon (only visible when there is text)
          if (query.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                setState(() {
                  searchController.clear();
                });
                widget.onQuery(''); // Call the onQuery function with an empty string
                _focusNode.unfocus(); // Remove focus from the TextField
              },
            ),
        ],
      ),
    );
  }
}

