import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'ticket_data.dart';

Future<Uint8List> generateTicketPdf(TicketData ticketData) async {
  final pdfWidgets.Document pdf = pdfWidgets.Document();

  final pdfWidgets.TextStyle headingStyle = pdfWidgets.TextStyle(
    color: PdfColors.blue,
    fontSize: 24,
    fontWeight: pdfWidgets.FontWeight.bold,
  );

  final pdfWidgets.TextStyle contentStyle = pdfWidgets.TextStyle(
    fontSize: 18,
  );

  final pdfWidgets.TextStyle tableHeaderStyle = pdfWidgets.TextStyle(
    fontWeight: pdfWidgets.FontWeight.bold,
  );

  final pdfWidgets.Widget _content = pdfWidgets.Column(
    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
    children: [
      // Header Section
      pdfWidgets.Text(
        'EasyRail',
        style: headingStyle,
      ),
      pdfWidgets.SizedBox(height: 5),
      pdfWidgets.Text(
        'Contact: 9834604926',
        style: contentStyle,
      ),
      pdfWidgets.Text(
        'Mail: EasyRail@gmail.com',
        style: contentStyle,
      ),
      pdfWidgets.Divider(thickness: 2),
      pdfWidgets.SizedBox(height: 10),
      pdfWidgets.Text(
        'Transaction ID: ${ticketData.transactionId}',
        style: contentStyle,
      ),
      pdfWidgets.Text(
        'Train Name: ${ticketData.trainName}',
        style: contentStyle,
      ),

      // Ticket Details Section (Table)
      pdfWidgets.SizedBox(height: 20),
      pdfWidgets.Table.fromTextArray(
        headers: ['From Station', 'To Station', 'Train ID'],
        data: [
          [ticketData.fromStation, ticketData.toStation, ticketData.trainId]
        ],
        cellAlignment: pdfWidgets.Alignment.centerLeft,
        cellStyle: pdfWidgets.TextStyle(fontSize: 16),
        headerStyle: tableHeaderStyle,
        headerAlignment: pdfWidgets.Alignment.centerLeft,
        headerDecoration: pdfWidgets.BoxDecoration(color: PdfColors.grey300),
        tableWidth: pdfWidgets.TableWidth.max,
      ),
      pdfWidgets.SizedBox(height: 20),
      pdfWidgets.Divider(thickness: 2),
      pdfWidgets.SizedBox(height: 20),
      pdfWidgets.Table.fromTextArray(
        headers: ['Passenger Name', 'Seat No.'],
        data: ticketData.passengers
            .map((passenger) => [passenger.name, passenger.seatNo])
            .toList(),
        cellAlignment: pdfWidgets.Alignment.centerLeft,
        cellStyle: pdfWidgets.TextStyle(fontSize: 16),
        headerStyle: tableHeaderStyle,
        headerAlignment: pdfWidgets.Alignment.centerLeft,
        headerDecoration: pdfWidgets.BoxDecoration(color: PdfColors.grey300),
        tableWidth: pdfWidgets.TableWidth.max,
      ),
      pdfWidgets.SizedBox(height: 20),
      pdfWidgets.Divider(thickness: 2),
      pdfWidgets.SizedBox(height: 20),
      pdfWidgets.Text(
        'This is your e-ticket.',
        style: pdfWidgets.TextStyle(
          color: PdfColors.red,
          fontSize: 18,
          fontWeight: pdfWidgets.FontWeight.bold,
        ),
      ),
      pdfWidgets.SizedBox(height: 10),
      pdfWidgets.Text(
        '© 2023 EasyRail. All rights reserved.',
        style: contentStyle,
      ),
      pdfWidgets.SizedBox(height: 10),
      pdfWidgets.Text(
        'Mr. Keegan Anes',
        style: contentStyle,
      ),
      pdfWidgets.Text(
        'CEO EasyRail',
        style: contentStyle,
      ),
    ],
  );

  pdf.addPage(
    pdfWidgets.Page(
      build: (context) {
        return pdfWidgets.Container(
          decoration: pdfWidgets.BoxDecoration(
            border: pdfWidgets.Border.all(
              color: PdfColors.black,
              width: 2,
            ),
          ),
          padding: pdfWidgets.EdgeInsets.all(20),
          child: _content,
        );
      },
    ),
  );

  return pdf.save();
}
