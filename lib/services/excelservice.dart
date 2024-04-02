import 'dart:io';

import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
import 'package:iocl_app/utils/consts.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class ExcelService {

  Future<void> createRequestReport(List<Map<String,dynamic>> requests) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Requests'];
    CellStyle cellStyle = CellStyle(backgroundColorHex: '#1AFF1A', fontFamily :getFontFamily(FontFamily.Calibri));
    cellStyle.underline = Underline.Single; // or Underline.Double
    final len = requests.length;
    var headerCell = sheetObject.cell(CellIndex.indexByString('A1'));
    var headerCell2 = sheetObject.cell(CellIndex.indexByString('B1'));
    var headerCell3 = sheetObject.cell(CellIndex.indexByString('C1'));
    var headerCell4 = sheetObject.cell(CellIndex.indexByString('D1'));
    var headerCell5 = sheetObject.cell(CellIndex.indexByString('E1'));
    headerCell.value = TextCellValue("Worker Name");
    headerCell2.value = TextCellValue("Bypass Reason");
    headerCell3.value = TextCellValue("Admin Status");
    headerCell4.value = TextCellValue("Manager Name");
    headerCell5.value = TextCellValue("Created At");
    for(int i = 0; i<len;i++){
      var numeric = i+2;
      DateTime createdAt = requests[i]['createdAt'].toDate();
      final date = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
      var cell = sheetObject.cell(CellIndex.indexByString('A${numeric}'));
      var cell2 = sheetObject.cell(CellIndex.indexByString('B${numeric}'));
      var cell3 = sheetObject.cell(CellIndex.indexByString('C${numeric}'));
      var cell4 = sheetObject.cell(CellIndex.indexByString('D${numeric}'));
      var cell5 = sheetObject.cell(CellIndex.indexByString('E${numeric}'));
      cell.value = TextCellValue(requests[i]['name']);
      cell2.value = TextCellValue(requests[i]['reason']);
      cell3.value = TextCellValue(requests[i]['status']);
      cell4.value = TextCellValue(requests[i]['createdBy']);
      cell5.value = TextCellValue(date);
      cell.cellStyle = cellStyle;
      cell2.cellStyle = cellStyle;
      cell3.cellStyle = cellStyle;
      cell4.cellStyle = cellStyle;
      cell5.cellStyle = cellStyle;

    }
    var fileBytes =  excel.save();

    var directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    var filepath = File('${directory}/output_file_name.xlsx');
    filepath.createSync(recursive: true);
    await filepath.writeAsBytes(fileBytes!);

    showGenericToast("Excel downloaded successfully");

    await OpenFile.open(filepath.path);
  }
}