import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadButton extends StatefulWidget {
  @override
  _FileUploadButtonState createState() => _FileUploadButtonState();
}

class _FileUploadButtonState extends State<FileUploadButton> {
  FilePickerResult? _filePickerResult;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Cho phép tải lên các loại tệp pdf, doc và docx
    );

    if (result != null) {
      setState(() {
        _filePickerResult = result;
      });
    } else {
      // Người dùng không chọn tệp.
      // Xử lý ở đây nếu cần thiết.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Tải lên tài liệu'),
          ),
          if (_filePickerResult != null)
            Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Tên tệp: ${_filePickerResult!.files.single.name}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Định dạng: ${_filePickerResult!.files.single.extension}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Kích thước: ${(_filePickerResult!.files.single.size / 1024).toStringAsFixed(2)} KB',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
